import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required TextEditingController passwordController,
    required this.colorScheme,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final ColorScheme colorScheme;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.colorScheme.primary, width: 2),
        ),
        prefixIcon: Icon(Icons.lock_outline, color: widget.colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: widget.colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        labelStyle: TextStyle(color: widget.colorScheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: widget.colorScheme.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

