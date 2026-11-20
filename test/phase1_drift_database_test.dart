import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/services/storage_service.dart';
import 'package:yhealth/core/services/database_migration_service.dart';
import 'package:yhealth/core/providers/activity_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftActivityRepository repository;

  setUp(() {
    // Spin up an isolated, in-memory SQLite database for deterministic tests
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftActivityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 1 - Drift Database & Schema Verification', () {
    test('Database schema version is 4 and tables are empty on init', () async {
      expect(db.schemaVersion, equals(4));
      final count = await repository.getDailyActivitiesCount();
      expect(count, equals(0));
      final routesCount = await repository.getRoutesCount();
      expect(routesCount, equals(0));
    });

    test('Daily activity upsert and uniqueness by calendar date', () async {
      // Insert initial record for 2026-11-07
      await repository.saveDailyActivity(
        date: '2026-11-07',
        steps: 5000,
        distanceKm: 3.5,
        calories: 220,
        activeMinutes: 45,
        goalSteps: 8000,
      );

      var entry = await repository.getDailyActivity('2026-11-07');
      expect(entry, isNotNull);
      expect(entry!.steps, equals(5000));
      expect(entry.distanceKm, equals(3.5));
      expect(entry.calories, equals(220));
      expect(entry.activeMinutes, equals(45));
      expect(entry.isGoalCompleted, isFalse);
      expect(await repository.getDailyActivitiesCount(), equals(1));

      // Same day update (steps increase during the day)
      // Must UPDATE the existing row and NEVER create a duplicate row
      await repository.saveDailyActivity(
        date: '2026-11-07',
        steps: 8500,
        distanceKm: 5.95,
        calories: 374,
        activeMinutes: 85,
        goalSteps: 8000,
      );

      entry = await repository.getDailyActivity('2026-11-07');
      expect(entry, isNotNull);
      expect(entry!.steps, equals(8500));
      expect(entry.isGoalCompleted, isTrue); // Goal completed now!
      expect(await repository.getDailyActivitiesCount(), equals(1)); // Still exactly 1 row!
    });

    test('Multiple calendar dates are maintained independently', () async {
      await repository.saveDailyActivity(
        date: '2026-11-05',
        steps: 7200,
        distanceKm: 5.0,
        calories: 300,
        activeMinutes: 65,
        goalSteps: 8000,
      );
      await repository.saveDailyActivity(
        date: '2026-11-06',
        steps: 9100,
        distanceKm: 6.4,
        calories: 390,
        activeMinutes: 80,
        goalSteps: 8000,
      );
      await repository.saveDailyActivity(
        date: '2026-11-07',
        steps: 4300,
        distanceKm: 3.0,
        calories: 180,
        activeMinutes: 40,
        goalSteps: 8000,
      );

      final total = await repository.getDailyActivitiesCount();
      expect(total, equals(3));

      final activities = await repository.getAllDailyActivities();
      expect(activities.length, equals(3));
      // Ordered descending by date: 07, 06, 05
      expect(activities[0].date, equals('2026-11-07'));
      expect(activities[1].date, equals('2026-11-06'));
      expect(activities[2].date, equals('2026-11-05'));
    });

    test('Date range filtering works correctly', () async {
      await repository.saveDailyActivity(
        date: '2026-11-01',
        steps: 5000,
        distanceKm: 3.5,
        calories: 200,
        activeMinutes: 50,
        goalSteps: 8000,
      );
      await repository.saveDailyActivity(
        date: '2026-11-03',
        steps: 7000,
        distanceKm: 4.9,
        calories: 290,
        activeMinutes: 65,
        goalSteps: 8000,
      );
      await repository.saveDailyActivity(
        date: '2026-11-05',
        steps: 8200,
        distanceKm: 5.7,
        calories: 350,
        activeMinutes: 80,
        goalSteps: 8000,
      );

      final range = await repository.getActivitiesInRange('2026-11-02', '2026-11-04');
      expect(range.length, equals(1));
      expect(range.first.date, equals('2026-11-03'));
    });
  });

  group('Phase 1 - Saved Routes Persistence in Drift', () {
    test('SavedRouteModel is properly persisted, retrieved, and deleted', () async {
      final route = SavedRouteModel(
        id: 'route_osm_001',
        title: 'Baku Boulevard Evening Walk',
        dateTime: DateTime(2026, 11, 7, 18, 30),
        distanceKm: 4.25,
        durationSeconds: 3100,
        avgSpeedKmH: 4.93,
        calories: 260,
        vehicleDistanceKm: 0.1,
        coordinates: const [
          LatLng(40.3667, 49.8352),
          LatLng(40.3675, 49.8360),
          LatLng(40.3685, 49.8372),
        ],
      );

      await repository.saveRoute(route);

      expect(await repository.getRoutesCount(), equals(1));

      final routes = await repository.getAllRoutes();
      expect(routes.length, equals(1));
      final retrieved = routes.first;

      expect(retrieved.id, equals('route_osm_001'));
      expect(retrieved.title, equals('Baku Boulevard Evening Walk'));
      expect(retrieved.distanceKm, equals(4.25));
      expect(retrieved.durationSeconds, equals(3100));
      expect(retrieved.avgSpeedKmH, equals(4.93));
      expect(retrieved.calories, equals(260));
      expect(retrieved.vehicleDistanceKm, equals(0.1));
      expect(retrieved.coordinates.length, equals(3));
      expect(retrieved.coordinates[0].latitude, equals(40.3667));
      expect(retrieved.coordinates[0].longitude, equals(49.8352));

      // Test delete
      await repository.deleteRoute('route_osm_001');
      expect(await repository.getRoutesCount(), equals(0));
    });
  });

  group('Phase 1 - Safe, Non-Destructive Migration Verification', () {
    test('Migrates existing SharedPreferences data into Drift without modifying source', () async {
      // 1. Setup mock SharedPreferences with existing user data
      SharedPreferences.setMockInitialValues({
        StorageService.keyStepHistory: jsonEncode({
          '2026-11-01': 7500,
          '2026-11-02': 8200,
          '2026-11-03': 6400,
          '2026-11-04': 9500,
        }),
        StorageService.keySavedRoutes: jsonEncode([
          {
            'id': 'route_historical_1',
            'title': 'Highland Park Loop',
            'dateTime': '2026-11-03T16:00:00.000',
            'distanceKm': 2.8,
            'durationSeconds': 2400,
            'avgSpeedKmH': 4.2,
            'calories': 175,
            'vehicleDistanceKm': 0.0,
            'coordinates': [
              {'lat': 40.3590, 'lng': 49.8280},
              {'lat': 40.3600, 'lng': 49.8290},
            ],
          }
        ]),
        StorageService.keyGoalSteps: 8000,
        StorageService.keyUserHeight: 175.0,
        StorageService.keyUserWeight: 70.0,
      });

      final storageService = await StorageService.init();

      // Check migration not yet run
      expect(
        await repository.isMigrationCompleted(DatabaseMigrationService.migrationKeyV1),
        isFalse,
      );

      // 2. Execute Migration
      final result = await DatabaseMigrationService.migrateFromSharedPreferences(
        storageService: storageService,
        activityRepository: repository,
      );

      // 3. Verify Migration Result
      expect(result.isSuccess, isTrue);
      expect(result.alreadyMigrated, isFalse);
      expect(result.migratedDailyRecords, equals(4));
      expect(result.migratedRoutes, equals(1));
      expect(result.verificationHash, isNotNull);

      // 4. Verify Drift Database Data Integrity
      expect(await repository.getDailyActivitiesCount(), equals(4));
      final day1 = await repository.getDailyActivity('2026-11-01');
      expect(day1, isNotNull);
      expect(day1!.steps, equals(7500));
      expect(day1.isGoalCompleted, isFalse);

      final day4 = await repository.getDailyActivity('2026-11-04');
      expect(day4, isNotNull);
      expect(day4!.steps, equals(9500));
      expect(day4.isGoalCompleted, isTrue); // 9500 >= 8000

      final routes = await repository.getAllRoutes();
      expect(routes.length, equals(1));
      expect(routes.first.id, equals('route_historical_1'));
      expect(routes.first.title, equals('Highland Park Loop'));
      expect(routes.first.coordinates.length, equals(2));

      // 5. CRITICAL: Verify that SharedPreferences was NEVER deleted or emptied
      final spHistory = storageService.getStepHistory();
      expect(spHistory.length, equals(4));
      expect(spHistory['2026-11-01'], equals(7500));
      expect(spHistory['2026-11-04'], equals(9500));

      final spRoutes = storageService.getSavedRoutes();
      expect(spRoutes.length, equals(1));
      expect(spRoutes.first['id'], equals('route_historical_1'));

      // 6. Verify Idempotence / Subsequent Runs
      final secondRun = await DatabaseMigrationService.migrateFromSharedPreferences(
        storageService: storageService,
        activityRepository: repository,
      );
      expect(secondRun.isSuccess, isTrue);
      expect(secondRun.alreadyMigrated, isTrue);
      // Row counts remain unaltered
      expect(await repository.getDailyActivitiesCount(), equals(4));
      expect(await repository.getRoutesCount(), equals(1));
    });
  });
}
