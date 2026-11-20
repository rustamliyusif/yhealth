import 'package:drift/drift.dart';

/// Tracks one-time migration execution and database upgrades.
class MigrationMetadataEntries extends Table {
  TextColumn get key => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get migratedAt => dateTime().nullable()();
  IntColumn get recordsCount => integer().withDefault(const Constant(0))();
  TextColumn get verificationHash => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
