import 'package:drift/drift.dart';

/// Table representing daily aggregated physical activity records.
/// Primary key is local calendar date (`yyyy-MM-dd`) to guarantee absolute uniqueness
/// and prevent duplicate daily records.
class DailyActivityEntries extends Table {
  /// Local calendar date representation: "YYYY-MM-DD" (Primary Key)
  TextColumn get date => text()();
  
  IntColumn get steps => integer().withDefault(const Constant(0))();
  RealColumn get distanceKm => real().withDefault(const Constant(0.0))();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  IntColumn get activeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get goalSteps => integer().withDefault(const Constant(8000))();
  BoolColumn get isGoalCompleted => boolean().withDefault(const Constant(false))();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date};
}
