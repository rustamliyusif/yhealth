import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import '../database/app_database.dart';
import '../models/sleep_record_model.dart';
import '../models/weekly_report_model.dart';
import '../models/weight_record_model.dart';
import '../models/coach_message_model.dart';
import '../providers/activity_provider.dart';

/// Clean repository interface abstracting persistent activity and health storage.
abstract class ActivityRepository {
  // Daily Activity
  Future<int> saveDailyActivity({
    required String date,
    required int steps,
    required double distanceKm,
    required int calories,
    required int activeMinutes,
    required int goalSteps,
  });

  Future<DailyActivityEntry?> getDailyActivity(String date);
  Stream<DailyActivityEntry?> watchDailyActivity(String date);
  Future<List<DailyActivityEntry>> getAllDailyActivities({int limit = 60});
  Stream<List<DailyActivityEntry>> watchAllDailyActivities({int limit = 60});
  Future<List<DailyActivityEntry>> getActivitiesInRange(String startDate, String endDate);
  Future<int> getDailyActivitiesCount();

  // Saved Routes
  Future<void> saveRoute(SavedRouteModel route);
  Future<List<SavedRouteModel>> getAllRoutes();
  Stream<List<SavedRouteModel>> watchAllRoutes();
  Future<void> deleteRoute(String id);
  Future<int> getRoutesCount();

  // Sleep Records
  Future<void> saveSleepRecord(SleepRecordModel record);
  Future<SleepRecordModel?> getSleepRecordById(String id);
  Future<SleepRecordModel?> getSleepRecordByDate(String date);
  Stream<SleepRecordModel?> watchLatestSleepRecord();
  Future<List<SleepRecordModel>> getAllSleepRecords({int limit = 60});
  Stream<List<SleepRecordModel>> watchAllSleepRecords({int limit = 60});
  Future<void> deleteSleepRecord(String id);
  Future<int> getSleepRecordsCount();
  Future<List<SleepRecordModel>> getOverlappingSleepRecords({
    required DateTime bedtime,
    required DateTime wakeTime,
    String? excludeId,
  });
  Future<List<SleepRecordsEntry>> getSleepRecordsInRange(String startDate, String endDate);

  // Weekly Reports
  Future<void> saveWeeklyReport(WeeklyReportModel report);
  Future<WeeklyReportModel?> getWeeklyReportById(String id);
  Future<WeeklyReportModel?> getWeeklyReportByWeek(int year, int weekNumber);
  Future<List<WeeklyReportModel>> getAllWeeklyReports({int limit = 52});
  Stream<List<WeeklyReportModel>> watchAllWeeklyReports({int limit = 52});
  Future<void> deleteWeeklyReport(String id);
  Future<int> getWeeklyReportsCount();

  // Weight Records
  Future<void> saveWeightRecord(WeightRecordModel record);
  Future<WeightRecordModel?> getWeightRecordById(String id);
  Future<WeightRecordModel?> getLatestWeightRecord();
  Future<List<WeightRecordModel>> getAllWeightRecords({int limit = 100});
  Stream<List<WeightRecordModel>> watchAllWeightRecords({int limit = 100});
  Future<void> deleteWeightRecord(String id);
  Future<int> getWeightRecordsCount();

  // Coach Messages
  Future<void> saveCoachMessage(CoachMessageModel message);
  Future<List<CoachMessageModel>> getAllCoachMessages({int limit = 100});
  Stream<List<CoachMessageModel>> watchAllCoachMessages({int limit = 100});
  Future<void> clearCoachMessages();
  Future<int> getCoachMessagesCount();

  // Migration & Metadata
  Future<bool> isMigrationCompleted(String migrationKey);
  Future<void> markMigrationCompleted({
    required String migrationKey,
    required int recordsCount,
    String? verificationHash,
  });
}

/// Production Drift-backed implementation of [ActivityRepository].
class DriftActivityRepository implements ActivityRepository {
  final AppDatabase _db;

  DriftActivityRepository(this._db);

  AppDatabase get db => _db;

