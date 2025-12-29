import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/app.dart';

void main() {
  testWidgets('App Follows MaterialTheme', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ProductiveApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
