import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/auth/use_cases/send_password_reset_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import '../../helpers/mocks.dart';

void main() {
  group('SendPasswordResetUseCase', () {
    late MockAuthService mockAuthService;
    late SendPasswordResetUseCase useCase;

    setUp(() {
      mockAuthService = MockAuthService();
      useCase = SendPasswordResetUseCase(mockAuthService);
    });

    test('should send password reset email successfully', () async {
      // Arrange
      when(() => mockAuthService.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase.execute('test@example.com');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (_) => expect(true, true),
      );
      verify(() => mockAuthService.sendPasswordResetEmail('test@example.com')).called(1);
    });

    test('should trim email before passing to service', () async {
      // Arrange
      when(() => mockAuthService.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      await useCase.execute('  test@example.com  ');

      // Assert
      verify(() => mockAuthService.sendPasswordResetEmail('test@example.com')).called(1);
    });

    test('should return ValidationError when email is empty', () async {
      // Act
      final result = await useCase.execute('');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Email is required');
        },
        (_) => fail('Expected error but got success'),
      );
      verifyNever(() => mockAuthService.sendPasswordResetEmail(any()));
    });

    test('should return ValidationError when email is only whitespace', () async {
      // Act
      final result = await useCase.execute('   ');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Email is required');
        },
        (_) => fail('Expected error but got success'),
      );
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = AuthError('User not found');
      when(() => mockAuthService.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute('test@example.com');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<AuthError>());
          expect(returnedError.message, 'User not found');
        },
        (_) => fail('Expected error but got success'),
      );
    });
  });
}

