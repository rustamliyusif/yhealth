import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:yhealth/core/database/app_database.dart';
import 'package:yhealth/core/models/weight_record_model.dart';
import 'package:yhealth/core/models/coach_message_model.dart';
import 'package:yhealth/core/models/weekly_report_model.dart';
import 'package:yhealth/core/repositories/activity_repository.dart';
import 'package:yhealth/core/services/weight_coach_engine.dart';

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

  group('Phase 5 - Metabolic Calculations (BMR, TDEE, Safe Deficits)', () {
    test('Calculates BMR accurately using Mifflin-St Jeor equation', () {
      // 75 kg, 180 cm, 30 years old, male:
      // BMR = 10(75) + 6.25(180) - 5(30) + 5 = 750 + 1125 - 150 + 5 = 1730 kcal
      final bmrMale = WeightCoachEngine.calculateBmr(
        weightKg: 75.0,
        heightCm: 180.0,
        ageYears: 30,
        isMale: true,
      );
      expect(bmrMale, equals(1730));

      // 60 kg, 165 cm, 28 years old, female:
      // BMR = 10(60) + 6.25(165) - 5(28) - 161 = 600 + 1031.25 - 140 - 161 = 1330.25 -> 1330 kcal
      final bmrFemale = WeightCoachEngine.calculateBmr(
        weightKg: 60.0,
        heightCm: 165.0,
        ageYears: 28,
        isMale: false,
      );
      expect(bmrFemale, equals(1330));
    });

    test('Calculates TDEE using standard activity multipliers', () {
      const bmr = 1700;
      expect(WeightCoachEngine.calculateTdee(bmr, ActivityLevel.sedentary), equals((1700 * 1.2).round()));
      expect(WeightCoachEngine.calculateTdee(bmr, ActivityLevel.lightlyActive), equals((1700 * 1.375).round()));
      expect(WeightCoachEngine.calculateTdee(bmr, ActivityLevel.moderatelyActive), equals((1700 * 1.55).round()));
      expect(WeightCoachEngine.calculateTdee(bmr, ActivityLevel.veryActive), equals((1700 * 1.725).round()));
    });

    test('Enforces safe calorie floor preventing extreme deficits', () {
      // Low weight/low expenditure scenario where deficit would drop below 1300 kcal
      final analysis = WeightCoachEngine.analyzeProfile(
        currentWeight: 52.0,
        targetWeight: 48.0,
        heightCm: 155.0,
        age: 35,
        activityLevel: ActivityLevel.sedentary,
      );

      // Must never recommend intake below the 1300 kcal metabolic safety floor
      expect(analysis.targetDailyKcal, greaterThanOrEqualTo(1300));
      expect(analysis.recommendedWeeklyChangeKg, equals(0.5));
    });

    test('Estimates realistic and gradual weight management timeline', () {
      // 80 kg -> 70 kg (10 kg difference)
      // At safe pace of 0.5 kg/week -> 10 / 0.5 = 20 weeks
      final analysis = WeightCoachEngine.analyzeProfile(
        currentWeight: 80.0,
        targetWeight: 70.0,
        heightCm: 175.0,
        age: 30,
        activityLevel: ActivityLevel.moderatelyActive,
      );

      expect(analysis.goalType, equals(WeightGoalType.loss));
      expect(analysis.weightDifference, equals(10.0));
      expect(analysis.estimatedWeeksToGoal, equals(20));
      expect(analysis.recommendedWeeklyChangeKg, equals(0.5));
    });
  });

  group('Phase 5 - BMI & Clinical Limitation Explanations', () {
    test('Calculates BMI accurately and categorizes boundaries', () {
      expect(WeightCoachEngine.calculateBmi(50.0, 175.0), closeTo(16.33, 0.01)); // Underweight
      expect(WeightCoachEngine.getBmiCategory(16.33), equals('underweight'));

      expect(WeightCoachEngine.calculateBmi(68.0, 175.0), closeTo(22.20, 0.01)); // Normal
      expect(WeightCoachEngine.getBmiCategory(22.20), equals('normal'));

      expect(WeightCoachEngine.calculateBmi(82.0, 175.0), closeTo(26.78, 0.01)); // Overweight
      expect(WeightCoachEngine.getBmiCategory(26.78), equals('overweight'));

      expect(WeightCoachEngine.calculateBmi(98.0, 175.0), closeTo(32.00, 0.01)); // Obese
      expect(WeightCoachEngine.getBmiCategory(32.00), equals('obese'));
    });

    test('Explains BMI clinical limitations in responses', () {
      final analysis = WeightCoachEngine.analyzeProfile(
        currentWeight: 75.0,
        targetWeight: 70.0,
        heightCm: 175.0,
        age: 28,
      );

      final replyEn = WeightCoachEngine.processQuery(
        query: 'Explain my BMI',
        analysis: analysis,
        isAzerbaijani: false,
      );

      expect(replyEn, contains('Limitations'));
      expect(replyEn, contains('lean skeletal muscle mass'));

      final replyAz = WeightCoachEngine.processQuery(
        query: 'BMI göstəricimi izah et',
        analysis: analysis,
        isAzerbaijani: true,
      );

      expect(replyAz, contains('Məhdudiyyətləri'));
      expect(replyAz, contains('əzələ kütləsi'));
    });
  });

  group('Phase 5 - Hydration & Contextual Insights', () {
    test('Calculates hydration based on weight and activity level', () {
      // 70 kg baseline: 70 * 33 / 1000 = 2.31 L
      final baselineHydration = WeightCoachEngine.calculateDailyHydrationLiters(70.0, steps: 4000);
      expect(baselineHydration, equals(2.31));

      // With high daily activity (> 8,000 steps), adds fluid replenishment (+0.4 L)
      final activeHydration = WeightCoachEngine.calculateDailyHydrationLiters(70.0, steps: 10000);
      expect(activeHydration, equals(2.71));
    });

    test('Adjusts recommendations using actual weekly activity and sleep data', () {
      final weeklyReport = WeeklyReportModel(
        id: 'report_2026_W45',
        startDate: '2026-11-02',
        endDate: '2026-11-08',
        year: 2026,
        weekNumber: 45,
        generatedAt: DateTime.now(),
        totalSteps: 35000,
        totalDistanceKm: 24.5,
        totalCalories: 1750,
        totalActiveMinutes: 240,
        totalSleepMinutes: 2400, // Avg 342 mins (~5.7 hours/night - short sleep!)
        avgDailySteps: 5000,
        avgDailyDistanceKm: 3.5,
        avgDailyCalories: 250,
        avgDailySleepMinutes: 342,
        goalMetDays: 3,
        mostActiveDayDate: '2026-11-04',
        mostActiveDaySteps: 8000,
        recordedDaysCount: 7,
        dailyBreakdowns: [],
      );

      final analysis = WeightCoachEngine.analyzeProfile(
        currentWeight: 78.0,
        targetWeight: 70.0,
        heightCm: 175.0,
        age: 30,
        latestWeeklyReport: weeklyReport,
      );

      // Recommendations should advise boosting daily steps from baseline 5,000
      expect(analysis.recommendedDailySteps, equals(6500));
      // Actionable advice should flag inadequate sleep (< 7h) and appetite hormones
      expect(analysis.actionableAdvice.any((a) => a.contains('sleep') || a.contains('yuxu')), isTrue);
    });
  });

  group('Phase 5 - Drift SQLite Persistence, Editing & Deletion', () {
    test('Persists, retrieves, and deletes weight records from Drift with confirmation', () async {
      final record1 = WeightRecordModel(
        id: 'w_1',
        date: '2026-11-01',
        weightKg: 78.5,
        bmi: 25.6,
        notes: 'Initial test weigh-in',
        createdAt: DateTime(2026, 11, 1, 8, 0),
      );
      final record2 = WeightRecordModel(
        id: 'w_2',
        date: '2026-11-08',
        weightKg: 77.8,
        bmi: 25.4,
        notes: 'Week 1 progress check',
        createdAt: DateTime(2026, 11, 8, 8, 0),
      );

      await repository.saveWeightRecord(record1);
      await repository.saveWeightRecord(record2);

      // Retrieve all records
      final records = await repository.getAllWeightRecords();
      expect(records.length, equals(2));

      // Retrieve latest record
      final latest = await repository.getLatestWeightRecord();
      expect(latest, isNotNull);
      expect(latest!.weightKg, equals(77.8));

      // Delete record with confirmation
      await repository.deleteWeightRecord('w_1');
      final updatedRecords = await repository.getAllWeightRecords();
      expect(updatedRecords.length, equals(1));
      expect(updatedRecords.first.id, equals('w_2'));
    });

    test('Persists and retrieves coach conversational messages in Drift', () async {
      final userMsg = CoachMessageModel(
        id: 'msg_1',
        sender: 'user',
        content: 'How much water should I drink?',
        timestamp: DateTime(2026, 11, 8, 10, 0),
      );
      final coachMsg = CoachMessageModel(
        id: 'msg_2',
        sender: 'coach',
        content: 'Based on your weight, aim for 2.4 liters daily.',
        timestamp: DateTime(2026, 11, 8, 10, 1),
      );

      await repository.saveCoachMessage(userMsg);
      await repository.saveCoachMessage(coachMsg);

      final messages = await repository.getAllCoachMessages();
      expect(messages.length, equals(2));
      expect(messages[0].isUser, isTrue);
      expect(messages[1].isCoach, isTrue);

      // Clear history
      await repository.clearCoachMessages();
      final count = await repository.getCoachMessagesCount();
      expect(count, equals(0));
    });
  });

  group('Phase 5 - Conversational Engine & Offline Verification', () {
    test('Answers common weight questions accurately in Azerbaijani and English', () {
      final analysis = WeightCoachEngine.analyzeProfile(
        currentWeight: 72.0,
        targetWeight: 65.0,
        heightCm: 172.0,
        age: 29,
      );

      // English
      final nutritionEn = WeightCoachEngine.processQuery(
        query: 'Nutrition guidance',
        analysis: analysis,
        isAzerbaijani: false,
      );
      expect(nutritionEn, contains('Plate Composition'));
      expect(nutritionEn, contains('never recommends crash diets'));

      final waterEn = WeightCoachEngine.processQuery(
        query: 'How much water should I drink?',
        analysis: analysis,
        isAzerbaijani: false,
      );
      expect(waterEn, contains('Hydration Guidance'));

      // Azerbaijani
      final nutritionAz = WeightCoachEngine.processQuery(
        query: 'Qidalanma tövsiyələri',
        analysis: analysis,
        isAzerbaijani: true,
      );
      expect(nutritionAz, contains('Balanslı Qidalanma'));
      expect(nutritionAz, contains('Boşqab Qaydası'));

      final waterAz = WeightCoachEngine.processQuery(
        query: 'Nə qədər su içməliyəm?',
        analysis: analysis,
        isAzerbaijani: true,
      );
      expect(waterAz, contains('Su Qəbulu'));
    });
  });
}
