import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../errors/app_error.dart';

/// Authentication service
/// Following cursor rules:
/// - Keep Firebase Auth SDK usage in services, not UI
/// - Never log tokens or sensitive user data
/// - Handle all errors explicitly
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<Either<AppError, UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_handleAuthException(e)));
    } catch (e) {
      return Left(UnknownError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Create user with email and password
  Future<Either<AppError, UserCredential>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Create user document in Firestore
      if (credential.user != null) {
        final createDocResult = await _createUserDocument(credential.user!);
        // If document creation fails, we still return success for auth
        // as the user was created successfully
        createDocResult.fold(
          (error) {
            // Log error but don't fail the auth operation
            // In production, this should be logged to a logging service
          },
          (_) {},
        );
      }

      return Right(credential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_handleAuthException(e)));
    } catch (e) {
      return Left(UnknownError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Sign out
  Future<Either<AppError, void>> signOut() async {
    try {
      await _auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnknownError('Failed to sign out: ${e.toString()}'));
    }
  }

  // Send password reset email
  Future<Either<AppError, void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_handleAuthException(e)));
    } catch (e) {
      return Left(UnknownError('Failed to send password reset email: ${e.toString()}'));
    }
  }

  // Create user document in Firestore
  Future<Either<AppError, void>> _createUserDocument(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } catch (e) {
      return Left(UnknownError('Error creating user document: ${e.toString()}'));
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get user email
  String? get userEmail => currentUser?.email;

  // Get user display name
  String? get userDisplayName => currentUser?.displayName;

  // Get user ID
  String? get userId => currentUser?.uid;
}

