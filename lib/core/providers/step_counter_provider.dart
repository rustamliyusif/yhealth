import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/activity_recognition_service.dart';
import '../services/native_step_service.dart';
import '../services/storage_service.dart';
import '../repositories/activity_repository.dart';
import '../database/app_database.dart';

enum SensorStatus {
  active,
  unsupported,
  permissionDenied,
  waiting,
}

class StepCounterProvider extends ChangeNotifier with WidgetsBindingObserver {
  final StorageService _storageService;
  final NativeStepService _nativeStepService;
  final ActivityRecognitionService _activityRecognitionService;
  final ActivityRepository? activityRepository;

  StreamSubscription<int>? _nativeStepSubscription;
  StreamSubscription<StepCount>? _fallbackPedometerSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  StreamSubscription<ActivityRecognitionEvent>? _activitySubscription;
  Timer? _midnightCheckTimer;
  Timer? _persistTimer;
  bool _started = false;

  int _todayHardwareSteps = 0;
  int _lastFallbackRawSteps = -1;
  int _simulatedSteps = 0;
  SensorStatus _sensorStatus = SensorStatus.waiting;
  String _pedestrianState = 'stopped'; // walking, stopped, unknown
  bool _isNativeServiceRunning = false;
  DeviceCompatibilityModel? _compatibility;

  Map<String, int> _history = {};
  String _currentDayKey = '';

  StepCounterProvider(
    this._storageService, {
    NativeStepService? nativeStepService,
    ActivityRecognitionService? activityRecognitionService,
    this.activityRepository,
  })  : _nativeStepService = nativeStepService ?? NativeStepService(),
        _activityRecognitionService =
            activityRecognitionService ?? ActivityRecognitionService() {
    WidgetsBinding.instance.addObserver(this);
    _currentDayKey = _getTodayKey();
    _loadState();
    _checkDailyResetOnStartup();
    _initActivityRecognitionListener();
    _startMidnightTimer();
    refreshCompatibility();
  }

  /// Requests sensor permissions and starts step tracking.
  /// Called once the user is signed in and the main UI is visible.
  Future<void> start() async {
    if (_started) return;
    _started = true;
    await _initPedometerService();
  }

  int get todaySteps => _todayHardwareSteps + _simulatedSteps;
  int get simulatedSteps => _simulatedSteps;
  SensorStatus get sensorStatus => _sensorStatus;
  String get pedestrianState => _pedestrianState;
  bool get isSensorActive => _sensorStatus == SensorStatus.active;
  bool get isNativeServiceRunning => _isNativeServiceRunning;
  Map<String, int> get history => _history;
  DeviceCompatibilityModel? get compatibility => _compatibility;
  DeviceCompatibilityModel? get deviceCompatibility => _compatibility;

  // Human Activity Recognition getters
  HumanActivityType get activityType => _activityRecognitionService.currentType;
  HumanActivityType get currentActivity => _activityRecognitionService.currentType;
  int get currentCadence => _activityRecognitionService.currentCadence;
  double get currentConfidence =>
      _activityRecognitionService.currentConfidence;
  bool get isVehicleDetected =>
      _activityRecognitionService.isVehicleDetected;
  ActivityRecognitionService get activityRecognition =>
      _activityRecognitionService;

  Future<void> refreshDeviceCompatibility() => refreshCompatibility();

  Stream<List<DailyActivityEntry>> watchDailyHistory({int limit = 60}) =>
      activityRepository?.watchAllDailyActivities(limit: limit) ?? const Stream.empty();

  // Conversions based on user height & weight
  double calculateDistanceKm(double heightCm) {
    final strideLengthMeters = (heightCm * 0.414) / 100.0;
    return (todaySteps * strideLengthMeters) / 1000.0;
  }

  int calculateCalories(double weightKg) {
    final factor = (weightKg / 70.0).clamp(0.7, 1.5);
    return (todaySteps * 0.042 * factor).round();
  }

