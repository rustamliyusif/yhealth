import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import 'storage_service.dart';

class CsvExportService {
  static const List<String> header = [
    'date',
    'steps',
    'goal_steps',
    'goal_reached',
    'distance_km',
    'calories',
    'active_minutes',
    'sleep_minutes',
    'sleep_hours',
    'bedtime',
    'wake_time',
    'weight_kg',
    'bmi',
    'water_ml',
  ];

  final AppDatabase _db;
  final StorageService _storage;

  CsvExportService(this._db, this._storage);

  static String _two(int v) => v.toString().padLeft(2, '0');
  static String _time(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';
  static String _num(double v, int digits) => v.toStringAsFixed(digits);

  Future<String> buildCsv({Map<String, int> liveStepHistory = const {}, String? todayKey, int todaySteps = 0}) async {
    final activities = await _db.select(_db.dailyActivityEntries).get();
    final sleeps = await _db.select(_db.sleepRecordsEntries).get();
    final weights = await _db.select(_db.weightRecordsEntries).get();
    final water = _storage.getWaterLog();
    final storedSteps = _storage.getStepHistory();

    final height = _storage.userHeight;
    final bodyWeight = _storage.userWeight;
    final goal = _storage.goalSteps;

    final rows = <String, Map<String, Object?>>{};
    Map<String, Object?> row(String date) => rows.putIfAbsent(date, () => {'date': date});

    void putSteps(String date, int steps, {int? goalSteps}) {
      final r = row(date);
      final existing = (r['steps'] as int?) ?? 0;
      if (steps < existing) return;
      final g = goalSteps ?? (r['goal_steps'] as int?) ?? goal;
      final stride = height * 0.414 / 100.0;
      r['steps'] = steps;
      r['goal_steps'] = g;
      r['goal_reached'] = steps >= g ? 1 : 0;
      r['distance_km'] = _num(steps * stride / 1000.0, 2);
      r['calories'] = (steps * 0.042 * (bodyWeight / 70.0).clamp(0.7, 1.5)).round();
      r['active_minutes'] = (steps / 100).round();
    }

    for (final a in activities) {
      final r = row(a.date);
      r['steps'] = a.steps;
      r['goal_steps'] = a.goalSteps;
      r['goal_reached'] = a.steps >= a.goalSteps ? 1 : 0;
      r['distance_km'] = _num(a.distanceKm, 2);
      r['calories'] = a.calories;
      r['active_minutes'] = a.activeMinutes;
    }
    storedSteps.forEach((d, s) => putSteps(d, s));
    liveStepHistory.forEach((d, s) => putSteps(d, s));
    if (todayKey != null && todaySteps > 0) putSteps(todayKey, todaySteps);

    final sleepByDate = <String, List<SleepRecordsEntry>>{};
    for (final s in sleeps) {
      sleepByDate.putIfAbsent(s.date, () => []).add(s);
    }
    sleepByDate.forEach((date, list) {
      list.sort((a, b) => a.bedtime.compareTo(b.bedtime));
      final minutes = list.fold<int>(0, (sum, s) => sum + s.durationMinutes);
      final r = row(date);
      r['sleep_minutes'] = minutes;
      r['sleep_hours'] = _num(minutes / 60.0, 2);
      r['bedtime'] = _time(list.first.bedtime);
      r['wake_time'] = _time(list.last.wakeTime);
    });

    final sortedWeights = [...weights]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    for (final w in sortedWeights) {
      final r = row(w.date);
      r['weight_kg'] = _num(w.weightKg, 1);
      r['bmi'] = _num(w.bmi, 1);
    }

    water.forEach((date, ml) {
      if (ml > 0) row(date)['water_ml'] = ml;
    });

    final dates = rows.keys.toList()..sort();
    final buffer = StringBuffer()..writeln(header.join(','));
    for (final d in dates) {
      final r = rows[d]!;
      buffer.writeln(header.map((h) => r[h]?.toString() ?? '').join(','));
    }
    return buffer.toString();
  }

  Future<String> exportToFile({Map<String, int> liveStepHistory = const {}, String? todayKey, int todaySteps = 0}) async {
    final csv = await buildCsv(liveStepHistory: liveStepHistory, todayKey: todayKey, todaySteps: todaySteps);
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final file = File(p.join(dir.path, 'yhealth-data-${now.year}${_two(now.month)}${_two(now.day)}.csv'));
    await file.writeAsString('﻿$csv', flush: true);
    return file.path;
  }
}
