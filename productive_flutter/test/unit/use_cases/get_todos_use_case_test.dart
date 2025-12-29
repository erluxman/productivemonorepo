import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/todo/use_cases/get_todos_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import 'package:productive_flutter/models/todo.dart';
import '../../helpers/mocks.dart';

void main() {
  group('GetTodosUseCase', () {
    late MockTodoService mockTodoService;
    late GetTodosUseCase useCase;

    setUp(() {
      mockTodoService = MockTodoService();
      useCase = GetTodosUseCase(mockTodoService);
    });

    test('should return list of todos on success', () async {
      // Arrange
      final todos = [
        Todo(title: 'Todo 1', category: TodoCategory.general),
        Todo(title: 'Todo 2', category: TodoCategory.work),
      ];
      when(() => mockTodoService.getTodos())
          .thenAnswer((_) async => Right(todos));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (returnedTodos) {
          expect(returnedTodos.length, 2);
          expect(returnedTodos[0].title, 'Todo 1');
        },
      );
      verify(() => mockTodoService.getTodos()).called(1);
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = NetworkError('Failed to load todos');
      when(() => mockTodoService.getTodos())
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<NetworkError>());
          expect(returnedError.message, 'Failed to load todos');
        },
        (todos) => fail('Expected error but got success: $todos'),
      );
    });
  });
}

