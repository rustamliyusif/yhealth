import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/sleep_record_model.dart';
import '../../core/providers/sleep_provider.dart';
import '../../core/services/health_connect_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/add_edit_sleep_dialog.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sleep = context.watch<SleepProvider>();
    final lastNight = sleep.lastNightSleep;
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.sleepTrackingTitle,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
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
              icon: Icon(Icons.sync_rounded, color: AppColors.primaryAccentOf(context), size: 22),
              tooltip: l10n.healthConnectSync,
              onPressed: () async {
                final count = await sleep.syncFromHealthConnect();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        count > 0
                            ? '$count sleep session(s) synchronized from Health Connect'
                            : 'Health Connect is up to date (or manual mode)',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.emeraldGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppDecorations.emeraldGlow(alpha: 0.35, blur: 16),
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () => _openAddEditDialog(context, null),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            l10n.logSleep,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Last Night's Sleep Overview Card
            if (lastNight != null) ...[
              _buildLastNightCard(context, lastNight, l10n, isDark),
              const SizedBox(height: 18),
            ] else ...[
              _buildEmptyStateCard(context, l10n, isDark),
              const SizedBox(height: 18),
            ],

            // Consistency & Trends Card
            _buildConsistencyCard(context, sleep, l10n, isDark),
            const SizedBox(height: 18),

            // Health Connect Integration Status Card
            _buildHealthConnectBanner(context, sleep, l10n, isDark),
            const SizedBox(height: 24),

            // Sleep History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sleep History',
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
                    '${sleep.records.length} records',
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

            if (sleep.records.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No sleep records yet. Tap "Log Sleep" to begin.',
                    style: TextStyle(color: AppColors.textSecondaryOf(context)),
                  ),
                ),
              )
            else
              ...sleep.records.map((r) => _buildSleepHistoryItem(context, r, sleep, l10n, isDark)),

            const SizedBox(height: 80), // Padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildLastNightCard(
    BuildContext context,
    SleepRecordModel record,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderOf(context)),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.nightlight_round, color: Color(0xFF6366F1), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.lastNightSleep,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: record.isHealthConnect
                      ? Colors.teal.withValues(alpha: 0.12)
                      : AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  record.isHealthConnect ? 'Health Connect' : 'Manual Entry',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: record.isHealthConnect ? Colors.teal : AppColors.primaryAccentOf(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Text(
                  record.formattedDuration,
                  style: AppTypography.displayLarge(context).copyWith(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryAccentOf(context),
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Efficiency: ${record.efficiencyPercent}%',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeStat(
                context,
                icon: Icons.bed_rounded,
                iconColor: const Color(0xFF6366F1),
                label: l10n.bedtime,
                time: '${record.bedtime.hour.toString().padLeft(2, '0')}:${record.bedtime.minute.toString().padLeft(2, '0')}',
              ),
              Container(width: 1, height: 32, color: AppColors.dividerOf(context)),
              _buildTimeStat(
                context,
                icon: Icons.wb_sunny_rounded,
                iconColor: Colors.amber,
                label: l10n.wakeTime,
                time: '${record.wakeTime.hour.toString().padLeft(2, '0')}:${record.wakeTime.minute.toString().padLeft(2, '0')}',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sleep stages section
          if (record.hasStages) ...[
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sleep Stages (Wearable)',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Genuine Wearable Data',
                    style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStageChip('Deep', '${record.deepSleepMinutes ?? 0}m', Colors.deepPurple),
                const SizedBox(width: 8),
                _buildStageChip('Light', '${record.lightSleepMinutes ?? 0}m', Colors.blue),
                const SizedBox(width: 8),
                _buildStageChip('REM', '${record.remSleepMinutes ?? 0}m', Colors.cyan),
                const SizedBox(width: 8),
                _buildStageChip('Awake', '${record.awakeMinutes ?? 0}m', Colors.amber),
              ],
            ),
          ] else ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMutedOf(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textSecondaryOf(context)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sleep stages require a smartwatch/wearable synced via Health Connect. Ordinary phone sensors cannot detect stages.',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 11.5, color: AppColors.textSecondaryOf(context), height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Container(
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.nightlight_outlined, size: 40, color: Color(0xFF6366F1)),
          ),
          const SizedBox(height: 14),
          Text(
            'Track Your Sleep Naturally',
            style: AppTypography.headlineMedium(context).copyWith(fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            'Log your bedtime and wake-up times to track sleep consistency, duration trends, and wellness recovery.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(context),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencyCard(
    BuildContext context,
    SleepProvider sleep,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
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
              color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.schedule_rounded, color: AppColors.primaryAccentOf(context), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeConsistency,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sleep.bedtimeConsistencyDescription,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryAccentOf(context),
                  ),
                ),
                Text(
                  '7-Day Average: ${sleep.formattedAverageDuration}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11.5,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthConnectBanner(
    BuildContext context,
    SleepProvider sleep,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final status = sleep.healthConnectStatus;
    final isAvailable = status == HealthConnectStatus.available;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.teal.withValues(alpha: 0.08)
            : (isDark ? AppColors.darkSurface : AppColors.surfaceMutedOf(context)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAvailable
              ? Colors.teal.withValues(alpha: 0.3)
              : AppColors.borderOf(context),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.health_and_safety_rounded : Icons.info_outline_rounded,
            color: isAvailable ? Colors.teal : AppColors.textSecondaryOf(context),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Android Health Connect',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                Text(
                  isAvailable
                      ? 'Connected • Wearable sleep sync active'
                      : (status == HealthConnectStatus.notInstalled
                          ? 'Available for installation via Google Play'
                          : 'Manual offline logging active'),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ),
          if (status == HealthConnectStatus.notInstalled || isAvailable)
            TextButton(
              onPressed: () => sleep.openHealthConnectSettings(),
              child: Text(isAvailable ? 'Settings' : 'Install'),
            ),
        ],
      ),
    );
  }

  Widget _buildSleepHistoryItem(
    BuildContext context,
    SleepRecordModel record,
    SleepProvider sleep,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final bedtimeStr =
        '${record.bedtime.hour.toString().padLeft(2, '0')}:${record.bedtime.minute.toString().padLeft(2, '0')}';
    final wakeStr =
        '${record.wakeTime.hour.toString().padLeft(2, '0')}:${record.wakeTime.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppColors.textSecondaryOf(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    record.date,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                  if (record.isOvernight) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Overnight',
                        style: TextStyle(fontSize: 10, color: Colors.indigo, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz_rounded, size: 20, color: AppColors.textSecondaryOf(context)),
                onSelected: (val) {
                  if (val == 'edit') {
                    _openAddEditDialog(context, record);
                  } else if (val == 'delete') {
                    _confirmDelete(context, record, sleep, l10n);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.formattedDuration,
                style: AppTypography.displayMedium(context).copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryAccentOf(context),
                ),
              ),
              Text(
                '$bedtimeStr → $wakeStr',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ],
          ),
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              record.notes!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeStat(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String time,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStageChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddEditDialog(BuildContext context, SleepRecordModel? record) {
    final sleep = context.read<SleepProvider>();
    showDialog(
      context: context,
      builder: (_) => AddEditSleepDialog(
        initialRecord: record,
        onSave: (bedtime, wakeTime, date, notes, efficiency) async {
          if (record != null) {
            final updated = record.copyWith(
              bedtime: bedtime,
              wakeTime: wakeTime,
              date: date,
              durationMinutes: wakeTime.difference(bedtime).inMinutes,
              notes: notes,
              efficiencyPercent: efficiency,
            );
            final success = await sleep.updateSleepRecord(updated);
            if (!success && context.mounted && sleep.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(sleep.errorMessage!), backgroundColor: AppColors.error),
              );
            }
          } else {
            final success = await sleep.addSleepRecord(
              bedtime: bedtime,
              wakeTime: wakeTime,
              referenceDate: date,
              notes: notes,
              efficiencyPercent: efficiency,
            );
            if (!success && context.mounted && sleep.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(sleep.errorMessage!), backgroundColor: AppColors.error),
              );
            }
          }
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    SleepRecordModel record,
    SleepProvider sleep,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Sleep Record'),
        content: Text(l10n.deleteSleepConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              sleep.deleteSleepRecord(record.id);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
