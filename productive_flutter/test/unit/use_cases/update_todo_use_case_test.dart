import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/todo/use_cases/update_todo_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import 'package:productive_flutter/models/todo.dart';
import '../../helpers/mocks.dart';

void main() {
  group('UpdateTodoUseCase', () {
    late MockTodoService mockTodoService;
    late UpdateTodoUseCase useCase;

    setUp(() {
      mockTodoService = MockTodoService();
      useCase = UpdateTodoUseCase(mockTodoService);
    });

    test('should update todo successfully with valid input', () async {
      // Arrange
      final updatedTodo = Todo(
        id: 'test_id',
        title: 'Updated Todo',
        category: TodoCategory.general,
        completed: true,
      );
      when(() => mockTodoService.updateTodo(
            id: any(named: 'id'),
            title: any(named: 'title'),
            description: any(named: 'description'),
            completed: any(named: 'completed'),
          )).thenAnswer((_) async => Right(updatedTodo));

      // Act
      final result = await useCase.execute(
        id: 'test_id',
        title: 'Updated Todo',
        completed: true,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (returnedTodo) {
          expect(returnedTodo.title, 'Updated Todo');
          expect(returnedTodo.completed, true);
        },
      );
      verify(() => mockTodoService.updateTodo(
            id: any(named: 'id'),
            title: any(named: 'title'),
            completed: any(named: 'completed'),
          )).called(1);
    });

    test('should return ValidationError when id is null', () async {
      // Act
      final result = await useCase.execute(id: null, title: 'Updated');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Todo ID is required');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
      verifyNever(() => mockTodoService.updateTodo(
            id: any(named: 'id'),
            title: any(named: 'title'),
          ));
    });

    test('should return ValidationError when id is empty', () async {
      // Act
      final result = await useCase.execute(id: '   ', title: 'Updated');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Todo ID is required');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
    });

    test('should return ValidationError when title is empty', () async {
      // Act
      final result = await useCase.execute(id: 'test_id', title: '   ');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Title cannot be empty');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
    });

    test('should trim title and description', () async {
      // Arrange
      final updatedTodo = Todo(
        id: 'test_id',
        title: 'Trimmed Title',
        category: TodoCategory.general,
      );
      when(() => mockTodoService.updateTodo(
            id: any(named: 'id'),
            title: any(named: 'title'),
            description: any(named: 'description'),
            completed: any(named: 'completed'),
          )).thenAnswer((_) async => Right(updatedTodo));

      // Act
      await useCase.execute(
        id: 'test_id',
        title: '  Trimmed Title  ',
        description: '  Trimmed Description  ',
      );

      // Assert
      verify(() => mockTodoService.updateTodo(
            id: 'test_id',
            title: 'Trimmed Title',
            description: 'Trimmed Description',
            completed: null,
          )).called(1);
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = NetworkError('Failed to update todo');
      when(() => mockTodoService.updateTodo(
            id: any(named: 'id'),
            title: any(named: 'title'),
          )).thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute(
        id: 'test_id',
        title: 'Updated',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<NetworkError>());
          expect(returnedError.message, 'Failed to update todo');
        },
        (todo) => fail('Expected error but got success: $todo'),
      );
    });
  });
}

