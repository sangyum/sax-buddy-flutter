import 'package:flutter/foundation.dart';
import 'package:sax_buddy/features/auth/models/user.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Mock AuthProvider for Storybook with same interface as real AuthProvider
class MockAuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.authenticated;
  User? _user;
  String? _errorMessage;

  MockAuthProvider() {
    // Initialize with a mock authenticated user for storybook
    _user = User(
      id: 'mock_user_123',
      email: 'demo@saxbuddy.com',
      displayName: 'Demo User',
      photoURL: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  // Getters matching AuthProvider interface
  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  bool get isLoading => _state == AuthState.loading;

  // Mock methods for storybook interactions
  Future<void> signInWithGoogle() async {
    _state = AuthState.loading;
    notifyListeners();
    
    // Simulate authentication process
    await Future.delayed(const Duration(seconds: 1));
    
    _user = User(
      id: 'mock_google_user',
      email: 'google@saxbuddy.com',
      displayName: 'Google User',
      photoURL: 'https://via.placeholder.com/100',
      createdAt: DateTime.now(),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().add(const Duration(days: 14)),
    );
    
    _state = AuthState.authenticated;
    notifyListeners();
  }

  Future<void> signOut() async {
    _state = AuthState.loading;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _state = AuthState.unauthenticated;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Helper methods to change user state for different stories
  void setTrialUser() {
    _user = User(
      id: 'trial_user_456',
      email: 'trial@saxbuddy.com',
      displayName: 'Trial User',
      photoURL: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().add(const Duration(days: 11)),
    );
    notifyListeners();
  }

  void setSubscribedUser() {
    _user = User(
      id: 'subscribed_user_789',
      email: 'subscribed@saxbuddy.com',
      displayName: 'Premium User',
      photoURL: null,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      hasActiveSubscription: true,
      trialEndsAt: null,
    );
    notifyListeners();
  }

  void setExpiredTrialUser() {
    _user = User(
      id: 'expired_user_101',
      email: 'expired@saxbuddy.com',
      displayName: 'Expired Trial User',
      photoURL: null,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      hasActiveSubscription: false,
      trialEndsAt: DateTime.now().subtract(const Duration(days: 1)),
    );
    notifyListeners();
  }
}