import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:productive_flutter/features/home/inbox/widgets/todo_item.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('TodoItem Golden Tests', () {
    testGoldens('TodoItem renders correctly', (tester) async {
      // Arrange
      final todo = createTestTodo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        completed: false,
      );

      // Act
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              todo: todo,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
        surfaceSize: const Size(400, 100),
      );

      // Assert
      await screenMatchesGolden(tester, 'todo_item');
    });

    testGoldens('TodoItem completed state', (tester) async {
      // Arrange
      final todo = createTestTodo(
        id: '1',
        title: 'Completed Todo',
        description: 'This todo is completed',
        completed: true,
      );

      // Act
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              todo: todo,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
        surfaceSize: const Size(400, 100),
      );

      // Assert
      await screenMatchesGolden(tester, 'todo_item_completed');
    });

    testGoldens('TodoItem with edit option', (tester) async {
      // Arrange
      final todo = createTestTodo(
        id: '1',
        title: 'Editable Todo',
        description: 'Tap to edit this todo',
        completed: false,
      );

      // Act
      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: TodoItem(
              todo: todo,
              onToggle: () {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
        surfaceSize: const Size(400, 120),
      );

      // Assert
      await screenMatchesGolden(tester, 'todo_item_editable');
    });

    testGoldens('TodoItem dark theme', (tester) async {
      // Arrange
      final todo = createTestTodo(
        id: '1',
        title: 'Dark Theme Todo',
        description: 'This is in dark theme',
        completed: false,
      );

      // Act
      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: TodoItem(
              todo: todo,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
        surfaceSize: const Size(400, 100),
      );

      // Assert
      await screenMatchesGolden(tester, 'todo_item_dark');
    });
  });
}

