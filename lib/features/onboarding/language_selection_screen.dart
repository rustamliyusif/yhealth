import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/widgets/yhealth_logo.dart';
import '../../l10n/app_localizations.dart';
import '../navigation/main_navigation_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'az';

  @override
  void initState() {
    super.initState();
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    _selectedLanguage = langProvider.languageCode;
  }

  void _onLanguageSelected(String code) {
    setState(() {
      _selectedLanguage = code;
    });
    Provider.of<LanguageProvider>(context, listen: false).setLanguage(code);
  }

  Future<void> _onContinue() async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    await langProvider.completeInitialLanguageSelection(_selectedLanguage);

    if (!mounted) return;
    if (widget.isFromSettings) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: widget.isFromSettings
          ? AppBar(
              title: Text(
                l10n.languageSettings,
                style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
              ),
              backgroundColor: AppColors.backgroundOf(context),
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Center(
                child: YHealthLogo(
                  size: 96,
                  showContainer: true,
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'YHealth',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryAccentOf(context),
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  l10n.chooseLanguageSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    color: AppColors.textSecondaryOf(context),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Language Option 1: Azərbaycan dili 🇦🇿 (Default)
              _buildLanguageCard(
                context: context,
                code: 'az',
                title: 'Azərbaycan dili',
                subtitle: '🇦🇿 Varsayılan dil',
                isSelected: _selectedLanguage == 'az',
              ),
              const SizedBox(height: 16),

              // Language Option 2: English 🇬🇧
              _buildLanguageCard(
                context: context,
                code: 'en',
                title: 'English',
                subtitle: '🇬🇧 English language',
                isSelected: _selectedLanguage == 'en',
              ),

              const Spacer(flex: 2),

              // Continue Button
              PremiumButton(
                onPressed: _onContinue,
                label: l10n.continueButton,
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String code,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _onLanguageSelected(code),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryAccentOf(context)
                : AppColors.borderOf(context),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? AppDecorations.emeraldGlow(alpha: 0.15, blur: 12)
              : AppDecorations.cardShadow(context),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.primaryAccentOf(context)
                          : AppColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryAccentOf(context)
                      : AppColors.borderOf(context),
                  width: 2,
                ),
                color: isSelected
                    ? AppColors.primaryAccentOf(context)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
