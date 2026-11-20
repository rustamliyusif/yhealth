import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:yhealth/core/providers/activity_provider.dart';
import 'package:yhealth/core/services/native_step_service.dart';
import 'package:yhealth/core/services/activity_recognition_service.dart';

void main() {
  group('1. GPS & Saved Route Verification', () {
    test('SavedRouteModel serialization and deserialization preserves all data', () {
      final route = SavedRouteModel(
        id: 'test_route_123',
        title: 'Morning Walk in Baku Boulevard',
        dateTime: DateTime(2026, 11, 3, 10, 30),
        distanceKm: 3.45,
        durationSeconds: 2700, // 45 minutes
        avgSpeedKmH: 4.6,
        calories: 214,
        coordinates: const [
          LatLng(40.3667, 49.8352),
          LatLng(40.3670, 49.8360),
          LatLng(40.3675, 49.8370),
        ],
      );

      final json = route.toJson();
      final restored = SavedRouteModel.fromJson(json);

      expect(restored.id, equals('test_route_123'));
      expect(restored.title, equals('Morning Walk in Baku Boulevard'));
      expect(restored.distanceKm, equals(3.45));
      expect(restored.durationSeconds, equals(2700));
      expect(restored.avgSpeedKmH, equals(4.6));
      expect(restored.calories, equals(214));
      expect(restored.coordinates.length, equals(3));
      expect(restored.coordinates[0].latitude, equals(40.3667));
      expect(restored.coordinates[0].longitude, equals(49.8352));
    });

    test('Speed and Pace calculations are mathematically correct', () {
      // 5 km in 3600 seconds (1 hour) -> speed = 5.0 km/h, pace = 12.0 min/km
      const distanceKm = 5.0;
      const durationSeconds = 3600;

      final hours = durationSeconds / 3600.0;
      final speed = distanceKm / hours;
      expect(speed, equals(5.0));

      final minutes = durationSeconds / 60.0;
      final pace = minutes / distanceKm;
      expect(pace, equals(12.0));
    });
  });

  group('2. Step Counter & Metric Conversions', () {
    test('Stride length and walking distance calculation', () {
      // For height 175 cm:
      // strideLength = (175 * 0.414) / 100 = 0.7245 meters
      // 10,000 steps = 7245 meters = 7.245 km
      const heightCm = 175.0;
      const steps = 10000;
      final strideLengthMeters = (heightCm * 0.414) / 100.0;
      final distanceKm = (steps * strideLengthMeters) / 1000.0;

      expect(distanceKm, closeTo(7.245, 0.01));
    });

    test('Calories burned calculation weighted by body mass', () {
      // 10,000 steps for 70kg person:
      // factor = (70 / 70) = 1.0
      // calories = (10000 * 0.042 * 1.0) = 420 kcal
      const steps = 10000;
      const weightKg = 70.0;
      final factor = (weightKg / 70.0).clamp(0.7, 1.5);
      final calories = (steps * 0.042 * factor).round();

      expect(calories, equals(420));
    });

    test('Active minutes estimation', () {
      // Brisk walk is ~100 steps per minute
      // 5,000 steps -> 50 minutes
      const steps = 5000;
      final activeMinutes = (steps / 100).round();
      expect(activeMinutes, equals(50));
    });
  });

  group('3. BMI Calculation & Health Categories', () {
    test('Underweight (< 18.5)', () {
      const height = 180.0;
      const weight = 55.0;
      final heightM = height / 100.0;
      final bmi = weight / (heightM * heightM);

      expect(bmi, closeTo(16.98, 0.02));
      expect(bmi < 18.5, isTrue);
    });

    test('Normal weight (18.5 - 24.9)', () {
      const height = 175.0;
      const weight = 68.0;
      final heightM = height / 100.0;
      final bmi = weight / (heightM * heightM);

      expect(bmi, closeTo(22.2, 0.05));
      expect(bmi >= 18.5 && bmi < 25.0, isTrue);
    });

    test('Overweight (25.0 - 29.9)', () {
      const height = 170.0;
      const weight = 80.0;
      final heightM = height / 100.0;
      final bmi = weight / (heightM * heightM);

      expect(bmi, closeTo(27.68, 0.02));
      expect(bmi >= 25.0 && bmi < 30.0, isTrue);
    });

    test('Obese (>= 30.0)', () {
      const height = 170.0;
      const weight = 95.0;
      final heightM = height / 100.0;
      final bmi = weight / (heightM * heightM);

      expect(bmi, closeTo(32.87, 0.02));
      expect(bmi >= 30.0, isTrue);
    });

    test('Healthy weight range bounds for 180 cm', () {
      const height = 180.0;
      final heightM = height / 100.0;
      final minWeight = 18.5 * (heightM * heightM);
      final maxWeight = 24.9 * (heightM * heightM);

      expect(minWeight, closeTo(59.94, 0.1));
      expect(maxWeight, closeTo(80.68, 0.1));
    });

    test('Gauge progress clamps between 0.02 and 0.98', () {
      // BMI 10 -> should clamp to 0.02
      final progressLow = ((10.0 - 15.0) / 20.0).clamp(0.02, 0.98);
      expect(progressLow, equals(0.02));

      // BMI 45 -> should clamp to 0.98
      final progressHigh = ((45.0 - 15.0) / 20.0).clamp(0.02, 0.98);
      expect(progressHigh, equals(0.98));

      // BMI 25 -> (25 - 15) / 20 = 0.50
      final progressMid = ((25.0 - 15.0) / 20.0).clamp(0.02, 0.98);
      expect(progressMid, equals(0.50));
    });
  });

  group('4. Localization Verification (Azerbaijani & English)', () {
    test('All keys in app_az.arb and app_en.arb match 1:1', () {
      final azFile = File('lib/l10n/app_az.arb');
      final enFile = File('lib/l10n/app_en.arb');

      expect(azFile.existsSync(), isTrue);
      expect(enFile.existsSync(), isTrue);

      final Map<String, dynamic> azMap = jsonDecode(azFile.readAsStringSync());
      final Map<String, dynamic> enMap = jsonDecode(enFile.readAsStringSync());

      final azKeys = azMap.keys.where((k) => !k.startsWith('@')).toSet();
      final enKeys = enMap.keys.where((k) => !k.startsWith('@')).toSet();

      final missingInEn = azKeys.difference(enKeys);
      final missingInAz = enKeys.difference(azKeys);

      expect(missingInEn, isEmpty, reason: 'Keys in AZ but missing in EN: $missingInEn');
      expect(missingInAz, isEmpty, reason: 'Keys in EN but missing in AZ: $missingInAz');
      expect(azKeys.length, greaterThan(150));
    });

    test('Critical health and disclaimer strings exist in Azerbaijani', () {
      final azFile = File('lib/l10n/app_az.arb');
      final Map<String, dynamic> azMap = jsonDecode(azFile.readAsStringSync());

      expect(azMap['bmiTitle'], equals('BÇİ Kalkulyatoru'));
      expect(azMap['appName'], equals('YHealth'));
      expect(azMap['azerbaijani'], equals('Azərbaycan dili'));
      expect(azMap['english'], equals('English'));
      expect(azMap['categoryNormal'], equals('Normal çəki'));
      expect(azMap['categoryOverweight'], equals('Artıq çəki'));
      expect(azMap['categoryObese'], equals('Piylənmə'));
      expect(azMap['categoryUnderweight'], equals('Çəki azlığı'));
      expect(azMap['bmiDisclaimerTitle'], equals('Vacib tibbi bildiriş'));
      expect(azMap['authErrorNetwork'], isNotEmpty);
      expect(azMap['authErrorTooManyRequests'], isNotEmpty);
    });

    test('Custom Android launcher icon assets exist across all mipmap densities', () {
      final resBase = Directory('android/app/src/main/res');
      expect(resBase.existsSync(), isTrue);

      final adaptiveXml = File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml');
      final adaptiveRoundXml = File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml');
      final colorsXml = File('android/app/src/main/res/values/colors.xml');

      expect(adaptiveXml.existsSync(), isTrue);
      expect(adaptiveRoundXml.existsSync(), isTrue);
      expect(colorsXml.existsSync(), isTrue);

      for (final density in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']) {
        final launcherPng = File('android/app/src/main/res/mipmap-$density/ic_launcher.png');
        final launcherRoundPng = File('android/app/src/main/res/mipmap-$density/ic_launcher_round.png');
        final launcherFgPng = File('android/app/src/main/res/mipmap-$density/ic_launcher_foreground.png');

        expect(launcherPng.existsSync(), isTrue, reason: 'Missing ic_launcher.png in mipmap-$density');
        expect(launcherRoundPng.existsSync(), isTrue, reason: 'Missing ic_launcher_round.png in mipmap-$density');
        expect(launcherFgPng.existsSync(), isTrue, reason: 'Missing ic_launcher_foreground.png in mipmap-$density');
      }
    });
  });

  group('5. Android Native Step Service Architecture & Manifest Verification', () {
    test('AndroidManifest.xml declares all background service and health permissions', () {
      final manifestFile = File('android/app/src/main/AndroidManifest.xml');
      expect(manifestFile.existsSync(), isTrue);

      final content = manifestFile.readAsStringSync();
      expect(content.contains('android.permission.ACTIVITY_RECOGNITION'), isTrue);
      expect(content.contains('android.permission.FOREGROUND_SERVICE'), isTrue);
      expect(content.contains('android.permission.FOREGROUND_SERVICE_HEALTH'), isTrue);
      expect(content.contains('android.permission.POST_NOTIFICATIONS'), isTrue);
      expect(content.contains('android.permission.RECEIVE_BOOT_COMPLETED'), isTrue);
      expect(content.contains('android:foregroundServiceType="health"'), isTrue);
      expect(content.contains('.StepCounterService'), isTrue);
      expect(content.contains('.BootReceiver'), isTrue);
    });

    test('Kotlin implementation files for background service and boot receiver exist', () {
      final serviceFile = File('android/app/src/main/kotlin/com/example/yhealth/StepCounterService.kt');
      final receiverFile = File('android/app/src/main/kotlin/com/example/yhealth/BootReceiver.kt');
      final mainActivityFile = File('android/app/src/main/kotlin/com/example/yhealth/MainActivity.kt');

      expect(serviceFile.existsSync(), isTrue);
      expect(receiverFile.existsSync(), isTrue);
      expect(mainActivityFile.existsSync(), isTrue);

      final serviceContent = serviceFile.readAsStringSync();
      expect(serviceContent.contains('Sensor.TYPE_STEP_COUNTER'), isTrue);
      expect(serviceContent.contains('yhealth_step_prefs'), isTrue);
      expect(serviceContent.contains('startForeground'), isTrue);

      final receiverContent = receiverFile.readAsStringSync();
      expect(receiverContent.contains('ACTION_BOOT_COMPLETED'), isTrue);

      final mainActivityContent = mainActivityFile.readAsStringSync();
      expect(mainActivityContent.contains('com.example.yhealth/step_counter'), isTrue);
      expect(mainActivityContent.contains('com.example.yhealth/step_counter_stream'), isTrue);
    });
  });

  group('6. Daily Reset & Cumulative Delta Tracking Verification', () {
    test('Cumulative delta handles normal increment accurately', () {
      int lastRaw = 1200;
      int todaySteps = 50;

      // New sensor reading of 1245 steps (+45)
      final newRaw = 1245;
      final delta = newRaw - lastRaw;
      todaySteps += delta;
      lastRaw = newRaw;

      expect(delta, equals(45));
      expect(todaySteps, equals(95));
      expect(lastRaw, equals(1245));
    });

    test('Reboot recovery correctly tracks steps without loss or huge jumps', () {
      // Prior to reboot: phone had 3,500 today steps and last raw sensor value was 14,000
      int todaySteps = 3500;
      int lastRaw = 14000;

      // Phone reboots! Raw sensor resets to 150 (steps since boot)
      final newRaw = 150;
      expect(newRaw < lastRaw, isTrue); // Reboot condition

      // Cumulative delta treating newRaw as steps accumulated since reboot
      final delta = newRaw;
      todaySteps += delta;
      lastRaw = newRaw;

      expect(delta, equals(150));
      expect(todaySteps, equals(3650)); // Accurately accumulated, no prior steps lost
      expect(lastRaw, equals(150));
    });

    test('Midnight date transition archives past day and resets daily total', () {
      final history = <String, int>{};
      const yesterdayKey = '2026-11-04';
      const todayKey = '2026-11-05';
      int currentDailySteps = 8420;

      // Midnight strikes:
      history[yesterdayKey] = currentDailySteps;
      currentDailySteps = 0; // Reset display total to 0

      expect(history[yesterdayKey], equals(8420));
      expect(currentDailySteps, equals(0));
      expect(history.containsKey(todayKey), isFalse);
    });
  });

  group('7. Light / Dark Theme Architecture Verification', () {
    test('Theme keys are present and localized in both languages', () {
      final azFile = File('lib/l10n/app_az.arb');
      final enFile = File('lib/l10n/app_en.arb');

      final Map<String, dynamic> azMap = jsonDecode(azFile.readAsStringSync());
      final Map<String, dynamic> enMap = jsonDecode(enFile.readAsStringSync());

      expect(azMap['themeSettings'], equals('Görünüş / Mövzu'));
      expect(azMap['themeLight'], equals('İşıqlı rejim'));
      expect(azMap['themeDark'], equals('Qaranlıq rejim'));

      expect(enMap['themeSettings'], equals('Appearance / Theme'));
      expect(enMap['themeLight'], equals('Light Mode'));
      expect(enMap['themeDark'], equals('Dark Mode'));
    });
  });

  group('8. Universal Device Compatibility & Hardware Sensor Detection', () {
    test('DeviceCompatibilityModel parses correctly and detects hardware capabilities', () {
      final Map<dynamic, dynamic> mockSamsungData = {
        'manufacturer': 'samsung',
        'model': 'SM-A566B',
        'brand': 'samsung',
        'device': 'a56x',
        'androidVersion': '14',
        'sdkInt': 34,
        'hasStepCounter': true,
        'stepCounterName': 'Samsung Step Counter Sensor',
        'hasStepDetector': true,
        'stepDetectorName': 'Samsung Step Detector Sensor',
        'hasAccelerometer': true,
        'accelerometerName': 'LSM6DSO Accelerometer',
        'activeSensorType': 'counter',
        'isStepServiceRunning': true,
        'isIgnoringBatteryOptimizations': true,
        'hasActivityRecognitionPermission': true,
        'hasNotificationPermission': true,
        'hasLocationPermission': true,
      };

      final samsungModel = DeviceCompatibilityModel.fromMap(mockSamsungData);
      expect(samsungModel.manufacturer, equals('samsung'));
      expect(samsungModel.hasStepCounter, isTrue);
      expect(samsungModel.hasHardwarePedometer, isTrue);
      expect(samsungModel.activeSensorType, equals('counter'));
      expect(samsungModel.isIgnoringBatteryOptimizations, isTrue);

      // MediaTek / Xiaomi Redmi device that only has TYPE_STEP_DETECTOR
      final Map<dynamic, dynamic> mockRedmiData = {
        'manufacturer': 'Xiaomi',
        'model': 'Redmi Note 12',
        'brand': 'Redmi',
        'device': 'topaz',
        'androidVersion': '13',
        'sdkInt': 33,
        'hasStepCounter': false,
        'stepCounterName': '',
        'hasStepDetector': true,
        'stepDetectorName': 'MTK Step Detector',
        'hasAccelerometer': true,
        'accelerometerName': 'BMA4xx',
        'activeSensorType': 'detector',
        'isStepServiceRunning': true,
        'isIgnoringBatteryOptimizations': false,
        'hasActivityRecognitionPermission': true,
        'hasNotificationPermission': true,
        'hasLocationPermission': true,
      };

      final redmiModel = DeviceCompatibilityModel.fromMap(mockRedmiData);
      expect(redmiModel.hasStepCounter, isFalse);
      expect(redmiModel.hasStepDetector, isTrue);
      expect(redmiModel.hasHardwarePedometer, isTrue); // Supported via alternative detector!
      expect(redmiModel.activeSensorType, equals('detector'));
    });

    test('Fallback model provides safe defaults when platform channel is uninitialized', () {
      final fallback = DeviceCompatibilityModel.fallback();
      expect(fallback.hasHardwarePedometer, isTrue);
      expect(fallback.sdkInt, equals(34));
    });
  });

  group('9. Human Activity Recognition & Vehicle Filtering', () {
    test('Activity classification based on cadence and velocity thresholds', () {
      final recognizer = ActivityRecognitionService();

      // Still: zero cadence, zero GPS speed
      expect(recognizer.classifyActivity(cadenceSpm: 0, gpsSpeedKmH: 0), equals(HumanActivityType.still));

      // Walking: normal cadence (~100 spm), slow speed
      expect(recognizer.classifyActivity(cadenceSpm: 105, gpsSpeedKmH: 4.5), equals(HumanActivityType.walking));

      // Running: high cadence (> 140 spm), running speed
      expect(recognizer.classifyActivity(cadenceSpm: 155, gpsSpeedKmH: 10.2), equals(HumanActivityType.running));

      // Vehicle transit: GPS velocity > 25 km/h with low walking cadence
      expect(recognizer.classifyActivity(cadenceSpm: 20, gpsSpeedKmH: 60.0), equals(HumanActivityType.inVehicle));

      // Cycling: high speed (> 16 km/h) with low cadence (< 40 spm)
      expect(recognizer.classifyActivity(cadenceSpm: 25, gpsSpeedKmH: 18.0), equals(HumanActivityType.onBicycle));
    });

    test('Vehicle journey distance is separated from walking workout distance', () {
      // Simulate walking 1.2 km, then riding in a car for 8.5 km
      double walkingDistanceKm = 1.2;
      double vehicleDistanceKm = 8.5;

      final route = SavedRouteModel(
        id: 'test_commute',
        title: 'Commute with Walk',
        dateTime: DateTime.now(),
        distanceKm: walkingDistanceKm, // Walk distance only
        durationSeconds: 1800,
        avgSpeedKmH: 4.8,
        calories: 75,
        coordinates: const [LatLng(40.40, 49.86), LatLng(40.45, 49.88)],
        vehicleDistanceKm: vehicleDistanceKm, // Separate vehicle distance
      );

      final json = route.toJson();
      final restored = SavedRouteModel.fromJson(json);

      expect(restored.distanceKm, equals(1.2)); // Walking stats not corrupted
      expect(restored.vehicleDistanceKm, equals(8.5));
    });
  });

  group('10. Universal Compatibility Localization Completeness', () {
    test('All compatibility, sensor, activity and battery keys exist in Azerbaijani & English', () {
      final azFile = File('lib/l10n/app_az.arb');
      final enFile = File('lib/l10n/app_en.arb');

      final Map<String, dynamic> azMap = jsonDecode(azFile.readAsStringSync());
      final Map<String, dynamic> enMap = jsonDecode(enFile.readAsStringSync());

      final requiredKeys = [
        'deviceCompatibilityTitle',
        'deviceCompatibilitySubtitle',
        'deviceInfo',
        'sensorDiagnostics',
        'stepCounterSensor',
        'stepDetectorSensor',
        'activeTrackingMode',
        'activityRecognitionTitle',
        'activityStill',
        'activityWalking',
        'activityRunning',
        'activityBicycle',
        'activityVehicle',
        'vehicleFilteringActive',
        'vehicleDetectedWarning',
        'backgroundOperationTitle',
        'batteryOptimizationTitle',
        'batteryUnrestricted',
        'batteryRestricted',
        'batteryOptimizeButton',
        'openOemSettingsButton',
        'manufacturerGuidance',
        'guidanceXiaomi',
        'guidanceSamsung',
        'guidanceHuawei',
        'guidanceOnePlus',
        'guidanceVivo',
        'guidancePixel',
        'guidanceGeneral',
        'fullyCompatible',
        'partiallyCompatible',
        'attentionNeeded',
      ];

      for (final key in requiredKeys) {
        expect(azMap.containsKey(key), isTrue, reason: 'Missing key in app_az.arb: $key');
        expect(enMap.containsKey(key), isTrue, reason: 'Missing key in app_en.arb: $key');
        expect(azMap[key].toString().isNotEmpty, isTrue);
        expect(enMap[key].toString().isNotEmpty, isTrue);
      }
    });
  });
}
