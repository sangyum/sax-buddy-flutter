import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/services/logger_service.dart';

class RoutinesProvider extends ChangeNotifier {
  final LoggerService _logger;
  final List<PracticeRoutine> _recentRoutines = [];
  bool _isLoading = false;
  String? _error;
  static const int _maxRecentRoutines = 10;

  RoutinesProvider({
    LoggerService? logger,
  }) : _logger = logger ?? LoggerService.instance;

  List<PracticeRoutine> get recentRoutines => List.unmodifiable(_recentRoutines);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Add a new routine to the recent routines list
  void addRoutine(PracticeRoutine routine) {
    try {
      _logger.debug('Adding routine: ${routine.title}');
      
      // Add to the beginning of the list (most recent first)
      _recentRoutines.insert(0, routine);
      
      // Limit the number of recent routines
      if (_recentRoutines.length > _maxRecentRoutines) {
        _recentRoutines.removeRange(_maxRecentRoutines, _recentRoutines.length);
      }
      
      _clearError();
      notifyListeners();
      
      _logger.debug('Routine added successfully. Total routines: ${_recentRoutines.length}');
    } catch (e) {
      _logger.error('Failed to add routine: $e');
      setError('Failed to add routine: $e');
    }
  }

  /// Add multiple routines at once
  void addRoutines(List<PracticeRoutine> routines) {
    try {
      _logger.debug('Adding ${routines.length} routines');
      
      for (final routine in routines.reversed) {
        _recentRoutines.insert(0, routine);
      }
      
      // Limit the number of recent routines
      if (_recentRoutines.length > _maxRecentRoutines) {
        _recentRoutines.removeRange(_maxRecentRoutines, _recentRoutines.length);
      }
      
      _clearError();
      notifyListeners();
      
      _logger.debug('${routines.length} routines added successfully. Total routines: ${_recentRoutines.length}');
    } catch (e) {
      _logger.error('Failed to add routines: $e');
      setError('Failed to add routines: $e');
    }
  }

  /// Get a routine by index
  PracticeRoutine? getRoutineAt(int index) {
    if (index >= 0 && index < _recentRoutines.length) {
      return _recentRoutines[index];
    }
    return null;
  }

  /// Clear all routines
  void clearRoutines() {
    try {
      _logger.debug('Clearing all routines');
      _recentRoutines.clear();
      _clearError();
      notifyListeners();
      _logger.debug('All routines cleared');
    } catch (e) {
      _logger.error('Failed to clear routines: $e');
      setError('Failed to clear routines: $e');
    }
  }

  /// Refresh the routines list
  Future<void> refreshRoutines() async {
    try {
      _logger.debug('Refreshing routines');
      setLoading(true);
      
      // In a real implementation, this would fetch from a database or API
      // For now, we'll just simulate a refresh
      await Future.delayed(const Duration(milliseconds: 500));
      
      _clearError();
      _logger.debug('Routines refreshed successfully');
    } catch (e) {
      _logger.error('Failed to refresh routines: $e');
      setError('Failed to refresh routines: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Set loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      if (loading) {
        _clearError();
      }
      notifyListeners();
    }
  }

  /// Set error state
  void setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    _error = null;
  }

  /// Check if there are any routines
  bool get hasRoutines => _recentRoutines.isNotEmpty;

  /// Get the total number of routines
  int get routineCount => _recentRoutines.length;

  /// Remove a routine by index
  void removeRoutineAt(int index) {
    try {
      if (index >= 0 && index < _recentRoutines.length) {
        final routine = _recentRoutines.removeAt(index);
        _logger.debug('Removed routine: ${routine.title}');
        _clearError();
        notifyListeners();
      }
    } catch (e) {
      _logger.error('Failed to remove routine: $e');
      setError('Failed to remove routine: $e');
    }
  }

  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'routineCount': _recentRoutines.length,
      'isLoading': _isLoading,
      'hasError': _error != null,
      'error': _error,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}