import 'dart:math';
import '../models/weight_record_model.dart';
import '../models/weekly_report_model.dart';
import 'coach_brain.dart';

export 'coach_brain.dart' show CoachBrain, CoachContext, CoachIntent, CoachReply;

/// Activity level enumeration for energy expenditure calculation.
enum ActivityLevel {
  sedentary, // Little or no exercise (desk job)
  lightlyActive, // Light exercise/sports 1-3 days/week (~5,000-7,500 steps)
  moderatelyActive, // Moderate exercise 3-5 days/week (~7,500-10,000 steps)
  veryActive, // Hard exercise 6-7 days/week (> 10,000 steps)
}

/// Dietary preference options.
enum DietaryPreference {
  balanced,
  mediterranean,
  lowCarb,
  vegetarian,
  vegan,
  highProtein,
}

/// Weight management goal category.
enum WeightGoalType {
  loss,
  maintenance,
  gain,
}

/// Structured response from the AI Weight Coach.
class CoachAnalysisResult {
  final double currentWeight;
  final double targetWeight;
  final double weightDifference;
  final WeightGoalType goalType;
  final double bmi;
  final String bmiCategory;
  final double minHealthyWeight;
  final double maxHealthyWeight;
  final int bmrKcal;
  final int tdeeKcal;
  final int targetDailyKcal;
  final double recommendedWeeklyChangeKg;
  final int estimatedWeeksToGoal;
  final double dailyHydrationLiters;
  final int recommendedDailySteps;
  final String progressTrend; // 'losing', 'gaining', 'maintaining', 'plateau', 'initial'
  final String summaryText;
  final List<String> actionableAdvice;

  CoachAnalysisResult({
    required this.currentWeight,
    required this.targetWeight,
    required this.weightDifference,
    required this.goalType,
    required this.bmi,
    required this.bmiCategory,
    required this.minHealthyWeight,
    required this.maxHealthyWeight,
    required this.bmrKcal,
    required this.tdeeKcal,
    required this.targetDailyKcal,
    required this.recommendedWeeklyChangeKg,
    required this.estimatedWeeksToGoal,
    required this.dailyHydrationLiters,
    required this.recommendedDailySteps,
    required this.progressTrend,
    required this.summaryText,
    required this.actionableAdvice,
  });
}

