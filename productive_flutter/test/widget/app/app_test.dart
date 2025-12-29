import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/features/app.dart';

void main() {
  group('ProductiveApp', () {
    testWidgets('should display MaterialApp', (tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: ProductiveApp(),
        ),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should have correct title', (tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: ProductiveApp(),
        ),
      );

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Productive App');
    });

    testWidgets('should not show debug banner', (tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: ProductiveApp(),
        ),
      );

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });
}

