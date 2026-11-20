import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../repositories/activity_repository.dart';
import '../providers/activity_provider.dart';

class MigrationResult {
  final bool isSuccess;
  final bool alreadyMigrated;
  final int migratedDailyRecords;
  final int migratedRoutes;
  final String? errorMessage;
  final String? verificationHash;

  const MigrationResult({
    required this.isSuccess,
    this.alreadyMigrated = false,
    this.migratedDailyRecords = 0,
    this.migratedRoutes = 0,
    this.errorMessage,
    this.verificationHash,
  });

  factory MigrationResult.alreadyCompleted() => const MigrationResult(
        isSuccess: true,
        alreadyMigrated: true,
      );

  factory MigrationResult.success({
    required int dailyCount,
    required int routeCount,
    required String hash,
  }) =>
      MigrationResult(
        isSuccess: true,
        migratedDailyRecords: dailyCount,
        migratedRoutes: routeCount,
        verificationHash: hash,
      );

  factory MigrationResult.failure(String message) => MigrationResult(
        isSuccess: false,
        errorMessage: message,
      );
}

class DatabaseMigrationService {
  static const String migrationKeyV1 = 'shared_preferences_to_drift_v1';

  /// Performs a safe, non-destructive, one-time migration of existing
  /// SharedPreferences step history and routes into the local Drift database.
  ///
  /// CRITICAL GUARANTEES:
  /// 1. Original SharedPreferences data is NEVER deleted or modified.
  /// 2. Every migrated record is verified against original data before marking complete.
  /// 3. If migration was already completed, it cleanly short-circuits.
  static Future<MigrationResult> migrateFromSharedPreferences({
    required StorageService storageService,
    required ActivityRepository activityRepository,
  }) async {
    try {
      // 1. Check if migration was already executed and verified
      final isCompleted = await activityRepository.isMigrationCompleted(migrationKeyV1);
      if (isCompleted) {
        debugPrint('DatabaseMigrationService: Migration already completed previously. Skipping.');
        return MigrationResult.alreadyCompleted();
      }

      debugPrint('DatabaseMigrationService: Starting safe one-time migration into Drift...');

      // 2. Read existing data from SharedPreferences (Read-only)
      final stepHistory = storageService.getStepHistory();
      final savedRoutesRaw = storageService.getSavedRoutes();
      final goalSteps = storageService.goalSteps;
      final userHeight = storageService.userHeight;
      final userWeight = storageService.userWeight;

      final strideLengthMeters = (userHeight * 0.414) / 100.0;
      final calorieFactor = (userWeight / 70.0).clamp(0.7, 1.5);

      int dailyRecordsMigrated = 0;
      int routesMigrated = 0;

      // 3. Migrate Daily Activity History
      for (final entry in stepHistory.entries) {
        final dateKey = entry.key; // "YYYY-MM-DD"
        final steps = entry.value;

        final distanceKm = (steps * strideLengthMeters) / 1000.0;
        final calories = (steps * 0.042 * calorieFactor).round();
        final activeMinutes = (steps / 100).round();

        await activityRepository.saveDailyActivity(
          date: dateKey,
          steps: steps,
          distanceKm: distanceKm,
          calories: calories,
          activeMinutes: activeMinutes,
          goalSteps: goalSteps,
        );
        dailyRecordsMigrated++;
      }

      // 4. Migrate Saved Routes
      for (final rawRoute in savedRoutesRaw) {
        try {
          final routeModel = SavedRouteModel.fromJson(rawRoute);
          await activityRepository.saveRoute(routeModel);
          routesMigrated++;
        } catch (e) {
          debugPrint('DatabaseMigrationService: Error migrating individual route: $e');
        }
      }

      // 5. Verification Phase: Verify migrated records against source data
      debugPrint('DatabaseMigrationService: Verifying migrated records against original data...');

      for (final entry in stepHistory.entries) {
        final dateKey = entry.key;
        final expectedSteps = entry.value;

        final record = await activityRepository.getDailyActivity(dateKey);
        if (record == null) {
          return MigrationResult.failure('Verification failed: Date $dateKey not found in Drift database.');
        }
        if (record.steps != expectedSteps) {
          return MigrationResult.failure(
            'Verification failed: Step count mismatch on $dateKey (Expected $expectedSteps, got ${record.steps}).',
          );
        }
      }

      if (savedRoutesRaw.isNotEmpty) {
        final driftRoutes = await activityRepository.getAllRoutes();
        final driftRouteIds = driftRoutes.map((r) => r.id).toSet();

        for (final rawRoute in savedRoutesRaw) {
          final id = rawRoute['id']?.toString();
          if (id != null && !driftRouteIds.contains(id)) {
            return MigrationResult.failure('Verification failed: Route id $id not found in Drift database.');
          }
        }
      }

      // 6. Generate Verification Checksum Hash
      final summaryString = 'daily:$dailyRecordsMigrated;routes:$routesMigrated;ts:${DateTime.now().toIso8601String()}';
      final verificationHash = sha256.convert(utf8.encode(summaryString)).toString();

      // 7. Mark Migration as Completed in MigrationMetadata table
      await activityRepository.markMigrationCompleted(
        migrationKey: migrationKeyV1,
        recordsCount: dailyRecordsMigrated + routesMigrated,
        verificationHash: verificationHash,
      );

      debugPrint(
        'DatabaseMigrationService: Migration successfully completed and verified! '
        'Daily: $dailyRecordsMigrated, Routes: $routesMigrated, Hash: $verificationHash',
      );

      // SharedPreferences is completely untouched and intact as per requirements.
      return MigrationResult.success(
        dailyCount: dailyRecordsMigrated,
        routeCount: routesMigrated,
        hash: verificationHash,
      );
    } catch (e, stack) {
      debugPrint('DatabaseMigrationService: Critical failure during migration: $e\n$stack');
      return MigrationResult.failure('Migration exception: $e');
    }
  }
}
