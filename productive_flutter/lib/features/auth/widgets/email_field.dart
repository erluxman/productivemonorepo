import 'package:flutter/material.dart';
import 'package:productive_flutter/utils/extensions/string_extensions.dart';

class EmailUsernameField extends StatelessWidget {
  const EmailUsernameField({
    super.key,
    required TextEditingController loginIdController,
    required this.colorScheme,
    required this.label,
  }) : _loginIdController = loginIdController;

  final TextEditingController _loginIdController;
  final ColorScheme colorScheme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _loginIdController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter your $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        } else if ((!value.contains('@'))) {
          return value.isValidUsername() ? null : 'Invalid $label';
        } else if (value.contains('@')) {
          return value.isValidEmail() ? null : 'Invalid email address';
        } else {
          return null;
        }
      },
    );
  }
}

