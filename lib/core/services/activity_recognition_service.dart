import 'dart:async';
import 'package:flutter/foundation.dart';

enum HumanActivityType {
  still,
  walking,
  running,
  onBicycle,
  inVehicle,
}

class ActivityRecognitionEvent {
  final HumanActivityType type;
  final double confidence; // 0.0 - 1.0
  final int cadenceStepsPerMinute;
  final double currentSpeedKmH;
  final DateTime timestamp;

  const ActivityRecognitionEvent({
    required this.type,
    required this.confidence,
    required this.cadenceStepsPerMinute,
    required this.currentSpeedKmH,
    required this.timestamp,
  });

  bool get isVehicle => type == HumanActivityType.inVehicle;
  bool get isWalkingOrRunning =>
      type == HumanActivityType.walking || type == HumanActivityType.running;
}

/// Device-independent multi-sensor Activity Recognition engine.
///
/// Fuses hardware step cadence, GPS kinematic velocity, and pedometer status
/// to recognize: Still, Walking, Running, Cycling, and Vehicle Transit.
class ActivityRecognitionService {
  final _activityController =
      StreamController<ActivityRecognitionEvent>.broadcast();

  HumanActivityType _currentType = HumanActivityType.still;
  double _currentConfidence = 0.95;
  int _cadence = 0;
  double _gpsSpeedKmH = 0.0;
  String _pedestrianStatus = 'stopped';

  // Sliding window for step cadence calculation
  final List<DateTime> _recentStepTimestamps = [];
  Timer? _cadenceDecayTimer;

  ActivityRecognitionService() {
    _startCadenceDecayTimer();
  }

  HumanActivityType get currentType => _currentType;
  double get currentConfidence => _currentConfidence;
  int get currentCadence => _cadence;
  double get currentSpeedKmH => _gpsSpeedKmH;
  bool get isVehicleDetected => _currentType == HumanActivityType.inVehicle;

  Stream<ActivityRecognitionEvent> get activityStream =>
      _activityController.stream;

  /// Ingests a new hardware step event to calculate real-time cadence.
  void recordStepEvent() {
    final now = DateTime.now();
    _recentStepTimestamps.add(now);
    _pruneStepTimestamps(now);
    _recalculateCadence();
    _evaluateActivityClassification();
  }

  /// Ingests live GPS velocity (in km/h).
  void updateGpsSpeed(double speedKmH) {
    _gpsSpeedKmH = speedKmH.clamp(0.0, 200.0);
    _evaluateActivityClassification();
  }

  /// Ingests pedestrian status ('walking', 'stopped', 'unknown').
  void updatePedestrianStatus(String status) {
    _pedestrianStatus = status.toLowerCase();
    _evaluateActivityClassification();
  }

  void _pruneStepTimestamps(DateTime now) {
    // Keep window within the last 15 seconds
    _recentStepTimestamps.removeWhere(
      (ts) => now.difference(ts).inSeconds > 15,
    );
  }

  void _recalculateCadence() {
    final now = DateTime.now();
    _pruneStepTimestamps(now);
    final count = _recentStepTimestamps.length;
    if (count < 2) {
      _cadence = count > 0 ? 30 : 0;
    } else {
      // Extrapolate steps in 15-second window to 60 seconds
      _cadence = (count * 4).clamp(0, 240);
    }
  }

  void _startCadenceDecayTimer() {
    _cadenceDecayTimer?.cancel();
    _cadenceDecayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final now = DateTime.now();
      _pruneStepTimestamps(now);
      if (_recentStepTimestamps.isEmpty && _cadence > 0) {
        _cadence = 0;
        _evaluateActivityClassification();
      }
    });
  }

  /// Static activity classification based on cadence and velocity thresholds
  HumanActivityType classifyActivity({
    required int cadenceSpm,
    required double gpsSpeedKmH,
    String pedestrianStatus = 'stopped',
  }) {
    if (gpsSpeedKmH > 25.0) {
      return HumanActivityType.inVehicle;
    } else if (gpsSpeedKmH >= 9.5 && gpsSpeedKmH <= 25.0 && cadenceSpm < 35) {
      return HumanActivityType.onBicycle;
    } else if (cadenceSpm >= 130 ||
        (gpsSpeedKmH >= 7.5 && gpsSpeedKmH <= 22.0 && cadenceSpm >= 75)) {
      return HumanActivityType.running;
    } else if (cadenceSpm >= 25 ||
        (gpsSpeedKmH >= 1.5 && gpsSpeedKmH < 7.5) ||
        pedestrianStatus == 'walking') {
      return HumanActivityType.walking;
    } else {
      return HumanActivityType.still;
    }
  }

  /// Primary multi-signal classification algorithm
  void _evaluateActivityClassification() {
    final detectedType = classifyActivity(
      cadenceSpm: _cadence,
      gpsSpeedKmH: _gpsSpeedKmH,
      pedestrianStatus: _pedestrianStatus,
    );

    double confidence;
    switch (detectedType) {
      case HumanActivityType.inVehicle:
        confidence = (_gpsSpeedKmH > 35.0) ? 0.98 : 0.88;
        break;
      case HumanActivityType.onBicycle:
        confidence = 0.85;
        break;
      case HumanActivityType.running:
        confidence = (_cadence >= 140) ? 0.95 : 0.85;
        break;
      case HumanActivityType.walking:
        confidence = (_cadence >= 40) ? 0.92 : 0.78;
        break;
      case HumanActivityType.still:
        confidence = 0.95;
        break;
    }

    final hasChanged = detectedType != _currentType;
    _currentType = detectedType;
    _currentConfidence = confidence;

    final event = ActivityRecognitionEvent(
      type: _currentType,
      confidence: _currentConfidence,
      cadenceStepsPerMinute: _cadence,
      currentSpeedKmH: _gpsSpeedKmH,
      timestamp: DateTime.now(),
    );

    _activityController.add(event);

    if (hasChanged) {
      debugPrint(
        'ActivityRecognition: $detectedType (conf: ${(confidence * 100).toInt()}%, cadence: $_cadence spm, speed: ${_gpsSpeedKmH.toStringAsFixed(1)} km/h)',
      );
    }
  }

  void dispose() {
    _cadenceDecayTimer?.cancel();
    _activityController.close();
  }
}
