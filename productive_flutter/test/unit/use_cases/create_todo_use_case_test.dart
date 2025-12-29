import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/todo/use_cases/create_todo_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import 'package:productive_flutter/models/todo.dart';
import '../../helpers/mocks.dart';

void main() {
  group('CreateTodoUseCase', () {
    late MockTodoService mockTodoService;
    late CreateTodoUseCase useCase;

    setUp(() {
      mockTodoService = MockTodoService();
      useCase = CreateTodoUseCase(mockTodoService);
    });

    test('should create todo successfully with valid input', () async {
      // Arrange
      final todo = Todo(title: 'New Todo', category: TodoCategory.general);
      final createdTodo = Todo(
        id: 'new_id',
        title: 'New Todo',
        category: TodoCategory.general,
      );
      when(() => mockTodoService.createTodo(todo: any(named: 'todo')))
          .thenAnswer((_) async => Right(createdTodo));

      // Act
      final result = await useCase.execute(todo: todo);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (returnedTodo) {
          expect(returnedTodo.title, 'New Todo');
          expect(returnedTodo.id, 'new_id');
        },
      );
      verify(() => mockTodoService.createTodo(todo: any(named: 'todo'))).called(1);
    });

    test('should return ValidationError when title is empty', () async {
      // Arrange
      final todo = Todo(title: '   ', category: TodoCategory.general);

      // Act
      final result = await useCase.execute(todo: todo);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Title is required');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
      verifyNever(() => mockTodoService.createTodo(todo: any(named: 'todo')));
    });

    test('should return ValidationError when title is only whitespace', () async {
      // Arrange
      final todo = Todo(title: '\t\n  ', category: TodoCategory.general);

      // Act
      final result = await useCase.execute(todo: todo);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Title is required');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
    });

    test('should return error when service fails', () async {
      // Arrange
      final todo = Todo(title: 'New Todo', category: TodoCategory.general);
      final error = NetworkError('Failed to create todo');
      when(() => mockTodoService.createTodo(todo: any(named: 'todo')))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute(todo: todo);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<NetworkError>());
          expect(returnedError.message, 'Failed to create todo');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
    });
  });
}