  @override
  Future<int> saveDailyActivity({
    required String date,
    required int steps,
    required double distanceKm,
    required int calories,
    required int activeMinutes,
    required int goalSteps,
  }) {
    final isGoalCompleted = steps >= goalSteps;
    final now = DateTime.now();

    return _db.activityDao.upsertDailyActivity(
      DailyActivityEntriesCompanion(
        date: Value(date),
        steps: Value(steps),
        distanceKm: Value(distanceKm),
        calories: Value(calories),
        activeMinutes: Value(activeMinutes),
        goalSteps: Value(goalSteps),
        isGoalCompleted: Value(isGoalCompleted),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<DailyActivityEntry?> getDailyActivity(String date) {
    return _db.activityDao.getDailyActivityByDate(date);
  }

  @override
  Stream<DailyActivityEntry?> watchDailyActivity(String date) {
    return _db.activityDao.watchDailyActivityByDate(date);
  }

  @override
  Future<List<DailyActivityEntry>> getAllDailyActivities({int limit = 60}) {
    return _db.activityDao.getAllDailyActivities(limit: limit);
  }

  @override
  Stream<List<DailyActivityEntry>> watchAllDailyActivities({int limit = 60}) {
    return _db.activityDao.watchAllDailyActivities(limit: limit);
  }

  @override
  Future<List<DailyActivityEntry>> getActivitiesInRange(String startDate, String endDate) {
    return _db.activityDao.getActivitiesInRange(startDate, endDate);
  }

  @override
  Future<int> getDailyActivitiesCount() {
    return _db.activityDao.getDailyActivitiesCount();
  }

  // Routes
  @override
  Future<void> saveRoute(SavedRouteModel route) async {
    final coordinatesJson = jsonEncode(
      route.coordinates.map((c) => {'lat': c.latitude, 'lng': c.longitude}).toList(),
    );

    await _db.activityDao.insertOrUpdateRoute(
      SavedRoutesEntriesCompanion(
        id: Value(route.id),
        title: Value(route.title),
        routeDateTime: Value(route.dateTime),
        distanceKm: Value(route.distanceKm),
        durationSeconds: Value(route.durationSeconds),
        avgSpeedKmH: Value(route.avgSpeedKmH),
        calories: Value(route.calories),
        vehicleDistanceKm: Value(route.vehicleDistanceKm),
        coordinatesJson: Value(coordinatesJson),
      ),
    );
  }

  @override
  Future<List<SavedRouteModel>> getAllRoutes() async {
    final entries = await _db.activityDao.getAllRoutes();
    return entries.map(_mapEntryToRouteModel).toList();
  }

  @override
  Stream<List<SavedRouteModel>> watchAllRoutes() {
    return _db.activityDao.watchAllRoutes().map(
          (entries) => entries.map(_mapEntryToRouteModel).toList(),
        );
  }

  @override
  Future<void> deleteRoute(String id) async {
    await _db.activityDao.deleteRoute(id);
  }

  @override
  Future<int> getRoutesCount() {
    return _db.activityDao.getRoutesCount();
  }

  SavedRouteModel _mapEntryToRouteModel(SavedRoutesEntry entry) {
    List<LatLng> coords = [];
    try {
      final decoded = jsonDecode(entry.coordinatesJson) as List<dynamic>;
      coords = decoded.map((c) {
        final m = c as Map<String, dynamic>;
        return LatLng((m['lat'] as num).toDouble(), (m['lng'] as num).toDouble());
      }).toList();
    } catch (_) {}

    return SavedRouteModel(
      id: entry.id,
      title: entry.title,
      dateTime: entry.routeDateTime,
      distanceKm: entry.distanceKm,
      durationSeconds: entry.durationSeconds,
      avgSpeedKmH: entry.avgSpeedKmH,
      calories: entry.calories,
      vehicleDistanceKm: entry.vehicleDistanceKm,
      coordinates: coords,
    );
  }

  // Sleep Records
  @override
  Future<void> saveSleepRecord(SleepRecordModel record) async {
    final now = DateTime.now();
    await _db.activityDao.upsertSleepRecord(
      SleepRecordsEntriesCompanion(
        id: Value(record.id),
        date: Value(record.date),
        bedtime: Value(record.bedtime),
        wakeTime: Value(record.wakeTime),
        durationMinutes: Value(record.durationMinutes),
        source: Value(record.source),
        efficiencyPercent: Value(record.efficiencyPercent),
        notes: Value(record.notes),
        hasStages: Value(record.hasStages),
        lightSleepMinutes: Value(record.lightSleepMinutes),
        deepSleepMinutes: Value(record.deepSleepMinutes),
        remSleepMinutes: Value(record.remSleepMinutes),
        awakeMinutes: Value(record.awakeMinutes),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<SleepRecordModel?> getSleepRecordById(String id) async {
    final entry = await _db.activityDao.getSleepRecordById(id);
    return entry != null ? _mapEntryToSleepModel(entry) : null;
  }

  @override
  Future<SleepRecordModel?> getSleepRecordByDate(String date) async {
    final entry = await _db.activityDao.getSleepRecordByDate(date);
    return entry != null ? _mapEntryToSleepModel(entry) : null;
  }

  @override
  Stream<SleepRecordModel?> watchLatestSleepRecord() {
    return _db.activityDao.watchLatestSleepRecord().map(
          (entry) => entry != null ? _mapEntryToSleepModel(entry) : null,
        );
  }

  @override
  Future<List<SleepRecordModel>> getAllSleepRecords({int limit = 60}) async {
    final entries = await _db.activityDao.getAllSleepRecords(limit: limit);
    return entries.map(_mapEntryToSleepModel).toList();
  }

  @override
  Stream<List<SleepRecordModel>> watchAllSleepRecords({int limit = 60}) {
    return _db.activityDao.watchAllSleepRecords(limit: limit).map(
          (entries) => entries.map(_mapEntryToSleepModel).toList(),
        );
  }

  @override
  Future<void> deleteSleepRecord(String id) async {
    await _db.activityDao.deleteSleepRecord(id);
  }

  @override
  Future<int> getSleepRecordsCount() {
    return _db.activityDao.getSleepRecordsCount();
  }

  @override
  Future<List<SleepRecordModel>> getOverlappingSleepRecords({
    required DateTime bedtime,
    required DateTime wakeTime,
    String? excludeId,
  }) async {
    final entries = await _db.activityDao.getOverlappingSleepRecords(
      bedtime: bedtime,
      wakeTime: wakeTime,
      excludeId: excludeId,
    );
    return entries.map(_mapEntryToSleepModel).toList();
  }

  SleepRecordModel _mapEntryToSleepModel(SleepRecordsEntry entry) {
    return SleepRecordModel(
      id: entry.id,
      date: entry.date,
      bedtime: entry.bedtime,
      wakeTime: entry.wakeTime,
      durationMinutes: entry.durationMinutes,
      source: entry.source,
      efficiencyPercent: entry.efficiencyPercent,
      notes: entry.notes,
      hasStages: entry.hasStages,
      lightSleepMinutes: entry.lightSleepMinutes,
      deepSleepMinutes: entry.deepSleepMinutes,
      remSleepMinutes: entry.remSleepMinutes,
      awakeMinutes: entry.awakeMinutes,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  @override
  Future<List<SleepRecordsEntry>> getSleepRecordsInRange(String startDate, String endDate) {
    return _db.activityDao.getSleepRecordsInRange(startDate, endDate);
  }

  // ---------------------------------------------------------
  // WEEKLY REPORTS IMPLEMENTATION
  // ---------------------------------------------------------

  @override
  Future<void> saveWeeklyReport(WeeklyReportModel report) async {
    await _db.activityDao.upsertWeeklyReport(report.toCompanion());
  }

  @override
  Future<WeeklyReportModel?> getWeeklyReportById(String id) async {
    final entry = await _db.activityDao.getWeeklyReportById(id);
    return entry != null ? WeeklyReportModel.fromEntity(entry) : null;
  }

  @override
  Future<WeeklyReportModel?> getWeeklyReportByWeek(int year, int weekNumber) async {
    final entry = await _db.activityDao.getWeeklyReportByWeek(year, weekNumber);
    return entry != null ? WeeklyReportModel.fromEntity(entry) : null;
  }

  @override
  Future<List<WeeklyReportModel>> getAllWeeklyReports({int limit = 52}) async {
    final entries = await _db.activityDao.getAllWeeklyReports(limit: limit);
    return entries.map(WeeklyReportModel.fromEntity).toList();
  }

  @override
  Stream<List<WeeklyReportModel>> watchAllWeeklyReports({int limit = 52}) {
    return _db.activityDao
        .watchAllWeeklyReports(limit: limit)
        .map((entries) => entries.map(WeeklyReportModel.fromEntity).toList());
  }

  @override
  Future<void> deleteWeeklyReport(String id) async {
    await _db.activityDao.deleteWeeklyReport(id);
  }

  @override
  Future<int> getWeeklyReportsCount() {
    return _db.activityDao.getWeeklyReportsCount();
  }

  // ---------------------------------------------------------
  // WEIGHT RECORDS IMPLEMENTATION
  // ---------------------------------------------------------

  @override
  Future<void> saveWeightRecord(WeightRecordModel record) async {
    await _db.activityDao.upsertWeightRecord(record.toCompanion());
  }

  @override
  Future<WeightRecordModel?> getWeightRecordById(String id) async {
    final entry = await _db.activityDao.getWeightRecordById(id);
    return entry != null ? WeightRecordModel.fromEntity(entry) : null;
  }

  @override
  Future<WeightRecordModel?> getLatestWeightRecord() async {
    final entry = await _db.activityDao.getLatestWeightRecord();
    return entry != null ? WeightRecordModel.fromEntity(entry) : null;
  }

  @override
  Future<List<WeightRecordModel>> getAllWeightRecords({int limit = 100}) async {
    final entries = await _db.activityDao.getAllWeightRecords(limit: limit);
    return entries.map(WeightRecordModel.fromEntity).toList();
  }

  @override
  Stream<List<WeightRecordModel>> watchAllWeightRecords({int limit = 100}) {
    return _db.activityDao
        .watchAllWeightRecords(limit: limit)
        .map((entries) => entries.map(WeightRecordModel.fromEntity).toList());
  }

  @override
  Future<void> deleteWeightRecord(String id) async {
    await _db.activityDao.deleteWeightRecord(id);
  }

  @override
  Future<int> getWeightRecordsCount() {
    return _db.activityDao.getWeightRecordsCount();
  }

  // ---------------------------------------------------------
  // COACH MESSAGES IMPLEMENTATION
  // ---------------------------------------------------------

  @override
  Future<void> saveCoachMessage(CoachMessageModel message) async {
    await _db.activityDao.insertCoachMessage(message.toCompanion());
  }

  @override
  Future<List<CoachMessageModel>> getAllCoachMessages({int limit = 100}) async {
    final entries = await _db.activityDao.getAllCoachMessages(limit: limit);
    return entries.map(CoachMessageModel.fromEntity).toList();
  }

  @override
  Stream<List<CoachMessageModel>> watchAllCoachMessages({int limit = 100}) {
    return _db.activityDao
        .watchAllCoachMessages(limit: limit)
        .map((entries) => entries.map(CoachMessageModel.fromEntity).toList());
  }

  @override
  Future<void> clearCoachMessages() async {
    await _db.activityDao.clearCoachMessages();
  }

  @override
  Future<int> getCoachMessagesCount() {
    return _db.activityDao.getCoachMessagesCount();
  }

  // Migration & Metadata
  @override
  Future<bool> isMigrationCompleted(String migrationKey) {
    return _db.activityDao.isMigrationCompleted(migrationKey);
  }

  @override
  Future<void> markMigrationCompleted({
    required String migrationKey,
    required int recordsCount,
    String? verificationHash,
  }) {
    return _db.activityDao.setMigrationCompleted(
      key: migrationKey,
      recordsCount: recordsCount,
      verificationHash: verificationHash,
    );
  }
}
