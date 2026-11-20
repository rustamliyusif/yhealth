import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/models/sleep_record_model.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/providers/sleep_provider.dart';
import 'package:yhealth/core/services/health_connect_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftActivityRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftActivityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 3 - Overnight Sleep Duration & Modeling', () {
    test('Overnight sleep session duration calculated accurately across midnight boundary', () {
      final bedtime = DateTime(2026, 11, 6, 23, 15);
      final wakeTime = DateTime(2026, 11, 7, 7, 30);

      final record = SleepRecordModel(
        id: 'test_sleep_1',
        date: '2026-11-07',
        bedtime: bedtime,
        wakeTime: wakeTime,
        durationMinutes: wakeTime.difference(bedtime).inMinutes,
      );

      expect(record.isOvernight, isTrue);
      expect(record.durationMinutes, equals(495)); // 8 hours and 15 minutes
      expect(record.formattedDuration, equals('8h 15m'));
      expect(record.durationHours, closeTo(8.25, 0.01));
    });

    test('Same-day daytime nap session calculates duration accurately', () {
      final bedtime = DateTime(2026, 11, 7, 14, 0);
      final wakeTime = DateTime(2026, 11, 7, 15, 30);

      final record = SleepRecordModel(
        id: 'test_nap_1',
        date: '2026-11-07',
        bedtime: bedtime,
        wakeTime: wakeTime,
        durationMinutes: wakeTime.difference(bedtime).inMinutes,
      );

      expect(record.isOvernight, isFalse);
      expect(record.durationMinutes, equals(90));
      expect(record.formattedDuration, equals('1h 30m'));
    });
  });

  group('Phase 3 - Drift Persistence, Overlap & Duplicate Prevention', () {
    test('Sleep record is properly saved, queried, and retrieved from Drift', () async {
      final record = SleepRecordModel(
        id: 'sleep_001',
        date: '2026-11-07',
        bedtime: DateTime(2026, 11, 6, 23, 0),
        wakeTime: DateTime(2026, 11, 7, 7, 0),
        durationMinutes: 480,
        source: 'manual',
        efficiencyPercent: 90,
        notes: 'Restful night without interruptions',
      );

      await repository.saveSleepRecord(record);
      expect(await repository.getSleepRecordsCount(), equals(1));

      final retrieved = await repository.getSleepRecordById('sleep_001');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals('sleep_001'));
      expect(retrieved.date, equals('2026-11-07'));
      expect(retrieved.durationMinutes, equals(480));
      expect(retrieved.efficiencyPercent, equals(90));
      expect(retrieved.notes, equals('Restful night without interruptions'));
      expect(retrieved.hasStages, isFalse); // Ordinary manual entry has no stages
    });

    test('Detects overlapping sessions to prevent duplicate sleep records', () async {
      // Existing record: 23:00 to 07:00
      final existing = SleepRecordModel(
        id: 'sleep_existing',
        date: '2026-11-07',
        bedtime: DateTime(2026, 11, 6, 23, 0),
        wakeTime: DateTime(2026, 11, 7, 7, 0),
        durationMinutes: 480,
      );
      await repository.saveSleepRecord(existing);

      // 1. Fully overlapping attempt: 23:30 to 06:30
      final overlaps1 = await repository.getOverlappingSleepRecords(
        bedtime: DateTime(2026, 11, 6, 23, 30),
        wakeTime: DateTime(2026, 11, 7, 6, 30),
      );
      expect(overlaps1.length, equals(1));

      // 2. Partial overlap crossing wake-up time: 06:00 to 08:30
      final overlaps2 = await repository.getOverlappingSleepRecords(
        bedtime: DateTime(2026, 11, 7, 6, 0),
        wakeTime: DateTime(2026, 11, 7, 8, 30),
      );
      expect(overlaps2.length, equals(1));

      // 3. Non-overlapping afternoon session: 14:00 to 15:00
      final overlaps3 = await repository.getOverlappingSleepRecords(
        bedtime: DateTime(2026, 11, 7, 14, 0),
        wakeTime: DateTime(2026, 11, 7, 15, 0),
      );
      expect(overlaps3.isEmpty, isTrue);
    });

    test('Editing and deleting sleep records operates reliably', () async {
      final initial = SleepRecordModel(
        id: 'sleep_to_edit',
        date: '2026-11-07',
        bedtime: DateTime(2026, 11, 6, 23, 0),
        wakeTime: DateTime(2026, 11, 7, 7, 0),
        durationMinutes: 480,
        efficiencyPercent: 80,
      );
      await repository.saveSleepRecord(initial);

      // Edit efficiency and notes
      final updated = initial.copyWith(
        efficiencyPercent: 92,
        notes: 'Updated notes after morning review',
      );
      await repository.saveSleepRecord(updated);

      final retrieved = await repository.getSleepRecordById('sleep_to_edit');
      expect(retrieved!.efficiencyPercent, equals(92));
      expect(retrieved.notes, equals('Updated notes after morning review'));
      expect(await repository.getSleepRecordsCount(), equals(1));

      // Delete
      await repository.deleteSleepRecord('sleep_to_edit');
      expect(await repository.getSleepRecordsCount(), equals(0));
    });
  });

  group('Phase 3 - Sleep Stages Genuineness Verification', () {
    test('Never fabricates sleep stages for ordinary manual or phone entries', () async {
      final manualRecord = SleepRecordModel(
        id: 'manual_sleep',
        date: '2026-11-07',
        bedtime: DateTime(2026, 11, 6, 23, 0),
        wakeTime: DateTime(2026, 11, 7, 7, 0),
        durationMinutes: 480,
        source: 'manual',
        hasStages: false,
      );

      await repository.saveSleepRecord(manualRecord);
      final entry = await repository.getSleepRecordById('manual_sleep');

      expect(entry!.hasStages, isFalse);
      expect(entry.lightSleepMinutes, isNull);
      expect(entry.deepSleepMinutes, isNull);
      expect(entry.remSleepMinutes, isNull);
      expect(entry.awakeMinutes, isNull);
    });

    test('Preserves genuine wearable sleep stages when imported from Health Connect', () async {
      final wearableRecord = SleepRecordModel(
        id: 'health_connect_sleep',
        date: '2026-11-07',
        bedtime: DateTime(2026, 11, 6, 23, 0),
        wakeTime: DateTime(2026, 11, 7, 7, 30),
        durationMinutes: 510,
        source: 'health_connect',
        hasStages: true,
        lightSleepMinutes: 240,
        deepSleepMinutes: 110,
        remSleepMinutes: 120,
        awakeMinutes: 40,
      );

      await repository.saveSleepRecord(wearableRecord);
      final entry = await repository.getSleepRecordById('health_connect_sleep');

      expect(entry!.hasStages, isTrue);
      expect(entry.source, equals('health_connect'));
      expect(entry.lightSleepMinutes, equals(240));
      expect(entry.deepSleepMinutes, equals(110));
      expect(entry.remSleepMinutes, equals(120));
      expect(entry.awakeMinutes, equals(40));
    });
  });

  group('Phase 3 - Bedtime Consistency & Provider Behavior', () {
    test('SleepProvider calculates consistency correctly from records', () async {
      final provider = SleepProvider(repository);

      // Add 4 consistent nights around 23:00 (±10 minutes)
      await provider.addSleepRecord(
        bedtime: DateTime(2026, 11, 3, 23, 5),
        wakeTime: DateTime(2026, 11, 4, 7, 0),
        referenceDate: '2026-11-04',
      );
      await provider.addSleepRecord(
        bedtime: DateTime(2026, 11, 4, 23, 0),
        wakeTime: DateTime(2026, 11, 5, 7, 0),
        referenceDate: '2026-11-05',
      );
      await provider.addSleepRecord(
        bedtime: DateTime(2026, 11, 5, 23, 10),
        wakeTime: DateTime(2026, 11, 6, 7, 0),
        referenceDate: '2026-11-06',
      );
      await provider.addSleepRecord(
        bedtime: DateTime(2026, 11, 6, 22, 55),
        wakeTime: DateTime(2026, 11, 7, 7, 0),
        referenceDate: '2026-11-07',
      );

      expect(provider.records.length, equals(4));
      expect(provider.averageDurationHours, closeTo(8.0, 0.2));
      expect(provider.bedtimeConsistencyDescription.contains('High Consistency'), isTrue);
    });

    test('Health Connect fallback behaves gracefully without crashing when unavailable', () async {
      final service = HealthConnectService();
      // On desktop test environment without Android runtime, checkAvailability returns unsupported gracefully
      final status = await service.checkAvailability();
      expect(status, isNotNull);

      final sessions = await service.fetchSleepSessions(
        startTime: DateTime.now().subtract(const Duration(days: 7)),
        endTime: DateTime.now(),
      );
      expect(sessions, isEmpty);
    });
  });
}
