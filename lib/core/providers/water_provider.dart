import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class WaterProvider extends ChangeNotifier {
  static const int glassMl = 250;
  static const int maxDailyMl = 10000;

  final StorageService _storage;
  final DateTime Function() _now;
  Map<String, int> _log;

  WaterProvider(this._storage, {DateTime Function()? clock})
      : _now = clock ?? DateTime.now,
        _log = _storage.getWaterLog();

  static String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  int get todayMl => _log[dayKey(_now())] ?? 0;

  int get recommendedGoalMl {
    final ml = (_storage.userWeight * 33).round();
    return ((ml / 50).round() * 50).clamp(1500, 4500);
  }

  int get goalMl => _storage.goalWaterMl ?? recommendedGoalMl;

  double get progress => goalMl <= 0 ? 0 : (todayMl / goalMl).clamp(0.0, 1.0);

  bool get goalReached => todayMl >= goalMl;

  Map<String, int> get history => Map.unmodifiable(_log);

  List<int> lastDays(int count) {
    final today = _now();
    return List.generate(count, (i) {
      final d = DateTime(today.year, today.month, today.day).subtract(Duration(days: count - 1 - i));
      return _log[dayKey(d)] ?? 0;
    });
  }

  Future<void> add(int ml) async {
    final key = dayKey(_now());
    final next = ((_log[key] ?? 0) + ml).clamp(0, maxDailyMl);
    if (next == 0) {
      _log.remove(key);
    } else {
      _log[key] = next;
    }
    notifyListeners();
    await _storage.saveWaterLog(_log);
  }

  Future<void> setGoal(int ml) async {
    await _storage.setGoalWaterMl(ml.clamp(500, 6000));
    notifyListeners();
  }

  void reload() {
    _log = _storage.getWaterLog();
    notifyListeners();
  }
}
