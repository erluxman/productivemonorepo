import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/core/errors/app_error.dart';

void main() {
  group('AppError', () {
    group('ValidationError', () {
      test('should create with message', () {
        // Act
        const error = ValidationError('Invalid input');

        // Assert
        expect(error, isA<AppError>());
        expect(error.message, 'Invalid input');
      });
    });

    group('NetworkError', () {
      test('should create with message', () {
        // Act
        const error = NetworkError('Network failure');

        // Assert
        expect(error, isA<AppError>());
        expect(error.message, 'Network failure');
      });
    });

    group('AuthError', () {
      test('should create with message', () {
        // Act
        const error = AuthError('Authentication failed');

        // Assert
        expect(error, isA<AppError>());
        expect(error.message, 'Authentication failed');
      });
    });

    group('UnknownError', () {
      test('should create with message', () {
        // Act
        const error = UnknownError('Unexpected error');

        // Assert
        expect(error, isA<AppError>());
        expect(error.message, 'Unexpected error');
      });
    });
  });
}

