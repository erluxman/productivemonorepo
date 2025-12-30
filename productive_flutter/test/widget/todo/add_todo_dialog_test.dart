import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/todo/widgets/add_todo_dialog.dart';
import 'package:productive_flutter/models/todo.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('AddTodoDialog', () {
    testWidgets('should display dialog with title and form fields',
        (tester) async {
      // Act
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddTodoDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Add New Todo'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should validate empty title', (tester) async {
      // Act
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddTodoDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Try to submit without title
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('should return todo when form is valid', (tester) async {
      // Arrange
      Todo? returnedTodo;

      // Act
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => const AddTodoDialog(),
                  );
                  if (result is Todo) {
                    returnedTodo = result;
                  }
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Enter title
      await tester.enterText(find.byType(TextFormField).first, 'New Todo');
      await tester.pumpAndSettle();

      // Enter description
      await tester.enterText(
          find.byType(TextFormField).last, 'Test Description');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Assert
      expect(returnedTodo, isNotNull);
      expect(returnedTodo?.title, 'New Todo');
      expect(returnedTodo?.description, 'Test Description');
    });

    testWidgets('should close dialog when cancel is tapped', (tester) async {
      // Act
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddTodoDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Add New Todo'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Add New Todo'), findsNothing);
    });
  });
}
