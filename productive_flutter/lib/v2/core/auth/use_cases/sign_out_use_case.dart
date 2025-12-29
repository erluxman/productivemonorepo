import 'package:fpdart/fpdart.dart';

import '../../errors/app_error.dart';
import '../services/auth_service.dart';

/// Use case for signing out
/// Following cursor rules: Use cases return Either<AppError, T>
class SignOutUseCase {
  final AuthService _authService;

  SignOutUseCase(this._authService);

  Future<Either<AppError, void>> execute() async {
    return _authService.signOut();
  }
}

