import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/daily_activity_table.dart';
import 'tables/saved_routes_table.dart';
import 'tables/migration_metadata_table.dart';
import 'tables/sleep_records_table.dart';
import 'tables/weekly_reports_table.dart';
import 'tables/weight_records_table.dart';
import 'tables/coach_messages_table.dart';
import 'daos/activity_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DailyActivityEntries,
    SavedRoutesEntries,
    MigrationMetadataEntries,
    SleepRecordsEntries,
    WeeklyReportsEntries,
    WeightRecordsEntries,
    CoachMessagesEntries,
  ],
  daos: [
    ActivityDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(sleepRecordsEntries);
          }
          if (from < 3) {
            await m.createTable(weeklyReportsEntries);
          }
          if (from < 4) {
            await m.createTable(weightRecordsEntries);
            await m.createTable(coachMessagesEntries);
          }
        },
        beforeOpen: (details) async {
          // Enable foreign keys and pragmas
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yhealth.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
