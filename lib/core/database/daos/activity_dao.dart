import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/daily_activity_table.dart';
import '../tables/saved_routes_table.dart';
import '../tables/migration_metadata_table.dart';
import '../tables/sleep_records_table.dart';
import '../tables/weekly_reports_table.dart';
import '../tables/weight_records_table.dart';
import '../tables/coach_messages_table.dart';

part 'activity_dao.g.dart';

@DriftAccessor(tables: [
  DailyActivityEntries,
  SavedRoutesEntries,
  MigrationMetadataEntries,
  SleepRecordsEntries,
  WeeklyReportsEntries,
  WeightRecordsEntries,
  CoachMessagesEntries,
])
class ActivityDao extends DatabaseAccessor<AppDatabase> with _$ActivityDaoMixin {
  ActivityDao(super.db);

  // ---------------------------------------------------------
  // DAILY ACTIVITY OPERATIONS
  // ---------------------------------------------------------

  Future<int> upsertDailyActivity(DailyActivityEntriesCompanion entry) {
    return into(dailyActivityEntries).insertOnConflictUpdate(entry);
  }

  Future<DailyActivityEntry?> getDailyActivityByDate(String date) {
    return (select(dailyActivityEntries)..where((tbl) => tbl.date.equals(date)))
        .getSingleOrNull();
  }

  Stream<DailyActivityEntry?> watchDailyActivityByDate(String date) {
    return (select(dailyActivityEntries)..where((tbl) => tbl.date.equals(date)))
        .watchSingleOrNull();
  }

