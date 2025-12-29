import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/home/inbox/widgets/todo_item.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('TodoItem', () {
    testWidgets('should display todo title', (tester) async {
      // Arrange
      final todo = createTestTodo(title: 'Test Todo');

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Test Todo'), findsOneWidget);
    });

    testWidgets('should display todo description when provided', (tester) async {
      // Arrange
      final todo = createTestTodo(
        title: 'Test Todo',
        description: 'Test Description',
      );

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should not display description when null', (tester) async {
      // Arrange
      final todo = createTestTodo(title: 'Test Todo', description: null);

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Test Description'), findsNothing);
    });

    testWidgets('should show completed state', (tester) async {
      // Arrange
      final todo = createTestTodo(title: 'Completed Todo', completed: true);

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {},
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('Completed Todo'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('should call onToggle when checkbox is tapped', (tester) async {
      // Arrange
      var toggleCalled = false;
      final todo = createTestTodo(title: 'Test Todo');

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {
              toggleCalled = true;
            },
            onDelete: () {},
          ),
        ),
      );

      // Find and tap the checkbox
      final checkbox = find.byType(GestureDetector).last;
      await tester.tap(checkbox);
      await tester.pump();

      // Assert
      expect(toggleCalled, true);
    });

    testWidgets('should show edit hint when onTap is provided', (tester) async {
      // Arrange
      final todo = createTestTodo(title: 'Test Todo');

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {},
            onTap: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Tap to edit'), findsOneWidget);
    });

    testWidgets('should not show edit hint when onTap is null', (tester) async {
      // Arrange
      final todo = createTestTodo(title: 'Test Todo');

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Tap to edit'), findsNothing);
    });

    testWidgets('should be dismissible for deletion', (tester) async {
      // Arrange
      var deleteCalled = false;
      final todo = createTestTodo(id: 'test_id', title: 'Test Todo');

      // Act
      await tester.pumpWidget(
        createTestApp(
          TodoItem(
            todo: todo,
            onToggle: () {},
            onDelete: () {
              deleteCalled = true;
            },
          ),
        ),
      );

      // Swipe to dismiss
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(deleteCalled, true);
    });
  });
}

