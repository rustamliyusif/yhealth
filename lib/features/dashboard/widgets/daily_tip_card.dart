import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/providers/sleep_provider.dart';
import '../../../core/providers/step_counter_provider.dart';
import '../../../core/providers/water_provider.dart';
import '../../../core/services/achievements.dart';
import '../../../core/services/daily_tip.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../l10n/app_localizations.dart';
import '../../coach/weight_coach_screen.dart';
import '../achievements_screen.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final az = context.watch<LanguageProvider>().isAzerbaijani;
    final auth = context.watch<AuthProvider>();
    final steps = context.watch<StepCounterProvider>();
    final sleep = context.watch<SleepProvider>().lastNightSleep;
    final water = context.watch<WaterProvider>();
    final summary = watchAchievements(context);

    final now = DateTime.now();
    final yesterday = Achievements.dayKey(now.subtract(const Duration(days: 1)));
    final tip = DailyTipEngine.build(
      DailyTipInput(
        now: now,
        todaySteps: steps.todaySteps,
        goalSteps: auth.goalSteps,
        yesterdaySteps: steps.history[yesterday] ?? 0,
        currentStreak: summary.currentStreak,
        todayGoalReached: summary.todayGoalReached,
        lastSleepMinutes: sleep?.durationMinutes,
        lastSleepWake: sleep?.wakeTime,
        waterMl: water.todayMl,
        waterGoalMl: water.goalMl,
      ),
      az: az,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WeightCoachScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accentCoach.withValues(alpha: 0.35), width: 1),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accentCoach.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(tip.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coach Leo • ${l10n.coachTipTitle}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentCoach,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.text,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13.5,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
