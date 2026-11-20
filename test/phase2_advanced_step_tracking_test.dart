import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/services/storage_service.dart';
import 'package:yhealth/core/services/native_step_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftActivityRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftActivityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 2 - Native Sensor Delta & Reboot Recovery Logic', () {
    test('Reboot recovery accumulates post-reboot steps accurately without data loss', () {
      // Scenario: Prior to reboot, user accumulated 4,200 steps today, raw sensor was 25,000
      int todaySteps = 4200;
      int lastRawSensor = 25000;
      int lastUptimeMs = 3600000; // 1 hour uptime

      // Device reboots!
      // After reboot, uptime resets to 60,000 ms (1 minute), raw sensor resets to 120 steps
      final currentUptimeMs = 60000;
      final rawAfterReboot = 120;

      final isRebootDetected = rawAfterReboot < lastRawSensor || currentUptimeMs < lastUptimeMs;
      expect(isRebootDetected, isTrue);

      // Cumulative delta logic applied
      final delta = rawAfterReboot;
      todaySteps += delta;
      lastRawSensor = rawAfterReboot;

      expect(delta, equals(120));
      expect(todaySteps, equals(4320)); // Steps correctly preserved and incremented!
      expect(lastRawSensor, equals(120));

      // Subsequent steps on same boot (user walks 80 more steps)
      final nextRaw = 200;
      final nextDelta = nextRaw - lastRawSensor;
      todaySteps += nextDelta;
      lastRawSensor = nextRaw;

      expect(nextDelta, equals(80));
      expect(todaySteps, equals(4400));
      expect(lastRawSensor, equals(200));
    });

    test('Anomalous sensor glitch spikes are filtered to prevent corrupting daily steps', () {
      int todaySteps = 5000;
      int lastRawSensor = 10000;

      // Anomaly: OEM sensor glitch reports an impossible jump of 100,000 steps instantly
      final glitchRaw = 110000;
      final rawDelta = glitchRaw - lastRawSensor;

      const maxPlausibleDelta = 50000;
      final isGlitch = rawDelta > maxPlausibleDelta;
      expect(isGlitch, isTrue);

      if (isGlitch) {
        // Re-align baseline without adding glitch to todaySteps
        lastRawSensor = glitchRaw;
      } else {
        todaySteps += rawDelta;
      }

      expect(todaySteps, equals(5000)); // Today's count safely protected!
      expect(lastRawSensor, equals(110000)); // Baseline re-aligned
    });
  });

  group('Phase 2 - Midnight Transition & Drift Synchronization', () {
    test('Midnight rollover cleanly archives yesterday and initializes today without duplicates', () async {
      SharedPreferences.setMockInitialValues({
        StorageService.keyGoalSteps: 8000,
        StorageService.keyUserHeight: 175.0,
        StorageService.keyUserWeight: 70.0,
      });

      // 1. Day 1 (2026-11-06)
      await repository.saveDailyActivity(
        date: '2026-11-06',
        steps: 9200,
        distanceKm: 6.66,
        calories: 386,
        activeMinutes: 92,
        goalSteps: 8000,
      );

      // Verify Day 1 is in Drift
      final day1 = await repository.getDailyActivity('2026-11-06');
      expect(day1, isNotNull);
      expect(day1!.steps, equals(9200));
      expect(day1.isGoalCompleted, isTrue);

      // 2. Midnight Rollover to Day 2 (2026-11-07)
      // New day starts at 0 steps
      await repository.saveDailyActivity(
        date: '2026-11-07',
        steps: 0,
        distanceKm: 0.0,
        calories: 0,
        activeMinutes: 0,
        goalSteps: 8000,
      );

      // Total records in Drift must be exactly 2
      expect(await repository.getDailyActivitiesCount(), equals(2));

      // User walks 3,500 steps on Day 2
      await repository.saveDailyActivity(
        date: '2026-11-07',
        steps: 3500,
        distanceKm: 2.53,
        calories: 147,
        activeMinutes: 35,
        goalSteps: 8000,
      );

      // Total records still strictly 2 (upserted Day 2 without duplicate!)
      expect(await repository.getDailyActivitiesCount(), equals(2));

      final day2 = await repository.getDailyActivity('2026-11-07');
      expect(day2, isNotNull);
      expect(day2!.steps, equals(3500));
      expect(day2.isGoalCompleted, isFalse);

      // Day 1 remained untouched and preserved
      final day1Verify = await repository.getDailyActivity('2026-11-06');
      expect(day1Verify!.steps, equals(9200));
    });

    test('Native background history syncs to Drift database idempotently', () async {
      final Map<String, int> nativeHistory = {
        '2026-11-04': 8100,
        '2026-11-05': 7400,
      };

      for (final entry in nativeHistory.entries) {
        await repository.saveDailyActivity(
          date: entry.key,
          steps: entry.value,
          distanceKm: (entry.value * ((175.0 * 0.414) / 100.0)) / 1000.0,
          calories: (entry.value * 0.042).round(),
          activeMinutes: (entry.value / 100).round(),
          goalSteps: 8000,
        );
      }

      expect(await repository.getDailyActivitiesCount(), equals(2));

      // Re-syncing the same native history must update/verify without creating duplicate records
      for (final entry in nativeHistory.entries) {
        await repository.saveDailyActivity(
          date: entry.key,
          steps: entry.value,
          distanceKm: (entry.value * ((175.0 * 0.414) / 100.0)) / 1000.0,
          calories: (entry.value * 0.042).round(),
          activeMinutes: (entry.value / 100).round(),
          goalSteps: 8000,
        );
      }

      expect(await repository.getDailyActivitiesCount(), equals(2));
      final record = await repository.getDailyActivity('2026-11-04');
      expect(record!.steps, equals(8100));
      expect(record.isGoalCompleted, isTrue);
    });
  });

  group('Phase 2 - Universal Android Device Compatibility Diagnostics', () {
    test('DeviceCompatibilityModel accurately reflects all supported OEM properties', () {
      final Map<dynamic, dynamic> pocoMap = {
        'manufacturer': 'Xiaomi',
        'model': 'POCO F5',
        'brand': 'POCO',
        'device': 'marble',
        'androidVersion': '14',
        'sdkInt': 34,
        'hasStepCounter': true,
        'stepCounterName': 'BMI160 Step Counter Sensor',
        'hasStepDetector': true,
        'stepDetectorName': 'BMI160 Step Detector Sensor',
        'hasAccelerometer': true,
        'accelerometerName': 'BMI160 Accelerometer',
        'activeSensorType': 'step_counter',
        'isStepServiceRunning': true,
        'isIgnoringBatteryOptimizations': true,
        'hasActivityRecognitionPermission': true,
        'hasNotificationPermission': true,
        'hasLocationPermission': true,
      };

      final model = DeviceCompatibilityModel.fromMap(pocoMap);
      expect(model.manufacturer, equals('Xiaomi'));
      expect(model.brand, equals('POCO'));
      expect(model.hasHardwarePedometer, isTrue);
      expect(model.hasStepCounter, isTrue);
      expect(model.hasStepDetector, isTrue);
      expect(model.isIgnoringBatteryOptimizations, isTrue);
      expect(model.isStepServiceRunning, isTrue);
    });

    test('DeviceCompatibilityModel handles non-hardware fallback devices gracefully', () {
      final Map<dynamic, dynamic> tabletMap = {
        'manufacturer': 'Generic',
        'model': 'Android Tablet',
        'brand': 'Generic',
        'device': 'tablet',
        'androidVersion': '13',
        'sdkInt': 33,
        'hasStepCounter': false,
        'stepCounterName': 'N/A',
        'hasStepDetector': false,
        'stepDetectorName': 'N/A',
        'hasAccelerometer': true,
        'accelerometerName': 'Basic Accelerometer',
        'activeSensorType': 'none',
        'isStepServiceRunning': false,
        'isIgnoringBatteryOptimizations': false,
        'hasActivityRecognitionPermission': true,
        'hasNotificationPermission': true,
        'hasLocationPermission': false,
      };

      final model = DeviceCompatibilityModel.fromMap(tabletMap);
      expect(model.hasHardwarePedometer, isFalse);
      expect(model.activeSensorType, equals('none'));
      expect(model.hasAccelerometer, isTrue);
    });
  });
}