  int calculateActiveMinutes() {
    return (todaySteps / 100).round();
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadState() async {
    _simulatedSteps = _storageService.simulatedSteps;
    _history = _storageService.getStepHistory();

    final repo = activityRepository;
    if (repo != null) {
      try {
        final driftEntries = await repo.getAllDailyActivities();
        if (driftEntries.isNotEmpty) {
          for (final entry in driftEntries) {
            _history[entry.date] = entry.steps;
          }
        }
      } catch (e) {
        debugPrint('StepCounterProvider._loadState drift error: $e');
      }
    }

    notifyListeners();
  }

  void _initActivityRecognitionListener() {
    _activitySubscription =
        _activityRecognitionService.activityStream.listen((_) {
      notifyListeners();
    });
  }

  /// Updates GPS velocity to feed the multi-sensor activity classifier.
  void updateGpsSpeed(double speedKmH) {
    _activityRecognitionService.updateGpsSpeed(speedKmH);
  }

  /// Refreshes device compatibility and hardware sensor diagnostics.
  Future<void> refreshCompatibility() async {
    try {
      _compatibility = await _nativeStepService.getDeviceCompatibilityInfo();
      notifyListeners();
    } catch (e) {
      debugPrint('StepCounterProvider.refreshCompatibility error: $e');
    }
  }

  /// Requests exemption from battery optimizations.
  Future<bool> requestIgnoreBatteryOptimization() async {
    final result =
        await _nativeStepService.requestIgnoreBatteryOptimization();
    await refreshCompatibility();
    return result;
  }

  /// Opens manufacturer-tailored power management / autostart settings.
  Future<bool> openOemBatterySettings() async {
    return await _nativeStepService.openOemBatterySettings();
  }

  /// Verifies whether the calendar day has changed since the app last operated.
  Future<void> _checkDailyResetOnStartup() async {
    final today = _getTodayKey();
    final lastTrackedDate = _storageService.lastTrackingDate;

    if (lastTrackedDate.isNotEmpty && lastTrackedDate != today) {
      // Midnight crossed while app was closed or device was off.
      // Save recorded steps from the previous tracking date.
      if (_todayHardwareSteps > 0 || _simulatedSteps > 0) {
        _history[lastTrackedDate] = todaySteps;
        await _storageService.saveStepHistory(_history);

        final repo = activityRepository;
        if (repo != null) {
          final userHeight = _storageService.userHeight;
          final userWeight = _storageService.userWeight;
          final goalSteps = _storageService.goalSteps;

          await repo.saveDailyActivity(
            date: lastTrackedDate,
            steps: todaySteps,
            distanceKm: calculateDistanceKm(userHeight),
            calories: calculateCalories(userWeight),
            activeMinutes: calculateActiveMinutes(),
            goalSteps: goalSteps,
          );
        }
      }
      // Reset displayed daily counter for the new date
      _todayHardwareSteps = 0;
      _simulatedSteps = 0;
      await _storageService.setSimulatedSteps(0);
      _lastFallbackRawSteps = -1;
    }

    _currentDayKey = today;
    await _storageService.setLastTrackingDate(today);

    // If native steps are saved for today, load them immediately
    final nativeSteps = await _nativeStepService.getTodaySteps();
    if (nativeSteps > 0) {
      _todayHardwareSteps = nativeSteps;
      _recordTodayHistory();
    }
    notifyListeners();
  }

  /// Starts a periodic 30-second checker to automatically reset daily steps at local midnight.
  void _startMidnightTimer() {
    _midnightCheckTimer?.cancel();
    _midnightCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _evaluateMidnightTransition();
    });
  }

  void _evaluateMidnightTransition() {
    final currentToday = _getTodayKey();
    if (_currentDayKey != currentToday) {
      _persistTimer?.cancel();
      _persistTimer = null;
      // MIDNIGHT REACHED!
      debugPrint(
          'StepCounterProvider: Midnight transition detected from $_currentDayKey to $currentToday');

      // 1. Archive previous day's steps to storage and Drift database
      _history[_currentDayKey] = todaySteps;
      _storageService.saveStepHistory(_history);

      final repo = activityRepository;
      if (repo != null) {
        final userHeight = _storageService.userHeight;
        final userWeight = _storageService.userWeight;
        final goalSteps = _storageService.goalSteps;

        repo.saveDailyActivity(
          date: _currentDayKey,
          steps: todaySteps,
          distanceKm: calculateDistanceKm(userHeight),
          calories: calculateCalories(userWeight),
          activeMinutes: calculateActiveMinutes(),
          goalSteps: goalSteps,
        );
      }

      // 2. Reset daily counter for the new day
      _todayHardwareSteps = 0;
      _simulatedSteps = 0;
      _storageService.setSimulatedSteps(0);
      _lastFallbackRawSteps = -1;

      // 3. Update current date tracker
      _currentDayKey = currentToday;
      _storageService.setLastTrackingDate(currentToday);

      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _flushTodayHistory();
    }
    if (state == AppLifecycleState.resumed) {
      _evaluateMidnightTransition();
      _syncFromNativeService();
      refreshCompatibility();
    }
  }

  Future<void> _syncFromNativeService() async {
    final nativeSteps = await _nativeStepService.getTodaySteps();
    if (nativeSteps > 0 && nativeSteps != _todayHardwareSteps) {
      _todayHardwareSteps = nativeSteps;
      _recordTodayHistory();
      notifyListeners();
    }

    final nativeHistory = await _nativeStepService.getStepHistory();
    if (nativeHistory.isNotEmpty) {
      _history.addAll(nativeHistory);
      await _storageService.saveStepHistory(_history);

      final repo = activityRepository;
      if (repo != null) {
        final userHeight = _storageService.userHeight;
        final userWeight = _storageService.userWeight;
        final goalSteps = _storageService.goalSteps;

        for (final entry in nativeHistory.entries) {
          await repo.saveDailyActivity(
            date: entry.key,
            steps: entry.value,
            distanceKm: (entry.value * ((userHeight * 0.414) / 100.0)) / 1000.0,
            calories: (entry.value * 0.042 * (userWeight / 70.0).clamp(0.7, 1.5)).round(),
            activeMinutes: (entry.value / 100).round(),
            goalSteps: goalSteps,
          );
        }
      }
    }
  }

  Future<void> _initPedometerService() async {
    try {
      // 1. Request Activity Recognition permission (Android 10+)
      final activityStatus = await Permission.activityRecognition.request();
      if (activityStatus.isDenied || activityStatus.isPermanentlyDenied) {
        _sensorStatus = SensorStatus.permissionDenied;
        notifyListeners();
        return;
      }

      // 2. Request Notification permission on Android 13+ (for Foreground Health Service)
      await Permission.notification.request();

      // 3. Check if Android hardware sensor is available (either TYPE_STEP_COUNTER or TYPE_STEP_DETECTOR)
      final hasNativeSensor = await _nativeStepService.isSensorAvailable();

      if (hasNativeSensor) {
        // Start native foreground service for continuous background step counting
        _isNativeServiceRunning = await _nativeStepService.startStepService();

        // Subscribe to live event stream from native service
        _nativeStepSubscription?.cancel();
        _nativeStepSubscription = _nativeStepService.stepStream.listen(
          (steps) {
            final delta = steps - _todayHardwareSteps;
            if (delta > 0) {
              _activityRecognitionService.recordStepEvent();
            }
            _todayHardwareSteps = steps;
            _sensorStatus = SensorStatus.active;
            _recordTodayHistory();
            notifyListeners();
          },
          onError: (e) {
            debugPrint('Native step stream error: $e');
            _initFallbackPedometer();
          },
        );

        // Fetch initial saved steps
        final currentSteps = await _nativeStepService.getTodaySteps();
        if (currentSteps > 0) {
          _todayHardwareSteps = currentSteps;
          _sensorStatus = SensorStatus.active;
          _recordTodayHistory();
          notifyListeners();
        }

        // Merge native history into local history and Drift SQLite database
        final nativeHistory = await _nativeStepService.getStepHistory();
        if (nativeHistory.isNotEmpty) {
          _history.addAll(nativeHistory);
          await _storageService.saveStepHistory(_history);

          final repo = activityRepository;
          if (repo != null) {
            final userHeight = _storageService.userHeight;
            final userWeight = _storageService.userWeight;
            final goalSteps = _storageService.goalSteps;

            for (final entry in nativeHistory.entries) {
              await repo.saveDailyActivity(
                date: entry.key,
                steps: entry.value,
                distanceKm: (entry.value * ((userHeight * 0.414) / 100.0)) / 1000.0,
                calories: (entry.value * 0.042 * (userWeight / 70.0).clamp(0.7, 1.5)).round(),
                activeMinutes: (entry.value / 100).round(),
                goalSteps: goalSteps,
              );
            }
          }
        }

        _sensorStatus = SensorStatus.active;
        notifyListeners();
      } else {
        // Fallback for devices without hardware step sensors (e.g. tablet, emulator)
        _initFallbackPedometer();
      }

      // Listen to pedestrian status if available
      try {
        _pedestrianStatusSubscription?.cancel();
        _pedestrianStatusSubscription =
            Pedometer.pedestrianStatusStream.listen(
          (status) {
            _pedestrianState = status.status;
            _activityRecognitionService
                .updatePedestrianStatus(status.status);
            notifyListeners();
          },
          onError: (_) {},
          cancelOnError: false,
        );
      } catch (_) {}
    } catch (e) {
      debugPrint('Error starting step counter service: $e');
      _initFallbackPedometer();
    }
  }

  void _initFallbackPedometer() {
    _fallbackPedometerSubscription?.cancel();
    try {
      _fallbackPedometerSubscription = Pedometer.stepCountStream.listen(
        _onFallbackStepCount,
        onError: (err) {
          debugPrint('Fallback pedometer error: $err');
          _sensorStatus = SensorStatus.unsupported;
          notifyListeners();
        },
        cancelOnError: false,
      );
    } catch (_) {
      _sensorStatus = SensorStatus.unsupported;
      notifyListeners();
    }
  }

  void _onFallbackStepCount(StepCount event) {
    final raw = event.steps;

    if (_lastFallbackRawSteps < 0) {
      _lastFallbackRawSteps = raw;
    } else if (raw < _lastFallbackRawSteps) {
      // Device rebooted during execution
      final delta = raw;
      _todayHardwareSteps += delta;
      _lastFallbackRawSteps = raw;
      if (delta > 0) {
        _activityRecognitionService.recordStepEvent();
      }
    } else {
      final delta = raw - _lastFallbackRawSteps;
      if (delta > 0) {
        _todayHardwareSteps += delta;
        _lastFallbackRawSteps = raw;
        _activityRecognitionService.recordStepEvent();
      }
    }

    _sensorStatus = SensorStatus.active;
    _recordTodayHistory();
    notifyListeners();
  }

  void _recordTodayHistory() {
    _history[_currentDayKey] = todaySteps;
    _persistTimer ??= Timer(const Duration(seconds: 15), _flushTodayHistory);
  }

  void _flushTodayHistory() {
    _persistTimer?.cancel();
    _persistTimer = null;
    _history[_currentDayKey] = todaySteps;
    _storageService.saveStepHistory(_history);

    final repo = activityRepository;
    if (repo != null) {
      final userHeight = _storageService.userHeight;
      final userWeight = _storageService.userWeight;
      final goalSteps = _storageService.goalSteps;

      repo.saveDailyActivity(
        date: _currentDayKey,
        steps: todaySteps,
        distanceKm: calculateDistanceKm(userHeight),
        calories: calculateCalories(userWeight),
        activeMinutes: calculateActiveMinutes(),
        goalSteps: goalSteps,
      );
    }
  }

  /// Simulation method for testing and automated verification
  Future<void> addSimulatedSteps(int count) async {
    _simulatedSteps += count;
    _activityRecognitionService.recordStepEvent();
    await _storageService.setSimulatedSteps(_simulatedSteps);
    _flushTodayHistory();
    notifyListeners();
  }

  Future<void> resetSimulatedSteps() async {
    _simulatedSteps = 0;
    await _storageService.setSimulatedSteps(0);
    _flushTodayHistory();
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _midnightCheckTimer?.cancel();
    _flushTodayHistory();
    _nativeStepSubscription?.cancel();
    _fallbackPedometerSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _activitySubscription?.cancel();
    _activityRecognitionService.dispose();
    super.dispose();
  }
}
