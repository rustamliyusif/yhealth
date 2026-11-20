import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/step_counter_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

class StepDetailsScreen extends StatelessWidget {
  const StepDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stepCounter = context.watch<StepCounterProvider>();
    final auth = context.watch<AuthProvider>();

    final distanceKm = stepCounter.calculateDistanceKm(auth.userHeight);
    final calories = stepCounter.calculateCalories(auth.userWeight);

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.stepStatistics,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Big Hero Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderOf(context)),
                boxShadow: AppDecorations.cardShadow(context),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 16,
                          color: AppColors.primaryAccentOf(context),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          l10n.todayProgress,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryAccentOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${stepCounter.todaySteps}',
                    style: AppTypography.displayLarge(context).copyWith(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryAccentOf(context),
                      letterSpacing: -1.5,
                    ),
                  ),
                  Text(
                    l10n.dailySteps,
                    style: AppTypography.labelSmall(context).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMutedOf(context),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryStat(
                          context: context,
                          label: l10n.distanceLabel,
                          value: '${distanceKm.toStringAsFixed(2)} ${l10n.kmUnit}',
                          color: AppColors.accentDistance,
                          icon: Icons.route_rounded,
                        ),
                        Container(width: 1, height: 32, color: AppColors.dividerOf(context)),
                        _buildSummaryStat(
                          context: context,
                          label: l10n.caloriesLabel,
                          value: '$calories ${l10n.kcalUnit}',
                          color: AppColors.accentCalories,
                          icon: Icons.local_fire_department_rounded,
                        ),
                        Container(width: 1, height: 32, color: AppColors.dividerOf(context)),
                        _buildSummaryStat(
                          context: context,
                          label: l10n.activeTimeLabel,
                          value: '${stepCounter.calculateActiveMinutes()} ${l10n.minUnit}',
                          color: AppColors.accentTime,
                          icon: Icons.timer_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Activity History Section (Drift SQLite persistence)
            StreamBuilder<List<DailyActivityEntry>>(
              stream: stepCounter.watchDailyHistory(limit: 30),
              builder: (context, snapshot) {
                final entries = snapshot.data ?? [];
                if (entries.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.dailySummary,
                          style: AppTypography.titleMedium(context).copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccentOf(context).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${entries.length} records',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryAccentOf(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...entries.map((entry) => _buildDailyHistoryItem(context, entry, l10n, isDark)),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),

            // Hardware Sensor Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.borderOf(context)),
                boxShadow: AppDecorations.cardShadow(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: stepCounter.isSensorActive
                              ? (isDark ? AppColors.primaryAccent.withValues(alpha: 0.2) : AppColors.primaryContainer)
                              : AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          stepCounter.isSensorActive
                              ? Icons.sensors_rounded
                              : Icons.sensors_off_rounded,
                          color: stepCounter.isSensorActive
                              ? AppColors.primaryAccentOf(context)
                              : AppColors.warning,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.hardwareSensorStatus,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryOf(context),
                              ),
                            ),
                            Text(
                              stepCounter.isSensorActive
                                  ? l10n.sensorActive
                                  : l10n.sensorUnavailable,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: stepCounter.isSensorActive
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.sensorExplanation,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      color: AppColors.textSecondaryOf(context),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.sensorCompatibilityNotice,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textMutedOf(context),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            if (kDebugMode) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surfaceMutedOf(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.simulateStepTitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.simulateStepDesc,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.5,
                      color: AppColors.textSecondaryOf(context),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => stepCounter.addSimulatedSteps(500),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(l10n.addTestSteps),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      if (stepCounter.simulatedSteps > 0) ...[
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () => stepCounter.resetSimulatedSteps(),
                          icon: Icon(Icons.refresh_rounded, color: AppColors.textSecondaryOf(context)),
                          tooltip: 'Reset',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            fontSize: 11,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyHistoryItem(
    BuildContext context,
    DailyActivityEntry entry,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final now = DateTime.now();
    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayKey =
        "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    String dateLabel = entry.date;
    if (entry.date == todayKey) {
      dateLabel = '${l10n.today} (${entry.date})';
    } else if (entry.date == yesterdayKey) {
      dateLabel = '${l10n.yesterday} (${entry.date})';
    }

    final isGoalAchieved = entry.isGoalCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isGoalAchieved
              ? AppColors.primaryAccentOf(context).withValues(alpha: 0.35)
              : AppColors.borderOf(context),
        ),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 15,
                    color: AppColors.textSecondaryOf(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
              if (isGoalAchieved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 13, color: AppColors.primaryAccentOf(context)),
                      const SizedBox(width: 4),
                      Text(
                        l10n.goalReached.split('!').first,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryAccentOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.steps}',
                      style: AppTypography.displayMedium(context).copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryAccentOf(context),
                      ),
                    ),
                    Text(
                      l10n.dailySteps,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              _buildCompactStat(
                label: l10n.distanceLabel,
                value: '${entry.distanceKm.toStringAsFixed(2)} ${l10n.kmUnit}',
                color: AppColors.accentDistance,
                context: context,
              ),
              const SizedBox(width: 14),
              _buildCompactStat(
                label: l10n.caloriesLabel,
                value: '${entry.calories} ${l10n.kcalUnit}',
                color: AppColors.accentCalories,
                context: context,
              ),
              const SizedBox(width: 14),
              _buildCompactStat(
                label: l10n.activeTimeLabel,
                value: '${entry.activeMinutes} ${l10n.minUnit}',
                color: AppColors.accentTime,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 10,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}
