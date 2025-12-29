import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../use_cases/sign_in_use_case.dart';
import '../use_cases/sign_out_use_case.dart';
import '../use_cases/sign_up_use_case.dart';
import '../use_cases/send_password_reset_use_case.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Auth state provider - streams auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Sign in use case provider
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SignInUseCase(authService);
});

/// Sign up use case provider
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SignUpUseCase(authService);
});

/// Sign out use case provider
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SignOutUseCase(authService);
});

/// Send password reset use case provider
final sendPasswordResetUseCaseProvider = Provider<SendPasswordResetUseCase>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SendPasswordResetUseCase(authService);
});

