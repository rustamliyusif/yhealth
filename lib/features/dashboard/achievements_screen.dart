import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/step_counter_provider.dart';
import '../../core/providers/water_provider.dart';
import '../../core/services/achievements.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../l10n/app_localizations.dart';

AchievementSummary watchAchievements(BuildContext context) {
  final auth = context.watch<AuthProvider>();
  final steps = context.watch<StepCounterProvider>();
  final water = context.watch<WaterProvider>();
  return Achievements.compute(
    stepHistory: steps.history,
    todaySteps: steps.todaySteps,
    goalSteps: auth.goalSteps,
    waterLog: water.history,
    waterGoalMl: water.goalMl,
  );
}

String badgeName(AppLocalizations l10n, String id) => switch (id) {
      'firstGoal' => l10n.badgeFirstGoal,
      'streak3' => l10n.badgeStreak3,
      'streak7' => l10n.badgeStreak7,
      'streak30' => l10n.badgeStreak30,
      'day10k' => l10n.badgeDay10k,
      'day20k' => l10n.badgeDay20k,
      'total100k' => l10n.badgeTotal100k,
      'total500k' => l10n.badgeTotal500k,
      'total1m' => l10n.badgeTotal1m,
      'water1' => l10n.badgeWater1,
      'water7' => l10n.badgeWater7,
      _ => id,
    };

String badgeDesc(AppLocalizations l10n, String id) => switch (id) {
      'firstGoal' => l10n.badgeFirstGoalDesc,
      'streak3' => l10n.badgeStreak3Desc,
      'streak7' => l10n.badgeStreak7Desc,
      'streak30' => l10n.badgeStreak30Desc,
      'day10k' => l10n.badgeDay10kDesc,
      'day20k' => l10n.badgeDay20kDesc,
      'total100k' => l10n.badgeTotal100kDesc,
      'total500k' => l10n.badgeTotal500kDesc,
      'total1m' => l10n.badgeTotal1mDesc,
      'water1' => l10n.badgeWater1Desc,
      'water7' => l10n.badgeWater7Desc,
      _ => '',
    };

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = watchAchievements(context);
    const flame = Color(0xFFF97316);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AchievementsScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderOf(context), width: 1),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: flame.withValues(alpha: s.currentStreak > 0 ? 0.15 : 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                s.currentStreak > 0 ? '🔥' : '🌱',
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${s.currentStreak}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                        TextSpan(
                          text: ' ${l10n.streakLabel}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.todayGoalReached ? l10n.streakTodayDone : l10n.streakTodayPending,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: s.todayGoalReached ? AppColors.success : AppColors.textSecondaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.streakBest(s.bestStreak)} • ${l10n.badgesEarned(s.earnedCount, s.badges.length)}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: flame,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMutedOf(context)),
          ],
        ),
      ),
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = watchAchievements(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.achievementsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(child: _stat(context, '🔥', '${s.currentStreak}', l10n.streakLabel)),
                const SizedBox(width: 10),
                Expanded(child: _stat(context, '🏅', '${s.bestStreak}', l10n.streakBestLabel)),
                const SizedBox(width: 10),
                Expanded(child: _stat(context, '👣', _compact(s.totalSteps), l10n.totalStepsLabel)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.badgesEarned(s.earnedCount, s.badges.length),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: s.badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, i) => _badge(context, l10n, s.badges[i]),
            ),
          ],
        ),
      ),
    );
  }

  static String _compact(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(v >= 100000 ? 0 : 1)}K';
    return '$v';
  }

  Widget _stat(BuildContext context, String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 11.5, color: AppColors.textSecondaryOf(context)),
          ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, AppLocalizations l10n, AchievementBadge b) {
    final accent = AppColors.primaryAccentOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: b.earned ? accent.withValues(alpha: 0.5) : AppColors.borderOf(context),
          width: b.earned ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: b.earned ? 1 : 0.35,
            child: Text(b.emoji, style: const TextStyle(fontSize: 32)),
          ),
          const Spacer(),
          Text(
            badgeName(l10n, b.id),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: b.earned ? AppColors.textPrimaryOf(context) : AppColors.textSecondaryOf(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            badgeDesc(l10n, b.id),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 11.5, color: AppColors.textSecondaryOf(context)),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: b.progress,
              minHeight: 5,
              backgroundColor: accent.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(b.earned ? accent : accent.withValues(alpha: 0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
