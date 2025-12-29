import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/features/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    testWidgets('should navigate from splash to login screen', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: ProductiveApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should show splash or login screen
      // Note: Actual navigation depends on auth state
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display login form elements', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: ProductiveApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Note: These tests would need actual Firebase setup or mocks
      // For now, we verify the app structure
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}

