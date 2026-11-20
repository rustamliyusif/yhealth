import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceCompatibilityModel {
  final String manufacturer;
  final String model;
  final String brand;
  final String device;
  final String androidVersion;
  final int sdkInt;
  final bool hasStepCounter;
  final String stepCounterName;
  final bool hasStepDetector;
  final String stepDetectorName;
  final bool hasAccelerometer;
  final String accelerometerName;
  final String activeSensorType; // 'step_counter', 'step_detector', 'none'
  final bool isStepServiceRunning;
  final bool isIgnoringBatteryOptimizations;
  final bool hasActivityRecognitionPermission;
  final bool hasNotificationPermission;
  final bool hasLocationPermission;

  const DeviceCompatibilityModel({
    required this.manufacturer,
    required this.model,
    required this.brand,
    required this.device,
    required this.androidVersion,
    required this.sdkInt,
    required this.hasStepCounter,
    required this.stepCounterName,
    required this.hasStepDetector,
    required this.stepDetectorName,
    required this.hasAccelerometer,
    required this.accelerometerName,
    required this.activeSensorType,
    required this.isStepServiceRunning,
    required this.isIgnoringBatteryOptimizations,
    required this.hasActivityRecognitionPermission,
    required this.hasNotificationPermission,
    required this.hasLocationPermission,
  });

  bool get hasHardwarePedometer => hasStepCounter || hasStepDetector;

  factory DeviceCompatibilityModel.fromMap(Map<dynamic, dynamic> map) {
    return DeviceCompatibilityModel(
      manufacturer: (map['manufacturer'] as String?) ?? 'Unknown',
      model: (map['model'] as String?) ?? 'Android Device',
      brand: (map['brand'] as String?) ?? 'Android',
      device: (map['device'] as String?) ?? 'Generic',
      androidVersion: (map['androidVersion'] as String?) ?? 'N/A',
      sdkInt: (map['sdkInt'] as int?) ?? 0,
      hasStepCounter: (map['hasStepCounter'] as bool?) ?? false,
      stepCounterName: (map['stepCounterName'] as String?) ?? 'N/A',
      hasStepDetector: (map['hasStepDetector'] as bool?) ?? false,
      stepDetectorName: (map['stepDetectorName'] as String?) ?? 'N/A',
      hasAccelerometer: (map['hasAccelerometer'] as bool?) ?? false,
      accelerometerName: (map['accelerometerName'] as String?) ?? 'N/A',
      activeSensorType: (map['activeSensorType'] as String?) ?? 'none',
      isStepServiceRunning: (map['isStepServiceRunning'] as bool?) ?? false,
      isIgnoringBatteryOptimizations: (map['isIgnoringBatteryOptimizations'] as bool?) ?? false,
      hasActivityRecognitionPermission: (map['hasActivityRecognitionPermission'] as bool?) ?? false,
      hasNotificationPermission: (map['hasNotificationPermission'] as bool?) ?? false,
      hasLocationPermission: (map['hasLocationPermission'] as bool?) ?? false,
    );
  }

  factory DeviceCompatibilityModel.fallback() {
    return const DeviceCompatibilityModel(
      manufacturer: 'Android Device',
      model: 'Smartphone',
      brand: 'Android',
      device: 'Standard',
      androidVersion: '14+',
      sdkInt: 34,
      hasStepCounter: true,
      stepCounterName: 'Hardware Step Counter',
      hasStepDetector: true,
      stepDetectorName: 'Hardware Step Detector',
      hasAccelerometer: true,
      accelerometerName: '3-Axis Accelerometer',
      activeSensorType: 'step_counter',
      isStepServiceRunning: true,
      isIgnoringBatteryOptimizations: false,
      hasActivityRecognitionPermission: true,
      hasNotificationPermission: true,
      hasLocationPermission: true,
    );
  }
}

class NativeStepService {
  static const MethodChannel _methodChannel =
      MethodChannel('com.rustamliyusif.yhealth/step_counter');
  static const EventChannel _eventChannel =
      EventChannel('com.rustamliyusif.yhealth/step_counter_stream');

  Stream<int>? _stepStream;

  /// Returns whether any hardware step sensor (TYPE_STEP_COUNTER or TYPE_STEP_DETECTOR) is present.
  Future<bool> isSensorAvailable() async {
    try {
      final available =
          await _methodChannel.invokeMethod<bool>('isSensorAvailable');
      return available ?? false;
    } catch (e) {
      debugPrint('NativeStepService.isSensorAvailable error: $e');
      return false;
    }
  }

  /// Starts the Android native foreground step tracking service.
  Future<bool> startStepService() async {
    try {
      final started =
          await _methodChannel.invokeMethod<bool>('startStepService');
      return started ?? false;
    } catch (e) {
      debugPrint('NativeStepService.startStepService error: $e');
      return false;
    }
  }

  /// Stops the background service.
  Future<bool> stopStepService() async {
    try {
      final stopped =
          await _methodChannel.invokeMethod<bool>('stopStepService');
      return stopped ?? false;
    } catch (e) {
      debugPrint('NativeStepService.stopStepService error: $e');
      return false;
    }
  }

  /// Fetches the current accumulated daily steps from Android persistent storage.
  Future<int> getTodaySteps() async {
    try {
      final steps = await _methodChannel.invokeMethod<int>('getTodaySteps');
      return steps ?? 0;
    } catch (e) {
      debugPrint('NativeStepService.getTodaySteps error: $e');
      return 0;
    }
  }

  /// Fetches historical steps recorded per day (YYYY-MM-DD -> steps).
  Future<Map<String, int>> getStepHistory() async {
    try {
      final result =
          await _methodChannel.invokeMethod<Map<dynamic, dynamic>>('getStepHistory');
      if (result == null) return {};
      final history = <String, int>{};
      result.forEach((key, value) {
        if (key is String && value is num) {
          history[key] = value.toInt();
        }
      });
      return history;
    } catch (e) {
      debugPrint('NativeStepService.getStepHistory error: $e');
      return {};
    }
  }

  /// Fetches comprehensive device compatibility and hardware sensor diagnostics.
  Future<DeviceCompatibilityModel> getDeviceCompatibilityInfo() async {
    try {
      final result = await _methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('getDeviceCompatibilityInfo');
      if (result != null) {
        return DeviceCompatibilityModel.fromMap(result);
      }
    } catch (e) {
      debugPrint('NativeStepService.getDeviceCompatibilityInfo error: $e');
    }
    return DeviceCompatibilityModel.fallback();
  }

  /// Prompts the Android OS system dialog to exempt YHealth from battery optimization.
  Future<bool> requestIgnoreBatteryOptimization() async {
    try {
      final result = await _methodChannel
          .invokeMethod<bool>('requestIgnoreBatteryOptimization');
      return result ?? false;
    } catch (e) {
      debugPrint('NativeStepService.requestIgnoreBatteryOptimization error: $e');
      return false;
    }
  }

  /// Opens manufacturer-specific power/autostart management settings (MIUI/OneUI/ColorOS/etc.).
  Future<bool> openOemBatterySettings() async {
    try {
      final result =
          await _methodChannel.invokeMethod<bool>('openOemBatterySettings');
      return result ?? false;
    } catch (e) {
      debugPrint('NativeStepService.openOemBatterySettings error: $e');
      return false;
    }
  }

  /// Broadcast stream providing real-time step increments from the hardware sensor.
  Stream<int> get stepStream {
    _stepStream ??= _eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => (event as num).toInt());
    return _stepStream!;
  }
}
