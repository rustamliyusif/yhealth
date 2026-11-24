import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/models/sleep_record_model.dart';
import 'package:yhealth/core/models/weight_record_model.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/services/csv_export_service.dart';
import 'package:yhealth/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CSV export merges steps, sleep, weight and water into one row per day', () async {
    SharedPreferences.setMockInitialValues({
      'goal_steps': 8000,
      'user_height': 175.0,
      'user_weight': 70.0,
      'water_log': '{"2026-11-22":1500,"2026-11-24":750}',
    });
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final storage = await StorageService.init();
    final repo = DriftActivityRepository(db);

    await repo.saveDailyActivity(
      date: '2026-11-22',
      steps: 9000,
      distanceKm: 6.5,
      calories: 380,
      activeMinutes: 90,
      goalSteps: 8000,
    );
    await repo.saveSleepRecord(SleepRecordModel(
      id: 's1',
      date: '2026-11-23',
      bedtime: DateTime(2026, 11, 22, 23, 30),
      wakeTime: DateTime(2026, 11, 23, 7, 0),
      durationMinutes: 450,
    ));
    await repo.saveWeightRecord(WeightRecordModel(
      id: 'w1',
      date: '2026-11-23',
      weightKg: 72.4,
      bmi: 23.6,
      createdAt: DateTime(2026, 11, 23, 8),
    ));

    final csv = await CsvExportService(db, storage).buildCsv(
      liveStepHistory: {'2026-11-23': 4000},
      todayKey: '2026-11-24',
      todaySteps: 5000,
    );
    await db.close();

    final lines = csv.trim().split('\n');
    expect(lines.first, CsvExportService.header.join(','));
    expect(lines.length, 4);
    expect(lines[1], '2026-11-22,9000,8000,1,6.50,380,90,,,,,,,1500');
    expect(lines[2], startsWith('2026-11-23,4000,8000,0,'));
    expect(lines[2], endsWith(',450,7.50,23:30,07:00,72.4,23.6,'));
    expect(lines[3], startsWith('2026-11-24,5000,8000,0,'));
    expect(lines[3], endsWith(',750'));
  });
}
