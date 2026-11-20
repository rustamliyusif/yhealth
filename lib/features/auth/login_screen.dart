import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/widgets/yhealth_logo.dart';
import '../../l10n/app_localizations.dart';
import '../navigation/main_navigation_screen.dart';
import '../profile/widgets/firebase_status_sheet.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      final l10n = AppLocalizations.of(context)!;
      String msg = l10n.authErrorDefault;
      if (authProvider.errorMessage == 'wrong_password') {
        msg = l10n.authErrorWrongPassword;
      } else if (authProvider.errorMessage == 'user_not_found') {
        msg = l10n.authErrorUserNotFound;
      } else if (authProvider.errorMessage == 'invalid_email') {
        msg = l10n.authErrorInvalidEmail;
      } else if (authProvider.errorMessage == 'network_error') {
        msg = l10n.authErrorNetwork;
      } else if (authProvider.errorMessage == 'too_many_requests') {
        msg = l10n.authErrorTooManyRequests;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _continueAsGuest() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.continueAsGuest();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded, color: AppColors.textMutedOf(context), size: 22),
                      tooltip: l10n.firebaseStatusTitle,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => FirebaseStatusSheet(
                            isConnected: authProvider.isFirebaseConnected,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // App Logo with glowing container
                Center(
                  child: YHealthLogo(
                    size: 88,
                    showContainer: true,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 22),
                Center(
                  child: Text(
                    l10n.loginTitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimaryOf(context),
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: AppColors.textSecondaryOf(context),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Email Field
                Text(
                  l10n.emailInput,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: l10n.emailHint,
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMutedOf(context), size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.authErrorInvalidEmail;
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return l10n.authErrorInvalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Password Field
                Text(
                  l10n.passwordInput,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: l10n.passwordHint,
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textMutedOf(context), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textMutedOf(context),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return l10n.authErrorWeakPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      l10n.forgotPassword,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: AppColors.primaryAccentOf(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login Button
                PremiumButton(
                  onPressed: _handleLogin,
                  isLoading: authProvider.status == AuthStatus.authenticating,
                  label: l10n.loginButton,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 14),

                // Continue Local Mode / Guest Button
                OutlinedButton(
                  onPressed: _continueAsGuest,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.borderOf(context), width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    l10n.skipForNow,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Switch to Register
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      l10n.doNotHaveAccount,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryAccentOf(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
