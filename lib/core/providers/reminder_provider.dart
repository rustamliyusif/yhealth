import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/native_step_service.dart';
import '../services/storage_service.dart';

class ReminderProvider extends ChangeNotifier {
  final StorageService _storage;
  final NativeStepService _native;

  ReminderProvider(this._storage, [NativeStepService? native]) : _native = native ?? NativeStepService();

  bool get water => _storage.reminderWater;
  bool get move => _storage.reminderMove;
  int get quietStart => _storage.quietStart;
  int get quietEnd => _storage.quietEnd;

  Future<void> _ensurePermission() async {
    try {
      await Permission.notification.request();
    } catch (_) {}
  }

  Future<void> setWater(bool value) async {
    if (value) await _ensurePermission();
    await _storage.setReminderWater(value);
    notifyListeners();
  }

  Future<void> setMove(bool value) async {
    if (value) await _ensurePermission();
    await _storage.setReminderMove(value);
    notifyListeners();
  }

  Future<void> setQuietStart(int minutes) async {
    await _storage.setQuietStart(minutes);
    notifyListeners();
  }

  Future<void> setQuietEnd(int minutes) async {
    await _storage.setQuietEnd(minutes);
    notifyListeners();
  }

  Future<void> sendTest() async {
    await _ensurePermission();
    await _native.testReminder();
  }

  void reload() => notifyListeners();

  static String formatMinutes(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
}
