import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as app_user;
import '../../../services/logger_service.dart';
import 'package:injectable/injectable.dart';

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message';
}

@singleton
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final LoggerService _logger;

  AuthService(this._firebaseAuth, this._logger);

  Future<app_user.User?> signInWithGoogle() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.logAuthEvent('google_signin_attempt');
      
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final UserCredential userCredential = await _firebaseAuth.signInWithProvider(googleProvider);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        _logger.logAuthEvent('google_signin_failed', extra: {'reason': 'null_user'});
        throw const AuthException('Failed to sign in with Firebase');
      }

      final appUser = _convertFirebaseUserToAppUser(firebaseUser);
      stopwatch.stop();
      
      _logger.logAuthEvent('google_signin_success', 
        userId: appUser.id,
        extra: {
          'email': appUser.email,
          'displayName': appUser.displayName,
          'durationMs': stopwatch.elapsedMilliseconds,
        }
      );
      
      _logger.logPerformance('google_signin', stopwatch.elapsed);
      
      return appUser;
    } on FirebaseAuthException catch (e) {
      stopwatch.stop();
      _logger.logError('google_signin', e, 
        extra: {
          'code': e.code,
          'message': e.message,
          'durationMs': stopwatch.elapsedMilliseconds,
        }
      );
      throw AuthException('Firebase authentication failed: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('google_signin', e,
        extra: {'durationMs': stopwatch.elapsedMilliseconds}
      );
      throw AuthException('Google sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      _logger.logAuthEvent('signout_attempt');
      await _firebaseAuth.signOut();
      _logger.logAuthEvent('signout_success');
    } catch (e) {
      _logger.logError('signout', e);
      throw AuthException('Sign out failed: $e');
    }
  }

  app_user.User? getCurrentUser() {
    try {
      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        _logger.debug('getCurrentUser: No current user');
        return null;
      }
      
      final appUser = _convertFirebaseUserToAppUser(firebaseUser);
      _logger.debug('getCurrentUser: Retrieved current user', 
        extra: {'userId': appUser.id, 'email': appUser.email});
      
      return appUser;
    } catch (e) {
      _logger.logError('get_current_user', e);
      return null;
    }
  }

  Stream<app_user.User?> authStateChanges() {
    _logger.debug('Setting up auth state change listener');
    
    return _firebaseAuth.authStateChanges().map((User? firebaseUser) {
      if (firebaseUser == null) {
        _logger.logAuthEvent('auth_state_change', extra: {'state': 'signed_out'});
        return null;
      }
      
      final appUser = _convertFirebaseUserToAppUser(firebaseUser);
      _logger.logAuthEvent('auth_state_change', 
        userId: appUser.id,
        extra: {'state': 'signed_in', 'email': appUser.email}
      );
      
      return appUser;
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