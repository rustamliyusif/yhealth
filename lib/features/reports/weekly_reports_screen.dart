import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/models/weekly_report_model.dart';
import '../../core/providers/weekly_report_provider.dart';
import '../../core/services/share_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/premium_button.dart';
import '../../l10n/app_localizations.dart';

/// Screen displaying comprehensive automated weekly health summaries,
/// 7-day bar chart breakdowns, week-over-week deltas, and PDF export.
class WeeklyReportsScreen extends StatelessWidget {
  const WeeklyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final reportProvider = context.watch<WeeklyReportProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.weeklyReportsTitle,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
        ),
        actions: [
          if (reportProvider.selectedReport != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderOf(context), width: 1),
              ),
              child: IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF0D9488), size: 20),
                tooltip: l10n.exportPdf,
                onPressed: () async {
                  final path = await reportProvider.exportPdf(
                    reportProvider.selectedReport!,
                    languageCode: Localizations.localeOf(context).languageCode,
                  );
                  if (path == null) return;
                  final shared = await ShareService.sharePdf(path, title: l10n.exportPdf);
                  if (context.mounted && !shared) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.pdfExportSuccess),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                },
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderOf(context), width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: AppColors.primaryAccentOf(context), size: 20),
              tooltip: 'Refresh / Check Reports',
              onPressed: () => reportProvider.checkAndGenerateCatchUpReports(),
            ),
          ),
        ],
      ),
      body: reportProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reportProvider.reports.isEmpty
              ? _buildEmptyState(context, l10n, reportProvider)
              : _buildReportContent(context, l10n, theme, reportProvider),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    WeeklyReportProvider provider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.analytics_outlined,
                size: 60,
                color: Color(0xFF0D9488),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              l10n.noReportsYet,
              style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.weeklyReportsSubtitle,
              style: AppTypography.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PremiumButton(
              onPressed: () => provider.forceGenerateReportForDate(DateTime.now()),
              icon: Icons.bolt_rounded,
              label: l10n.generateNow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportContent(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    WeeklyReportProvider provider,
  ) {
    final report = provider.selectedReport ?? provider.reports.first;
    final allReports = provider.reports;
    final currentIndex = allReports.indexWhere((r) => r.id == report.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Week Navigator Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.borderOf(context)),
              boxShadow: AppDecorations.cardShadow(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 24),
                  onPressed: currentIndex < allReports.length - 1
                      ? () => provider.selectReport(allReports[currentIndex + 1])
                      : null,
                ),
                Column(
                  children: [
                    Text(
                      '${l10n.weekNumberLabel} ${report.weekNumber}, ${report.year}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.startDate}  –  ${report.endDate}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, size: 24),
                  onPressed: currentIndex > 0
                      ? () => provider.selectReport(allReports[currentIndex - 1])
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Most Active Day Highlight
          _buildMostActiveDayCard(context, l10n, report),
          const SizedBox(height: 14),

          // KPI Grid Cards
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  context,
                  title: 'Total Steps',
                  value: '${report.totalSteps}',
                  delta: report.stepsChangePercent,
                  icon: Icons.directions_walk_rounded,
                  color: AppColors.accentSteps,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKpiCard(
                  context,
                  title: 'Distance',
                  value: report.formattedTotalDistance,
                  delta: report.distanceChangePercent,
                  icon: Icons.map_outlined,
                  color: AppColors.accentDistance,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  context,
                  title: 'Calories',
                  value: '${report.totalCalories} kcal',
                  delta: report.caloriesChangePercent,
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.accentCalories,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKpiCard(
                  context,
                  title: l10n.avgSleepPerNight,
                  value: report.formattedAvgDailySleep,
                  delta: report.sleepChangePercent,
                  icon: Icons.bedtime_rounded,
                  color: AppColors.accentSleep,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  context,
                  title: 'Active Time',
                  value: '${report.totalActiveMinutes} min',
                  delta: null,
                  icon: Icons.timer_outlined,
                  color: AppColors.accentTime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKpiCard(
                  context,
                  title: l10n.goalsMet,
                  value: '${report.goalMetDays} / 7 days',
                  delta: null,
                  subtext: '${report.goalCompletionPercent}% target',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 7-Day Steps Bar Chart
          _buildStepsChart(context, theme, report),
          const SizedBox(height: 18),

          // Daily Breakdown Section Header
          Text(
            l10n.dailyBreakdown,
            style: AppTypography.titleMedium(context).copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...report.dailyBreakdowns.map((d) => _buildDayBreakdownItem(context, l10n, d)),

          const SizedBox(height: 22),

          // PDF Export Button
          PremiumButton(
            onPressed: () async {
              final path = await provider.exportPdf(
                report,
                languageCode: Localizations.localeOf(context).languageCode,
              );
              if (path == null) return;
              final shared = await ShareService.sharePdf(path, title: l10n.exportPdf);
              if (context.mounted && !shared) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.pdfExportSuccess),
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            icon: Icons.picture_as_pdf_rounded,
            label: l10n.exportPdf,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0D9488),
                Color(0xFF14B8A6),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMostActiveDayCard(
    BuildContext context,
    AppLocalizations l10n,
    WeeklyReportModel report,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.mostActiveDay,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color(0xFFB45309),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${report.mostActiveDayDate} • ${report.mostActiveDaySteps} steps',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    double? delta,
    String? subtext,
  }) {
    final isPositive = (delta ?? 0) >= 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 4),
          if (delta != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${isPositive ? "+" : ""}${delta.toStringAsFixed(1)}% vs prev',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? Colors.green[800] : Colors.deepOrange[800],
                ),
              ),
            ),
          ] else if (subtext != null) ...[
            Text(
              subtext,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: AppColors.textMutedOf(context),
                fontSize: 10.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepsChart(BuildContext context, ThemeData theme, WeeklyReportModel report) {
    final maxY = report.dailyBreakdowns.fold<double>(
      10000.0,
      (max, d) => d.steps > max ? d.steps.toDouble() * 1.15 : max,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Step Progress',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey[800]!,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = report.dailyBreakdowns[group.x.toInt()];
                      return BarTooltipItem(
                        '${day.dayName}\n${day.steps} steps',
                        const TextStyle(color: Colors.white, fontSize: 11),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < report.dailyBreakdowns.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              report.dailyBreakdowns[idx].dayName,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: report.dailyBreakdowns.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final day = entry.value;
                  final isMostActive = day.date == report.mostActiveDayDate && day.steps > 0;

                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: day.steps.toDouble(),
                        color: isMostActive
                            ? const Color(0xFFF59E0B)
                            : day.isGoalMet
                                ? AppColors.primaryAccentOf(context)
                                : day.isMissing
                                    ? Colors.grey.withValues(alpha: 0.3)
                                    : AppColors.primaryAccentOf(context).withValues(alpha: 0.4),
                        width: 18,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBreakdownItem(
    BuildContext context,
    AppLocalizations l10n,
    WeeklyDayBreakdown day,
  ) {
    final sleepText = day.sleepMinutes > 0
        ? '${day.sleepMinutes ~/ 60}h ${day.sleepMinutes % 60}m'
        : '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.dayName,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                Text(
                  day.date.split('-').skip(1).join('/'),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    color: AppColors.textMutedOf(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: day.isMissing
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.missingRecord,
                          style: TextStyle(fontSize: 11, color: AppColors.textMutedOf(context)),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricChip(Icons.directions_walk_rounded, '${day.steps}', AppColors.accentSteps),
                      _buildMetricChip(Icons.map_outlined, '${day.distanceKm.toStringAsFixed(1)}km', AppColors.accentDistance),
                      _buildMetricChip(Icons.local_fire_department_rounded, '${day.calories}', AppColors.accentCalories),
                      _buildMetricChip(Icons.bedtime_rounded, sleepText, AppColors.accentSleep),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          Icon(
            day.isGoalMet ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: day.isGoalMet ? AppColors.success : AppColors.textMutedOf(context),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