  Future<List<DailyActivityEntry>> getAllDailyActivities({int limit = 60}) {
    return (select(dailyActivityEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Stream<List<DailyActivityEntry>> watchAllDailyActivities({int limit = 60}) {
    return (select(dailyActivityEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Future<List<DailyActivityEntry>> getActivitiesInRange(String startDate, String endDate) {
    return (select(dailyActivityEntries)
          ..where((t) => t.date.isBiggerOrEqualValue(startDate) & t.date.isSmallerOrEqualValue(endDate))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .get();
  }

  Future<int> getDailyActivitiesCount() async {
    final countExp = dailyActivityEntries.date.count();
    final query = selectOnly(dailyActivityEntries)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  // ---------------------------------------------------------
  // SAVED ROUTES OPERATIONS
  // ---------------------------------------------------------

  Future<int> insertOrUpdateRoute(SavedRoutesEntriesCompanion entry) {
    return into(savedRoutesEntries).insertOnConflictUpdate(entry);
  }

  Future<List<SavedRoutesEntry>> getAllRoutes() {
    return (select(savedRoutesEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.routeDateTime, mode: OrderingMode.desc)]))
        .get();
  }

  Stream<List<SavedRoutesEntry>> watchAllRoutes() {
    return (select(savedRoutesEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.routeDateTime, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> deleteRoute(String id) {
    return (delete(savedRoutesEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getRoutesCount() async {
    final countExp = savedRoutesEntries.id.count();
    final query = selectOnly(savedRoutesEntries)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  // ---------------------------------------------------------
  // SLEEP RECORDS OPERATIONS
  // ---------------------------------------------------------

  Future<int> upsertSleepRecord(SleepRecordsEntriesCompanion entry) {
    return into(sleepRecordsEntries).insertOnConflictUpdate(entry);
  }

  Future<SleepRecordsEntry?> getSleepRecordById(String id) {
    return (select(sleepRecordsEntries)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<SleepRecordsEntry?> getSleepRecordByDate(String date) {
    return (select(sleepRecordsEntries)
          ..where((tbl) => tbl.date.equals(date))
          ..orderBy([(t) => OrderingTerm(expression: t.wakeTime, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<SleepRecordsEntry?> watchLatestSleepRecord() {
    return (select(sleepRecordsEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.wakeTime, mode: OrderingMode.desc)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<List<SleepRecordsEntry>> getAllSleepRecords({int limit = 60}) {
    return (select(sleepRecordsEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.wakeTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Stream<List<SleepRecordsEntry>> watchAllSleepRecords({int limit = 60}) {
    return (select(sleepRecordsEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.wakeTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Future<int> deleteSleepRecord(String id) {
    return (delete(sleepRecordsEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getSleepRecordsCount() async {
    final countExp = sleepRecordsEntries.id.count();
    final query = selectOnly(sleepRecordsEntries)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<List<SleepRecordsEntry>> getOverlappingSleepRecords({
    required DateTime bedtime,
    required DateTime wakeTime,
    String? excludeId,
  }) {
    final query = select(sleepRecordsEntries)
      ..where((t) {
        final overlapCond = t.bedtime.isSmallerThanValue(wakeTime) &
            t.wakeTime.isBiggerThanValue(bedtime);
        if (excludeId != null) {
          return overlapCond & t.id.equals(excludeId).not();
        }
        return overlapCond;
      });
    return query.get();
  }

  Future<List<SleepRecordsEntry>> getSleepRecordsInRange(String startDate, String endDate) {
    return (select(sleepRecordsEntries)
          ..where((t) => t.date.isBiggerOrEqualValue(startDate) & t.date.isSmallerOrEqualValue(endDate))
          ..orderBy([(t) => OrderingTerm(expression: t.wakeTime, mode: OrderingMode.asc)]))
        .get();
  }

  // ---------------------------------------------------------
  // WEEKLY REPORTS OPERATIONS
  // ---------------------------------------------------------

  Future<int> upsertWeeklyReport(WeeklyReportsEntriesCompanion entry) {
    return into(weeklyReportsEntries).insertOnConflictUpdate(entry);
  }

  Future<WeeklyReportsEntry?> getWeeklyReportById(String id) {
    return (select(weeklyReportsEntries)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<WeeklyReportsEntry?> getWeeklyReportByWeek(int year, int weekNumber) {
    return (select(weeklyReportsEntries)
          ..where((tbl) => tbl.year.equals(year) & tbl.weekNumber.equals(weekNumber)))
        .getSingleOrNull();
  }

  Future<List<WeeklyReportsEntry>> getAllWeeklyReports({int limit = 52}) {
    return (select(weeklyReportsEntries)
          ..orderBy([
            (t) => OrderingTerm(expression: t.year, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.weekNumber, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  Stream<List<WeeklyReportsEntry>> watchAllWeeklyReports({int limit = 52}) {
    return (select(weeklyReportsEntries)
          ..orderBy([
            (t) => OrderingTerm(expression: t.year, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.weekNumber, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch();
  }

  Future<int> deleteWeeklyReport(String id) {
    return (delete(weeklyReportsEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getWeeklyReportsCount() async {
    final countExp = weeklyReportsEntries.id.count();
    final query = selectOnly(weeklyReportsEntries)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  // ---------------------------------------------------------
  // WEIGHT RECORDS OPERATIONS
  // ---------------------------------------------------------

  Future<int> upsertWeightRecord(WeightRecordsEntriesCompanion entry) {
    return into(weightRecordsEntries).insertOnConflictUpdate(entry);
  }

  Future<WeightRecordsEntry?> getWeightRecordById(String id) {
    return (select(weightRecordsEntries)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<WeightRecordsEntry?> getLatestWeightRecord() {
    return (select(weightRecordsEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<WeightRecordsEntry>> getAllWeightRecords({int limit = 100}) {
    return (select(weightRecordsEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Stream<List<WeightRecordsEntry>> watchAllWeightRecords({int limit = 100}) {
    return (select(weightRecordsEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Future<int> deleteWeightRecord(String id) {
    return (delete(weightRecordsEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getWeightRecordsCount() async {
    final countExp = weightRecordsEntries.id.count();
    final query = selectOnly(weightRecordsEntries)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  // ---------------------------------------------------------
  // COACH MESSAGES OPERATIONS
  // ---------------------------------------------------------

  Future<int> insertCoachMessage(CoachMessagesEntriesCompanion entry) {
    return into(coachMessagesEntries).insertOnConflictUpdate(entry);
  }

  Future<List<CoachMessagesEntry>> getAllCoachMessages({int limit = 100}) {
    return (select(coachMessagesEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)])
          ..limit(limit))
        .get();
  }

  Stream<List<CoachMessagesEntry>> watchAllCoachMessages({int limit = 100}) {
    return (select(coachMessagesEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)])
          ..limit(limit))
        .watch();
  }

  Future<int> clearCoachMessages() {
    return delete(coachMessagesEntries).go();
  }

  Future<int> getCoachMessagesCount() async {
    final countExp = coachMessagesEntries.id.count();
    final query = selectOnly(coachMessagesEntries)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  // ---------------------------------------------------------
  // MIGRATION METADATA OPERATIONS
  // ---------------------------------------------------------

  Future<bool> isMigrationCompleted(String key) async {
    final entry = await (select(migrationMetadataEntries)
          ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
    return entry?.isCompleted ?? false;
  }

  Future<MigrationMetadataEntry?> getMigrationMetadata(String key) {
    return (select(migrationMetadataEntries)
          ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
  }

  Future<int> setMigrationCompleted({
    required String key,
    required int recordsCount,
    String? verificationHash,
  }) {
    return into(migrationMetadataEntries).insertOnConflictUpdate(
      MigrationMetadataEntriesCompanion(
        key: Value(key),
        isCompleted: const Value(true),
        migratedAt: Value(DateTime.now()),
        recordsCount: Value(recordsCount),
        verificationHash: Value(verificationHash),
      ),
    );
  }
}
