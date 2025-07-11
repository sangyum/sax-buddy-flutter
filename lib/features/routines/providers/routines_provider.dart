import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/practice/repositories/practice_routine_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class RoutinesProvider extends ChangeNotifier {
  final LoggerService _logger;
  final PracticeRoutineRepository _repository;
  final List<PracticeRoutine> _recentRoutines = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;
  static const int _maxRecentRoutines = 10;

  RoutinesProvider(this._logger, this._repository);

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
  Future<void> addRoutines(List<PracticeRoutine> routines) async {
    try {
      _logger.debug('Adding ${routines.length} routines');
      
      // Add to local list first for immediate UI update
      for (final routine in routines.reversed) {
        _recentRoutines.insert(0, routine);
      }
      
      // Limit the number of recent routines
      if (_recentRoutines.length > _maxRecentRoutines) {
        _recentRoutines.removeRange(_maxRecentRoutines, _recentRoutines.length);
      }
      
      _clearError();
      notifyListeners();
      
      // Save each routine to Firestore if user ID is set
      if (_userId != null) {
        for (final routine in routines) {
          try {
            await saveRoutine(routine);
          } catch (e) {
            _logger.error('Failed to save routine ${routine.title}: $e');
            // Continue with other routines even if one fails
          }
        }
      } else {
        _logger.warning('User ID not set, routines not persisted to Firestore');
      }
      
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

  /// Set user ID for persistence operations
  void setUserId(String userId) {
    _userId = userId;
    _logger.debug('User ID set for routines provider: $userId');
  }

  /// Load user's routines from Firestore
  Future<void> loadUserRoutines() async {
    if (_userId == null) {
      _logger.warning('Cannot load routines: user ID not set');
      return;
    }

    try {
      _logger.debug('Loading user routines from Firestore');
      setLoading(true);
      
      final routines = await _repository.getUserRoutines(_userId!);
      
      _recentRoutines.clear();
      _recentRoutines.addAll(routines);
      
      // Limit to max recent routines, keep most recent
      if (_recentRoutines.length > _maxRecentRoutines) {
        _recentRoutines.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _recentRoutines.removeRange(_maxRecentRoutines, _recentRoutines.length);
      }
      
      _clearError();
      _logger.debug('User routines loaded successfully: ${routines.length} routines');
    } catch (e) {
      _logger.error('Failed to load user routines: $e');
      setError('Failed to load routines: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Save a routine to Firestore
  Future<void> saveRoutine(PracticeRoutine routine) async {
    if (_userId == null) {
      _logger.warning('Cannot save routine: user ID not set');
      return;
    }

    try {
      _logger.debug('Saving routine to Firestore: ${routine.title}');
      
      // Create a copy with the correct user ID
      final routineToSave = PracticeRoutine(
        id: routine.id,
        userId: _userId!,
        title: routine.title,
        description: routine.description,
        targetAreas: routine.targetAreas,
        difficulty: routine.difficulty,
        estimatedDuration: routine.estimatedDuration,
        exercises: routine.exercises,
        createdAt: routine.createdAt,
        updatedAt: DateTime.now(),
        isAIGenerated: routine.isAIGenerated,
      );
      
      await _repository.createRoutine(routineToSave);
      _logger.debug('Routine saved successfully: ${routine.title}');
    } catch (e) {
      _logger.error('Failed to save routine: $e');
      setError('Failed to save routine: $e');
      rethrow;
    }
  }

  /// Delete a routine from Firestore
  Future<void> deleteRoutine(String routineId) async {
    if (_userId == null) {
      _logger.warning('Cannot delete routine: user ID not set');
      return;
    }

    try {
      _logger.debug('Deleting routine from Firestore: $routineId');
      
      await _repository.deleteRoutine(_userId!, routineId);
      
      // Remove from local list
      _recentRoutines.removeWhere((routine) => routine.id == routineId);
      
      _clearError();
      notifyListeners();
      _logger.debug('Routine deleted successfully: $routineId');
    } catch (e) {
      _logger.error('Failed to delete routine: $e');
      setError('Failed to delete routine: $e');
    }
  }

  /// Sync routines between memory and Firestore
  Future<void> syncRoutines() async {
    if (_userId == null) {
      _logger.warning('Cannot sync routines: user ID not set');
      return;
    }

    try {
      _logger.debug('Syncing routines with Firestore');
      setLoading(true);
      
      // Load latest from Firestore
      await loadUserRoutines();
      
      _logger.debug('Routines synced successfully');
    } catch (e) {
      _logger.error('Failed to sync routines: $e');
      setError('Failed to sync routines: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'routineCount': _recentRoutines.length,
      'isLoading': _isLoading,
      'hasError': _error != null,
      'error': _error,
      'userId': _userId,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}