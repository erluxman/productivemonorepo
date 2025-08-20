import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/app.dart';

void main() {
  testWidgets('App Follows MaterialTheme', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductiveApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
