import 'package:flutter/material.dart';
import 'package:productive_flutter/v2/features/auth/widgets/email_field.dart';
import 'package:productive_flutter/v2/features/auth/widgets/signup_options.dart';
import 'package:productive_flutter/v2/features/auth/widgets/terms_checkbox.dart';

import '../../../utils/haptics.dart';
import 'password_field.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.acceptedTerms,
    required this.privacyPolicyError,
    required this.isValid,
    required this.isLoading,
    required this.onTermsChanged,
    required this.onPrivacyPolicyTap,
    required this.onTermsOfServiceTap,
    required this.onSignup,
    required this.navigateTo,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool acceptedTerms;
  final bool privacyPolicyError;
  final bool isValid;
  final bool isLoading;
  final Function(bool?) onTermsChanged;
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsOfServiceTap;
  final VoidCallback onSignup;
  final Function(BuildContext, Widget) navigateTo;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmailUsernameField(
                  loginIdController: emailController,
                  label: 'Email Address',
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                PasswordField(
                  passwordController: passwordController,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                TermsCheckbox(
                  acceptedTerms: acceptedTerms,
                  privacyPolicyError: privacyPolicyError,
                  onTermsChanged: onTermsChanged,
                  onPrivacyPolicyTap: onPrivacyPolicyTap,
                  onTermsOfServiceTap: onTermsOfServiceTap,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (isLoading || !isValid)
                        ? null
                        : () {
                            Haptics.medium();
                            onSignup();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor:
                          colorScheme.surfaceContainerHighest.withAlpha(204),
                      disabledForegroundColor: colorScheme.onSurfaceVariant,
                      elevation: (isLoading || !isValid) ? 0 : 4,
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
                            'Create Account',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isValid
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                SignupOptions(
                  acceptedTerms: acceptedTerms,
                  navigateTo: navigateTo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

