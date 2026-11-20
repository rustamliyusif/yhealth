import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService;
  final FirebaseService _firebaseService;

  AuthStatus _status = AuthStatus.unauthenticated;
  String? _userId;
  String _userName = '';
  String _userEmail = '';
  int _userAge = 28;
  double _userHeight = 175.0; // cm
  double _userWeight = 70.0; // kg
  String _measurementUnit = 'metric';

  // Daily goals
  int _goalSteps = 8000;
  int _goalCalories = 450;
  double _goalDistance = 5.0; // km
  int _goalActiveTime = 30; // minutes

  String? _errorMessage;

  AuthProvider(this._storageService, this._firebaseService) {
    _loadInitialState();
  }

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isFirebaseConnected => FirebaseService.isAvailable;
  String? get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;
  int get userAge => _userAge;
  double get userHeight => _userHeight;
  double get userWeight => _userWeight;
  String get measurementUnit => _measurementUnit;

  int get goalSteps => _goalSteps;
  int get goalCalories => _goalCalories;
  double get goalDistance => _goalDistance;
  int get goalActiveTime => _goalActiveTime;

  String? get errorMessage => _errorMessage;

  void _loadInitialState() {
    _userName = _storageService.userName;
    _userEmail = _storageService.userEmail;
    _userAge = _storageService.userAge;
    _userHeight = _storageService.userHeight;
    _userWeight = _storageService.userWeight;
    _measurementUnit = _storageService.measurementUnit;

    _goalSteps = _storageService.goalSteps;
    _goalCalories = _storageService.goalCalories;
    _goalDistance = _storageService.goalDistance;
    _goalActiveTime = _storageService.goalActiveTime;

    final savedId = _storageService.currentUserId;
    if (savedId != null) {
      _userId = savedId;
      _status = AuthStatus.authenticated;
    }
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final users = _storageService.getOfflineUsers();
      final normalizedEmail = email.trim().toLowerCase();
      if (users.containsKey(normalizedEmail)) {
        final userData = users[normalizedEmail] as Map<String, dynamic>;
        if (await _storageService.verifyOfflineUserPassword(normalizedEmail, password)) {
          _userId = userData['id'] as String;
          _userEmail = normalizedEmail;
          _userName = (userData['name'] as String?) ?? 'YHealth User';
          await _storageService.setUserEmail(_userEmail);
          await _storageService.setUserName(_userName);
          await _storageService.setCurrentUserId(_userId);
          _status = AuthStatus.authenticated;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'wrong_password';
          _status = AuthStatus.unauthenticated;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'user_not_found';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final users = _storageService.getOfflineUsers();
      final normalizedEmail = email.trim().toLowerCase();
      if (users.containsKey(normalizedEmail)) {
        _errorMessage = 'email_already_in_use';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      await _storageService.saveOfflineUser(normalizedEmail, password, name.trim());
      _userId = normalizedEmail;
      _userEmail = normalizedEmail;
      _userName = name.trim();
      await _storageService.setUserEmail(_userEmail);
      await _storageService.setUserName(_userName);
      await _storageService.setCurrentUserId(_userId);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> resetPassword(String email) async {
    _errorMessage = null;
    try {
      final users = _storageService.getOfflineUsers();
      if (users.containsKey(email.trim().toLowerCase())) {
        _errorMessage = 'reset_unavailable_offline';
      } else {
        _errorMessage = 'user_not_found';
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<void> continueAsGuest() async {
    _userId = 'local_guest';
    _userEmail = '';
    _userName = '';
    await _storageService.setUserEmail(_userEmail);
    await _storageService.setUserName(_userName);
    await _storageService.setCurrentUserId(_userId);
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storageService.clearSessionProfile();
    _userId = null;
    _userName = '';
    _userEmail = '';
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    int? age,
    double? height,
    double? weight,
    String? measurementUnit,
  }) async {
    if (name != null) {
      _userName = name;
      await _storageService.setUserName(name);
    }
    if (age != null) {
      _userAge = age;
      await _storageService.setUserAge(age);
    }
    if (height != null) {
      _userHeight = height;
      await _storageService.setUserHeight(height);
    }
    if (weight != null) {
      _userWeight = weight;
      await _storageService.setUserWeight(weight);
    }
    if (measurementUnit != null) {
      _measurementUnit = measurementUnit;
      await _storageService.setMeasurementUnit(measurementUnit);
    }

    if (FirebaseService.isAvailable && _userId != null) {
      await _firebaseService.syncUserProfile(
        userId: _userId!,
        profileData: {
          'name': _userName,
          'age': _userAge,
          'height': _userHeight,
          'weight': _userWeight,
          'measurementUnit': _measurementUnit,
        },
      );
    }
    notifyListeners();
  }

  Future<void> updateGoals({
    int? steps,
    int? calories,
    double? distance,
    int? activeTime,
  }) async {
    if (steps != null) {
      _goalSteps = steps;
      await _storageService.setGoalSteps(steps);
    }
    if (calories != null) {
      _goalCalories = calories;
      await _storageService.setGoalCalories(calories);
    }
    if (distance != null) {
      _goalDistance = distance;
      await _storageService.setGoalDistance(distance);
    }
    if (activeTime != null) {
      _goalActiveTime = activeTime;
      await _storageService.setGoalActiveTime(activeTime);
    }

    if (FirebaseService.isAvailable && _userId != null) {
      await _firebaseService.syncUserProfile(
        userId: _userId!,
        profileData: {
          'goalSteps': _goalSteps,
          'goalCalories': _goalCalories,
          'goalDistance': _goalDistance,
          'goalActiveTime': _goalActiveTime,
        },
      );
    }
    notifyListeners();
  }
}
