import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Modernized Hero Radial Step Progress Gauge with vibrant emerald sweep gradient
/// and tabular typography.
class CircularStepProgress extends StatelessWidget {
  final int currentSteps;
  final int goalSteps;
  final String stepsLabel;
  final String goalLabel;

  const CircularStepProgress({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
    required this.stepsLabel,
    required this.goalLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final progress = goalSteps > 0 ? (currentSteps / goalSteps).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).toInt();
    final isGoalReached = currentSteps >= goalSteps && goalSteps > 0;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track and gradient arc
          SizedBox(
            width: 226,
            height: 226,
            child: CustomPaint(
              painter: _RingPainter(
                progress: progress,
                trackColor: isDark
                    ? const Color(0xFF1B2921)
                    : const Color(0xFFE5EFE9),
                isDark: isDark,
                strokeWidth: 16.0,
              ),
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: isGoalReached
                      ? AppColors.emeraldGradient
                      : LinearGradient(
                          colors: [
                            AppColors.primaryAccentOf(context).withValues(alpha: 0.18),
                            AppColors.primaryAccentOf(context).withValues(alpha: 0.08),
                          ],
                        ),
                  shape: BoxShape.circle,
                  boxShadow: isGoalReached
                      ? [
                          BoxShadow(
                            color: AppColors.primaryAccentOf(context).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isGoalReached
                      ? Icons.local_fire_department_rounded
                      : Icons.directions_walk_rounded,
                  color: isGoalReached ? Colors.white : AppColors.primaryAccentOf(context),
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatNumber(currentSteps),
                style: AppTypography.displayLarge(context).copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              ),
              Text(
                stepsLabel,
                style: AppTypography.labelSmall(context).copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
                decoration: BoxDecoration(
                  color: isGoalReached
                      ? (isDark
                          ? AppColors.primaryContainerOf(context)
                          : const Color(0xFFD7F2E3))
                      : (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMutedOf(context)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isGoalReached
                        ? AppColors.primaryAccentOf(context).withValues(alpha: 0.45)
                        : AppColors.borderOf(context),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isGoalReached) ...[
                      const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.primaryAccent),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '$percent% • $goalLabel',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isGoalReached
                            ? (isDark ? AppColors.primaryAccent : const Color(0xFF0F5132))
                            : AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final bool isDark;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.isDark,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 270 degree arc for an open bottom look
    const startAngle = 135 * (pi / 180);
    const sweepAngle = 270 * (pi / 180);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Progress Paint with SweepGradient
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: isDark
            ? const [
                Color(0xFF059669),
                Color(0xFF10B981),
                Color(0xFF34D399),
              ]
            : const [
                Color(0xFF1E563E),
                Color(0xFF10B981),
                Color(0xFF34D399),
              ],
        stops: const [0.0, 0.6, 1.0],
        transform: GradientRotation(startAngle),
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Glow shadow behind the arc
      final glowPaint = Paint()
        ..color = (isDark ? const Color(0xFF10B981) : const Color(0xFF10B981)).withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle * progress,
        false,
        glowPaint,
      );

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.isDark != isDark;
  }
}
