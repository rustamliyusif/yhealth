import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyHasSelectedLanguage = 'has_selected_language';
  static const String keyLanguageCode = 'language_code';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserAge = 'user_age';
  static const String keyUserHeight = 'user_height';
  static const String keyUserWeight = 'user_weight';
  static const String keyMeasurementUnit = 'measurement_unit';
  static const String keyGoalSteps = 'goal_steps';
  static const String keyGoalCalories = 'goal_calories';
  static const String keyGoalDistance = 'goal_distance';
  static const String keyGoalActiveTime = 'goal_active_time';
  static const String keySavedRoutes = 'saved_routes';
  static const String keyStepHistory = 'step_history';
  static const String keySimulatedSteps = 'simulated_steps';
  static const String keyOfflineUsers = 'offline_users';
  static const String keyCurrentUserId = 'current_user_id';
  static const String keyLastTrackingDate = 'last_tracking_date';
  static const String keyThemeMode = 'theme_mode';
  static const String keyTargetWeight = 'target_weight';
  static const String keyActivityLevel = 'activity_level';
  static const String keyDietaryPreference = 'dietary_preference';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Language
  bool get hasSelectedLanguage => _prefs.getBool(keyHasSelectedLanguage) ?? false;
  Future<void> setHasSelectedLanguage(bool value) async {
    await _prefs.setBool(keyHasSelectedLanguage, value);
  }

  String get languageCode => _prefs.getString(keyLanguageCode) ?? 'az';
  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(keyLanguageCode, code);
  }

  // User Profile
  String get userName => _prefs.getString(keyUserName) ?? '';
  Future<void> setUserName(String name) async {
    await _prefs.setString(keyUserName, name);
  }

  String get userEmail => _prefs.getString(keyUserEmail) ?? '';
  Future<void> setUserEmail(String email) async {
    await _prefs.setString(keyUserEmail, email);
  }

  int get userAge => _prefs.getInt(keyUserAge) ?? 28;
  Future<void> setUserAge(int age) async {
    await _prefs.setInt(keyUserAge, age);
  }

  double get userHeight => _prefs.getDouble(keyUserHeight) ?? 175.0; // cm
  Future<void> setUserHeight(double height) async {
    await _prefs.setDouble(keyUserHeight, height);
  }

  double get userWeight => _prefs.getDouble(keyUserWeight) ?? 70.0; // kg
  Future<void> setUserWeight(double weight) async {
    await _prefs.setDouble(keyUserWeight, weight);
  }

  double get targetWeight => _prefs.getDouble(keyTargetWeight) ?? 65.0; // kg
  Future<void> setTargetWeight(double weight) async {
    await _prefs.setDouble(keyTargetWeight, weight);
  }

  String get activityLevel => _prefs.getString(keyActivityLevel) ?? 'moderatelyActive';
  Future<void> setActivityLevel(String level) async {
    await _prefs.setString(keyActivityLevel, level);
  }

  String get dietaryPreference => _prefs.getString(keyDietaryPreference) ?? 'balanced';
  Future<void> setDietaryPreference(String pref) async {
    await _prefs.setString(keyDietaryPreference, pref);
  }

  String get measurementUnit => _prefs.getString(keyMeasurementUnit) ?? 'metric';
  Future<void> setMeasurementUnit(String unit) async {
    await _prefs.setString(keyMeasurementUnit, unit);
  }

  // Daily Goals
  int get goalSteps => _prefs.getInt(keyGoalSteps) ?? 8000;
  Future<void> setGoalSteps(int steps) async {
    await _prefs.setInt(keyGoalSteps, steps);
  }

  int get goalCalories => _prefs.getInt(keyGoalCalories) ?? 450;
  Future<void> setGoalCalories(int calories) async {
    await _prefs.setInt(keyGoalCalories, calories);
  }

  double get goalDistance => _prefs.getDouble(keyGoalDistance) ?? 5.0; // km
  Future<void> setGoalDistance(double distance) async {
    await _prefs.setDouble(keyGoalDistance, distance);
  }

  int get goalActiveTime => _prefs.getInt(keyGoalActiveTime) ?? 30; // minutes
  Future<void> setGoalActiveTime(int minutes) async {
    await _prefs.setInt(keyGoalActiveTime, minutes);
  }

  // Theme Mode
  String get themeMode => _prefs.getString(keyThemeMode) ?? 'light';
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(keyThemeMode, mode);
  }

  // Tracking Date
  String get lastTrackingDate => _prefs.getString(keyLastTrackingDate) ?? '';
  Future<void> setLastTrackingDate(String date) async {
    await _prefs.setString(keyLastTrackingDate, date);
  }

  // Steps
  int get simulatedSteps => _prefs.getInt(keySimulatedSteps) ?? 0;
  Future<void> setSimulatedSteps(int steps) async {
    await _prefs.setInt(keySimulatedSteps, steps);
  }

  Map<String, int> getStepHistory() {
    final raw = _prefs.getString(keyStepHistory);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveStepHistory(Map<String, int> history) async {
    await _prefs.setString(keyStepHistory, jsonEncode(history));
  }

  // Routes
  List<Map<String, dynamic>> getSavedRoutes() {
    final raw = _prefs.getString(keySavedRoutes);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveRoute(Map<String, dynamic> route) async {
    final routes = getSavedRoutes();
    routes.insert(0, route);
    await _prefs.setString(keySavedRoutes, jsonEncode(routes));
  }

  // Auth / Offline Users
  String? get currentUserId => _prefs.getString(keyCurrentUserId);
  Future<void> setCurrentUserId(String? id) async {
    if (id == null) {
      await _prefs.remove(keyCurrentUserId);
    } else {
      await _prefs.setString(keyCurrentUserId, id);
    }
  }

  Map<String, dynamic> getOfflineUsers() {
    final raw = _prefs.getString(keyOfflineUsers);
    if (raw == null || raw.isEmpty) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveOfflineUser(String email, String password, String name) async {
    final users = getOfflineUsers();
    final salt = _generateSalt();
    users[email.toLowerCase()] = {
      'id': email.toLowerCase(),
      'email': email.toLowerCase(),
      'passwordHash': hashPassword(password, salt),
      'salt': salt,
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(keyOfflineUsers, jsonEncode(users));
  }

  Future<bool> verifyOfflineUserPassword(String email, String password) async {
    final users = getOfflineUsers();
    final key = email.toLowerCase();
    final user = users[key];
    if (user is! Map) return false;
    final userData = Map<String, dynamic>.from(user);

    final hash = userData['passwordHash'] as String?;
    final salt = userData['salt'] as String?;
    if (hash != null && salt != null) {
      return hashPassword(password, salt) == hash;
    }

    final legacyPassword = userData['password'] as String?;
    if (legacyPassword == null || legacyPassword != password) return false;

    final newSalt = _generateSalt();
    userData
      ..remove('password')
      ..['passwordHash'] = hashPassword(password, newSalt)
      ..['salt'] = newSalt;
    users[key] = userData;
    await _prefs.setString(keyOfflineUsers, jsonEncode(users));
    return true;
  }

  Future<void> clearSessionProfile() async {
    await _prefs.remove(keyCurrentUserId);
    await _prefs.remove(keyUserName);
    await _prefs.remove(keyUserEmail);
  }

  static String hashPassword(String password, String salt) {
    var bytes = utf8.encode('$salt:$password');
    var digest = sha256.convert(bytes);
    for (var i = 0; i < 10000; i++) {
      digest = sha256.convert([...digest.bytes, ...bytes]);
    }
    return digest.toString();
  }

  static String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }
}
