import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../repositories/user_repository.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserRepository _userRepository;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  AuthProvider({
    required AuthService authService,
    required UserRepository userRepository,
  })  : _authService = authService,
        _userRepository = userRepository {
    _initializeAuth();
  }

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  bool get isLoading => _state == AuthState.loading;

  void _initializeAuth() {
    _authService.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        _state = AuthState.authenticated;
      } else {
        _user = null;
        _state = AuthState.unauthenticated;
      }
      notifyListeners();
    });

    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      _user = currentUser;
      _state = AuthState.authenticated;
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _state = AuthState.loading;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      if (user != null) {
        try {
          await _userRepository.createUser(user);
        } on RepositoryException catch (e) {
          final existingUser = await _userRepository.getUser(user.id);
          if (existingUser != null) {
            _user = existingUser;
            _state = AuthState.authenticated;
            return;
          } else {
            _errorMessage = e.message;
            _state = AuthState.error;
            return;
          }
        }
        _user = user;
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _state = AuthState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      await _authService.signOut();
      _user = null;
      _state = AuthState.unauthenticated;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
    } catch (e) {
      _errorMessage = 'Failed to sign out: $e';
      _state = AuthState.error;
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    }
    notifyListeners();
  }
}