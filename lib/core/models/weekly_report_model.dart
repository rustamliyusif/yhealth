import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';

/// Represents daily activity and sleep metrics for a specific day within a reporting week.
class WeeklyDayBreakdown {
  final String date; // yyyy-MM-dd
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String dayName; // Mon, Tue, etc.
  final int steps;
  final double distanceKm;
  final int calories;
  final int activeMinutes;
  final int sleepMinutes;
  final int goalSteps;
  final bool isGoalMet;
  final bool isMissing; // True if no record was found in the database

  WeeklyDayBreakdown({
    required this.date,
    required this.dayOfWeek,
    required this.dayName,
    required this.steps,
    required this.distanceKm,
    required this.calories,
    required this.activeMinutes,
    required this.sleepMinutes,
    required this.goalSteps,
    required this.isGoalMet,
    required this.isMissing,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'dayOfWeek': dayOfWeek,
        'dayName': dayName,
        'steps': steps,
        'distanceKm': distanceKm,
        'calories': calories,
        'activeMinutes': activeMinutes,
        'sleepMinutes': sleepMinutes,
        'goalSteps': goalSteps,
        'isGoalMet': isGoalMet,
        'isMissing': isMissing,
      };

  factory WeeklyDayBreakdown.fromJson(Map<String, dynamic> json) {
    return WeeklyDayBreakdown(
      date: json['date'] as String? ?? '',
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 1,
      dayName: json['dayName'] as String? ?? '',
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      activeMinutes: (json['activeMinutes'] as num?)?.toInt() ?? 0,
      sleepMinutes: (json['sleepMinutes'] as num?)?.toInt() ?? 0,
      goalSteps: (json['goalSteps'] as num?)?.toInt() ?? 8000,
      isGoalMet: json['isGoalMet'] as bool? ?? false,
      isMissing: json['isMissing'] as bool? ?? false,
    );
  }
}

/// Domain model representing a fully calculated weekly summary report.
class WeeklyReportModel {
  final String id;
  final String startDate; // Monday yyyy-MM-dd
  final String endDate; // Sunday yyyy-MM-dd
  final int year;
  final int weekNumber;
  final DateTime generatedAt;
  final int totalSteps;
  final double totalDistanceKm;
  final int totalCalories;
  final int totalActiveMinutes;
  final int totalSleepMinutes;
  final int avgDailySteps;
  final double avgDailyDistanceKm;
  final int avgDailyCalories;
  final int avgDailySleepMinutes;
  final int goalMetDays;
  final String mostActiveDayDate;
  final int mostActiveDaySteps;
  final int recordedDaysCount;
  final double? stepsChangePercent;
  final double? sleepChangePercent;
  final double? caloriesChangePercent;
  final double? distanceChangePercent;
  final List<WeeklyDayBreakdown> dailyBreakdowns;

  WeeklyReportModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.year,
    required this.weekNumber,
    required this.generatedAt,
    required this.totalSteps,
    required this.totalDistanceKm,
    required this.totalCalories,
    required this.totalActiveMinutes,
    required this.totalSleepMinutes,
    required this.avgDailySteps,
    required this.avgDailyDistanceKm,
    required this.avgDailyCalories,
    required this.avgDailySleepMinutes,
    required this.goalMetDays,
    required this.mostActiveDayDate,
    required this.mostActiveDaySteps,
    required this.recordedDaysCount,
    this.stepsChangePercent,
    this.sleepChangePercent,
    this.caloriesChangePercent,
    this.distanceChangePercent,
    required this.dailyBreakdowns,
  });

  String get formattedTotalSleep {
    final h = totalSleepMinutes ~/ 60;
    final m = totalSleepMinutes % 60;
    return '${h}h ${m}m';
  }

  String get formattedAvgDailySleep {
    final h = avgDailySleepMinutes ~/ 60;
    final m = avgDailySleepMinutes % 60;
    return '${h}h ${m}m';
  }

  String get formattedTotalDistance => '${totalDistanceKm.toStringAsFixed(1)} km';
  String get formattedAvgDailyDistance => '${avgDailyDistanceKm.toStringAsFixed(1)} km';

  int get goalCompletionPercent => (goalMetDays / 7.0 * 100).round();

  String formatDeltaPercent(double? delta) {
    if (delta == null) return '—';
    final prefix = delta > 0 ? '+' : '';
    return '$prefix${delta.toStringAsFixed(1)}%';
  }

  factory WeeklyReportModel.fromEntity(WeeklyReportsEntry entity) {
    List<WeeklyDayBreakdown> breakdowns = [];
    try {
      final decoded = jsonDecode(entity.dailyBreakdownJson) as List<dynamic>;
      breakdowns = decoded
          .map((item) => WeeklyDayBreakdown.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      breakdowns = [];
    }

    return WeeklyReportModel(
      id: entity.id,
      startDate: entity.startDate,
      endDate: entity.endDate,
      year: entity.year,
      weekNumber: entity.weekNumber,
      generatedAt: entity.generatedAt,
      totalSteps: entity.totalSteps,
      totalDistanceKm: entity.totalDistanceKm,
      totalCalories: entity.totalCalories,
      totalActiveMinutes: entity.totalActiveMinutes,
      totalSleepMinutes: entity.totalSleepMinutes,
      avgDailySteps: entity.avgDailySteps,
      avgDailyDistanceKm: entity.avgDailyDistanceKm,
      avgDailyCalories: entity.avgDailyCalories,
      avgDailySleepMinutes: entity.avgDailySleepMinutes,
      goalMetDays: entity.goalMetDays,
      mostActiveDayDate: entity.mostActiveDayDate,
      mostActiveDaySteps: entity.mostActiveDaySteps,
      recordedDaysCount: entity.recordedDaysCount,
      stepsChangePercent: entity.stepsChangePercent,
      sleepChangePercent: entity.sleepChangePercent,
      caloriesChangePercent: entity.caloriesChangePercent,
      distanceChangePercent: entity.distanceChangePercent,
      dailyBreakdowns: breakdowns,
    );
  }

  WeeklyReportsEntriesCompanion toCompanion() {
    return WeeklyReportsEntriesCompanion(
      id: drift.Value(id),
      startDate: drift.Value(startDate),
      endDate: drift.Value(endDate),
      year: drift.Value(year),
      weekNumber: drift.Value(weekNumber),
      generatedAt: drift.Value(generatedAt),
      totalSteps: drift.Value(totalSteps),
      totalDistanceKm: drift.Value(totalDistanceKm),
      totalCalories: drift.Value(totalCalories),
      totalActiveMinutes: drift.Value(totalActiveMinutes),
      totalSleepMinutes: drift.Value(totalSleepMinutes),
      avgDailySteps: drift.Value(avgDailySteps),
      avgDailyDistanceKm: drift.Value(avgDailyDistanceKm),
      avgDailyCalories: drift.Value(avgDailyCalories),
      avgDailySleepMinutes: drift.Value(avgDailySleepMinutes),
      goalMetDays: drift.Value(goalMetDays),
      mostActiveDayDate: drift.Value(mostActiveDayDate),
      mostActiveDaySteps: drift.Value(mostActiveDaySteps),
      recordedDaysCount: drift.Value(recordedDaysCount),
      stepsChangePercent: drift.Value(stepsChangePercent),
      sleepChangePercent: drift.Value(sleepChangePercent),
      caloriesChangePercent: drift.Value(caloriesChangePercent),
      distanceChangePercent: drift.Value(distanceChangePercent),
      dailyBreakdownJson: drift.Value(
        jsonEncode(dailyBreakdowns.map((d) => d.toJson()).toList()),
      ),
    );
  }
}
