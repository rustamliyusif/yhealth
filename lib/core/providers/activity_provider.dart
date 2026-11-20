import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../repositories/activity_repository.dart';

enum TrackingState {
  idle,
  tracking,
  paused,
}

class SavedRouteModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final double distanceKm;
  final int durationSeconds;
  final double avgSpeedKmH;
  final int calories;
  final List<LatLng> coordinates;
  final double vehicleDistanceKm;

  SavedRouteModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.distanceKm,
    required this.durationSeconds,
    required this.avgSpeedKmH,
    required this.calories,
    required this.coordinates,
    this.vehicleDistanceKm = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'distanceKm': distanceKm,
        'durationSeconds': durationSeconds,
        'avgSpeedKmH': avgSpeedKmH,
        'calories': calories,
        'coordinates': coordinates.map((c) => {'lat': c.latitude, 'lng': c.longitude}).toList(),
        'vehicleDistanceKm': vehicleDistanceKm,
      };

  factory SavedRouteModel.fromJson(Map<String, dynamic> json) {
    final rawCoords = (json['coordinates'] as List<dynamic>?) ?? [];
    return SavedRouteModel(
      id: (json['id'] as String?) ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: (json['title'] as String?) ?? 'Walk Route',
      dateTime: DateTime.tryParse((json['dateTime'] as String?) ?? '') ?? DateTime.now(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      avgSpeedKmH: (json['avgSpeedKmH'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      vehicleDistanceKm: (json['vehicleDistanceKm'] as num?)?.toDouble() ?? 0.0,
      coordinates: rawCoords
          .map((c) => LatLng(
                (c['lat'] as num).toDouble(),
                (c['lng'] as num).toDouble(),
              ))
          .toList(),
    );
  }
}

class ActivityProvider extends ChangeNotifier {
  final StorageService _storageService;

  TrackingState _trackingState = TrackingState.idle;
  final List<LatLng> _currentRoutePoints = [];
  Timer? _timer;
  int _durationSeconds = 0;
  double _distanceMeters = 0.0;
  double _vehicleDistanceMeters = 0.0;
  double _currentSpeedKmH = 0.0;
  bool _isVehicleDetected = false;

  final ActivityRepository? _activityRepository;
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _currentPosition;
  List<SavedRouteModel> _savedRoutes = [];
  String? _statusError;

  // Optional listener callback for StepCounterProvider / ActivityRecognition
  ValueChanged<double>? onSpeedUpdate;

  ActivityProvider(this._storageService, [dynamic _, this._activityRepository]) {
    _loadSavedRoutes();
    _fetchInitialPosition();
  }

  TrackingState get trackingState => _trackingState;
  bool get isTracking => _trackingState == TrackingState.tracking;
  bool get isPaused => _trackingState == TrackingState.paused;
  bool get isIdle => _trackingState == TrackingState.idle;

  List<LatLng> get currentRoutePoints => List.unmodifiable(_currentRoutePoints);
  LatLng? get currentPosition => _currentPosition;
  int get durationSeconds => _durationSeconds;
  double get distanceMeters => _distanceMeters;
  double get distanceKm => _distanceMeters / 1000.0;
  double get vehicleDistanceKm => _vehicleDistanceMeters / 1000.0;
  double get currentSpeedKmH => _currentSpeedKmH;
  bool get isVehicleDetected => _isVehicleDetected;
  List<SavedRouteModel> get savedRoutes => _savedRoutes;
  String? get statusError => _statusError;

  double get avgSpeedKmH {
    if (_durationSeconds <= 0) return 0.0;
    final hours = _durationSeconds / 3600.0;
    return distanceKm / hours;
  }

  double get paceMinKm {
    if (distanceKm <= 0.05) return 0.0;
    final minutes = _durationSeconds / 60.0;
    return minutes / distanceKm;
  }

  int get estimatedCalories {
    // Approx 60-62 kcal per km walked for average adult
    return (distanceKm * 62).round();
  }

  void _loadSavedRoutes() async {
    if (_activityRepository != null) {
      try {
        final driftRoutes = await _activityRepository.getAllRoutes();
        if (driftRoutes.isNotEmpty) {
          _savedRoutes = driftRoutes;
          notifyListeners();
          return;
        }
      } catch (e) {
        debugPrint('ActivityProvider._loadSavedRoutes error: $e');
      }
    }
    final rawRoutes = _storageService.getSavedRoutes();
    _savedRoutes = rawRoutes.map((r) => SavedRouteModel.fromJson(r)).toList();
    notifyListeners();
  }

  Future<void> _fetchInitialPosition() async {
    final pos = await LocationService.getCurrentLocation();
    if (pos != null) {
      _currentPosition = pos;
      notifyListeners();
    } else {
      // Default to Baku center fallback if permission not yet granted
      _currentPosition = const LatLng(40.4093, 49.8671);
      notifyListeners();
    }
  }

  Future<bool> startTracking() async {
    final perm = await LocationService.checkAndRequestPermission();
    if (perm != LocationPermissionState.granted) {
      if (perm == LocationPermissionState.deniedForever) {
        _statusError = 'permanently_denied';
      } else if (perm == LocationPermissionState.serviceDisabled) {
        _statusError = 'service_disabled';
      } else {
        _statusError = 'permission_denied';
      }
      notifyListeners();
      return false;
    }

    _statusError = null;
    _currentRoutePoints.clear();
    _durationSeconds = 0;
    _distanceMeters = 0.0;
    _vehicleDistanceMeters = 0.0;
    _currentSpeedKmH = 0.0;
    _isVehicleDetected = false;
    _trackingState = TrackingState.tracking;

    // Start workout duration timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_trackingState == TrackingState.tracking) {
        _durationSeconds++;
        notifyListeners();
      }
    });

    // Start real-time GPS location stream
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = LocationService.getPositionStream().listen(
      _onPositionUpdate,
      onError: (err) {
        debugPrint('Location stream error: $err');
      },
    );

    notifyListeners();
    return true;
  }

  void _onPositionUpdate(Position position) {
    if (_trackingState != TrackingState.tracking) return;

    final newPoint = LatLng(position.latitude, position.longitude);
    _currentPosition = newPoint;
    final speed = (position.speed * 3.6).clamp(0.0, 180.0); // m/s to km/h
    _currentSpeedKmH = speed;
    onSpeedUpdate?.call(speed);

    // Human athletic speed vs vehicular velocity classification
    if (speed > 25.0) {
      _isVehicleDetected = true;
    } else if (speed < 18.0) {
      _isVehicleDetected = false;
    }

    if (_currentRoutePoints.isNotEmpty) {
      final lastPoint = _currentRoutePoints.last;
      final addedDistance = LocationService.calculateDistanceInMeters(lastPoint, newPoint);
      // Filter GPS drift jitter (< 1.5m)
      if (addedDistance >= 1.5) {
        if (_isVehicleDetected) {
          // EXCLUDE vehicle journeys from walking and running fitness distance
          _vehicleDistanceMeters += addedDistance;
        } else {
          _distanceMeters += addedDistance;
        }
        _currentRoutePoints.add(newPoint);
      }
    } else {
      _currentRoutePoints.add(newPoint);
    }

    notifyListeners();
  }

  void pauseTracking() {
    if (_trackingState == TrackingState.tracking) {
      _trackingState = TrackingState.paused;
      _currentSpeedKmH = 0.0;
      onSpeedUpdate?.call(0.0);
      notifyListeners();
    }
  }

  void resumeTracking() {
    if (_trackingState == TrackingState.paused) {
      _trackingState = TrackingState.tracking;
      notifyListeners();
    }
  }

  Future<SavedRouteModel?> stopAndSaveRoute(String title, {String? userId}) async {
    _trackingState = TrackingState.idle;
    _timer?.cancel();
    _positionStreamSubscription?.cancel();
    _currentSpeedKmH = 0.0;
    onSpeedUpdate?.call(0.0);

    if (_currentRoutePoints.isEmpty && _currentPosition != null) {
      _currentRoutePoints.add(_currentPosition!);
    }

    final newRoute = SavedRouteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Walk Session' : title,
      dateTime: DateTime.now(),
      distanceKm: distanceKm,
      durationSeconds: _durationSeconds,
      avgSpeedKmH: avgSpeedKmH,
      calories: estimatedCalories,
      coordinates: List.from(_currentRoutePoints),
      vehicleDistanceKm: vehicleDistanceKm,
    );

    _savedRoutes.insert(0, newRoute);
    await _storageService.saveRoute(newRoute.toJson());
    if (_activityRepository != null) {
      try {
        await _activityRepository.saveRoute(newRoute);
      } catch (e) {
        debugPrint('ActivityProvider.stopAndSaveRoute drift error: $e');
      }
    }

    notifyListeners();
    return newRoute;
  }

  Future<void> deleteRoute(String id) async {
    _savedRoutes.removeWhere((r) => r.id == id);
    if (_activityRepository != null) {
      try {
        await _activityRepository.deleteRoute(id);
      } catch (e) {
        debugPrint('ActivityProvider.deleteRoute drift error: $e');
      }
    }
    notifyListeners();
  }

  void discardTracking() {
    _trackingState = TrackingState.idle;
    _timer?.cancel();
    _positionStreamSubscription?.cancel();
    _currentRoutePoints.clear();
    _durationSeconds = 0;
    _distanceMeters = 0.0;
    _vehicleDistanceMeters = 0.0;
    _currentSpeedKmH = 0.0;
    _isVehicleDetected = false;
    onSpeedUpdate?.call(0.0);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
