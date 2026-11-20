import 'package:flutter/foundation.dart';

/// Clean local service stub ensuring offline mode compatibility without external Firebase dependencies.
class FirebaseService {
  static bool get isAvailable => false;
  static String? get initErrorMessage => null;

  static Future<void> initialize() async {
    debugPrint('YHealth running in clean local storage mode.');
  }

  // Local stub methods returning null/empty
  Future<dynamic> signUpWithEmail({
    required String email,
    required String password,
  }) async => null;

  Future<dynamic> signInWithEmail({
    required String email,
    required String password,
  }) async => null;

  Future<void> sendPasswordResetEmail(String email) async {}
  Future<void> signOut() async {}

  Future<void> syncUserProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {}

  Future<void> syncActivityRoute({
    required String userId,
    required Map<String, dynamic> routeData,
  }) async {}

  Future<void> syncDailySummary({
    required String userId,
    required String dateKey,
    required Map<String, dynamic> summary,
  }) async {}

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async => null;
  Future<List<Map<String, dynamic>>> fetchSavedRoutes(String userId) async => [];
  Future<Map<String, dynamic>> fetchDailySummaries(String userId) async => {};
}
