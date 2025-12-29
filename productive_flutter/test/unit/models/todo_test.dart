import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/models/todo.dart';

void main() {
  group('Todo', () {
    test('should create todo with required fields', () {
      // Act
      final todo = Todo(
        title: 'Test Todo',
        category: TodoCategory.general,
      );

      // Assert
      expect(todo.title, 'Test Todo');
      expect(todo.category, TodoCategory.general);
      expect(todo.completed, false);
      expect(todo.isUrgent, false);
      expect(todo.id, isNotNull);
    });

    test('should create todo with all fields', () {
      // Arrange
      final now = DateTime.now();
      final dueDate = now.add(const Duration(days: 1));

      // Act
      final todo = Todo(
        id: 'test_id',
        title: 'Test Todo',
        description: 'Test Description',
        category: TodoCategory.work,
        completed: true,
        isUrgent: true,
        dueDate: dueDate,
        feedMessage: 'Test message',
      );

      // Assert
      expect(todo.id, 'test_id');
      expect(todo.title, 'Test Todo');
      expect(todo.description, 'Test Description');
      expect(todo.category, TodoCategory.work);
      expect(todo.completed, true);
      expect(todo.isUrgent, true);
      expect(todo.dueDate, dueDate);
      expect(todo.feedMessage, 'Test message');
    });

    test('should generate UUID when id is not provided', () {
      // Act
      final todo1 = Todo(title: 'Todo 1', category: TodoCategory.general);
      final todo2 = Todo(title: 'Todo 2', category: TodoCategory.general);

      // Assert
      expect(todo1.id, isNotNull);
      expect(todo2.id, isNotNull);
      expect(todo1.id, isNot(equals(todo2.id)));
    });

    test('should create copy with updated fields', () {
      // Arrange
      final original = Todo(
        id: 'test_id',
        title: 'Original',
        description: 'Original Description',
        category: TodoCategory.general,
        completed: false,
      );

      // Act
      final updated = original.copyWith(
        title: 'Updated',
        completed: true,
      );

      // Assert
      expect(updated.id, 'test_id');
      expect(updated.title, 'Updated');
      expect(updated.description, 'Original Description');
      expect(updated.completed, true);
      expect(original.title, 'Original'); // Original should be unchanged
    });

    test('should create copy with null fields', () {
      // Arrange
      final original = Todo(
        id: 'test_id',
        title: 'Original',
        description: 'Description',
        category: TodoCategory.general,
      );

      // Act
      final updated = original.copyWith(description: null);

      // Assert
      expect(updated.description, isNull);
    });

    group('TodoCategory', () {
      test('should return correct icon for each category', () {
        expect(TodoCategory.habits.icon, isNotNull);
        expect(TodoCategory.work.icon, isNotNull);
        expect(TodoCategory.personal.icon, isNotNull);
        expect(TodoCategory.health.icon, isNotNull);
        expect(TodoCategory.general.icon, isNotNull);
        expect(TodoCategory.learning.icon, isNotNull);
      });

      test('should return correct display name for each category', () {
        expect(TodoCategory.habits.displayName, 'Habits');
        expect(TodoCategory.work.displayName, 'Work');
        expect(TodoCategory.personal.displayName, 'Personal');
        expect(TodoCategory.health.displayName, 'Health');
        expect(TodoCategory.general.displayName, 'General');
        expect(TodoCategory.learning.displayName, 'Learning');
      });
    });
  });
}

