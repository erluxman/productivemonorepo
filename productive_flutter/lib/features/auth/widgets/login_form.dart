import 'package:flutter/material.dart';
import '../../../core/utils/haptics.dart';

import 'email_field.dart';
import 'login_options.dart';
import 'password_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.loginIdController,
    required this.passwordController,
    required this.isLoading,
    required this.isFormValid,
    required this.showForgotPasswordDialog,
    required this.login,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController loginIdController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback showForgotPasswordDialog;
  final VoidCallback login;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                EmailUsernameField(
                  loginIdController: loginIdController,
                  colorScheme: colorScheme,
                  label: 'Email/Username',
                ),
                const SizedBox(height: 20),
                PasswordField(
                  passwordController: passwordController,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Haptics.light();
                      showForgotPasswordDialog();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (isLoading || !isFormValid) ? null : () {
                      Haptics.medium();
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: isLoading ? 0 : 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            'Log In',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Continue with social login options - similar to splash screen
                Text(
                  "Continue with",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const LoginOptions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
