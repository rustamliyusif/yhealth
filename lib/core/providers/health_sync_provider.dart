import 'package:flutter/widgets.dart';
import '../services/health_connect_service.dart';
import '../services/storage_service.dart';
import 'sleep_provider.dart';
import 'step_counter_provider.dart';
import 'weight_coach_provider.dart';

class HealthSyncResult {
  final int sleep;
  final int weight;
  const HealthSyncResult(this.sleep, this.weight);
}

class HealthSyncProvider extends ChangeNotifier with WidgetsBindingObserver {
  final StorageService _storage;
  final HealthConnectService _service;
  final StepCounterProvider _steps;
  final SleepProvider _sleep;
  final WeightCoachProvider _weight;

  HealthConnectStatus _status = HealthConnectStatus.unknown;
  int _granted = 0;
  int _total = 4;
  bool _syncing = false;
  DateTime? _lastSync;

  HealthSyncProvider(
    this._storage,
    this._steps,
    this._sleep,
    this._weight, [
    HealthConnectService? service,
  ]) : _service = service ?? HealthConnectService() {
    _lastSync = DateTime.tryParse(_storage.healthConnectLastSync ?? '');
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 3), () => refresh(sync: true));
  }

  HealthConnectStatus get status => _status;
  int get granted => _granted;
  int get total => _total;
  bool get connected => _status == HealthConnectStatus.available && _granted > 0;
  bool get syncing => _syncing;
  DateTime? get lastSync => _lastSync;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh(sync: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> refresh({bool sync = false}) async {
    _status = await _service.checkAvailability();
    if (_status == HealthConnectStatus.available) {
      final p = await _service.permissionStatus();
      _granted = p.granted;
      _total = p.total;
    } else {
      _granted = 0;
    }
    notifyListeners();
    if (sync && connected && _storage.healthConnectEnabled) {
      final last = _lastSync;
      if (last == null || DateTime.now().difference(last).inMinutes >= 15) {
        await syncNow();
      }
    }
  }

  Future<bool> connect() async {
    await _service.requestPermissions();
    await refresh();
    if (connected) {
      await _storage.setHealthConnectEnabled(true);
      await syncNow();
    }
    return connected;
  }

  Future<void> disconnect() async {
    await _storage.setHealthConnectEnabled(false);
    notifyListeners();
  }

  static String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<HealthSyncResult> syncNow() async {
    if (_syncing || !connected) return const HealthSyncResult(0, 0);
    _syncing = true;
    notifyListeners();
    var sleepCount = 0;
    var weightCount = 0;
    try {
      await _sleep.checkHealthConnectStatus();
      sleepCount = await _sleep.syncFromHealthConnect();

      final now = DateTime.now();
      final weights = await _service.fetchWeights(
        startTime: now.subtract(const Duration(days: 90)),
        endTime: now,
      );
      weightCount = await _weight.importWeights(weights);

      final today = DateTime(now.year, now.month, now.day);
      final keys = List.generate(7, (i) => _key(today.subtract(Duration(days: i))));
      final history = _steps.history;
      final stepDays = <String, int>{};
      for (final k in keys) {
        final v = history[k] ?? 0;
        if (v > 0) stepDays[k] = v;
      }
      if (_steps.todaySteps > (stepDays[keys.first] ?? 0)) stepDays[keys.first] = _steps.todaySteps;
      await _service.writeSteps(stepDays);

      final water = _storage.getWaterLog();
      final waterDays = <String, int>{};
      for (final k in keys) {
        final v = water[k] ?? 0;
        if (v > 0) waterDays[k] = v;
      }
      await _service.writeHydration(waterDays);

      _lastSync = DateTime.now();
      await _storage.setHealthConnectLastSync(_lastSync!.toIso8601String());
    } finally {
      _syncing = false;
      notifyListeners();
    }
    return HealthSyncResult(sleepCount, weightCount);
  }

  Future<bool> openSettings() => _service.openHealthConnectSettings();
}
