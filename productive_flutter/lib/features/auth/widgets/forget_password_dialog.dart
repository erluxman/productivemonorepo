import 'package:flutter/material.dart';

import '../../../utils/haptics.dart';
import '../../../core/ui/dialog_transitions.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final Future<bool> Function(String loginId) onSubmit;

  const ForgotPasswordDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();

  static Future<bool?> show(
    BuildContext context, {
    required Future<bool> Function(String email) onSubmit,
  }) async {
    return showCustomDialog<bool>(
      context: context,
      barrierDismissible: false,
      useBlurBackground: true,
      builder: (context) => ForgotPasswordDialog(
        onSubmit: onSubmit,
      ),
    );
  }
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _loginIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isSuccess = false;
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _loginIdController.addListener(_validateInput);
  }

  void _validateInput() {
    final value = _loginIdController.text;
    // For forgot password, we ONLY accept valid emails
    setState(() {
      _isInputValid = _isValidEmailFormat(value);
    });
  }

  @override
  void dispose() {
    _loginIdController.removeListener(_validateInput);
    _loginIdController.dispose();
    super.dispose();
  }

  Future<void> _submitLoginId() async {
    if (_formKey.currentState?.validate() != true) return;

    // Just double-check it's a valid email
    final value = _loginIdController.text;
    if (!_isValidEmailFormat(value)) {
      setState(() {
        _isInputValid = false;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await widget.onSubmit(_loginIdController.text);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _isSuccess = result;
    });

    if (_isSuccess) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  bool _isValidEmailFormat(String email) {
    // Simple regex to check if email format is valid
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.white.withAlpha(230),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withAlpha(204),
            width: 1.5,
          ),
          color: Colors.white.withAlpha(51),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isSuccess
                    ? Colors.green.withAlpha(26)
                    : colorScheme.primary.withAlpha(26),
              ),
              child: Icon(
                _isSuccess ? Icons.check_circle : Icons.lock_reset,
                size: 40,
                color: _isSuccess ? Colors.green : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isSuccess ? 'Recovery Email Sent' : 'Forgot Password',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isSuccess
                  ? 'Check your email for instructions to reset your password'
                  : 'Enter your email address and we\'ll send you recovery instructions',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (!_isSuccess) ...[
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _loginIdController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.email_outlined, color: colorScheme.primary),
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    floatingLabelStyle: TextStyle(color: colorScheme.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_isValidEmailFormat(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSuccess
                    ? () {
                        Haptics.light();
                        Navigator.pop(context);
                      }
                    : (_isSubmitting || !_isInputValid
                        ? null
                        : () {
                            Haptics.medium();
                            _submitLoginId();
                          }),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isSuccess ? Colors.green : colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor:
                      colorScheme.surfaceContainerHighest.withAlpha(128),
                  disabledForegroundColor: colorScheme.onSurfaceVariant,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(_isSuccess ? 'Close' : 'Submit'),
              ),
            ),
            if (!_isSuccess) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
