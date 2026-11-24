import 'dart:math';
import 'package:flutter/material.dart';
import '../models/sleep_record_model.dart';
import '../repositories/activity_repository.dart';
import '../services/health_connect_service.dart';

class SleepProvider extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  final HealthConnectService _healthConnectService;

  List<SleepRecordModel> _records = [];
  HealthConnectStatus _healthConnectStatus = HealthConnectStatus.unknown;
  bool _isLoading = false;
  String? _errorMessage;

  SleepProvider(
    this._activityRepository, [
    HealthConnectService? healthConnectService,
  ]) : _healthConnectService = healthConnectService ?? HealthConnectService() {
    _init();
  }

  List<SleepRecordModel> get records => List.unmodifiable(_records);
  HealthConnectStatus get healthConnectStatus => _healthConnectStatus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Returns the most recent sleep session (last night's sleep).
  SleepRecordModel? get lastNightSleep => _records.isNotEmpty ? _records.first : null;

  /// Average sleep duration over the past records in hours.
  double get averageDurationHours {
    if (_records.isEmpty) return 0.0;
    final totalMins = _records.take(7).fold<int>(0, (sum, r) => sum + r.durationMinutes);
    final count = min(_records.length, 7);
    return (totalMins / count) / 60.0;
  }

  String get formattedAverageDuration {
    final hours = averageDurationHours;
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  /// Calculates bedtime consistency score based on standard deviation of bedtimes over last 7 days.
  int? get bedtimeStdDevMinutes {
    if (_records.length < 3) return null;
    final recent = _records.take(7).toList();
    final minutesList = recent.map((r) {
      final hour = r.bedtime.hour;
      final minute = r.bedtime.minute;
      return hour >= 12 ? (hour - 20) * 60 + minute : (hour + 4) * 60 + minute;
    }).toList();
    final mean = minutesList.reduce((a, b) => a + b) / minutesList.length;
    final variance =
        minutesList.map((m) => pow(m - mean, 2)).reduce((a, b) => a + b) / minutesList.length;
    return sqrt(variance).round();
  }

  String get bedtimeConsistencyDescription {
    if (_records.length < 3) return 'Gathering data...';

    final recent = _records.take(7).toList();
    // Convert bedtimes to minutes relative to 20:00 (8:00 PM) baseline to handle midnight crossing smoothly
    final minutesList = recent.map((r) {
      final hour = r.bedtime.hour;
      final minute = r.bedtime.minute;
      // If bedtime is after 12:00 PM (e.g. 23:30), relative to 20:00
      if (hour >= 12) {
        return (hour - 20) * 60 + minute;
      } else {
        // If bedtime is past midnight (e.g. 01:15), it is 4 hours after midnight + 4 hours from 20:00 = 8h
        return (hour + 4) * 60 + minute;
      }
    }).toList();

    final mean = minutesList.reduce((a, b) => a + b) / minutesList.length;
    final variance =
        minutesList.map((m) => pow(m - mean, 2)).reduce((a, b) => a + b) / minutesList.length;
    final stdDevMinutes = sqrt(variance);

    if (stdDevMinutes <= 30) {
      return 'High Consistency (±${stdDevMinutes.round()}m)';
    } else if (stdDevMinutes <= 60) {
      return 'Moderate Consistency (±${stdDevMinutes.round()}m)';
    } else {
      return 'Variable Bedtimes (±${stdDevMinutes.round()}m)';
    }
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    await checkHealthConnectStatus();
    await loadRecords();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkHealthConnectStatus() async {
    _healthConnectStatus = await _healthConnectService.checkAvailability();
    notifyListeners();
  }

  static int _idCounter = 0;

  Future<void> loadRecords() async {
    try {
      _records = await _activityRepository.getAllSleepRecords(limit: 60);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load sleep records: $e';
    }
    notifyListeners();
  }

  Stream<List<SleepRecordModel>> watchAllRecords() {
    return _activityRepository.watchAllSleepRecords(limit: 60);
  }

  /// Adds a new sleep record with strict overlap validation and duplicate prevention.
  Future<bool> addSleepRecord({
    required DateTime bedtime,
    required DateTime wakeTime,
    required String referenceDate,
    String source = 'manual',
    int efficiencyPercent = 85,
    String? notes,
    bool hasStages = false,
    int? lightSleepMinutes,
    int? deepSleepMinutes,
    int? remSleepMinutes,
    int? awakeMinutes,
  }) async {
    // 1. Validate timestamps
    if (wakeTime.isBefore(bedtime) || wakeTime.isAtSameMomentAs(bedtime)) {
      _errorMessage = 'Wake-up time must be after bedtime';
      notifyListeners();
      return false;
    }

    final durationMins = wakeTime.difference(bedtime).inMinutes;
    if (durationMins < 10) {
      _errorMessage = 'Sleep session must be at least 10 minutes';
      notifyListeners();
      return false;
    }

    // 2. Prevent duplicate/overlapping records
    final overlaps = await _activityRepository.getOverlappingSleepRecords(
      bedtime: bedtime,
      wakeTime: wakeTime,
    );

    if (overlaps.isNotEmpty) {
      _errorMessage = 'This sleep session overlaps with an existing record';
      notifyListeners();
      return false;
    }

    // 3. Create model and persist
    final id = 'sleep_${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';
    final record = SleepRecordModel(
      id: id,
      date: referenceDate,
      bedtime: bedtime,
      wakeTime: wakeTime,
      durationMinutes: durationMins,
      source: source,
      efficiencyPercent: efficiencyPercent,
      notes: notes,
      hasStages: hasStages,
      lightSleepMinutes: lightSleepMinutes,
      deepSleepMinutes: deepSleepMinutes,
      remSleepMinutes: remSleepMinutes,
      awakeMinutes: awakeMinutes,
    );

    await _activityRepository.saveSleepRecord(record);
    await loadRecords();
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  /// Updates an existing sleep record with overlap checking.
  Future<bool> updateSleepRecord(SleepRecordModel record) async {
    if (record.wakeTime.isBefore(record.bedtime) ||
        record.wakeTime.isAtSameMomentAs(record.bedtime)) {
      _errorMessage = 'Wake-up time must be after bedtime';
      notifyListeners();
      return false;
    }

    final overlaps = await _activityRepository.getOverlappingSleepRecords(
      bedtime: record.bedtime,
      wakeTime: record.wakeTime,
      excludeId: record.id,
    );

    if (overlaps.isNotEmpty) {
      _errorMessage = 'Updated times overlap with another existing record';
      notifyListeners();
      return false;
    }

    await _activityRepository.saveSleepRecord(record);
    await loadRecords();
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  /// Deletes a sleep record by id.
  Future<void> deleteSleepRecord(String id) async {
    await _activityRepository.deleteSleepRecord(id);
    _records.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  /// Synchronizes genuine wearable sleep sessions from Android Health Connect.
  Future<int> syncFromHealthConnect() async {
    if (_healthConnectStatus != HealthConnectStatus.available) {
      return 0;
    }

    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 30));

    final sessions = await _healthConnectService.fetchSleepSessions(
      startTime: twoWeeksAgo,
      endTime: now,
    );

    int importedCount = 0;
    for (final session in sessions) {
      if (await _activityRepository.getSleepRecordById(session.id) != null) continue;
      final overlaps = await _activityRepository.getOverlappingSleepRecords(
        bedtime: session.bedtime,
        wakeTime: session.wakeTime,
        excludeId: session.id,
      );

      if (overlaps.isEmpty) {
        await _activityRepository.saveSleepRecord(session);
        importedCount++;
      }
    }

    if (importedCount > 0) {
      await loadRecords();
    }
    return importedCount;
  }

  Future<bool> openHealthConnectSettings() => _healthConnectService.openHealthConnectSettings();
}
