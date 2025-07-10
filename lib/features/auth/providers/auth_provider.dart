import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../repositories/user_repository.dart';
import '../../../services/logger_service.dart';

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
  final LoggerService _logger = LoggerService.instance;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  AuthProvider({
    required AuthService authService,
    required UserRepository userRepository,
  })  : _authService = authService,
        _userRepository = userRepository {
    _logger.info('Initializing AuthProvider');
    _initializeAuth();
  }

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  bool get isLoading => _state == AuthState.loading;

  void _initializeAuth() {
    _logger.debug('Setting up authentication state listener');
    
    _authService.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        _state = AuthState.authenticated;
        _logger.info('Auth state changed to authenticated', extra: {
          'userId': user.id,
          'email': user.email,
        });
      } else {
        _user = null;
        _state = AuthState.unauthenticated;
        _logger.info('Auth state changed to unauthenticated');
      }
      notifyListeners();
    });

    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      _user = currentUser;
      _state = AuthState.authenticated;
      _logger.info('Initial auth state: authenticated', extra: {
        'userId': currentUser.id,
        'email': currentUser.email,
      });
    } else {
      _state = AuthState.unauthenticated;
      _logger.info('Initial auth state: unauthenticated');
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Starting Google sign-in process');
      _state = AuthState.loading;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _logger.info('Google sign-in successful, creating user record', extra: {
          'userId': user.id,
          'email': user.email,
        });
        
        try {
          await _userRepository.createUser(user);
          _logger.info('User record created successfully', extra: {'userId': user.id});
        } on RepositoryException catch (e) {
          _logger.info('User record already exists, fetching existing user', extra: {
            'userId': user.id,
            'error': e.message,
          });
          
          final existingUser = await _userRepository.getUser(user.id);
          if (existingUser != null) {
            _user = existingUser;
            _state = AuthState.authenticated;
            stopwatch.stop();
            
            _logger.info('Sign-in completed with existing user', extra: {
              'userId': existingUser.id,
              'durationMs': stopwatch.elapsedMilliseconds,
            });
            
            _logger.logPerformance('google_signin_flow', stopwatch.elapsed);
            return;
          } else {
            _errorMessage = e.message;
            _state = AuthState.error;
            _logger.error('Failed to fetch existing user after creation failed', extra: {
              'userId': user.id,
              'error': e.message,
            });
            return;
          }
        }
        _user = user;
        _state = AuthState.authenticated;
        stopwatch.stop();
        
        _logger.info('Sign-in completed successfully', extra: {
          'userId': user.id,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        
        _logger.logPerformance('google_signin_flow', stopwatch.elapsed);
      } else {
        _state = AuthState.unauthenticated;
        _logger.info('Google sign-in cancelled by user');
      }
    } on AuthException catch (e) {
      stopwatch.stop();
      _errorMessage = e.message;
      _state = AuthState.error;
      _logger.logError('google_signin_flow', e, extra: {
        'durationMs': stopwatch.elapsedMilliseconds,
      });
    } catch (e) {
      stopwatch.stop();
      _errorMessage = 'An unexpected error occurred: $e';
      _state = AuthState.error;
      _logger.logError('google_signin_flow', e, extra: {
        'durationMs': stopwatch.elapsedMilliseconds,
      });
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      final userId = _user?.id;
      _logger.info('Starting sign-out process', extra: {
        if (userId != null) 'userId': userId,
      });
      
      _state = AuthState.loading;
      notifyListeners();

      await _authService.signOut();
      _user = null;
      _state = AuthState.unauthenticated;
      
      _logger.info('Sign-out completed successfully', extra: {
        if (userId != null) 'userId': userId,
      });
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
      _logger.logError('signout_flow', e);
    } catch (e) {
      _errorMessage = 'Failed to sign out: $e';
      _state = AuthState.error;
      _logger.logError('signout_flow', e);
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    _logger.debug('Clearing error state');
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
      _logger.debug('Error state cleared, new state: ${_state.name}');
    }
    notifyListeners();
  }
}