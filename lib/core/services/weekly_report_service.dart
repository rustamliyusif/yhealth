import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../models/weekly_report_model.dart';

/// Core engine responsible for calculating weekly health statistics,
/// ISO date ranges, and week-over-week progress comparisons.
class WeeklyReportService {
  static const List<String> dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  /// Returns the ISO 8601 week number (1 - 53) for the given [date].
  /// Week 1 is the week with the first Thursday of the year.
  static int getIsoWeekNumber(DateTime date) {
    // Determine the Thursday in the current week (date.weekday: 1=Mon .. 7=Sun)
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    final dayOfYear = thursday.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear - 1) / 7).floor() + 1;
  }

  /// Returns the ISO 8601 calendar year for the week of [date].
  static int getIsoYear(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    return thursday.year;
  }

  /// Returns the Monday 00:00:00 and Sunday 23:59:59 bounding the week of [date].
  static ({DateTime monday, DateTime sunday}) getWeekRange(DateTime date) {
    final monday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return (monday: monday, sunday: sunday);
  }

  /// Returns the previous completed week's Monday and Sunday.
  static ({DateTime monday, DateTime sunday}) getPreviousWeekRange(DateTime date) {
    final thisMonday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
    final prevMonday = thisMonday.subtract(const Duration(days: 7));
    final prevSunday = prevMonday.add(const Duration(days: 6));
    return (monday: prevMonday, sunday: prevSunday);
  }

  /// Generates a [WeeklyReportModel] for the 7-day period starting on [monday] and ending on [sunday].
  /// Uses strictly verified data from [activities] and [sleepRecords].
  /// Distinguishes zero activity from missing records with [WeeklyDayBreakdown.isMissing].
  static WeeklyReportModel calculateWeeklyReport({
    required DateTime monday,
    required DateTime sunday,
    required List<DailyActivityEntry> activities,
    required List<SleepRecordsEntry> sleepRecords,
    WeeklyReportModel? previousWeekReport,
  }) {
    final year = getIsoYear(monday);
    final weekNumber = getIsoWeekNumber(monday);
    final id = 'report_${year}_W${weekNumber.toString().padLeft(2, '0')}';
    final formatter = DateFormat('yyyy-MM-dd');
    final startDateStr = formatter.format(monday);
    final endDateStr = formatter.format(sunday);

    final List<WeeklyDayBreakdown> breakdowns = [];
    int totalSteps = 0;
    double totalDistanceKm = 0.0;
    int totalCalories = 0;
    int totalActiveMinutes = 0;
    int totalSleepMinutes = 0;
    int goalMetDays = 0;
    int recordedDaysCount = 0;

    String mostActiveDayDate = startDateStr;
    int mostActiveDaySteps = 0;

    for (int i = 0; i < 7; i++) {
      final currentDay = monday.add(Duration(days: i));
      final dateKey = formatter.format(currentDay);
      final dayName = dayNames[i];

      // Find activity record for this specific calendar date
      DailyActivityEntry? activity;
      for (final a in activities) {
        if (a.date == dateKey) {
          activity = a;
          break;
        }
      }

      // Aggregate all sleep records belonging to this calendar date
      int daySleepMinutes = 0;
      for (final s in sleepRecords) {
        if (s.date == dateKey) {
          daySleepMinutes += s.durationMinutes;
        }
      }

      final bool isMissing = (activity == null);
      final int steps = activity?.steps ?? 0;
      final double distanceKm = activity?.distanceKm ?? 0.0;
      final int calories = activity?.calories ?? 0;
      final int activeMinutes = activity?.activeMinutes ?? 0;
      final int goalSteps = activity?.goalSteps ?? 8000;
      final bool isGoalMet = !isMissing && steps >= goalSteps;

      if (!isMissing) {
        recordedDaysCount++;
      }

      totalSteps += steps;
      totalDistanceKm += distanceKm;
      totalCalories += calories;
      totalActiveMinutes += activeMinutes;
      totalSleepMinutes += daySleepMinutes;

      if (isGoalMet) {
        goalMetDays++;
      }

      if (steps > mostActiveDaySteps) {
        mostActiveDaySteps = steps;
        mostActiveDayDate = dateKey;
      }

      breakdowns.add(
        WeeklyDayBreakdown(
          date: dateKey,
          dayOfWeek: i + 1,
          dayName: dayName,
          steps: steps,
          distanceKm: distanceKm,
          calories: calories,
          activeMinutes: activeMinutes,
          sleepMinutes: daySleepMinutes,
          goalSteps: goalSteps,
          isGoalMet: isGoalMet,
          isMissing: isMissing,
        ),
      );
    }

    // Averages across the 7-day calendar week
    final avgDailySteps = (totalSteps / 7.0).round();
    final avgDailyDistanceKm = totalDistanceKm / 7.0;
    final avgDailyCalories = (totalCalories / 7.0).round();
    final avgDailySleepMinutes = (totalSleepMinutes / 7.0).round();

    // Week-over-week deltas calculation
    double? stepsChangePercent;
    double? sleepChangePercent;
    double? caloriesChangePercent;
    double? distanceChangePercent;

    if (previousWeekReport != null) {
      if (previousWeekReport.totalSteps > 0) {
        stepsChangePercent =
            ((totalSteps - previousWeekReport.totalSteps) / previousWeekReport.totalSteps) * 100.0;
      } else if (totalSteps > 0) {
        stepsChangePercent = 100.0;
      }

      if (previousWeekReport.totalSleepMinutes > 0) {
        sleepChangePercent =
            ((totalSleepMinutes - previousWeekReport.totalSleepMinutes) /
                    previousWeekReport.totalSleepMinutes) *
                100.0;
      } else if (totalSleepMinutes > 0) {
        sleepChangePercent = 100.0;
      }

      if (previousWeekReport.totalCalories > 0) {
        caloriesChangePercent =
            ((totalCalories - previousWeekReport.totalCalories) /
                    previousWeekReport.totalCalories) *
                100.0;
      } else if (totalCalories > 0) {
        caloriesChangePercent = 100.0;
      }

      if (previousWeekReport.totalDistanceKm > 0.0) {
        distanceChangePercent =
            ((totalDistanceKm - previousWeekReport.totalDistanceKm) /
                    previousWeekReport.totalDistanceKm) *
                100.0;
      } else if (totalDistanceKm > 0.0) {
        distanceChangePercent = 100.0;
      }
    }

    return WeeklyReportModel(
      id: id,
      startDate: startDateStr,
      endDate: endDateStr,
      year: year,
      weekNumber: weekNumber,
      generatedAt: DateTime.now(),
      totalSteps: totalSteps,
      totalDistanceKm: totalDistanceKm,
      totalCalories: totalCalories,
      totalActiveMinutes: totalActiveMinutes,
      totalSleepMinutes: totalSleepMinutes,
      avgDailySteps: avgDailySteps,
      avgDailyDistanceKm: avgDailyDistanceKm,
      avgDailyCalories: avgDailyCalories,
      avgDailySleepMinutes: avgDailySleepMinutes,
      goalMetDays: goalMetDays,
      mostActiveDayDate: mostActiveDayDate,
      mostActiveDaySteps: mostActiveDaySteps,
      recordedDaysCount: recordedDaysCount,
      stepsChangePercent: stepsChangePercent,
      sleepChangePercent: sleepChangePercent,
      caloriesChangePercent: caloriesChangePercent,
      distanceChangePercent: distanceChangePercent,
      dailyBreakdowns: breakdowns,
    );
  }
}
