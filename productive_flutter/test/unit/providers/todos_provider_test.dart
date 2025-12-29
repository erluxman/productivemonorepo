import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/todo/providers/todos_provider.dart';
import 'package:productive_flutter/core/todo/use_cases/get_todos_use_case.dart';
import 'package:productive_flutter/core/todo/use_cases/create_todo_use_case.dart';
import 'package:productive_flutter/core/todo/use_cases/update_todo_use_case.dart';
import 'package:productive_flutter/core/todo/use_cases/delete_todo_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import 'package:productive_flutter/models/todo.dart';

class MockGetTodosUseCase extends Mock implements GetTodosUseCase {}
class MockCreateTodoUseCase extends Mock implements CreateTodoUseCase {}
class MockUpdateTodoUseCase extends Mock implements UpdateTodoUseCase {}
class MockDeleteTodoUseCase extends Mock implements DeleteTodoUseCase {}

void main() {
  group('TodosNotifier', () {
    late MockGetTodosUseCase mockGetTodosUseCase;
    late MockCreateTodoUseCase mockCreateTodoUseCase;
    late MockUpdateTodoUseCase mockUpdateTodoUseCase;
    late MockDeleteTodoUseCase mockDeleteTodoUseCase;
    late TodosNotifier notifier;

    setUp(() {
      mockGetTodosUseCase = MockGetTodosUseCase();
      mockCreateTodoUseCase = MockCreateTodoUseCase();
      mockUpdateTodoUseCase = MockUpdateTodoUseCase();
      mockDeleteTodoUseCase = MockDeleteTodoUseCase();

      notifier = TodosNotifier(
        getTodosUseCase: mockGetTodosUseCase,
        createTodoUseCase: mockCreateTodoUseCase,
        updateTodoUseCase: mockUpdateTodoUseCase,
        deleteTodoUseCase: mockDeleteTodoUseCase,
      );
    });

    tearDown(() {
      notifier.dispose();
    });

    test('should initialize with loading state', () {
      // Assert
      expect(notifier.state.isLoading, true);
    });

    group('loadTodos', () {
      test('should load todos successfully', () async {
        // Arrange
        final todos = [
          Todo(title: 'Todo 1', category: TodoCategory.general),
          Todo(title: 'Todo 2', category: TodoCategory.work),
        ];
        when(() => mockGetTodosUseCase.execute())
            .thenAnswer((_) async => Right(todos));

        // Act
        await notifier.loadTodos();

        // Assert
        expect(notifier.state.hasValue, true);
        notifier.state.whenData((loadedTodos) {
          expect(loadedTodos.length, 2);
          expect(loadedTodos[0].title, 'Todo 1');
        });
        verify(() => mockGetTodosUseCase.execute()).called(1);
      });

      test('should handle error when loading todos fails', () async {
        // Arrange
        final error = NetworkError('Failed to load todos');
        when(() => mockGetTodosUseCase.execute())
            .thenAnswer((_) async => Left(error));

        // Act
        await notifier.loadTodos();

      // Assert
      expect(notifier.state.hasError, true);
      notifier.state.when(
        data: (_) => fail('Expected error state'),
        loading: () => fail('Expected error state'),
        error: (err, stack) {
          expect(err, isA<NetworkError>());
        },
      );
      });
    });

    group('createTodo', () {
      test('should create todo and add to list', () async {
        // Arrange
        final existingTodos = [
          Todo(id: '1', title: 'Todo 1', category: TodoCategory.general),
        ];
        notifier.state = AsyncValue.data(existingTodos);

        final newTodo = Todo(id: '2', title: 'New Todo', category: TodoCategory.general);
        when(() => mockCreateTodoUseCase.execute(todo: any(named: 'todo')))
            .thenAnswer((_) async => Right(newTodo));

        // Act
        final result = await notifier.createTodo(todo: newTodo);

        // Assert
        expect(result.isRight(), true);
        expect(notifier.state.hasValue, true);
        notifier.state.whenData((todos) {
          expect(todos.length, 2);
          expect(todos[1].title, 'New Todo');
        });
      });

      test('should return error when creation fails', () async {
        // Arrange
        final existingTodos = [
          Todo(id: '1', title: 'Todo 1', category: TodoCategory.general),
        ];
        notifier.state = AsyncValue.data(existingTodos);

        final newTodo = Todo(title: 'New Todo', category: TodoCategory.general);
        final error = NetworkError('Failed to create');
        when(() => mockCreateTodoUseCase.execute(todo: any(named: 'todo')))
            .thenAnswer((_) async => Left(error));

        // Act
        final result = await notifier.createTodo(todo: newTodo);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (err) => expect(err, isA<NetworkError>()),
          (_) => fail('Expected error'),
        );
        // State should remain unchanged
        notifier.state.whenData((todos) {
          expect(todos.length, 1);
        });
      });
    });

    group('updateTodo', () {
      test('should update todo in list', () async {
        // Arrange
        final todos = [
          Todo(id: '1', title: 'Todo 1', category: TodoCategory.general, completed: false),
        ];
        notifier.state = AsyncValue.data(todos);

        final updatedTodo = Todo(
          id: '1',
          title: 'Updated Todo',
          category: TodoCategory.general,
          completed: true,
        );
        when(() => mockUpdateTodoUseCase.execute(
              id: any(named: 'id'),
              title: any(named: 'title'),
              completed: any(named: 'completed'),
            )).thenAnswer((_) async => Right(updatedTodo));

        // Act
        final result = await notifier.updateTodo(
          id: '1',
          title: 'Updated Todo',
          completed: true,
        );

        // Assert
        expect(result.isRight(), true);
        notifier.state.whenData((updatedTodos) {
          expect(updatedTodos.length, 1);
          expect(updatedTodos[0].title, 'Updated Todo');
          expect(updatedTodos[0].completed, true);
        });
      });

      test('should return error when update fails', () async {
        // Arrange
        final todos = [
          Todo(id: '1', title: 'Todo 1', category: TodoCategory.general),
        ];
        notifier.state = AsyncValue.data(todos);

        final error = NetworkError('Failed to update');
        when(() => mockUpdateTodoUseCase.execute(
              id: any(named: 'id'),
              title: any(named: 'title'),
            )).thenAnswer((_) async => Left(error));

        // Act
        final result = await notifier.updateTodo(
          id: '1',
          title: 'Updated',
        );

        // Assert
        expect(result.isLeft(), true);
      });
    });

    group('deleteTodo', () {
      test('should delete todo from list', () async {
        // Arrange
        final todos = [
          Todo(id: '1', title: 'Todo 1', category: TodoCategory.general),
          Todo(id: '2', title: 'Todo 2', category: TodoCategory.work),
        ];
        notifier.state = AsyncValue.data(todos);

        when(() => mockDeleteTodoUseCase.execute(any()))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await notifier.deleteTodo('1');

        // Assert
        expect(result.isRight(), true);
        notifier.state.whenData((remainingTodos) {
          expect(remainingTodos.length, 1);
          expect(remainingTodos[0].id, '2');
        });
      });

      test('should return ValidationError when id is null', () async {
        // Act
        final result = await notifier.deleteTodo(null);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'Todo ID is required');
          },
          (_) => fail('Expected error'),
        );
      });

      test('should return error when deletion fails', () async {
        // Arrange
        final todos = [
          Todo(id: '1', title: 'Todo 1', category: TodoCategory.general),
        ];
        notifier.state = AsyncValue.data(todos);

        final error = NetworkError('Failed to delete');
        when(() => mockDeleteTodoUseCase.execute(any()))
            .thenAnswer((_) async => Left(error));

        // Act
        final result = await notifier.deleteTodo('1');

        // Assert
        expect(result.isLeft(), true);
        // State should remain unchanged
        notifier.state.whenData((todos) {
          expect(todos.length, 1);
        });
      });
    });
  });
}

