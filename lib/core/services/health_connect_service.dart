import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/sleep_record_model.dart';

enum HealthConnectStatus {
  available,
  notInstalled,
  unsupported,
  unknown,
}

/// Clean service abstracting Android Health Connect integration.
class HealthConnectService {
  static const MethodChannel _channel = MethodChannel('com.example.yhealth/health_connect');

  /// Checks Health Connect status on the current Android device.
  Future<HealthConnectStatus> checkAvailability() async {
    try {
      final status = await _channel.invokeMethod<String>('checkAvailability');
      switch (status) {
        case 'available':
          return HealthConnectStatus.available;
        case 'not_installed':
          return HealthConnectStatus.notInstalled;
        case 'unsupported':
          return HealthConnectStatus.unsupported;
        default:
          return HealthConnectStatus.unknown;
      }
    } catch (e) {
      debugPrint('HealthConnectService.checkAvailability error: $e');
      return HealthConnectStatus.unsupported;
    }
  }

  /// Opens the Health Connect settings or Google Play Store to install.
  Future<bool> openHealthConnectSettings() async {
    try {
      final opened = await _channel.invokeMethod<bool>('openHealthConnectSettings');
      return opened ?? false;
    } catch (e) {
      debugPrint('HealthConnectService.openHealthConnectSettings error: $e');
      return false;
    }
  }

  /// Reads recorded sleep sessions from Health Connect.
  /// Genuinely preserves wearable sleep stages when present.
  Future<List<SleepRecordModel>> fetchSleepSessions({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('readSleepSessions', {
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      });

      if (result == null || result.isEmpty) return [];

      final list = <SleepRecordModel>[];
      for (final item in result) {
        if (item is Map) {
          try {
            final map = Map<String, dynamic>.from(item);
            list.add(SleepRecordModel.fromJson(map));
          } catch (e) {
            debugPrint('Error parsing sleep session: $e');
          }
        }
      }
      return list;
    } catch (e) {
      debugPrint('HealthConnectService.fetchSleepSessions error: $e');
      return [];
    }
  }
}
