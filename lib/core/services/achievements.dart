class AchievementBadge {
  final String id;
  final String emoji;
  final bool earned;
  final double progress;

  const AchievementBadge({
    required this.id,
    required this.emoji,
    required this.earned,
    required this.progress,
  });
}

class AchievementSummary {
  final int currentStreak;
  final int bestStreak;
  final bool todayGoalReached;
  final int totalSteps;
  final List<AchievementBadge> badges;

  const AchievementSummary({
    required this.currentStreak,
    required this.bestStreak,
    required this.todayGoalReached,
    required this.totalSteps,
    required this.badges,
  });

  int get earnedCount => badges.where((b) => b.earned).length;
}

class Achievements {
  static String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static AchievementSummary compute({
    required Map<String, int> stepHistory,
    required int todaySteps,
    required int goalSteps,
    required Map<String, int> waterLog,
    required int waterGoalMl,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final todayKey = dayKey(today);
    final steps = Map<String, int>.from(stepHistory);
    final storedToday = steps[todayKey] ?? 0;
    steps[todayKey] = todaySteps > storedToday ? todaySteps : storedToday;

    final goal = goalSteps > 0 ? goalSteps : 8000;
    bool reached(DateTime d) => (steps[dayKey(d)] ?? 0) >= goal;

    final base = DateTime(today.year, today.month, today.day);
    final todayReached = reached(base);
    var current = 0;
    var cursor = todayReached ? base : base.subtract(const Duration(days: 1));
    while (reached(cursor)) {
      current++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final reachedDays = steps.entries
        .where((e) => e.value >= goal)
        .map((e) => DateTime.tryParse(e.key))
        .whereType<DateTime>()
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();
    var best = 0;
    var run = 0;
    DateTime? prev;
    for (final d in reachedDays) {
      run = (prev != null && d.difference(prev).inDays == 1) ? run + 1 : 1;
      if (run > best) best = run;
      prev = d;
    }
    if (current > best) best = current;

    final total = steps.values.fold<int>(0, (a, b) => a + b);
    final maxDay = steps.values.fold<int>(0, (a, b) => a > b ? a : b);
    final goalDays = reachedDays.length;
    final waterGoal = waterGoalMl > 0 ? waterGoalMl : 2000;
    final waterDays = waterLog.values.where((v) => v >= waterGoal).length;

    AchievementBadge ratio(String id, String emoji, num value, num target) => AchievementBadge(
          id: id,
          emoji: emoji,
          earned: value >= target,
          progress: (value / target).clamp(0.0, 1.0).toDouble(),
        );

    return AchievementSummary(
      currentStreak: current,
      bestStreak: best,
      todayGoalReached: todayReached,
      totalSteps: total,
      badges: [
        ratio('firstGoal', '🎯', goalDays, 1),
        ratio('streak3', '🔥', best, 3),
        ratio('streak7', '⚡', best, 7),
        ratio('streak30', '🏆', best, 30),
        ratio('day10k', '👟', maxDay, 10000),
        ratio('day20k', '🚀', maxDay, 20000),
        ratio('total100k', '🥉', total, 100000),
        ratio('total500k', '🥈', total, 500000),
        ratio('total1m', '🥇', total, 1000000),
        ratio('water1', '💧', waterDays, 1),
        ratio('water7', '🌊', waterDays, 7),
      ],
    );
  }
}
