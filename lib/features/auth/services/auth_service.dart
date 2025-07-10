import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as app_user;

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message';
}

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<app_user.User?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final UserCredential userCredential = await _firebaseAuth.signInWithProvider(googleProvider);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw const AuthException('Failed to sign in with Firebase');
      }

      return _convertFirebaseUserToAppUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      throw AuthException('Firebase authentication failed: ${e.message}', code: e.code);
    } catch (e) {
      throw AuthException('Google sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }

  app_user.User? getCurrentUser() {
    final User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    
    return _convertFirebaseUserToAppUser(firebaseUser);
  }

  Stream<app_user.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((User? firebaseUser) {
      if (firebaseUser == null) return null;
      return _convertFirebaseUserToAppUser(firebaseUser);
    });
  }

  app_user.User _convertFirebaseUserToAppUser(User firebaseUser) {
    return app_user.User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoURL: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().add(const Duration(days: 14)),
    );
  }
}