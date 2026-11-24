class DailyTipInput {
  final DateTime now;
  final int todaySteps;
  final int goalSteps;
  final int yesterdaySteps;
  final int currentStreak;
  final bool todayGoalReached;
  final int? lastSleepMinutes;
  final DateTime? lastSleepWake;
  final int waterMl;
  final int waterGoalMl;

  const DailyTipInput({
    required this.now,
    required this.todaySteps,
    required this.goalSteps,
    required this.yesterdaySteps,
    required this.currentStreak,
    required this.todayGoalReached,
    required this.lastSleepMinutes,
    required this.lastSleepWake,
    required this.waterMl,
    required this.waterGoalMl,
  });
}

class DailyTip {
  final String emoji;
  final String text;

  const DailyTip(this.emoji, this.text);
}

class DailyTipEngine {
  static String _n(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
      b.write(s[i]);
    }
    return b.toString();
  }

  static DailyTip build(DailyTipInput i, {required bool az}) {
    final hour = i.now.hour;
    final goal = i.goalSteps > 0 ? i.goalSteps : 8000;
    final remaining = goal - i.todaySteps;

    final sleptLastNight = i.lastSleepMinutes != null &&
        i.lastSleepWake != null &&
        i.now.difference(i.lastSleepWake!).inHours < 18;
    if (sleptLastNight && i.lastSleepMinutes! < 360 && hour < 14) {
      final h = (i.lastSleepMinutes! / 60).toStringAsFixed(1);
      return DailyTip(
        '😴',
        az
            ? 'Dünən gecə cəmi $h saat yatmısan. Bu gün ağır məşq əvəzinə yüngül gəzinti seç və axşam tez yat.'
            : 'You slept only $h hours last night. Pick a light walk over a hard workout today and go to bed early.',
      );
    }

    if (i.todayGoalReached) {
      if (i.currentStreak >= 3) {
        return DailyTip(
          '🔥',
          az
              ? '${i.currentStreak} gündür hədəfə çatırsan. Sabah da davam et, seriya qırılmasın.'
              : "You've hit your goal ${i.currentStreak} days in a row. Keep it going tomorrow.",
        );
      }
      return DailyTip(
        '🎉',
        az
            ? 'Bugünkü addım hədəfin tamamdır. İndi bərpa vaxtıdır: su iç və yaxşı yat.'
            : "Today's step goal is done. Now recover: drink water and sleep well.",
      );
    }

    if (hour >= 17 && remaining > 0 && remaining <= 3000) {
      final minutes = (remaining / 100).ceil();
      return DailyTip(
        '🎯',
        az
            ? 'Hədəfə ${_n(remaining)} addım qalıb. Təxminən $minutes dəqiqəlik gəzinti kifayətdir.'
            : '${_n(remaining)} steps to go. About a $minutes-minute walk will do it.',
      );
    }

    if (i.currentStreak >= 2 && hour >= 15) {
      return DailyTip(
        '⚡',
        az
            ? '${i.currentStreak} günlük seriyan var. Bu gün də hədəfə çatsan, seriya davam edəcək.'
            : "You're on a ${i.currentStreak}-day streak. Reach today's goal to keep it alive.",
      );
    }

    if (hour >= 12 && i.waterGoalMl > 0 && i.waterMl < i.waterGoalMl * 0.3) {
      return DailyTip(
        '💧',
        az
            ? 'Bu gün az su içmisən (${i.waterMl} ml). İndi bir stəkan su iç, yorğunluğu azaldır.'
            : "You've had little water today (${i.waterMl} ml). Drink a glass now; it helps with fatigue.",
      );
    }

    if (i.yesterdaySteps > 0 && i.yesterdaySteps < goal * 0.5 && hour < 12) {
      return DailyTip(
        '🌅',
        az
            ? 'Dünən az hərəkət etmisən. Bu gün səhər 10 dəqiqəlik gəzinti ilə başla, günün qalanı asan gələcək.'
            : 'Yesterday was a quiet day. Start today with a 10-minute walk; the rest gets easier.',
      );
    }

    final general = az
        ? const [
            DailyTip('🚶', 'Telefonla danışanda ayağa qalx və gəz. Gün ərzində minlərlə əlavə addım deməkdir.'),
            DailyTip('🥗', 'Hər yeməkdə boşqabın yarısını tərəvəz et. Kalorini azaldır, toxluğu artırır.'),
            DailyTip('🪜', 'Lift əvəzinə pilləkəndən istifadə et. Qısa, amma ürək üçün faydalı məşqdir.'),
            DailyTip('🌙', 'Yatmazdan 1 saat əvvəl ekranı kənara qoy. Yuxun daha dərin olacaq.'),
            DailyTip('🍽️', 'Yeməkdən sonra 10 dəqiqə gəz. Qanda şəkərin qalxmasını azaldır.'),
            DailyTip('💧', 'Səhər ilk iş bir stəkan su iç. Bədən gecədən sonra susuz oyanır.'),
            DailyTip('⏰', 'Hər gün eyni saatda oyan, həftəsonu da. Bədən saatın sabitləşir.'),
          ]
        : const [
            DailyTip('🚶', 'Stand up and walk during phone calls. It adds thousands of steps over a day.'),
            DailyTip('🥗', 'Make half your plate vegetables. Fewer calories, more fullness.'),
            DailyTip('🪜', 'Take the stairs instead of the lift. Short, but good for your heart.'),
            DailyTip('🌙', 'Put screens away an hour before bed. Your sleep will be deeper.'),
            DailyTip('🍽️', 'Walk for 10 minutes after meals. It reduces blood sugar spikes.'),
            DailyTip('💧', 'Drink a glass of water first thing in the morning. You wake up dehydrated.'),
            DailyTip('⏰', 'Wake up at the same time every day, weekends too. It steadies your body clock.'),
          ];
    final dayOfYear = i.now.difference(DateTime(i.now.year)).inDays;
    return general[dayOfYear % general.length];
  }
}
