import 'package:flutter_test/flutter_test.dart';
import 'package:yhealth/core/services/achievements.dart';

void main() {
  final now = DateTime(2026, 11, 24, 18);

  AchievementSummary run(Map<String, int> history, int today, {Map<String, int> water = const {}}) =>
      Achievements.compute(
        stepHistory: history,
        todaySteps: today,
        goalSteps: 8000,
        waterLog: water,
        waterGoalMl: 2000,
        now: now,
      );

  test('Current streak counts back from yesterday when today is not reached yet', () {
    final s = run({'2026-11-21': 9000, '2026-11-22': 8500, '2026-11-23': 8000}, 3000);
    expect(s.currentStreak, 3);
    expect(s.todayGoalReached, isFalse);
  });

  test('Current streak includes today once the goal is reached', () {
    final s = run({'2026-11-22': 9000, '2026-11-23': 8500}, 8100);
    expect(s.currentStreak, 3);
    expect(s.todayGoalReached, isTrue);
  });

  test('A missed day breaks the current streak but best streak is kept', () {
    final s = run({
      '2026-11-10': 9000,
      '2026-11-11': 9000,
      '2026-11-12': 9000,
      '2026-11-13': 9000,
      '2026-11-22': 2000,
      '2026-11-23': 9000,
    }, 1000);
    expect(s.currentStreak, 1);
    expect(s.bestStreak, 4);
  });

  test('Badges unlock from totals, peaks and water days', () {
    final s = run({'2026-11-20': 21000, '2026-11-21': 100000}, 0, water: {'2026-11-23': 2100});
    final earned = s.badges.where((b) => b.earned).map((b) => b.id).toSet();
    expect(earned, containsAll(['firstGoal', 'day10k', 'day20k', 'total100k', 'water1']));
    expect(earned.contains('streak3'), isFalse);
    expect(s.badges.firstWhere((b) => b.id == 'streak3').progress, closeTo(2 / 3, 0.001));
  });
}
