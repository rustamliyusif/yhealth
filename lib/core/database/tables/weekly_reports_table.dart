import 'package:drift/drift.dart';

/// Drift table storing generated weekly health, activity, and sleep reports.
/// Stores historical summaries, daily breakdowns, and week-over-week deltas locally.
class WeeklyReportsEntries extends Table {
  /// Unique identifier: e.g. 'report_2026_W44' or 'report_2026-10-26_2026-11-01'
  TextColumn get id => text()();

  /// Start date of the week (Monday, formatted as yyyy-MM-dd)
  TextColumn get startDate => text()();

  /// End date of the week (Sunday, formatted as yyyy-MM-dd)
  TextColumn get endDate => text()();

  /// Calendar year of the reporting week
  IntColumn get year => integer()();

  /// ISO 8601 week number (1 - 53)
  IntColumn get weekNumber => integer()();

  /// Timestamp when the report was generated
  DateTimeColumn get generatedAt => dateTime()();

  /// Total steps recorded across the 7-day period
  IntColumn get totalSteps => integer()();

  /// Total distance in kilometers
  RealColumn get totalDistanceKm => real()();

  /// Total calories burned (kcal)
  IntColumn get totalCalories => integer()();

  /// Total active duration in minutes
  IntColumn get totalActiveMinutes => integer()();

  /// Total sleep duration in minutes
  IntColumn get totalSleepMinutes => integer()();

  /// Daily average step count (totalSteps / 7)
  IntColumn get avgDailySteps => integer()();

  /// Daily average distance in km
  RealColumn get avgDailyDistanceKm => real()();

  /// Daily average calories burned
  IntColumn get avgDailyCalories => integer()();

  /// Daily average sleep in minutes
  IntColumn get avgDailySleepMinutes => integer()();

  /// Number of days (0 - 7) where the user met their daily step goal
  IntColumn get goalMetDays => integer()();

  /// Calendar date of the most active day (yyyy-MM-dd)
  TextColumn get mostActiveDayDate => text()();

  /// Step count achieved on the most active day
  IntColumn get mostActiveDaySteps => integer()();

  /// Number of days during the week with recorded activity (0 - 7)
  IntColumn get recordedDaysCount => integer()();

  /// Percentage change in total steps compared to preceding week (nullable)
  RealColumn get stepsChangePercent => real().nullable()();

  /// Percentage change in total sleep compared to preceding week (nullable)
  RealColumn get sleepChangePercent => real().nullable()();

  /// Percentage change in calories burned compared to preceding week (nullable)
  RealColumn get caloriesChangePercent => real().nullable()();

  /// Percentage change in distance compared to preceding week (nullable)
  RealColumn get distanceChangePercent => real().nullable()();

  /// JSON-encoded array containing the 7-day daily breakdown data
  TextColumn get dailyBreakdownJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}
