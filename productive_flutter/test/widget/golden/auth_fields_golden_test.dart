import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:productive_flutter/features/auth/widgets/email_field.dart';
import 'package:productive_flutter/features/auth/widgets/password_field.dart';

void main() {
  group('Auth Fields Golden Tests', () {
    testGoldens('EmailField renders correctly', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidgetBuilder(
        EmailUsernameField(
          loginIdController: controller,
          colorScheme: ThemeData.light().colorScheme,
          label: 'Email',
        ),
        surfaceSize: const Size(400, 80),
      );

      // Assert
      await screenMatchesGolden(tester, 'email_field');
    });

    testGoldens('PasswordField renders correctly', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidgetBuilder(
        PasswordField(
          passwordController: controller,
          colorScheme: ThemeData.light().colorScheme,
        ),
        surfaceSize: const Size(400, 80),
      );

      // Assert
      await screenMatchesGolden(tester, 'password_field');
    });

    testGoldens('PasswordField with visible password', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'password123');

      // Act
      await tester.pumpWidgetBuilder(
        PasswordField(
          passwordController: controller,
          colorScheme: ThemeData.light().colorScheme,
        ),
        surfaceSize: const Size(400, 80),
      );

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Assert
      await screenMatchesGolden(tester, 'password_field_visible');
    });
  });
}

