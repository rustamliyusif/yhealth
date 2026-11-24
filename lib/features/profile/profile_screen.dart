import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/providers/water_provider.dart';
import '../../core/providers/reminder_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/csv_export_service.dart';
import '../../core/providers/step_counter_provider.dart';
import '../../core/services/share_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/yhealth_logo.dart';
import '../../l10n/app_localizations.dart';
import '../onboarding/language_selection_screen.dart';
import 'widgets/edit_goals_dialog.dart';
import 'device_compatibility_screen.dart';
import 'reminders_screen.dart';
import 'health_connect_screen.dart';
import '../../core/providers/health_sync_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, AuthProvider auth, AppLocalizations l10n) {
    final nameController = TextEditingController(text: auth.userName);
    final ageController = TextEditingController(text: '${auth.userAge}');
    final heightController = TextEditingController(text: auth.userHeight.toStringAsFixed(0));
    final weightController = TextEditingController(text: auth.userWeight.toStringAsFixed(1));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.personalInfo, style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.nameLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.ageLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.heightLabel, suffixText: l10n.heightUnitCm),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.weightLabel, suffixText: l10n.weightUnitKg),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final age = int.tryParse(ageController.text);
              final height = double.tryParse(heightController.text);
              final weight = double.tryParse(weightController.text);

              auth.updateProfile(
                name: name.isNotEmpty ? name : null,
                age: age,
                height: height,
                weight: weight,
              );
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccentOf(context),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, AppLocalizations l10n) async {
    final csv = context.read<CsvExportService>();
    final steps = context.read<StepCounterProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final now = DateTime.now();
    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    try {
      final path = await csv.exportToFile(
        liveStepHistory: steps.history,
        todayKey: todayKey,
        todaySteps: steps.todaySteps,
      );
      await ShareService.shareFile(path, mimeType: 'text/csv', title: l10n.csvExport);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupExportFailed), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _exportBackup(BuildContext context, AppLocalizations l10n) async {
    final backup = context.read<BackupService>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final path = await backup.exportToFile();
      await ShareService.shareFile(path, mimeType: 'application/json', title: l10n.backupExport);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupExportFailed), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _importBackup(BuildContext context, AppLocalizations l10n) async {
    final backup = context.read<BackupService>();
    final messenger = ScaffoldMessenger.of(context);
    final path = await ShareService.pickFile();
    if (path == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.backupImportConfirmTitle, style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w700)),
        content: Text(l10n.backupImportConfirmDesc, style: AppTypography.bodyMedium(ctx)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.backupRestore),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await backup.importFromFile(path);
      if (context.mounted) {
        context.read<WaterProvider>().reload();
        context.read<ReminderProvider>().reload();
      }
    } on BackupException catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${e.code == 'unsupported_version' ? l10n.backupUnsupportedVersion : l10n.backupInvalidFile}'
            '${e.detail == null ? '' : '\n${e.detail}'}',
          ),
          duration: const Duration(seconds: 10),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Text(l10n.backupRestoreSuccess, style: AppTypography.bodyMedium(ctx)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final theme = context.watch<ThemeProvider>();

    final initials = auth.userName.isNotEmpty
        ? auth.userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'YH';

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.profileTitle,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        gradient: AppColors.emeraldGradient,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: AppDecorations.emeraldGlow(alpha: 0.25, blur: 12),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.userName.isNotEmpty ? auth.userName : 'YHealth',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                          if (auth.userEmail.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              auth.userEmail,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${l10n.yearsOld(auth.userAge.toString())} • ${auth.userHeight.round()} ${l10n.heightUnitCm} • ${auth.userWeight.toStringAsFixed(1)} ${l10n.weightUnitKg}',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryAccentOf(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: AppColors.primaryAccentOf(context)),
                      onPressed: () => _showEditProfileDialog(context, auth, l10n),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Settings Group
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Column(
                  children: [
                    // Daily Goals Setting
                    _buildSettingsTile(
                      context: context,
                      icon: Icons.track_changes_rounded,
                      title: l10n.dailyGoalsSettings,
                      subtitle: '${auth.goalSteps} ${l10n.stepsUnit} • ${auth.goalCalories} ${l10n.kcalUnit}',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => EditGoalsDialog(authProvider: auth),
                        );
                      },
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.health_and_safety_rounded,
                      iconColor: const Color(0xFF14B8A6),
                      title: 'Health Connect',
                      subtitle: context.watch<HealthSyncProvider>().connected
                          ? l10n.hcConnected(
                              HealthConnectScreen.formatLastSync(l10n, context.watch<HealthSyncProvider>().lastSync))
                          : l10n.hcNotConnected,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HealthConnectScreen()),
                        );
                      },
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.notifications_active_rounded,
                      title: l10n.remindersTitle,
                      subtitle: l10n.remindersSubtitle,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RemindersScreen()),
                        );
                      },
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),

                    // Language Setting
                    _buildSettingsTile(
                      context: context,
                      icon: Icons.language_rounded,
                      title: l10n.languageSettings,
                      subtitle: lang.isAzerbaijani ? l10n.azerbaijani : l10n.english,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          lang.isAzerbaijani ? '🇦🇿 AZ' : '🇬🇧 EN',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryAccentOf(context),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen(isFromSettings: true),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),

                    // Units Setting
                    _buildSettingsTile(
                      context: context,
                      icon: Icons.tune_rounded,
                      title: l10n.measurementUnits,
                      subtitle: auth.measurementUnit == 'metric' ? l10n.unitMetric : l10n.unitImperial,
                      onTap: () {
                        final nextUnit = auth.measurementUnit == 'metric' ? 'imperial' : 'metric';
                        auth.updateProfile(measurementUnit: nextUnit);
                      },
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),

                    // Theme Setting (Light / Dark Mode)
                    _buildSettingsTile(
                      context: context,
                      icon: theme.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      iconColor: theme.isDarkMode ? const Color(0xFF34D399) : const Color(0xFFF59E0B),
                      title: l10n.themeSettings,
                      subtitle: theme.isDarkMode ? l10n.themeDark : l10n.themeLight,
                      trailing: Switch.adaptive(
                        value: theme.isDarkMode,
                        activeThumbColor: AppColors.primaryAccentOf(context),
                        onChanged: (_) => theme.toggleTheme(),
                      ),
                      onTap: () => theme.toggleTheme(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: auth.shareProfile,
                      onChanged: (value) => auth.setShareProfile(value),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      secondary: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.badge_outlined, color: AppColors.primaryAccentOf(context), size: 20),
                      ),
                      title: Text(
                        l10n.shareSettingTitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      subtitle: Text(
                        auth.shareProfile ? l10n.shareSettingOn : l10n.shareSettingOff,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.5,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),
                    _buildSettingsTile(
                      context: context,
                      icon: Icons.upload_file_rounded,
                      title: l10n.backupExport,
                      subtitle: l10n.backupExportDesc,
                      onTap: () => _exportBackup(context, l10n),
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),
                    _buildSettingsTile(
                      context: context,
                      icon: Icons.table_chart_outlined,
                      title: l10n.csvExport,
                      subtitle: l10n.csvExportDesc,
                      onTap: () => _exportCsv(context, l10n),
                    ),
                    Divider(height: 1, indent: 56, color: AppColors.dividerOf(context)),
                    _buildSettingsTile(
                      context: context,
                      icon: Icons.settings_backup_restore_rounded,
                      title: l10n.backupImport,
                      subtitle: l10n.backupImportDesc,
                      onTap: () => _importBackup(context, l10n),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Device Compatibility Center Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: _buildSettingsTile(
                  context: context,
                  icon: Icons.phone_android_rounded,
                  iconColor: AppColors.accentDistance,
                  title: l10n.deviceCompatibilityTitle,
                  subtitle: l10n.deviceCompatibilitySubtitle,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DeviceCompatibilityScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // About Card with VITA-Y Monogram
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
                        YHealthLogo(size: 26, showContainer: true, isDark: theme.isDarkMode),
                        const SizedBox(width: 10),
                        Text(
                          l10n.aboutYHealth,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccentOf(context).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.appVersion,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryAccentOf(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.privacyPhilosophy,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.5,
                        color: AppColors.textSecondaryOf(context),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final effectiveColor = iconColor ?? AppColors.primaryAccentOf(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: effectiveColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryOf(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12.5,
          color: AppColors.textSecondaryOf(context),
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: AppColors.textMutedOf(context)),
    );
  }
}
