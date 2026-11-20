import 'package:drift/drift.dart';

/// Table representing local sleep sessions.
/// Sessions can be entered manually or imported from Android Health Connect.
class SleepRecordsEntries extends Table {
  /// Unique identifier (UUID or timestamp string)
  TextColumn get id => text()();

  /// Reference date representing the wake-up calendar morning ("YYYY-MM-DD")
  TextColumn get date => text()();

  /// Precise bedtime timestamp (e.g. 2026-11-06 23:15:00)
  DateTimeColumn get bedtime => dateTime()();

  /// Precise wake-up timestamp (e.g. 2026-11-07 07:30:00)
  DateTimeColumn get wakeTime => dateTime()();

  /// Total sleep duration in minutes
  IntColumn get durationMinutes => integer()();

  /// Data origin: 'manual', 'health_connect', 'estimated'
  TextColumn get source => text().withDefault(const Constant('manual'))();

  /// Optional sleep efficiency percentage (0-100%)
  IntColumn get efficiencyPercent => integer().withDefault(const Constant(85))();

  /// Optional personal notes or dream tags
  TextColumn get notes => text().nullable()();

  /// Sleep stage breakdown - ONLY populated when genuinely provided by Health Connect or wearable.
  /// Never fabricated.
  BoolColumn get hasStages => boolean().withDefault(const Constant(false))();
  IntColumn get lightSleepMinutes => integer().nullable()();
  IntColumn get deepSleepMinutes => integer().nullable()();
  IntColumn get remSleepMinutes => integer().nullable()();
  IntColumn get awakeMinutes => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
