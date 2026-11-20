import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/premium_button.dart';
import '../../l10n/app_localizations.dart';
import '../navigation/main_navigation_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  bool _share = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.userName);
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final auth = context.read<AuthProvider>();
    await auth.completeProfileSetup(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      share: _share,
    );
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.setupTitle, style: AppTypography.headlineMedium(context)),
                const SizedBox(height: 8),
                Text(l10n.setupSubtitle, style: AppTypography.bodyMedium(context)),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l10n.nameLabel),
                  validator: (value) {
                    if (_share && (value == null || value.trim().isEmpty)) {
                      return l10n.setupNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.ageLabel),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return _share ? l10n.setupInvalidAge : null;
                    final age = int.tryParse(text);
                    if (age == null || age < 5 || age > 120) return l10n.setupInvalidAge;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: CheckboxListTile(
                    value: _share,
                    onChanged: (value) => setState(() => _share = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      l10n.setupShareConsent,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        l10n.setupShareDesc,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.5,
                          height: 1.4,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                PremiumButton(
                  onPressed: _saving ? null : _submit,
                  label: l10n.continueButton,
                  icon: Icons.arrow_forward_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
