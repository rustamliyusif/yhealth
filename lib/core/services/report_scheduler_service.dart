import 'package:intl/intl.dart';
import '../models/weekly_report_model.dart';
import '../repositories/activity_repository.dart';
import 'weekly_report_service.dart';

/// Service ensuring reliable weekly report generation, catch-up execution,
/// and duplicate prevention.
class ReportSchedulerService {
  final ActivityRepository _repository;

  ReportSchedulerService(this._repository);

  /// Checks for any completed weeks that lack a generated report in the database,
  /// generating and storing them in Drift SQLite.
  /// Handles missed background execution seamlessly on app startup.
  Future<List<WeeklyReportModel>> checkAndGeneratePendingReports({
    DateTime? referenceDate,
    int maxWeeksToCheck = 4,
  }) async {
    final now = referenceDate ?? DateTime.now();
    final List<WeeklyReportModel> newlyGenerated = [];

    // Check past completed weeks in chronological order so comparisons chain correctly
    for (int i = maxWeeksToCheck; i >= 1; i--) {
      // Step back by i weeks
      final pastDate = now.subtract(Duration(days: i * 7));
      final weekRange = WeeklyReportService.getWeekRange(pastDate);

      // Verify that the week has actually concluded (its Sunday has passed)
      final endOfSunday = DateTime(
        weekRange.sunday.year,
        weekRange.sunday.month,
        weekRange.sunday.day,
        23,
        59,
        59,
      );
      if (now.isBefore(endOfSunday)) {
        continue;
      }

      final year = WeeklyReportService.getIsoYear(weekRange.monday);
      final weekNumber = WeeklyReportService.getIsoWeekNumber(weekRange.monday);
      final id = 'report_${year}_W${weekNumber.toString().padLeft(2, '0')}';

      // Check if report already exists (prevents duplicate reports)
      final existing = await _repository.getWeeklyReportById(id);
      if (existing != null) {
        continue;
      }

      // Check if previous week exists for week-over-week deltas
      final prevWeekRange = WeeklyReportService.getPreviousWeekRange(weekRange.monday);
      final prevYear = WeeklyReportService.getIsoYear(prevWeekRange.monday);
      final prevWeekNumber = WeeklyReportService.getIsoWeekNumber(prevWeekRange.monday);
      final prevId = 'report_${prevYear}_W${prevWeekNumber.toString().padLeft(2, '0')}';
      final previousWeekReport = await _repository.getWeeklyReportById(prevId);

      final formatter = DateFormat('yyyy-MM-dd');
      final startStr = formatter.format(weekRange.monday);
      final endStr = formatter.format(weekRange.sunday);

      final activities = await _repository.getActivitiesInRange(startStr, endStr);
      final sleepRecords = await _repository.getSleepRecordsInRange(startStr, endStr);

      final report = WeeklyReportService.calculateWeeklyReport(
        monday: weekRange.monday,
        sunday: weekRange.sunday,
        activities: activities,
        sleepRecords: sleepRecords,
        previousWeekReport: previousWeekReport,
      );

      await _repository.saveWeeklyReport(report);
      newlyGenerated.add(report);
    }

    return newlyGenerated;
  }

  /// Forces generation of a report for a specific week, replacing any existing entry.
  Future<WeeklyReportModel> forceGenerateReportForWeek(DateTime targetDate) async {
    final weekRange = WeeklyReportService.getWeekRange(targetDate);
    final prevWeekRange = WeeklyReportService.getPreviousWeekRange(weekRange.monday);
    final prevYear = WeeklyReportService.getIsoYear(prevWeekRange.monday);
    final prevWeekNumber = WeeklyReportService.getIsoWeekNumber(prevWeekRange.monday);
    final prevId = 'report_${prevYear}_W${prevWeekNumber.toString().padLeft(2, '0')}';
    final previousWeekReport = await _repository.getWeeklyReportById(prevId);

    final formatter = DateFormat('yyyy-MM-dd');
    final startStr = formatter.format(weekRange.monday);
    final endStr = formatter.format(weekRange.sunday);

    final activities = await _repository.getActivitiesInRange(startStr, endStr);
    final sleepRecords = await _repository.getSleepRecordsInRange(startStr, endStr);

    final report = WeeklyReportService.calculateWeeklyReport(
      monday: weekRange.monday,
      sunday: weekRange.sunday,
      activities: activities,
      sleepRecords: sleepRecords,
      previousWeekReport: previousWeekReport,
    );

    await _repository.saveWeeklyReport(report);
    return report;
  }
}
