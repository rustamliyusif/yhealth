import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/coach_message_model.dart';
import '../models/weight_record_model.dart';
import '../models/weekly_report_model.dart';
import '../repositories/activity_repository.dart';
import '../services/storage_service.dart';
import '../services/weight_coach_engine.dart';

/// Provider orchestrating user weight profile, historical weight logs in Drift,
/// metabolic analysis, and conversational coaching interactions.
class WeightCoachProvider extends ChangeNotifier {
  final ActivityRepository _repository;
  final StorageService _storageService;

  double _currentWeight = 70.0;
  double _targetWeight = 65.0;
  double _heightCm = 175.0;
  int _ageYears = 28;
  ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;
  DietaryPreference _dietaryPreference = DietaryPreference.balanced;

  List<WeightRecordModel> _weightHistory = [];
  List<CoachMessageModel> _messages = [];
  WeeklyReportModel? _latestWeeklyReport;
  bool _isLoading = false;
  CoachIntent? _lastIntent;
  String? _errorMessage;

  WeightCoachProvider(this._repository, this._storageService) {
    _loadState();
  }

  double get currentWeight => _currentWeight;
  double get targetWeight => _targetWeight;
  double get heightCm => _heightCm;
  int get ageYears => _ageYears;
  ActivityLevel get activityLevel => _activityLevel;
  DietaryPreference get dietaryPreference => _dietaryPreference;
  List<WeightRecordModel> get weightHistory => List.unmodifiable(_weightHistory);
  List<CoachMessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CoachAnalysisResult get currentAnalysis {
    return WeightCoachEngine.analyzeProfile(
      currentWeight: _currentWeight,
      targetWeight: _targetWeight,
      heightCm: _heightCm,
      age: _ageYears,
      activityLevel: _activityLevel,
      dietaryPreference: _dietaryPreference,
      weightHistory: _weightHistory,
      latestWeeklyReport: _latestWeeklyReport,
      isAzerbaijani: _storageService.languageCode == 'az',
    );
  }

  Future<void> _loadState() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentWeight = _storageService.userWeight;
      _targetWeight = _storageService.targetWeight;
      _heightCm = _storageService.userHeight;
      _ageYears = _storageService.userAge;

      final levelStr = _storageService.activityLevel;
      _activityLevel = ActivityLevel.values.firstWhere(
        (l) => l.name == levelStr,
        orElse: () => ActivityLevel.moderatelyActive,
      );

      final dietStr = _storageService.dietaryPreference;
      _dietaryPreference = DietaryPreference.values.firstWhere(
        (d) => d.name == dietStr,
        orElse: () => DietaryPreference.balanced,
      );

      // Load weekly reports to get recent step and sleep metrics
      final reports = await _repository.getAllWeeklyReports(limit: 1);
      _latestWeeklyReport = reports.isNotEmpty ? reports.first : null;

      // Load weight records from Drift
      _weightHistory = await _repository.getAllWeightRecords();

      // If user has no logged weight records yet, create the baseline record
      if (_weightHistory.isEmpty && _currentWeight > 0) {
        final initialRecord = WeightRecordModel(
          id: 'weight_${DateTime.now().millisecondsSinceEpoch}',
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          weightKg: _currentWeight,
          bmi: WeightCoachEngine.calculateBmi(_currentWeight, _heightCm),
          notes: 'Baseline profile measurement',
          createdAt: DateTime.now(),
        );
        await _repository.saveWeightRecord(initialRecord);
        _weightHistory = [initialRecord];
      }

