import 'package:drift/drift.dart';

/// Drift table storing historical body weight measurements.
class WeightRecordsEntries extends Table {
  /// Unique identifier (e.g. UUID or timestamp string)
  TextColumn get id => text()();

  /// Calendar date of the weight measurement (yyyy-MM-dd)
  TextColumn get date => text()();

  /// Body weight in kilograms
  RealColumn get weightKg => real()();

  /// Body Mass Index calculated at the time of recording
  RealColumn get bmi => real()();

  /// Optional user notes or context (e.g. "Morning before breakfast")
  TextColumn get notes => text().nullable()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
