import 'package:fpdart/fpdart.dart';

import '../../errors/app_error.dart';
import '../services/auth_service.dart';

/// Use case for sending password reset email
/// Following cursor rules: Use cases return Either<AppError, T>
class SendPasswordResetUseCase {
  final AuthService _authService;

  SendPasswordResetUseCase(this._authService);

  Future<Either<AppError, void>> execute(String email) async {
    // Validation
    if (email.trim().isEmpty) {
      return const Left(ValidationError('Email is required'));
    }

    // Delegate to service
    return _authService.sendPasswordResetEmail(email.trim());
  }
}

