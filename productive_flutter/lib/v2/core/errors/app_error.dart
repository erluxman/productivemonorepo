/// Error types for the application layer
/// Following cursor rules: Use fpdart Either pattern for error handling

sealed class AppError {
  const AppError();
  
  String get message;
}

/// Validation errors for input validation failures
class ValidationError extends AppError {
  @override
  final String message;
  
  const ValidationError(this.message);
}

/// Network errors for API/network failures
class NetworkError extends AppError {
  @override
  final String message;
  
  const NetworkError(this.message);
}

/// Authentication errors
class AuthError extends AppError {
  @override
  final String message;
  
  const AuthError(this.message);
}

/// Unknown/unexpected errors
class UnknownError extends AppError {
  @override
  final String message;
  
  const UnknownError(this.message);
}

