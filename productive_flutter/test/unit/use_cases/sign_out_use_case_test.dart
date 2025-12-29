import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/auth/use_cases/sign_out_use_case.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import '../../helpers/mocks.dart';

void main() {
  group('SignOutUseCase', () {
    late MockAuthService mockAuthService;
    late SignOutUseCase useCase;

    setUp(() {
      mockAuthService = MockAuthService();
      useCase = SignOutUseCase(mockAuthService);
    });

    test('should sign out successfully', () async {
      // Arrange
      when(() => mockAuthService.signOut())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (_) => expect(true, true),
      );
      verify(() => mockAuthService.signOut()).called(1);
    });

    test('should return error when service fails', () async {
      // Arrange
      final error = UnknownError('Failed to sign out');
      when(() => mockAuthService.signOut())
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (returnedError) {
          expect(returnedError, isA<UnknownError>());
          expect(returnedError.message, 'Failed to sign out');
        },
        (_) => fail('Expected error but got success'),
      );
    });
  });
}

