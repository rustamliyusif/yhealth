import 'package:flutter_test/flutter_test.dart';
import 'package:yhealth/core/services/daily_tip.dart';

DailyTipInput input({
  int hour = 10,
  int steps = 0,
  int yesterday = 8000,
  int streak = 0,
  bool reached = false,
  int? sleep,
  int water = 1000,
}) {
  final now = DateTime(2026, 11, 24, hour);
  return DailyTipInput(
    now: now,
    todaySteps: steps,
    goalSteps: 8000,
    yesterdaySteps: yesterday,
    currentStreak: streak,
    todayGoalReached: reached,
    lastSleepMinutes: sleep,
    lastSleepWake: sleep == null ? null : DateTime(2026, 11, 24, 7),
    waterMl: water,
    waterGoalMl: 2500,
  );
}

void main() {
  test('Short sleep tip has priority in the morning', () {
    final tip = DailyTipEngine.build(input(sleep: 300), az: true);
    expect(tip.emoji, '😴');
    expect(tip.text, contains('5.0 saat'));
  });

  test('Evening nudge when close to goal', () {
    final tip = DailyTipEngine.build(input(hour: 19, steps: 6500), az: false);
    expect(tip.emoji, '🎯');
    expect(tip.text, contains('1 500 steps'));
  });

  test('Streak celebration after goal is reached', () {
    final tip = DailyTipEngine.build(input(hour: 20, steps: 9000, reached: true, streak: 4), az: true);
    expect(tip.emoji, '🔥');
    expect(tip.text, contains('4 gündür'));
  });

  test('Low water tip in the afternoon', () {
    final tip = DailyTipEngine.build(input(hour: 13, steps: 3000, water: 250), az: false);
    expect(tip.emoji, '💧');
  });

  test('Falls back to a rotating general tip', () {
    final tip = DailyTipEngine.build(input(hour: 11, steps: 3000), az: true);
    expect(tip.text, isNotEmpty);
  });
}
