import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/auth/widgets/email_field.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('EmailUsernameField', () {
    testWidgets('should display email field with label', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmailUsernameField(
              loginIdController: controller,
              colorScheme: ThemeData.light().colorScheme,
              label: 'Email',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should validate empty email', (tester) async {
      // Arrange
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: EmailUsernameField(
              loginIdController: controller,
              colorScheme: ThemeData.light().colorScheme,
              label: 'Email',
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState?.validate();

      await tester.pump();

      // Assert
      expect(find.text('Please enter your Email'), findsOneWidget);
    });

    testWidgets('should validate invalid email format', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'invalid-email');
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: EmailUsernameField(
              loginIdController: controller,
              colorScheme: ThemeData.light().colorScheme,
              label: 'Email',
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState?.validate();

      await tester.pump();

      // Assert
      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('should accept valid email', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'test@example.com');
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: EmailUsernameField(
              loginIdController: controller,
              colorScheme: ThemeData.light().colorScheme,
              label: 'Email',
            ),
          ),
        ),
      );

      // Trigger validation
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, true);
    });

    testWidgets('should accept valid username', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'username123');
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        createTestApp(
          Form(
            key: formKey,
            child: EmailUsernameField(
              loginIdController: controller,
              colorScheme: ThemeData.light().colorScheme,
              label: 'Username',
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

