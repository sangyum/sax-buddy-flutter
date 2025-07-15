import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/practice_routine.dart';
import '../../../services/logger_service.dart';
import 'package:injectable/injectable.dart';
import '../../auth/repositories/user_repository.dart';

@injectable
class PracticeRoutineRepository {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;
  static const String _collection = 'practice_routines';

  PracticeRoutineRepository(this._firestore, this._logger);

  Future<void> createRoutine(PracticeRoutine routine) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Creating practice routine in Firestore', extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'title': routine.title,
        'isAIGenerated': routine.isAIGenerated,
      });
      
      await _firestore
          .collection(_collection)
          .doc(routine.userId)
          .collection('routines')
          .doc(routine.id)
          .set(routine.toJson());
      
      stopwatch.stop();
      
      _logger.info('Practice routine created successfully', extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'title': routine.title,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('create_practice_routine', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('create_practice_routine', e, extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to create practice routine: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('create_practice_routine', e, extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to create practice routine: $e');
    }
  }

  Future<PracticeRoutine?> getRoutine(String userId, String routineId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Fetching practice routine from Firestore', extra: {
        'userId': userId,
        'routineId': routineId,
      });
      
      final doc = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('routines')
          .doc(routineId)
          .get();
      
      stopwatch.stop();
      
      if (!doc.exists) {
        _logger.info('Practice routine not found in Firestore', extra: {
          'userId': userId,
          'routineId': routineId,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        return null;
      }

      final data = doc.data();
      if (data == null) {
        _logger.warning('Practice routine document exists but has no data', extra: {
          'userId': userId,
          'routineId': routineId,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        return null;
      }

      final routine = PracticeRoutine.fromJson(data);
      _logger.debug('Practice routine fetched successfully', extra: {
        'userId': userId,
        'routineId': routineId,
        'title': routine.title,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('get_practice_routine', stopwatch.elapsed);
      return routine;
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('get_practice_routine', e, extra: {
        'userId': userId,
        'routineId': routineId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get practice routine: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('get_practice_routine', e, extra: {
        'userId': userId,
        'routineId': routineId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get practice routine: $e');
    }
  }

  Future<List<PracticeRoutine>> getUserRoutines(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Fetching user practice routines from Firestore', extra: {
        'userId': userId,
      });
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('routines')
          .get();
      
      stopwatch.stop();
      
      final routines = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PracticeRoutine.fromJson(data);
      }).toList();
      
      _logger.debug('User practice routines fetched successfully', extra: {
        'userId': userId,
        'routineCount': routines.length,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('get_user_practice_routines', stopwatch.elapsed);
      return routines;
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('get_user_practice_routines', e, extra: {
        'userId': userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get user practice routines: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('get_user_practice_routines', e, extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get user practice routines: $e');
    }
  }

  Future<void> updateRoutine(PracticeRoutine routine) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Updating practice routine in Firestore', extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'title': routine.title,
      });
      
      await _firestore
          .collection(_collection)
          .doc(routine.userId)
          .collection('routines')
          .doc(routine.id)
          .update(routine.toJson());
      
      stopwatch.stop();
      
      _logger.info('Practice routine updated successfully', extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('update_practice_routine', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('update_practice_routine', e, extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to update practice routine: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('update_practice_routine', e, extra: {
        'routineId': routine.id,
        'userId': routine.userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to update practice routine: $e');
    }
  }

  Future<void> deleteRoutine(String userId, String routineId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Deleting practice routine from Firestore', extra: {
        'userId': userId,
        'routineId': routineId,
      });
      
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('routines')
          .doc(routineId)
          .delete();
      
      stopwatch.stop();
      
      _logger.info('Practice routine deleted successfully', extra: {
        'userId': userId,
        'routineId': routineId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('delete_practice_routine', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('delete_practice_routine', e, extra: {
        'userId': userId,
        'routineId': routineId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to delete practice routine: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('delete_practice_routine', e, extra: {
        'userId': userId,
        'routineId': routineId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to delete practice routine: $e');
    }
  }

  Future<List<PracticeRoutine>> getCurrentRoutineSet(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Fetching current routine set from Firestore', extra: {
        'userId': userId,
      });
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('routines')
          .where('isCurrent', isEqualTo: true)
          .get();
      
      stopwatch.stop();
      
      final routines = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PracticeRoutine.fromJson(data);
      }).toList();
      
      _logger.debug('Current routine set fetched successfully', extra: {
        'userId': userId,
        'routineCount': routines.length,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('get_current_routine_set', stopwatch.elapsed);
      return routines;
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('get_current_routine_set', e, extra: {
        'userId': userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get current routine set: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('get_current_routine_set', e, extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get current routine set: $e');
    }
  }

  Future<void> markRoutinesAsNotCurrent(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Marking routines as not current in Firestore', extra: {
        'userId': userId,
      });
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('routines')
          .where('isCurrent', isEqualTo: true)
          .get();
      
      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isCurrent': false});
      }
      
      await batch.commit();
      
      stopwatch.stop();
      
      _logger.debug('Routines marked as not current successfully', extra: {
        'userId': userId,
        'routineCount': querySnapshot.docs.length,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('mark_routines_not_current', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('mark_routines_not_current', e, extra: {
        'userId': userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to mark routines as not current: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('mark_routines_not_current', e, extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to mark routines as not current: $e');
    }
  }
}