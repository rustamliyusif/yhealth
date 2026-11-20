import 'package:drift/drift.dart';

/// Table representing outdoor GPS tracks and OpenStreetMap sessions.
class SavedRoutesEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get routeDateTime => dateTime().named('date_time')();
  RealColumn get distanceKm => real()();
  IntColumn get durationSeconds => integer()();
  RealColumn get avgSpeedKmH => real()();
  IntColumn get calories => integer()();
  RealColumn get vehicleDistanceKm => real().withDefault(const Constant(0.0))();
  TextColumn get coordinatesJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}
