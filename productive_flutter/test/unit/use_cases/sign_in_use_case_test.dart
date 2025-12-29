import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/auth/use_cases/sign_in_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import '../../helpers/mocks.dart';

void main() {
  group('SignInUseCase', () {
    late MockAuthService mockAuthService;
    late SignInUseCase useCase;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthService = MockAuthService();
      useCase = SignInUseCase(mockAuthService);
      mockUserCredential = MockUserCredential();
    });

    test('should sign in successfully with valid credentials', () async {
      // Arrange
      when(() => mockAuthService.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(mockUserCredential));

      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (credential) => expect(credential, mockUserCredential),
      );
      verify(() => mockAuthService.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('should trim email before passing to service', () async {
      // Arrange
      when(() => mockAuthService.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(mockUserCredential));

      // Act
      await useCase.execute(
        email: '  test@example.com  ',
        password: 'password123',
      );

      // Assert
      verify(() => mockAuthService.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('should return ValidationError when email is empty', () async {
      // Act
      final result = await useCase.execute(
        email: '',
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Email is required');
        },
        (credential) => fail('Expected error but got success: $credential'),
      );
      verifyNever(() => mockAuthService.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('should return ValidationError when email is only whitespace', () async {
      // Act
      final result = await useCase.execute(
        email: '   ',
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Email is required');
        },
        (credential) => fail('Expected error but got success: $credential'),
      );
    });

    test('should return ValidationError when password is empty', () async {
      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: '',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Password is required');
        },
        (credential) => fail('Expected error but got success: $credential'),
      );
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = AuthError('Invalid credentials');
      when(() => mockAuthService.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: 'wrongpassword',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<AuthError>());
          expect(returnedError.message, 'Invalid credentials');
        },
        (credential) => fail('Expected error but got success: $credential'),
      );
    });
  });
}

