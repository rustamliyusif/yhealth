import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/step_counter_provider.dart';
import '../../core/providers/sleep_provider.dart';
import '../../core/providers/water_provider.dart';
import '../../core/providers/weekly_report_provider.dart';
import '../../core/providers/weight_coach_provider.dart';
import '../../core/services/activity_recognition_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/premium_button.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/circular_step_progress.dart';
import 'widgets/stat_card.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/weekly_step_bar_chart.dart';
import '../steps/step_details_screen.dart';
import '../profile/device_compatibility_screen.dart';
import '../sleep/sleep_screen.dart';
import '../sleep/widgets/add_edit_sleep_dialog.dart';
import '../reports/weekly_reports_screen.dart';
import '../coach/weight_coach_screen.dart';
import '../coach/widgets/add_edit_weight_dialog.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onStartWalkTap;

  const DashboardScreen({super.key, required this.onStartWalkTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final stepCounter = context.watch<StepCounterProvider>();

    final distanceKm = stepCounter.calculateDistanceKm(auth.userHeight);
    final calories = stepCounter.calculateCalories(auth.userWeight);
    final activeMinutes = stepCounter.calculateActiveMinutes();

    final greeting = _getGreeting(l10n);
    final formattedDate = _getFormattedDate();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$greeting, ${auth.userName.isNotEmpty ? auth.userName.split(' ').first : 'Friend'}',
                  style: AppTypography.headlineMedium(context).copyWith(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              formattedDate,
              style: AppTypography.labelSmall(context).copyWith(
                fontSize: 12,
                color: AppColors.textSecondaryOf(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderOf(context), width: 1),
            ),
            child: IconButton(
              icon: Icon(
                Icons.analytics_outlined,
                color: AppColors.primaryAccentOf(context),
                size: 22,
              ),
              tooltip: l10n.stepStatistics,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StepDetailsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Step Ring Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.borderOf(context), width: 1),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Column(
                  children: [
                    CircularStepProgress(
                      currentSteps: stepCounter.todaySteps,
                      goalSteps: auth.goalSteps,
                      stepsLabel: l10n.stepsLabel,
                      goalLabel: l10n.goalTarget('${auth.goalSteps}'),
                    ),
                    const SizedBox(height: 22),
                    // Start Walk Hero Button
                    PremiumButton(
                      onPressed: onStartWalkTap,
                      icon: Icons.play_arrow_rounded,
                      label: l10n.quickStartWalk,
                    ),
                    const SizedBox(height: 14),
                    // Quick Action Shortcuts Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            context: context,
                            icon: Icons.bedtime_rounded,
                            label: l10n.logSleep,
                            color: AppColors.accentSleep,
                            onTap: () => _openQuickSleepLog(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionButton(
                            context: context,
                            icon: Icons.scale_rounded,
                            label: l10n.logWeight,
                            color: AppColors.accentSteps,
                            onTap: () => _openQuickWeightLog(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionButton(
                            context: context,
                            icon: Icons.psychology_rounded,
                            label: 'Coach Leo',
                            color: AppColors.accentCoach,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const WeightCoachScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3 Stat Cards Row
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: l10n.distanceLabel,
                      value: distanceKm.toStringAsFixed(1),
                      unit: l10n.kmUnit,
                      icon: Icons.route_rounded,
                      iconColor: AppColors.accentDistance,
                      iconBgColor: AppColors.accentDistance.withValues(alpha: 0.12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: l10n.caloriesLabel,
                      value: '$calories',
                      unit: l10n.kcalUnit,
                      icon: Icons.local_fire_department_rounded,
                      iconColor: AppColors.accentCalories,
                      iconBgColor: AppColors.accentCalories.withValues(alpha: 0.12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: l10n.activeTimeLabel,
                      value: '$activeMinutes',
                      unit: l10n.minUnit,
                      icon: Icons.timer_outlined,
                      iconColor: AppColors.accentTime,
                      iconBgColor: AppColors.accentTime.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildWaterCard(context, l10n),
              const SizedBox(height: 16),

              // Sleep Tracking Summary Card
              _buildSleepDashboardCard(context, l10n),
              const SizedBox(height: 16),

              // Weekly Reports Summary Card
              _buildWeeklyReportsDashboardCard(context, l10n),
              const SizedBox(height: 16),

              // AI Weight Coach Summary Card
              _buildWeightCoachDashboardCard(context, l10n),
              const SizedBox(height: 16),

              // Sensor Status Notice Card
              _buildSensorNoticeCard(context, l10n, stepCounter),
              const SizedBox(height: 16),

              // Daily Goals Card
              DailyGoalCard(
                title: l10n.dailyGoalsTitle,
                currentSteps: stepCounter.todaySteps,
                goalSteps: auth.goalSteps,
                currentCalories: calories,
                goalCalories: auth.goalCalories,
                currentDistanceKm: distanceKm,
                goalDistanceKm: auth.goalDistance,
                currentActiveMinutes: activeMinutes,
                goalActiveMinutes: auth.goalActiveTime,
                stepsLabel: l10n.stepsLabel,
                caloriesLabel: l10n.caloriesLabel,
                distanceLabel: l10n.distanceLabel,
                activeTimeLabel: l10n.activeTimeLabel,
                kmUnit: l10n.kmUnit,
                kcalUnit: l10n.kcalUnit,
                minUnit: l10n.minUnit,
              ),
              const SizedBox(height: 16),

              // Weekly Activity Bar Chart
              WeeklyStepBarChart(
                history: stepCounter.history,
                todaySteps: stepCounter.todaySteps,
                goalSteps: auth.goalSteps,
                title: l10n.weeklyOverview,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCard(BuildContext context, AppLocalizations l10n) {
    final water = context.watch<WaterProvider>();
    const color = Color(0xFF0EA5E9);
    final remaining = (water.goalMl - water.todayMl).clamp(0, water.goalMl);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderOf(context), width: 1),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.water_drop_rounded, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.waterTitle,
                      style: AppTypography.labelSmall(context).copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${water.todayMl}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                          TextSpan(
                            text: ' / ${water.goalMl} ${l10n.mlUnit}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondaryOf(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.tune_rounded, size: 20, color: AppColors.textSecondaryOf(context)),
                tooltip: l10n.waterGoalTitle,
                onPressed: () => _editWaterGoal(context, l10n),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: water.progress,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            water.goalReached ? l10n.waterGoalReached : l10n.waterRemaining('$remaining'),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: water.goalReached ? AppColors.success : AppColors.textSecondaryOf(context),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _waterButton(
                context,
                icon: Icons.remove_rounded,
                label: '${WaterProvider.glassMl}',
                color: AppColors.textSecondaryOf(context),
                onTap: water.todayMl > 0 ? () => water.add(-WaterProvider.glassMl) : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _waterButton(
                  context,
                  icon: Icons.add_rounded,
                  label: '${WaterProvider.glassMl} ${l10n.mlUnit}',
                  color: color,
                  onTap: () => water.add(WaterProvider.glassMl),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _waterButton(
                  context,
                  icon: Icons.add_rounded,
                  label: '500 ${l10n.mlUnit}',
                  color: color,
                  onTap: () => water.add(500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _waterButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    final c = enabled ? color : color.withValues(alpha: 0.4);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: c),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: c,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editWaterGoal(BuildContext context, AppLocalizations l10n) async {
    final water = context.read<WaterProvider>();
    final controller = TextEditingController(text: '${water.goalMl}');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.waterGoalTitle, style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(suffixText: l10n.mlUnit),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.waterRecommended('${water.recommendedGoalMl}'),
              style: AppTypography.labelSmall(ctx).copyWith(color: AppColors.textSecondaryOf(ctx)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(int.tryParse(controller.text.trim())),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      await water.setGoal(result);
    }
  }

  void _openQuickSleepLog(BuildContext context) {
    final sleep = context.read<SleepProvider>();
    showDialog(
      context: context,
      builder: (_) => AddEditSleepDialog(
        onSave: (bedtime, wakeTime, date, notes, efficiency) async {
          await sleep.addSleepRecord(
            bedtime: bedtime,
            wakeTime: wakeTime,
            referenceDate: date,
            notes: notes,
            efficiencyPercent: efficiency,
          );
        },
      ),
    );
  }

  void _openQuickWeightLog(BuildContext context) {
    final coach = context.read<WeightCoachProvider>();
    showDialog(
      context: context,
      builder: (_) => AddEditWeightDialog(
        currentWeight: coach.currentWeight,
        onSave: (w, n, d) => coach.logWeight(weightKg: w, notes: n, date: d),
      ),
    );
  }

  Widget _buildSensorNoticeCard(
    BuildContext context,
    AppLocalizations l10n,
    StepCounterProvider stepCounter,
  ) {
    final isActive = stepCounter.isSensorActive;
    final currentActivity = stepCounter.currentActivity;
    final activityName = _getActivityName(currentActivity, l10n);
    final activityColor = _getActivityColor(currentActivity);
    final activityIcon = _getActivityIcon(currentActivity);

    final activeSensorType = stepCounter.deviceCompatibility?.activeSensorType;
    String sensorSubtitle;
    if (activeSensorType == 'counter') {
      sensorSubtitle = l10n.sensorCounterPrimary;
    } else if (activeSensorType == 'detector') {
      sensorSubtitle = l10n.sensorDetectorAlternative;
    } else {
      sensorSubtitle = isActive ? l10n.sensorActive : l10n.sensorUnavailable;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderOf(context), width: 1),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.success : AppColors.warning,
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? AppColors.success : AppColors.warning).withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sensorSubtitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
              // Live Activity Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: activityColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(activityIcon, color: activityColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      activityName,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: activityColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.sensorExplanation,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11.5,
                    color: AppColors.textSecondaryOf(context),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DeviceCompatibilityScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMutedOf(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primaryAccentOf(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getActivityName(HumanActivityType type, AppLocalizations l10n) {
    switch (type) {
      case HumanActivityType.still:
        return l10n.activityStill;
      case HumanActivityType.walking:
        return l10n.activityWalking;
      case HumanActivityType.running:
        return l10n.activityRunning;
      case HumanActivityType.onBicycle:
        return l10n.activityBicycle;
      case HumanActivityType.inVehicle:
        return l10n.activityVehicle;
    }
  }

  IconData _getActivityIcon(HumanActivityType type) {
    switch (type) {
      case HumanActivityType.still:
        return Icons.accessibility_new_rounded;
      case HumanActivityType.walking:
        return Icons.directions_walk_rounded;
      case HumanActivityType.running:
        return Icons.directions_run_rounded;
      case HumanActivityType.onBicycle:
        return Icons.directions_bike_rounded;
      case HumanActivityType.inVehicle:
        return Icons.directions_car_rounded;
    }
  }

  Color _getActivityColor(HumanActivityType type) {
    switch (type) {
      case HumanActivityType.still:
        return const Color(0xFF6B7280);
      case HumanActivityType.walking:
        return const Color(0xFF10B981);
      case HumanActivityType.running:
        return const Color(0xFF059669);
      case HumanActivityType.onBicycle:
        return const Color(0xFF3B82F6);
      case HumanActivityType.inVehicle:
        return const Color(0xFFF59E0B);
    }
  }

  Widget _buildSleepDashboardCard(BuildContext context, AppLocalizations l10n) {
    final sleep = context.watch<SleepProvider>();
    final lastNight = sleep.lastNightSleep;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SleepScreen()),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderOf(context)),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF4F46E5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.bedtime_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.sleepTrackingTitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondaryOf(context)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (lastNight != null) ...[
                    Row(
                      children: [
                        Text(
                          lastNight.formattedDuration,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryAccentOf(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${lastNight.efficiencyPercent}% efficiency',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'No sleep recorded yet • Tap to log',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.5,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyReportsDashboardCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final reportProvider = context.watch<WeeklyReportProvider>();
    final latestReport = reportProvider.reports.isNotEmpty ? reportProvider.reports.first : null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WeeklyReportsScreen()),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderOf(context), width: 1),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D9488),
                    Color(0xFF14B8A6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.weeklySummary,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondaryOf(context)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (latestReport != null) ...[
                    Row(
                      children: [
                        Text(
                          '${latestReport.totalSteps} steps',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${latestReport.goalMetDays}/7 days met',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'Automated Monday report • Tap to view',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.5,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightCoachDashboardCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final coach = context.watch<WeightCoachProvider>();
    final analysis = coach.currentAnalysis;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WeightCoachScreen()),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderOf(context), width: 1),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF6D28D9),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.weightCoachTitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Coach Leo',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryAccentOf(context),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondaryOf(context)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '${coach.currentWeight} kg → ${coach.targetWeight} kg',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• ${analysis.targetDailyKcal} kcal/day',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l10n.greetingMorning;
    } else if (hour < 18) {
      return l10n.greetingAfternoon;
    } else {
      return l10n.greetingEvening;
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    return '$dayName, $monthName ${now.day}';
  }
}
