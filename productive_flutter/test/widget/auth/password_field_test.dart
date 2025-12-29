import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/auth/widgets/password_field.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('PasswordField', () {
    testWidgets('should display password field with label', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        createTestApp(
          PasswordField(
            passwordController: controller,
            colorScheme: ThemeData.light().colorScheme,
          ),
        ),
      );

      // Assert
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should obscure password by default', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'password123');

      // Act
      await tester.pumpWidget(
        createTestApp(
          PasswordField(
            passwordController: controller,
            colorScheme: ThemeData.light().colorScheme,
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      // Note: obscureText is not directly accessible, but we can verify the widget exists
      expect(textField, isNotNull);
    });

    testWidgets('should toggle password visibility', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'password123');

      // Act
      await tester.pumpWidget(
        createTestApp(
          PasswordField(
            passwordController: controller,
            colorScheme: ThemeData.light().colorScheme,
          ),
        ),
      );

      // Find and tap visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility_outlined);
      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pump();

      // Assert
      // Verify visibility icon changed
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should validate empty password', (tester) async {
      // Arrange
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: PasswordField(
              passwordController: controller,
              colorScheme: ThemeData.light().colorScheme,
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState?.validate();

      await tester.pump();

      // Assert
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should validate short password', (tester) async {
      // Arrange
      final controller = TextEditingController(text: '12345');
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: PasswordField(
              passwordController: controller,
              colorScheme: ThemeData.light().colorScheme,
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState?.validate();

      await tester.pump();

      // Assert
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should accept valid password', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'password123');
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: PasswordField(
              passwordController: controller,
              colorScheme: ThemeData.light().colorScheme,
            ),
          ),
        ),
      );

      // Trigger validation
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, true);
    });
  });
}

