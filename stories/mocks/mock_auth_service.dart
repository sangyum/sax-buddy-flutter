import 'dart:async';
import 'package:sax_buddy/features/auth/models/user.dart';

/// Mock AuthService for Storybook
class MockAuthService {
  final StreamController<User?> _authStateController = StreamController<User?>();
  User? _currentUser;

  MockAuthService() {
    // Initialize with a mock user for storybook
    _currentUser = User(
      id: 'mock_user_123',
      email: 'demo@saxbuddy.com',
      displayName: 'Demo User',
      photoURL: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().add(const Duration(days: 7)),
    );
    
    // Emit the initial user state
    Future.microtask(() => _authStateController.add(_currentUser));
  }

  Stream<User?> authStateChanges() {
    return _authStateController.stream;
  }

  User? get currentUser => _currentUser;

  Future<User?> signInWithGoogle() async {
    _currentUser = User(
      id: 'mock_google_user',
      email: 'google@saxbuddy.com',
      displayName: 'Google User',
      photoURL: 'https://via.placeholder.com/100',
      createdAt: DateTime.now(),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().add(const Duration(days: 14)),
    );
    
    _authStateController.add(_currentUser);
    return _currentUser;
  }

  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}