import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/services/backup_service.dart';
import 'package:yhealth/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Backup round-trips database rows and preferences', () async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Yusif',
      'user_height': 180.0,
      'goal_steps': 12000,
      'theme_mode': 'dark',
      'current_user_id': 'local_user',
    });
    final sourceDb = AppDatabase.forTesting(NativeDatabase.memory());
    final sourceStorage = await StorageService.init();
    await DriftActivityRepository(sourceDb).saveDailyActivity(
      date: '2026-11-20',
      steps: 9876,
      distanceKm: 7.1,
      calories: 400,
      activeMinutes: 90,
      goalSteps: 12000,
    );

    final backup = await BackupService(sourceDb, sourceStorage).buildBackup();
    final encoded = jsonDecode(jsonEncode(backup)) as Map<String, dynamic>;
    await sourceDb.close();

    SharedPreferences.setMockInitialValues({});
    final targetDb = AppDatabase.forTesting(NativeDatabase.memory());
    final targetStorage = await StorageService.init();
    final targetRepo = DriftActivityRepository(targetDb);
    await targetRepo.saveDailyActivity(
      date: '2026-01-01',
      steps: 1,
      distanceKm: 0,
      calories: 0,
      activeMinutes: 0,
      goalSteps: 8000,
    );

    await BackupService(targetDb, targetStorage).restoreBackup(encoded);

    expect(await targetRepo.getDailyActivitiesCount(), 1);
    final restored = await targetRepo.getDailyActivity('2026-11-20');
    expect(restored!.steps, 9876);
    expect(restored.distanceKm, closeTo(7.1, 0.0001));
    expect(targetStorage.userName, 'Yusif');
    expect(targetStorage.userHeight, 180.0);
    expect(targetStorage.goalSteps, 12000);
    expect(targetStorage.themeMode, 'dark');
    expect(targetStorage.currentUserId, isNull);
    await targetDb.close();
  });

  test('Restore rejects files that are not YHealth backups', () async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final storage = await StorageService.init();
    final service = BackupService(db, storage);

    await expectLater(
      () => service.restoreBackup({'format': 'something-else'}),
      throwsA(isA<BackupException>().having((e) => e.code, 'code', 'invalid_file')),
    );
    await expectLater(
      () => service.restoreBackup({'format': BackupService.format, 'formatVersion': 99, 'tables': {}}),
      throwsA(isA<BackupException>().having((e) => e.code, 'code', 'unsupported_version')),
    );
    await db.close();
  });
}
