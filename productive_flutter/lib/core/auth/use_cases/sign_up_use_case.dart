import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../errors/app_error.dart';
import '../services/auth_service.dart';

/// Use case for signing up with email and password
/// Following cursor rules: Use cases return Either<AppError, T>
class SignUpUseCase {
  final AuthService _authService;

  SignUpUseCase(this._authService);

  Future<Either<AppError, UserCredential>> execute({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Validation
    if (email.trim().isEmpty) {
      return const Left(ValidationError('Email is required'));
    }
    
    if (password.trim().isEmpty) {
      return const Left(ValidationError('Password is required'));
    }
    
    if (password.length < 6) {
      return const Left(ValidationError('Password must be at least 6 characters'));
    }

    // Delegate to service
    return _authService.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
      displayName: displayName?.trim(),
    );
  }
}

