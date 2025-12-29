import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/auth/use_cases/sign_up_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import '../../helpers/mocks.dart';

void main() {
  group('SignUpUseCase', () {
    late MockAuthService mockAuthService;
    late SignUpUseCase useCase;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthService = MockAuthService();
      useCase = SignUpUseCase(mockAuthService);
      mockUserCredential = MockUserCredential();
    });

    test('should sign up successfully with valid credentials', () async {
      // Arrange
      when(() => mockAuthService.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          )).thenAnswer((_) async => Right(mockUserCredential));

      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: 'password123',
        displayName: 'Test User',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (credential) => expect(credential, mockUserCredential),
      );
      verify(() => mockAuthService.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'Test User',
          )).called(1);
    });

    test('should trim email and displayName', () async {
      // Arrange
      when(() => mockAuthService.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          )).thenAnswer((_) async => Right(mockUserCredential));

      // Act
      await useCase.execute(
        email: '  test@example.com  ',
        password: 'password123',
        displayName: '  Test User  ',
      );

      // Assert
      verify(() => mockAuthService.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'Test User',
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

    test('should return ValidationError when password is too short', () async {
      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: '12345',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (error) {
          expect(error, isA<ValidationError>());
          expect(error.message, 'Password must be at least 6 characters');
        },
        (credential) => fail('Expected error but got success: $credential'),
      );
    });

    test('should accept password with exactly 6 characters', () async {
      // Arrange
      when(() => mockAuthService.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          )).thenAnswer((_) async => Right(mockUserCredential));

      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: '123456',
      );

      // Assert
      expect(result.isRight(), true);
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = AuthError('Email already in use');
      when(() => mockAuthService.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          )).thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<AuthError>());
          expect(returnedError.message, 'Email already in use');
        },
        (credential) => fail('Expected error but got success: $credential'),
      );
    });
  });
}

