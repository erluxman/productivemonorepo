import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/models/todo.dart';

/// Helper to create a test app with ProviderScope
Widget createTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

/// Helper to create a test app with theme
Widget createTestAppWithTheme(Widget child, {ThemeMode themeMode = ThemeMode.light}) {
  return ProviderScope(
    child: MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Scaffold(body: child),
    ),
  );
}

/// Helper to create a test todo
Todo createTestTodo({
  String? id,
  String title = 'Test Todo',
  String? description,
  TodoCategory? category,
  bool completed = false,
  bool isUrgent = false,
}) {
  return Todo(
    id: id,
    title: title,
    description: description,
    category: category ?? TodoCategory.general,
    completed: completed,
    isUrgent: isUrgent,
  );
}

/// Helper to create a list of test todos
List<Todo> createTestTodos({int count = 3}) {
  return List.generate(
    count,
    (index) => createTestTodo(
      id: 'todo_$index',
      title: 'Todo $index',
      description: 'Description $index',
      completed: index % 2 == 0,
    ),
  );
}

/// Helper to wait for async operations
Future<void> waitForAsync(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

/// Helper to wait for animations
Future<void> waitForAnimations(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

