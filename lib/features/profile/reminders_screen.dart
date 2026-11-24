import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/reminder_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../l10n/app_localizations.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reminders = context.watch<ReminderProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.remindersTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _card(
              context,
              children: [
                _switchTile(
                  context,
                  icon: Icons.water_drop_rounded,
                  color: const Color(0xFF0EA5E9),
                  title: l10n.reminderWaterTitle,
                  subtitle: l10n.reminderWaterDesc,
                  value: reminders.water,
                  onChanged: reminders.setWater,
                ),
                Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),
                _switchTile(
                  context,
                  icon: Icons.directions_walk_rounded,
                  color: AppColors.accentSteps,
                  title: l10n.reminderMoveTitle,
                  subtitle: l10n.reminderMoveDesc,
                  value: reminders.move,
                  onChanged: reminders.setMove,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _card(
              context,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  leading: _icon(context, Icons.bedtime_rounded, AppColors.accentSleep),
                  title: Text(l10n.quietHoursTitle, style: _titleStyle(context)),
                  subtitle: Text(l10n.quietHoursDesc, style: _subtitleStyle(context)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _timeButton(
                          context,
                          label: l10n.quietFrom,
                          minutes: reminders.quietStart,
                          onPicked: reminders.setQuietStart,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _timeButton(
                          context,
                          label: l10n.quietTo,
                          minutes: reminders.quietEnd,
                          onPicked: reminders.setQuietEnd,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                await reminders.sendTest();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.reminderTestSent)),
                );
              },
              icon: const Icon(Icons.notifications_active_outlined),
              label: Text(l10n.reminderTest),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.remindersFootnote,
              style: _subtitleStyle(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Column(children: children),
    );
  }

  Widget _icon(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  TextStyle _titleStyle(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryOf(context),
      );

  TextStyle _subtitleStyle(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12.5,
        color: AppColors.textSecondaryOf(context),
      );

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      secondary: _icon(context, icon, color),
      title: Text(title, style: _titleStyle(context)),
      subtitle: Text(subtitle, style: _subtitleStyle(context)),
    );
  }

  Widget _timeButton(
    BuildContext context, {
    required String label,
    required int minutes,
    required ValueChanged<int> onPicked,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
          builder: (ctx, child) => MediaQuery(
            data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
        if (picked != null) onPicked(picked.hour * 60 + picked.minute);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.accentSleep.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.accentSleep.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _subtitleStyle(context)),
            const SizedBox(height: 2),
            Text(
              ReminderProvider.formatMinutes(minutes),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
