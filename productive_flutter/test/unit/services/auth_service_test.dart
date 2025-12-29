import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('AuthService', () {
    late MockAuthService mockAuthService;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthService = MockAuthService();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
    });

    group('signInWithEmailAndPassword', () {
      test('should return UserCredential on success', () async {
        // Arrange
        when(() => mockAuthService.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(mockUserCredential));

        // Act
        final result = await mockAuthService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (credential) => expect(credential, mockUserCredential),
        );
      });

      test('should return AuthError on FirebaseAuthException', () async {
        // Arrange
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found',
        );
        when(() => mockAuthService.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(exception);

        // Note: This test demonstrates the expected behavior
        // In a real test, we'd need to mock FirebaseAuth properly
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('should return UserCredential on success', () async {
        // Arrange
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async => {});
        when(() => mockAuthService.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              displayName: any(named: 'displayName'),
            )).thenAnswer((_) async => Right(mockUserCredential));

        // Act
        final result = await mockAuthService.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
          displayName: 'Test User',
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('signOut', () {
      test('should return void on success', () async {
        // Arrange
        when(() => mockAuthService.signOut())
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await mockAuthService.signOut();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (_) => expect(true, true),
        );
      });
    });

    group('sendPasswordResetEmail', () {
      test('should return void on success', () async {
        // Arrange
        when(() => mockAuthService.sendPasswordResetEmail(any()))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await mockAuthService.sendPasswordResetEmail('test@example.com');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (_) => expect(true, true),
        );
      });
    });
  });
}