/// Offline rule-based intelligence engine powering the YHealth AI Weight Coach.
/// Performs clinically sound metabolic calculations, safe pacing estimations,
/// and contextual health advice without internet connectivity.
class WeightCoachEngine {
  /// Calculates Basal Metabolic Rate using the Mifflin-St Jeor equation.
  static int calculateBmr({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    bool isMale = true,
  }) {
    if (weightKg <= 0 || heightCm <= 0 || ageYears <= 0) return 1500;
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears);
    final bmr = isMale ? (base + 5) : (base - 161);
    return bmr.round().clamp(900, 3500);
  }

  /// Calculates Total Daily Energy Expenditure based on activity multiplier.
  static int calculateTdee(int bmr, ActivityLevel level) {
    double multiplier;
    switch (level) {
      case ActivityLevel.sedentary:
        multiplier = 1.2;
        break;
      case ActivityLevel.lightlyActive:
        multiplier = 1.375;
        break;
      case ActivityLevel.moderatelyActive:
        multiplier = 1.55;
        break;
      case ActivityLevel.veryActive:
        multiplier = 1.725;
        break;
    }
    return (bmr * multiplier).round();
  }

  /// Calculates Body Mass Index.
  static double calculateBmi(double weightKg, double heightCm) {
    if (heightCm <= 0) return 0.0;
    final h = heightCm / 100.0;
    return weightKg / (h * h);
  }

  /// Classifies BMI into standard clinical categories.
  static String getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25.0) return 'normal';
    if (bmi < 30.0) return 'overweight';
    return 'obese';
  }

  /// Calculates recommended hydration volume (32-35 ml per kg body weight).
  static double calculateDailyHydrationLiters(double weightKg, {int steps = 0}) {
    if (weightKg <= 0) return 2.0;
    double liters = (weightKg * 33.0) / 1000.0;
    if (steps > 8000) {
      liters += 0.4; // Activity water replacement
    }
    return double.parse(liters.toStringAsFixed(2)).clamp(1.5, 4.5);
  }

  /// Analyzes historical weight measurements to determine recent trajectory.
  static String analyzeProgressTrend(List<WeightRecordModel> history) {
    if (history.length < 2) return 'initial';

    // Sort chronologically (oldest first)
    final sorted = List<WeightRecordModel>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    final oldest = sorted.first;
    final latest = sorted.last;
    final diff = latest.weightKg - oldest.weightKg;

    if (history.length >= 4) {
      // Check for plateau (weight fluctuation < 0.3 kg across last 3 records)
      final recentRecords = sorted.sublist(sorted.length - 3);
      final maxW = recentRecords.map((r) => r.weightKg).reduce(max);
      final minW = recentRecords.map((r) => r.weightKg).reduce(min);
      if ((maxW - minW) < 0.3) {
        return 'plateau';
      }
    }

    if (diff < -0.3) return 'losing';
    if (diff > 0.3) return 'gaining';
    return 'maintaining';
  }

  /// Performs full comprehensive weight management analysis.
  static CoachAnalysisResult analyzeProfile({
    required double currentWeight,
    required double targetWeight,
    required double heightCm,
    required int age,
    ActivityLevel activityLevel = ActivityLevel.moderatelyActive,
    DietaryPreference dietaryPreference = DietaryPreference.balanced,
    List<WeightRecordModel> weightHistory = const [],
    WeeklyReportModel? latestWeeklyReport,
    bool isAzerbaijani = false,
  }) {
    final hInM = heightCm / 100.0;
    final minHealthy = 18.5 * (hInM * hInM);
    final maxHealthy = 24.9 * (hInM * hInM);
    final bmi = calculateBmi(currentWeight, heightCm);
    final bmiCat = getBmiCategory(bmi);

    final diff = currentWeight - targetWeight;
    WeightGoalType goalType;
    if (diff.abs() < 0.5) {
      goalType = WeightGoalType.maintenance;
    } else if (diff > 0) {
      goalType = WeightGoalType.loss;
    } else {
      goalType = WeightGoalType.gain;
    }

    final bmr = calculateBmr(
      weightKg: currentWeight,
      heightCm: heightCm,
      ageYears: age,
    );
    final tdee = calculateTdee(bmr, activityLevel);

    // Safe pacing rules:
    // Safe loss: 0.4 - 0.5 kg/week (approx 400-500 kcal deficit)
    // Absolute safety floor: never drop below 1300 kcal
    double weeklyChangeRateKg;
    int targetDailyKcal;
    int estimatedWeeks;

    if (goalType == WeightGoalType.loss) {
      weeklyChangeRateKg = 0.5;
      final proposedDeficit = 450;
      targetDailyKcal = max(1300, tdee - proposedDeficit);
      estimatedWeeks = (diff / weeklyChangeRateKg).ceil().clamp(1, 104);
    } else if (goalType == WeightGoalType.gain) {
      weeklyChangeRateKg = 0.3;
      final surplus = 300;
      targetDailyKcal = tdee + surplus;
      estimatedWeeks = ((-diff) / weeklyChangeRateKg).ceil().clamp(1, 104);
    } else {
      weeklyChangeRateKg = 0.0;
      targetDailyKcal = tdee;
      estimatedWeeks = 0;
    }

    // Step recommendations tailored to current baseline
    int targetSteps = 8000;
    if (latestWeeklyReport != null && latestWeeklyReport.avgDailySteps > 0) {
      final currentAvg = latestWeeklyReport.avgDailySteps;
      if (goalType == WeightGoalType.loss) {
        targetSteps = (currentAvg + 1500).clamp(6000, 12000);
      } else {
        targetSteps = currentAvg.clamp(7000, 10000);
      }
    }

    final hydrationLiters = calculateDailyHydrationLiters(currentWeight, steps: targetSteps);
    final trend = analyzeProgressTrend(weightHistory);

    // Build personalized advice
    final advice = <String>[];
    if (goalType == WeightGoalType.loss) {
      advice.add(
        isAzerbaijani
            ? 'Gündəlik $targetDailyKcal kcal kalori hədəfi seçin (təhlükəsiz və dayanıqlı kəsir).'
            : 'Aim for ~$targetDailyKcal kcal/day for a safe, metabolism-protective deficit.',
      );
      advice.add(
        isAzerbaijani
            ? 'Gündə təxminən $targetSteps addım ataraq aktiv enerjinizi artırın.'
            : 'Aim for ~$targetSteps daily steps to support cardiovascular health and energy output.',
      );
    } else if (goalType == WeightGoalType.gain) {
      advice.add(
        isAzerbaijani
            ? 'Hər gün təxminən $targetDailyKcal kcal qidalanaraq sağlam əzələ kütləsi qazanın.'
            : 'Consume ~$targetDailyKcal kcal/day focusing on protein-dense whole foods and strength training.',
      );
    } else {
      advice.add(
        isAzerbaijani
            ? 'Çəkinizi qorumaq üçün gündəlik $targetDailyKcal kcal səviyyəsində balanslı qidalanın.'
            : 'Maintain balance at ~$targetDailyKcal kcal/day to support consistent energy and weight stability.',
      );
    }

    advice.add(
      isAzerbaijani
          ? 'Gündəlik ${hydrationLiters}L su için. Düzgün hidratasiya maddələr mübadiləsini tənzimləyir.'
          : 'Drink ~${hydrationLiters}L water daily. Hydration aids cellular metabolism and appetite regulation.',
    );

    if (latestWeeklyReport != null && latestWeeklyReport.avgDailySleepMinutes < 420) {
      advice.add(
        isAzerbaijani
            ? 'Yuxu rejiminiz orta hesabla 7 saatdan azdır. Yetersiz yuxu iştah hormonlarını (qrelin) artırır.'
            : 'Your weekly sleep averages under 7h. Prioritize rest—sleep deficit elevates hunger hormones.',
      );
    }

    final summary = isAzerbaijani
        ? 'Cari çəkiniz: ${currentWeight}kg, Hədəf: ${targetWeight}kg. Təhlükəsiz tempdə (~${weeklyChangeRateKg}kg/həftə) hədəfinizə təxminən $estimatedWeeks həftəyə çata bilərsiniz.'
        : 'Current: ${currentWeight}kg, Goal: ${targetWeight}kg. At a safe pace of ~${weeklyChangeRateKg}kg/week, your target is achievable in approximately $estimatedWeeks weeks.';

    return CoachAnalysisResult(
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      weightDifference: diff,
      goalType: goalType,
      bmi: bmi,
      bmiCategory: bmiCat,
      minHealthyWeight: minHealthy,
      maxHealthyWeight: maxHealthy,
      bmrKcal: bmr,
      tdeeKcal: tdee,
      targetDailyKcal: targetDailyKcal,
      recommendedWeeklyChangeKg: weeklyChangeRateKg,
      estimatedWeeksToGoal: estimatedWeeks,
      dailyHydrationLiters: hydrationLiters,
      recommendedDailySteps: targetSteps,
      progressTrend: trend,
      summaryText: summary,
      actionableAdvice: advice,
    );
  }

  /// Processes user chat input and returns an expert, personalized response
  /// using the local rules and health knowledge engine.
  static String processQuery({
    required String query,
    required CoachAnalysisResult analysis,
    required bool isAzerbaijani,
    CoachContext? context,
    CoachIntent? previousIntent,
  }) {
    return CoachBrain.respond(
      query: query,
      analysis: analysis,
      isAzerbaijani: isAzerbaijani,
      context: context ?? const CoachContext(),
      previousIntent: previousIntent,
    ).text;
  }

  /// Canonical topic answers reused by [CoachBrain]. [topicKey] must be one of:
  /// analyze, bmi, water, sleep, food, step, plateau, help.
  static String topicAnswer({
    required String topicKey,
    required CoachAnalysisResult analysis,
    required bool isAzerbaijani,
  }) {
    final q = topicKey;

    // 1. Progress / Analysis
    if (q.contains('analyze') ||
        q.contains('progress') ||
        q.contains('tərəqqi') ||
        q.contains('təhlil') ||
        q.contains('status')) {
      if (isAzerbaijani) {
        return '📊 **Çəki İdarəetmə Analizi**:\n\n'
            '• **Cari Çəki**: ${analysis.currentWeight} kg\n'
            '• **Hədəf Çəki**: ${analysis.targetWeight} kg\n'
            '• **BMI**: ${analysis.bmi.toStringAsFixed(1)} (${analysis.bmiCategory})\n'
            '• **Baza Maddələr Mübadiləsi (BMR)**: ${analysis.bmrKcal} kcal\n'
            '• **Gündəlik Ümumi Xərc (TDEE)**: ${analysis.tdeeKcal} kcal\n'
            '• **Tövsiyə Olunan Gündəlik Kalori**: ${analysis.targetDailyKcal} kcal\n'
            '• **Hədəfə Çatma Müddəti**: ~${analysis.estimatedWeeksToGoal} həftə (təhlükəsiz ${analysis.recommendedWeeklyChangeKg} kg/həftə tempi ilə)\n\n'
            '💡 *Qeyd: Bu göstəricilər elmi formulalara əsaslanır və heç vaxt orqanizmi ac qoymağı tələb etmir.*';
      } else {
        return '📊 **Weight Management Analysis**:\n\n'
            '• **Current Weight**: ${analysis.currentWeight} kg\n'
            '• **Target Weight**: ${analysis.targetWeight} kg\n'
            '• **BMI**: ${analysis.bmi.toStringAsFixed(1)} (${analysis.bmiCategory})\n'
            '• **Basal Metabolic Rate (BMR)**: ${analysis.bmrKcal} kcal\n'
            '• **Daily Energy Expenditure (TDEE)**: ${analysis.tdeeKcal} kcal\n'
            '• **Recommended Daily Intake**: ${analysis.targetDailyKcal} kcal\n'
            '• **Estimated Timeline**: ~${analysis.estimatedWeeksToGoal} weeks at a safe ${analysis.recommendedWeeklyChangeKg} kg/week pace\n\n'
            '💡 *Note: Recommendations prioritize metabolic longevity without extreme calorie deprivation.*';
      }
    }

    // 2. BMI explanation & limitations
    if (q.contains('bmi') || q.contains('çəki indeksi') || q.contains('index')) {
      if (isAzerbaijani) {
        return 'ℹ️ **BMI (Bədən Kütlə İndeksi) haqqında vacib məlumat**:\n\n'
            'Sizin cari BMI göstəriciniz: **${analysis.bmi.toStringAsFixed(1)}** (${analysis.bmiCategory}).\n'
            'Boyunuza (${(sqrt(analysis.currentWeight / analysis.bmi) * 100).round()} cm) uyğun normal çəki aralığı: '
            '${analysis.minHealthyWeight.toStringAsFixed(1)} kg – ${analysis.maxHealthyWeight.toStringAsFixed(1)} kg.\n\n'
            '⚠️ **BMI-nin Məhdudiyyətləri**:\n'
            'BMI yalnız boy və ümumi çəkini nisbətləndirir. O, əzələ kütləsi ilə piy kütləsini, sümük sıxlığını və ya bədən quruluşunu ayırd etmir. '
            'İdmanla məşğul olanlarda və ya sıx əzələli insanlarda BMI yüksək görünə bilər, amma bu piylənmə demək deyil. '
            'Buna görə də BMI-ni təkbaşına deyil, ümumi rifah və aktivliklə birgə qiymətləndirmək lazımdır.';
      } else {
        return 'ℹ️ **Understanding BMI & Its Clinical Limitations**:\n\n'
            'Your calculated BMI is **${analysis.bmi.toStringAsFixed(1)}** (${analysis.bmiCategory}).\n'
            'Healthy weight range for your height: ${analysis.minHealthyWeight.toStringAsFixed(1)} kg – ${analysis.maxHealthyWeight.toStringAsFixed(1)} kg.\n\n'
            '⚠️ **Limitations to Remember**:\n'
            'BMI is a population-level screening formula (weight / height²). It does not distinguish between lean skeletal muscle mass and adipose fat tissue, '
            'nor does it reflect bone density or visceral fat distribution. Athletic individuals with high muscle volume may be categorized as "overweight" '
            'despite excellent metabolic health. Always consider fitness, waist circumference, and vitality alongside BMI.';
      }
    }

    // 3. Hydration
    if (q.contains('water') ||
        q.contains('su') ||
        q.contains('drink') ||
        q.contains('maye') ||
        q.contains('hydrat')) {
      if (isAzerbaijani) {
        return '💧 **Gündəlik Su Qəbulu Tövsiyəsi**:\n\n'
            'Bədən çəkinizə (${analysis.currentWeight} kg) və aktivlik səviyyənizə əsasən gündə təxminən '
            '**${analysis.dailyHydrationLiters} litr** (təxminən ${((analysis.dailyHydrationLiters * 1000) / 250).round()} stəkan) su içməyiniz məsləhətdir.\n\n'
            '• Səhər oyananda 1 stəkan ilıq su maddələr mübadiləsini oyadır.\n'
            '• Yeməkdən 20-30 dəqiqə əvvəl su içmək doyma hissinə kömək edir.\n'
            '• Ağır gəzinti və ya idman günlərində tərləmə ilə itirilən mayeni bərpa etmək üçün miqdarı 300-500 ml artırın.';
      } else {
        return '💧 **Personalized Hydration Guidance**:\n\n'
            'Based on your weight (${analysis.currentWeight} kg) and movement, your recommended baseline hydration is '
            '**${analysis.dailyHydrationLiters} liters** (~${((analysis.dailyHydrationLiters * 1000) / 250).round()} glasses) per day.\n\n'
            '• A glass upon waking stimulates metabolic readiness.\n'
            '• Drinking 250-300 ml before meals supports digestive pacing and satiety signaling.\n'
            '• On days with active walks (> 8,000 steps), add 300-500 ml to replace exercise fluid loss.';
      }
    }

    // 4. Sleep & weight loss
    if (q.contains('sleep') || q.contains('yuxu') || q.contains('yatmaq') || q.contains('rest')) {
      if (isAzerbaijani) {
        return '🌙 **Yuxu və Çəki İdarəetməsi Arasındakı Əlaqə**:\n\n'
            'Keyfiyyətli yuxu çəki tənzimləməsinin təməl daşıdır:\n\n'
            '1. **Hormonal Tarazlıq**: Yuxu 7 saatdan az olduqda bədən daha çox *qrelin* (aclıq hormonu) və daha az *leptin* (doyma hormonu) ifraz edir.\n'
            '2. **Kortizol Səviyyəsi**: Yuxusuzluq stres hormonu kortizolu artırır, bu da qarın nahiyəsində piy toplanmasına səbəb olur.\n'
            '3. **İnsulin Həssaslığı**: Yaxşı yuxu hüceyrələrin qlükozanı effektiv emal etməsinə imkan verir.\n\n'
            'Tövsiyə: Hər gecə 7–8 saat ardıcıl yatmağa və sabit yuxu rejimi saxlamağa çalışın.';
      } else {
        return '🌙 **The Science of Sleep in Weight Management**:\n\n'
            'Adequate restorative sleep is non-negotiable for fat loss and metabolic regulation:\n\n'
            '1. **Appetite Hormones**: Sleeping under 7h spikes *ghrelin* (the hunger hormone) by ~15% and blunts *leptin* (the satiety hormone).\n'
            '2. **Cortisol & Insulin**: Chronic sleep deprivation elevates cortisol, prompting increased cravings for calorie-dense carbohydrates and promoting abdominal fat storage.\n'
            '3. **Recovery**: Deep sleep stages are when muscle protein synthesis and tissue repair occur.\n\n'
            'Recommendation: Aim for 7–8 hours of consistent overnight sleep with regular bedtime timing.';
      }
    }

    // 5. Nutrition & Food
    if (q.contains('food') ||
        q.contains('eat') ||
        q.contains('diet') ||
        q.contains('yemək') ||
        q.contains('qidalan') ||
        q.contains('pəhriz') ||
        q.contains('nutrit')) {
      if (isAzerbaijani) {
        return '🥗 **Sağlam və Balanslı Qidalanma Prinsipləri**:\n\n'
            '• **Kalori Çərçivəsi**: Gündəlik hədəfiniz təxminən ${analysis.targetDailyKcal} kcal-dir. Şiddətli ac qalmaq maddələr mübadiləsini zəiflədir.\n'
            '• **Boşqab Qaydası**: Boşqabınızın 50%-ni tərəvəzlər və lif, 25%-ni keyfiyyətli protein (toyuq, balıq, yumurta, paxlalılar), 25%-ni tam taxıllar təşkil etsin.\n'
            '• **Şəkər və Ultra-Emal Edilmiş Qidalar**: Şirniyyat və qazlı içkiləri minimuma endirin.\n'
            '• **Yavaş Yemək**: Beynin doyma siqnalını qəbul etməsi 15-20 dəqiqə çəkir.\n\n'
            '⚠️ *Xatırlatma: YHealth qətiyyən şok pəhrizləri tövsiyə etmir. Davamlı vərdişlər uğurun açarıdır.*';
      } else {
        return '🥗 **Evidence-Based Nutrition Framework**:\n\n'
            '• **Target Caloric Allowance**: Aim for ~${analysis.targetDailyKcal} kcal/day. Severe deficits (> 700 kcal) trigger metabolic adaptation and muscle loss.\n'
            '• **Plate Composition**: Fill 50% with colorful fiber-rich vegetables, 25% with lean protein (poultry, fish, legumes, eggs), and 25% with complex whole carbohydrates.\n'
            '• **Ultra-Processed Foods**: Reduce refined sugars and industrial trans-fats; prioritize whole single-ingredient foods.\n'
            '• **Mindful Eating**: Satiety hormones require 15-20 minutes to signal the brain—eat without digital screens.\n\n'
            '⚠️ *Safety Notice: YHealth never recommends crash diets. Sustainable habit change creates lasting health.*';
      }
    }

    // 6. Steps & Activity
    if (q.contains('step') ||
        q.contains('walk') ||
        q.contains('addım') ||
        q.contains('yeriş') ||
        q.contains('hərəkət') ||
        q.contains('activ')) {
      if (isAzerbaijani) {
        return '👟 **Fəallıq və Addım Tövsiyələri**:\n\n'
            'Gündəlik tövsiyə olunan addım sayı: **${analysis.recommendedDailySteps} addım**.\n\n'
            '• Gündə 30-40 dəqiqəlik orta templi yeriş təxminən 3,500-4,500 addım edir və ürək-damar sağlamlığını qoruyur.\n'
            '• Yeməkdən sonra 10-15 dəqiqəlik gəzinti qanda şəkərin kəskin yüksəlməsinin qarşısını alır.\n'
            '• Oturaq iş zamanı hər 1 saatdan bir 2 dəqiqə ayağa qalxıb hərəkət edin.';
      } else {
        return '👟 **Daily Movement & Step Strategy**:\n\n'
            'Your recommended target is **${analysis.recommendedDailySteps} steps/day**.\n\n'
            '• A brisk 30-40 minute daily walk contributes ~3,500-4,500 steps while burning 180-250 kcal.\n'
            '• A short 10-minute walk post-meal significantly attenuates postprandial glucose spikes.\n'
            '• Interrupt prolonged sitting every 60 minutes with 2 minutes of posture breaks or mobility.';
      }
    }

    // 7. Plateau
    if (q.contains('plateau') || q.contains('stuck') || q.contains('dayanıb') || q.contains('azalmır')) {
      if (isAzerbaijani) {
        return '⏳ **Çəki Düşməsinin Dayanması (Plato Dövrü)**:\n\n'
            'Çəkinin bir neçə həftə eyni qalması tamamilə təbii fizioloji reaksiyadır:\n\n'
            '1. **Su Saxlanması**: Yeni fiziki aktivlik və ya duz miqdarı əzələlərdə müvəqqəti su toplaya bilər.\n'
            '2. **Maddələr Mübadiləsi Uyğunlaşması**: Çəki azaldıqca bədənin enerji xərci də bir qədər azalır.\n'
            '3. **Həll Yolları**:\n'
            '   • Kalorini kəskin azaltmayın!\n'
            '   • Gündəlik addım sayınızı 1,000 addım artırın.\n'
            '   • Yuxu rejimini və su qəbulunu yoxlayın.\n'
            '   • Yalnız tərəziyə deyil, bədən ölçülərinə (bel çevrəsi) və geyimlərinizin oturuşuna diqqət yetirin.';
      } else {
        return '⏳ **Navigating Weight Plateaus**:\n\n'
            'Weight stalls lasting 1-3 weeks are standard physiological adaptations, not failure:\n\n'
            '1. **Water Retention**: Increased step counts and training cause minor muscular micro-inflammation, temporarily holding 0.5-1.5 kg of glycogen and water.\n'
            '2. **Adaptive Thermogenesis**: As body mass reduces, baseline expenditure drops marginally.\n'
            '3. **Tactical Adjustments**:\n'
            '   • Do NOT drastically cut calories below your ${analysis.targetDailyKcal} kcal target!\n'
            '   • Increase non-exercise movement (NEAT) by +1,000 steps daily.\n'
            '   • Audit sleep and sodium intake.\n'
            '   • Track waist measurements and clothing fit—body recomposition often precedes scale drops.';
      }
    }

    // Default general response
    if (isAzerbaijani) {
      return '👋 **Salam! Mən sizin YHealth Çəki Məşqçinizəm.**\n\n'
          '${analysis.summaryText}\n\n'
          'Sizə bu mövzularda kömək edə bilərəm:\n'
          '• *"Tərəqqimi təhlil et"*\n'
          '• *"Nə qədər su içməliyəm?"*\n'
          '• *"BMI göstəricimi izah et"*\n'
          '• *"Qidalanma tövsiyələri ver"*\n'
          '• *"Gündə neçə addım atmalıyam?"*\n'
          '• *"Yuxu çəkiyə necə təsir edir?"*\n\n'
          'Hansı mövzu ilə başlayaq?';
    } else {
      return '👋 **Hello! I am your YHealth Weight Management Coach.**\n\n'
          '${analysis.summaryText}\n\n'
          'I can provide personalized insights on:\n'
          '• *"Analyze my progress"*\n'
          '• *"How much water should I drink?"*\n'
          '• *"Explain my BMI"*\n'
          '• *"Nutrition guidance"*\n'
          '• *"How many steps should I walk?"*\n'
          '• *"How does sleep affect weight?"*\n\n'
          'What would you like to explore today?';
    }
  }
}
