import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';

class DailyGoalCard extends StatelessWidget {
  final String title;
  final int currentSteps;
  final int goalSteps;
  final int currentCalories;
  final int goalCalories;
  final double currentDistanceKm;
  final double goalDistanceKm;
  final int currentActiveMinutes;
  final int goalActiveMinutes;

  final String stepsLabel;
  final String caloriesLabel;
  final String distanceLabel;
  final String activeTimeLabel;
  final String kmUnit;
  final String kcalUnit;
  final String minUnit;

  const DailyGoalCard({
    super.key,
    required this.title,
    required this.currentSteps,
    required this.goalSteps,
    required this.currentCalories,
    required this.goalCalories,
    required this.currentDistanceKm,
    required this.goalDistanceKm,
    required this.currentActiveMinutes,
    required this.goalActiveMinutes,
    required this.stepsLabel,
    required this.caloriesLabel,
    required this.distanceLabel,
    required this.activeTimeLabel,
    required this.kmUnit,
    required this.kcalUnit,
    required this.minUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderOf(context), width: 1),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium(context).copyWith(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.primaryAccentOf(context),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildGoalRow(
            context: context,
            icon: Icons.directions_walk_rounded,
            label: stepsLabel,
            current: '$currentSteps',
            goal: '$goalSteps',
            progress: goalSteps > 0 ? (currentSteps / goalSteps).clamp(0.0, 1.0) : 0.0,
            color: AppColors.accentSteps,
          ),
          const SizedBox(height: 14),
          _buildGoalRow(
            context: context,
            icon: Icons.local_fire_department_rounded,
            label: caloriesLabel,
            current: '$currentCalories $kcalUnit',
            goal: '$goalCalories $kcalUnit',
            progress: goalCalories > 0 ? (currentCalories / goalCalories).clamp(0.0, 1.0) : 0.0,
            color: AppColors.accentCalories,
          ),
          const SizedBox(height: 14),
          _buildGoalRow(
            context: context,
            icon: Icons.route_rounded,
            label: distanceLabel,
            current: '${currentDistanceKm.toStringAsFixed(1)} $kmUnit',
            goal: '${goalDistanceKm.toStringAsFixed(1)} $kmUnit',
            progress: goalDistanceKm > 0 ? (currentDistanceKm / goalDistanceKm).clamp(0.0, 1.0) : 0.0,
            color: AppColors.accentDistance,
          ),
          const SizedBox(height: 14),
          _buildGoalRow(
            context: context,
            icon: Icons.timer_outlined,
            label: activeTimeLabel,
            current: '$currentActiveMinutes $minUnit',
            goal: '$goalActiveMinutes $minUnit',
            progress: goalActiveMinutes > 0 ? (currentActiveMinutes / goalActiveMinutes).clamp(0.0, 1.0) : 0.0,
            color: AppColors.accentTime,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String current,
    required String goal,
    required double progress,
    required Color color,
  }) {
    final percent = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelSmall(context).copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ),
            Text(
              '$current / $goal',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$percent%',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
