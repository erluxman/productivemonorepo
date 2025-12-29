import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../errors/app_error.dart';
import '../services/auth_service.dart';

/// Use case for signing in with email and password
/// Following cursor rules: Use cases return Either<AppError, T>
class SignInUseCase {
  final AuthService _authService;

  SignInUseCase(this._authService);

  Future<Either<AppError, UserCredential>> execute({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.trim().isEmpty) {
      return const Left(ValidationError('Email is required'));
    }
    
    if (password.trim().isEmpty) {
      return const Left(ValidationError('Password is required'));
    }

    // Delegate to service
    return _authService.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }
}

