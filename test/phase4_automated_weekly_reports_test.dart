// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/models/weekly_report_model.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/services/weekly_report_service.dart';
import 'package:yhealth/core/services/report_scheduler_service.dart';
import 'package:yhealth/core/services/pdf_report_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.createTempSync('yhealth_test_').path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = MockPathProviderPlatform();

  late AppDatabase db;
  late DriftActivityRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftActivityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 4 - Monday-to-Sunday Date Calculations & Boundaries', () {
    test('Calculates Monday-to-Sunday date range accurately for mid-week date', () {
      // Wednesday, Nov 4, 2026
      final wednesday = DateTime(2026, 11, 4);
      final range = WeeklyReportService.getWeekRange(wednesday);

      expect(range.monday.weekday, equals(DateTime.monday));
      expect(range.sunday.weekday, equals(DateTime.sunday));
      expect(range.monday.year, equals(2026));
      expect(range.monday.month, equals(11));
      expect(range.monday.day, equals(2)); // Monday Nov 2
      expect(range.sunday.day, equals(8)); // Sunday Nov 8
    });

    test('Calculates previous completed week range accurately', () {
      // Monday Nov 9, 2026
      final monday = DateTime(2026, 11, 9);
      final prevRange = WeeklyReportService.getPreviousWeekRange(monday);

      expect(prevRange.monday.weekday, equals(DateTime.monday));
      expect(prevRange.sunday.weekday, equals(DateTime.sunday));
      expect(prevRange.monday.day, equals(2)); // Nov 2
      expect(prevRange.sunday.day, equals(8)); // Nov 8
    });

    test('Handles month boundary transitions correctly', () {
      // Sunday Nov 1, 2026
      final sunday = DateTime(2026, 11, 1);
      final range = WeeklyReportService.getWeekRange(sunday);

      expect(range.monday.month, equals(10)); // October
      expect(range.monday.day, equals(26)); // Oct 26
      expect(range.sunday.month, equals(11)); // November
      expect(range.sunday.day, equals(1)); // Nov 1
    });

    test('Handles year boundary transitions according to ISO 8601', () {
      // Wednesday Dec 31, 2025 -> Thursday is Jan 1, 2026 -> ISO Year 2026, Week 1
      final date1 = DateTime(2025, 12, 31);
      final weekNum1 = WeeklyReportService.getIsoWeekNumber(date1);
      final year1 = WeeklyReportService.getIsoYear(date1);

      expect(year1, equals(2026));
      expect(weekNum1, equals(1));

      // Sunday Jan 2, 2022 -> Thursday was Dec 30, 2021 -> ISO Year 2021, Week 52
      final date2 = DateTime(2022, 1, 2);
      final weekNum2 = WeeklyReportService.getIsoWeekNumber(date2);
      final year2 = WeeklyReportService.getIsoYear(date2);

      expect(year2, equals(2021));
      expect(weekNum2, equals(52));
    });
  });

  group('Phase 4 - Data Calculation, Missing Records & Metric Accuracy', () {
    test('Calculates totals, averages, most active day, and goal met days', () {
      final monday = DateTime(2026, 11, 2);
      final sunday = DateTime(2026, 11, 8);

      final List<DailyActivityEntry> activities = [
        DailyActivityEntry(
          date: '2026-11-02',
          steps: 8500,
          distanceKm: 6.2,
          calories: 410,
          activeMinutes: 65,
          goalSteps: 8000,
          isGoalCompleted: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        DailyActivityEntry(
          date: '2026-11-03',
          steps: 12000, // Most active day
          distanceKm: 8.8,
          calories: 590,
          activeMinutes: 90,
          goalSteps: 8000,
          isGoalCompleted: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        DailyActivityEntry(
          date: '2026-11-04',
          steps: 6500,
          distanceKm: 4.5,
          calories: 320,
          activeMinutes: 45,
          goalSteps: 8000,
          isGoalCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final List<SleepRecordsEntry> sleepRecords = [
        SleepRecordsEntry(
          id: 'sleep_1',
          date: '2026-11-02',
          bedtime: DateTime(2026, 11, 1, 23, 0),
          wakeTime: DateTime(2026, 11, 2, 7, 0),
          durationMinutes: 480, // 8h
          source: 'manual',
          efficiencyPercent: 90,
          hasStages: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        SleepRecordsEntry(
          id: 'sleep_2',
          date: '2026-11-03',
          bedtime: DateTime(2026, 11, 2, 23, 30),
          wakeTime: DateTime(2026, 11, 3, 7, 0),
          durationMinutes: 450, // 7h 30m
          source: 'manual',
          efficiencyPercent: 88,
          hasStages: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final report = WeeklyReportService.calculateWeeklyReport(
        monday: monday,
        sunday: sunday,
        activities: activities,
        sleepRecords: sleepRecords,
      );

      expect(report.totalSteps, equals(27000));
      expect(report.totalDistanceKm, closeTo(19.5, 0.01));
      expect(report.totalCalories, equals(1320));
      expect(report.totalActiveMinutes, equals(200));
      expect(report.totalSleepMinutes, equals(930)); // 480 + 450
      expect(report.goalMetDays, equals(2));
      expect(report.recordedDaysCount, equals(3));
      expect(report.mostActiveDayDate, equals('2026-11-03'));
      expect(report.mostActiveDaySteps, equals(12000));

      // Daily averages across 7 days
      expect(report.avgDailySteps, equals((27000 / 7).round()));
      expect(report.avgDailySleepMinutes, equals((930 / 7).round()));
    });

    test('Clearly distinguishes zero activity from missing records without fabricating data', () {
      final monday = DateTime(2026, 11, 2);
      final sunday = DateTime(2026, 11, 8);

      final List<DailyActivityEntry> activities = [
        DailyActivityEntry(
          date: '2026-11-02',
          steps: 0, // Genuine 0 recorded steps (e.g. user stayed home)
          distanceKm: 0.0,
          calories: 0,
          activeMinutes: 0,
          goalSteps: 8000,
          isGoalCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // Days 2026-11-03 through 2026-11-08 are completely missing
      ];

      final report = WeeklyReportService.calculateWeeklyReport(
        monday: monday,
        sunday: sunday,
        activities: activities,
        sleepRecords: [],
      );

      final day1 = report.dailyBreakdowns[0]; // Monday
      expect(day1.steps, equals(0));
      expect(day1.isMissing, isFalse); // Genuine recorded 0

      final day2 = report.dailyBreakdowns[1]; // Tuesday
      expect(day2.steps, equals(0));
      expect(day2.isMissing, isTrue); // Missing data record
    });
  });

  group('Phase 4 - Week-over-Week Comparisons', () {
    test('Calculates positive and negative percentage changes relative to previous week', () {
      final monday = DateTime(2026, 11, 9);
      final sunday = DateTime(2026, 11, 15);

      final previousWeekReport = WeeklyReportModel(
        id: 'report_2026_W45',
        startDate: '2026-11-02',
        endDate: '2026-11-08',
        year: 2026,
        weekNumber: 45,
        generatedAt: DateTime.now(),
        totalSteps: 50000,
        totalDistanceKm: 35.0,
        totalCalories: 2500,
        totalActiveMinutes: 350,
        totalSleepMinutes: 3000,
        avgDailySteps: 7143,
        avgDailyDistanceKm: 5.0,
        avgDailyCalories: 357,
        avgDailySleepMinutes: 428,
        goalMetDays: 5,
        mostActiveDayDate: '2026-11-05',
        mostActiveDaySteps: 11000,
        recordedDaysCount: 7,
        dailyBreakdowns: [],
      );

      final List<DailyActivityEntry> currentActivities = [
        DailyActivityEntry(
          date: '2026-11-09',
          steps: 60000, // 20% increase over 50,000
          distanceKm: 42.0, // 20% increase over 35.0
          calories: 2250, // 10% decrease from 2500
          activeMinutes: 400,
          goalSteps: 8000,
          isGoalCompleted: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final List<SleepRecordsEntry> currentSleep = [
        SleepRecordsEntry(
          id: 'sleep_w46',
          date: '2026-11-09',
          bedtime: DateTime(2026, 11, 8, 23, 0),
          wakeTime: DateTime(2026, 11, 9, 6, 0),
          durationMinutes: 2400, // 20% decrease from 3000
          source: 'manual',
          efficiencyPercent: 85,
          hasStages: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final report = WeeklyReportService.calculateWeeklyReport(
        monday: monday,
        sunday: sunday,
        activities: currentActivities,
        sleepRecords: currentSleep,
        previousWeekReport: previousWeekReport,
      );

      expect(report.stepsChangePercent, closeTo(20.0, 0.1));
      expect(report.distanceChangePercent, closeTo(20.0, 0.1));
      expect(report.caloriesChangePercent, closeTo(-10.0, 0.1));
      expect(report.sleepChangePercent, closeTo(-20.0, 0.1));
      expect(report.formatDeltaPercent(report.stepsChangePercent), equals('+20.0%'));
      expect(report.formatDeltaPercent(report.caloriesChangePercent), equals('-10.0%'));
    });

    test('Returns null delta when previous week report does not exist', () {
      final monday = DateTime(2026, 11, 2);
      final sunday = DateTime(2026, 11, 8);

      final report = WeeklyReportService.calculateWeeklyReport(
        monday: monday,
        sunday: sunday,
        activities: [],
        sleepRecords: [],
        previousWeekReport: null,
      );

      expect(report.stepsChangePercent, isNull);
      expect(report.formatDeltaPercent(report.stepsChangePercent), equals('—'));
    });
  });

  group('Phase 4 - Drift SQLite Persistence & Duplicate Prevention', () {
    test('Persists, retrieves, and prevents duplicate weekly reports in Drift', () async {
      final report = WeeklyReportModel(
        id: 'report_2026_W45',
        startDate: '2026-11-02',
        endDate: '2026-11-08',
        year: 2026,
        weekNumber: 45,
        generatedAt: DateTime(2026, 11, 9, 9, 0),
        totalSteps: 55000,
        totalDistanceKm: 38.5,
        totalCalories: 2600,
        totalActiveMinutes: 380,
        totalSleepMinutes: 3200,
        avgDailySteps: 7857,
        avgDailyDistanceKm: 5.5,
        avgDailyCalories: 371,
        avgDailySleepMinutes: 457,
        goalMetDays: 6,
        mostActiveDayDate: '2026-11-06',
        mostActiveDaySteps: 12500,
        recordedDaysCount: 7,
        dailyBreakdowns: [
          WeeklyDayBreakdown(
            date: '2026-11-02',
            dayOfWeek: 1,
            dayName: 'Mon',
            steps: 8000,
            distanceKm: 5.6,
            calories: 380,
            activeMinutes: 55,
            sleepMinutes: 480,
            goalSteps: 8000,
            isGoalMet: true,
            isMissing: false,
          ),
        ],
      );

      // Save initial report
      await repository.saveWeeklyReport(report);

      // Verify retrieval by id
      final retrieved = await repository.getWeeklyReportById('report_2026_W45');
      expect(retrieved, isNotNull);
      expect(retrieved!.totalSteps, equals(55000));
      expect(retrieved.dailyBreakdowns.length, equals(1));
      expect(retrieved.dailyBreakdowns.first.dayName, equals('Mon'));

      // Verify retrieval by week number and year
      final byWeek = await repository.getWeeklyReportByWeek(2026, 45);
      expect(byWeek, isNotNull);
      expect(byWeek!.id, equals('report_2026_W45'));

      // Re-inserting updated report with same ID must update without duplication
      final updatedReport = WeeklyReportModel(
        id: 'report_2026_W45',
        startDate: '2026-11-02',
        endDate: '2026-11-08',
        year: 2026,
        weekNumber: 45,
        generatedAt: DateTime(2026, 11, 9, 9, 30),
        totalSteps: 58000, // Updated
        totalDistanceKm: 40.0,
        totalCalories: 2750,
        totalActiveMinutes: 400,
        totalSleepMinutes: 3300,
        avgDailySteps: 8285,
        avgDailyDistanceKm: 5.7,
        avgDailyCalories: 392,
        avgDailySleepMinutes: 471,
        goalMetDays: 7,
        mostActiveDayDate: '2026-11-06',
        mostActiveDaySteps: 13000,
        recordedDaysCount: 7,
        dailyBreakdowns: [],
      );

      await repository.saveWeeklyReport(updatedReport);

      final count = await repository.getWeeklyReportsCount();
      expect(count, equals(1)); // Exactly 1, no duplicate rows

      final latest = await repository.getWeeklyReportById('report_2026_W45');
      expect(latest!.totalSteps, equals(58000));
    });
  });

  group('Phase 4 - Missed Background Execution & Catch-Up Scheduler', () {
    test('Catch-up generator automatically detects and backfills completed weeks', () async {
      final scheduler = ReportSchedulerService(repository);

      // Populate database with activity for previous week: Monday Nov 2 to Sunday Nov 8, 2026
      await repository.saveDailyActivity(
        date: '2026-11-02',
        steps: 8000,
        distanceKm: 5.6,
        calories: 380,
        activeMinutes: 50,
        goalSteps: 8000,
      );
      await repository.saveDailyActivity(
        date: '2026-11-03',
        steps: 9000,
        distanceKm: 6.3,
        calories: 420,
        activeMinutes: 60,
        goalSteps: 8000,
      );

      // Simulate Monday Nov 9, 2026 (the week of Nov 2..Nov 8 has ended)
      final simulatedMonday = DateTime(2026, 11, 9, 10, 0);

      // Run catch-up
      final generated = await scheduler.checkAndGeneratePendingReports(
        referenceDate: simulatedMonday,
        maxWeeksToCheck: 2,
      );

      expect(generated.length, greaterThanOrEqualTo(1));
      final report = generated.firstWhere((r) => r.weekNumber == 45);
      expect(report.totalSteps, equals(17000));

      // Second run must be completely idempotent (0 newly generated reports)
      final secondRun = await scheduler.checkAndGeneratePendingReports(
        referenceDate: simulatedMonday,
        maxWeeksToCheck: 2,
      );
      expect(secondRun.isEmpty, isTrue);
    });
  });

  group('Phase 4 - PDF Generation Verification', () {
    test('Generates PDF report document without errors and writes to file', () async {
      final report = WeeklyReportModel(
        id: 'report_2026_W45',
        startDate: '2026-11-02',
        endDate: '2026-11-08',
        year: 2026,
        weekNumber: 45,
        generatedAt: DateTime.now(),
        totalSteps: 62000,
        totalDistanceKm: 43.4,
        totalCalories: 2950,
        totalActiveMinutes: 410,
        totalSleepMinutes: 3150,
        avgDailySteps: 8857,
        avgDailyDistanceKm: 6.2,
        avgDailyCalories: 421,
        avgDailySleepMinutes: 450,
        goalMetDays: 6,
        mostActiveDayDate: '2026-11-05',
        mostActiveDaySteps: 13500,
        recordedDaysCount: 7,
        stepsChangePercent: 12.5,
        sleepChangePercent: 5.0,
        dailyBreakdowns: [
          WeeklyDayBreakdown(
            date: '2026-11-02',
            dayOfWeek: 1,
            dayName: 'Mon',
            steps: 9500,
            distanceKm: 6.6,
            calories: 450,
            activeMinutes: 65,
            sleepMinutes: 470,
            goalSteps: 8000,
            isGoalMet: true,
            isMissing: false,
          ),
        ],
      );

      final path = await PdfReportService.generateAndSaveWeeklyReportPdf(report);
      expect(path, isNotEmpty);
      final file = File(path);
      expect(await file.exists(), isTrue);
      expect(await file.length(), greaterThan(500));
    });
  });
}
