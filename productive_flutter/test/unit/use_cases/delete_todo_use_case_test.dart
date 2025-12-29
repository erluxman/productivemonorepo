import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/todo/use_cases/delete_todo_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import '../../helpers/mocks.dart';

void main() {
  group('DeleteTodoUseCase', () {
    late MockTodoService mockTodoService;
    late DeleteTodoUseCase useCase;

    setUp(() {
      mockTodoService = MockTodoService();
      useCase = DeleteTodoUseCase(mockTodoService);
    });

    test('should delete todo successfully with valid id', () async {
      // Arrange
      when(() => mockTodoService.deleteTodo(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase.execute('test_id');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (_) => expect(true, true),
      );
      verify(() => mockTodoService.deleteTodo('test_id')).called(1);
    });

    test('should return ValidationError when id is empty', () async {
      // Act
      final result = await useCase.execute('   ');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Todo ID is required');
        },
        (_) => fail('Expected error but got success'),
      );
      verifyNever(() => mockTodoService.deleteTodo(any()));
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = NetworkError('Failed to delete todo');
      when(() => mockTodoService.deleteTodo(any()))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute('test_id');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<NetworkError>());
          expect(returnedError.message, 'Failed to delete todo');
        },
        (_) => fail('Expected error but got success'),
      );
    });
  });
}

