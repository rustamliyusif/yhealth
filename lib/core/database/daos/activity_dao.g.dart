// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_dao.dart';

// ignore_for_file: type=lint
mixin _$ActivityDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyActivityEntriesTable get dailyActivityEntries =>
      attachedDatabase.dailyActivityEntries;
  $SavedRoutesEntriesTable get savedRoutesEntries =>
      attachedDatabase.savedRoutesEntries;
  $MigrationMetadataEntriesTable get migrationMetadataEntries =>
      attachedDatabase.migrationMetadataEntries;
  $SleepRecordsEntriesTable get sleepRecordsEntries =>
      attachedDatabase.sleepRecordsEntries;
  $WeeklyReportsEntriesTable get weeklyReportsEntries =>
      attachedDatabase.weeklyReportsEntries;
  $WeightRecordsEntriesTable get weightRecordsEntries =>
      attachedDatabase.weightRecordsEntries;
  $CoachMessagesEntriesTable get coachMessagesEntries =>
      attachedDatabase.coachMessagesEntries;
  ActivityDaoManager get managers => ActivityDaoManager(this);
}

class ActivityDaoManager {
  final _$ActivityDaoMixin _db;
  ActivityDaoManager(this._db);
  $$DailyActivityEntriesTableTableManager get dailyActivityEntries =>
      $$DailyActivityEntriesTableTableManager(
        _db.attachedDatabase,
        _db.dailyActivityEntries,
      );
  $$SavedRoutesEntriesTableTableManager get savedRoutesEntries =>
      $$SavedRoutesEntriesTableTableManager(
        _db.attachedDatabase,
        _db.savedRoutesEntries,
      );
  $$MigrationMetadataEntriesTableTableManager get migrationMetadataEntries =>
      $$MigrationMetadataEntriesTableTableManager(
        _db.attachedDatabase,
        _db.migrationMetadataEntries,
      );
  $$SleepRecordsEntriesTableTableManager get sleepRecordsEntries =>
      $$SleepRecordsEntriesTableTableManager(
        _db.attachedDatabase,
        _db.sleepRecordsEntries,
      );
  $$WeeklyReportsEntriesTableTableManager get weeklyReportsEntries =>
      $$WeeklyReportsEntriesTableTableManager(
        _db.attachedDatabase,
        _db.weeklyReportsEntries,
      );
  $$WeightRecordsEntriesTableTableManager get weightRecordsEntries =>
      $$WeightRecordsEntriesTableTableManager(
        _db.attachedDatabase,
        _db.weightRecordsEntries,
      );
  $$CoachMessagesEntriesTableTableManager get coachMessagesEntries =>
      $$CoachMessagesEntriesTableTableManager(
        _db.attachedDatabase,
        _db.coachMessagesEntries,
      );
}