      // Load coach chat history
      _messages = await _repository.getAllCoachMessages();
      if (_messages.isEmpty) {
        await _seedWelcomeMessage();
      }
    } catch (e) {
      _errorMessage = 'Failed to load weight coach state: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _seedWelcomeMessage() async {
    final isAz = _storageService.languageCode == 'az';
    final analysis = currentAnalysis;
    final welcomeText = isAz
        ? '👋 Salam! Mən sizin YHealth Şəxsi Çəki Məşqçinizəm.\n\n'
            'Cari çəkiniz: **${analysis.currentWeight} kg**, Hədəf: **${analysis.targetWeight} kg**.\n'
            'Sağlam tempdə hədəfinizə təxminən **${analysis.estimatedWeeksToGoal} həftəyə** çatmaq mümkündür.\n\n'
            'Sizə tərəqqinizin analizi, qidalanma, su qəbulu və addım hədəfləri üzrə yardım etməyə hazıram. Aşağıdakı suallardan birini seçə və ya öz sualınızı yaza bilərsiniz!\n\n'
            '_Coach Leo ümumi tövsiyələr verir və həkim məsləhətini əvəz etmir._'
        : '👋 Hello! I am your personal YHealth Weight Management Coach.\n\n'
            'Current weight: **${analysis.currentWeight} kg**, Goal: **${analysis.targetWeight} kg**.\n'
            'At a safe, sustainable pace, your goal is reachable in approximately **${analysis.estimatedWeeksToGoal} weeks**.\n\n'
            'I can guide you through metabolic analysis, balanced nutrition, hydration, and activity pacing. Pick a quick prompt below or type any question!\n\n'
            '_Coach Leo gives general guidance and is not a substitute for medical advice._';

    final welcomeMessage = CoachMessageModel(
      id: 'msg_welcome_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'coach',
      content: welcomeText,
      timestamp: DateTime.now(),
      category: 'general',
    );

    await _repository.saveCoachMessage(welcomeMessage);
    _messages = [welcomeMessage];
  }

  Future<void> logWeight({
    required double weightKg,
    String? notes,
    DateTime? date,
  }) async {
    final entryDate = date ?? DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(entryDate);
    final bmi = WeightCoachEngine.calculateBmi(weightKg, _heightCm);

    final record = WeightRecordModel(
      id: 'weight_${entryDate.millisecondsSinceEpoch}',
      date: dateStr,
      weightKg: weightKg,
      bmi: bmi,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _repository.saveWeightRecord(record);
    _currentWeight = weightKg;
    await _storageService.setUserWeight(weightKg);

    _weightHistory = await _repository.getAllWeightRecords();
    notifyListeners();
  }

  Future<void> updateTargetWeight(double targetKg) async {
    _targetWeight = targetKg;
    await _storageService.setTargetWeight(targetKg);
    notifyListeners();
  }

  Future<void> updateProfilePreferences({
    double? heightCm,
    int? ageYears,
    ActivityLevel? activityLevel,
    DietaryPreference? dietaryPreference,
  }) async {
    if (heightCm != null) {
      _heightCm = heightCm;
      await _storageService.setUserHeight(heightCm);
    }
    if (ageYears != null) {
      _ageYears = ageYears;
      await _storageService.setUserAge(ageYears);
    }
    if (activityLevel != null) {
      _activityLevel = activityLevel;
      await _storageService.setActivityLevel(activityLevel.name);
    }
    if (dietaryPreference != null) {
      _dietaryPreference = dietaryPreference;
      await _storageService.setDietaryPreference(dietaryPreference.name);
    }
    notifyListeners();
  }

  Future<void> deleteWeightRecord(String id) async {
    await _repository.deleteWeightRecord(id);
    _weightHistory = await _repository.getAllWeightRecords();
    if (_weightHistory.isNotEmpty) {
      _currentWeight = _weightHistory.first.weightKg;
      await _storageService.setUserWeight(_currentWeight);
    }
    notifyListeners();
  }

  Future<void> sendMessage(String text, {bool? isAzerbaijani}) async {
    if (text.trim().isEmpty) return;

    final isAz = isAzerbaijani ?? (_storageService.languageCode == 'az');
    final now = DateTime.now();

    // 1. User message
    final userMsg = CoachMessageModel(
      id: 'msg_user_${now.millisecondsSinceEpoch}',
      sender: 'user',
      content: text.trim(),
      timestamp: now,
    );
    await _repository.saveCoachMessage(userMsg);
    _messages.add(userMsg);
    notifyListeners();

    // 2. Generate coach response using local rules engine
    final reply = CoachBrain.respond(
      query: text,
      analysis: currentAnalysis,
      isAzerbaijani: isAz,
      context: await _buildContext(),
      previousIntent: _lastIntent,
    );
    _lastIntent = reply.intent;
    final replyContent = reply.text;

    final coachMsg = CoachMessageModel(
      id: 'msg_coach_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'coach',
      content: replyContent,
      timestamp: DateTime.now(),
    );
    await _repository.saveCoachMessage(coachMsg);
    _messages.add(coachMsg);
    notifyListeners();
  }

  Future<CoachContext> _buildContext() async {
    final fmt = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();
    final today = fmt.format(now);
    final weekStart = fmt.format(now.subtract(const Duration(days: 6)));
    final goalSteps = _storageService.goalSteps;

    var todaySteps = 0;
    var daysTracked = 0;
    var totalSteps = 0;
    var goalHits = 0;
    try {
      final activities = await _repository.getActivitiesInRange(weekStart, today);
      for (final day in activities) {
        if (day.date == today) todaySteps = day.steps;
        if (day.steps <= 0) continue;
        daysTracked++;
        totalSteps += day.steps;
        if (day.steps >= goalSteps) goalHits++;
      }
    } catch (e) {
      debugPrint('WeightCoachProvider._buildContext: $e');
    }

    var sleepNights = 0;
    var sleepTotal = 0;
    try {
      final sleeps = await _repository.getSleepRecordsInRange(weekStart, today);
      for (final night in sleeps) {
        if (night.durationMinutes <= 0) continue;
        sleepNights++;
        sleepTotal += night.durationMinutes;
      }
    } catch (e) {
      debugPrint('WeightCoachProvider._buildContext: $e');
    }

    double? weightChange;
    final monthAgo = fmt.format(now.subtract(const Duration(days: 30)));
    final recent = _weightHistory.where((r) => r.date.compareTo(monthAgo) >= 0).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final weighIns = recent.length;
    if (recent.length >= 2) {
      weightChange = recent.last.weightKg - recent.first.weightKg;
    }

    return CoachContext(
      todaySteps: todaySteps,
      goalSteps: goalSteps,
      daysTracked7d: daysTracked,
      avgSteps7d: daysTracked > 0 ? (totalSteps / daysTracked).round() : 0,
      goalHits7d: goalHits,
      sleepNights7d: sleepNights,
      avgSleepMinutes7d: sleepNights > 0 ? (sleepTotal / sleepNights).round() : 0,
      weightChange30d: weightChange,
      weighIns30d: weighIns,
    );
  }

  Future<void> clearChatHistory() async {
    _lastIntent = null;
    await _repository.clearCoachMessages();
    _messages.clear();
    await _seedWelcomeMessage();
    notifyListeners();
  }
}
