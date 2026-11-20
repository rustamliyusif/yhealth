import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';

class WeeklyStepBarChart extends StatelessWidget {
  final Map<String, int> history;
  final int todaySteps;
  final int goalSteps;
  final String title;

  const WeeklyStepBarChart({
    super.key,
    required this.history,
    required this.todaySteps,
    required this.goalSteps,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final daysData = _getLast7Days();
    final maxSteps = max(goalSteps, daysData.map((d) => d.steps).fold(0, max));

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
                  Icons.bar_chart_rounded,
                  color: AppColors.primaryAccentOf(context),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 145,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: daysData.map((data) {
                final heightFactor = maxSteps > 0 ? (data.steps / maxSteps).clamp(0.08, 1.0) : 0.08;
                final isGoalMet = data.steps >= goalSteps && goalSteps > 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${(data.steps / 1000).toStringAsFixed(1)}k',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: data.isToday
                            ? AppColors.primaryAccentOf(context)
                            : AppColors.textMutedOf(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Container(
                        width: 24,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2B23)
                              : const Color(0xFFEDF4F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          heightFactor: heightFactor,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: data.isToday
                                  ? AppColors.emeraldGradient
                                  : isGoalMet
                                      ? const LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Color(0xFF059669),
                                            Color(0xFF10B981),
                                          ],
                                        )
                                      : LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: isDark
                                              ? [
                                                  const Color(0xFF1F3D2F),
                                                  const Color(0xFF285440),
                                                ]
                                              : [
                                                  const Color(0xFFC7E2D3),
                                                  const Color(0xFFD9ECE1),
                                                ],
                                        ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: data.isToday
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryAccentOf(context).withValues(alpha: 0.35),
                                        blurRadius: 6,
                                        offset: const Offset(0, -2),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.dayLabel,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11.5,
                        fontWeight: data.isToday ? FontWeight.w800 : FontWeight.w600,
                        color: data.isToday
                            ? AppColors.primaryAccentOf(context)
                            : AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<_DayStepData> _getLast7Days() {
    final now = DateTime.now();
    final result = <_DayStepData>[];
    const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final steps = (i == 0) ? todaySteps : (history[dateKey] ?? 0);
      final label = weekdayNames[date.weekday - 1];

      result.add(_DayStepData(
        dayLabel: label,
        steps: steps,
        isToday: i == 0,
      ));
    }
    return result;
  }
}

class _DayStepData {
  final String dayLabel;
  final int steps;
  final bool isToday;

  _DayStepData({
    required this.dayLabel,
    required this.steps,
    required this.isToday,
  });
}
