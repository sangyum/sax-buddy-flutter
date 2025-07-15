import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assessment_result.dart';
import '../../../services/logger_service.dart';
import 'package:injectable/injectable.dart';
import '../../auth/repositories/user_repository.dart';

@injectable
class AssessmentRepository {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;
  static const String _collection = 'assessments';

  AssessmentRepository(this._firestore, this._logger);

  Future<void> createAssessment(String userId, AssessmentResult assessment) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Creating assessment in Firestore', extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'skillLevel': assessment.skillLevel.name,
        'exerciseCount': assessment.exerciseResults.length,
      });
      
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('results')
          .doc(assessment.sessionId)
          .set(assessment.toJson());
      
      stopwatch.stop();
      
      _logger.info('Assessment created successfully', extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'skillLevel': assessment.skillLevel.name,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('create_assessment', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('create_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to create assessment: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('create_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to create assessment: $e');
    }
  }

  Future<AssessmentResult?> getAssessment(String userId, String assessmentId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Fetching assessment from Firestore', extra: {
        'userId': userId,
        'assessmentId': assessmentId,
      });
      
      final doc = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('results')
          .doc(assessmentId)
          .get();
      
      stopwatch.stop();
      
      if (!doc.exists) {
        _logger.info('Assessment not found in Firestore', extra: {
          'userId': userId,
          'assessmentId': assessmentId,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        return null;
      }

      final data = doc.data();
      if (data == null) {
        _logger.warning('Assessment document exists but has no data', extra: {
          'userId': userId,
          'assessmentId': assessmentId,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        return null;
      }

      final assessment = AssessmentResult.fromJson(data);
      _logger.debug('Assessment fetched successfully', extra: {
        'userId': userId,
        'assessmentId': assessmentId,
        'skillLevel': assessment.skillLevel.name,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('get_assessment', stopwatch.elapsed);
      return assessment;
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('get_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessmentId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get assessment: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('get_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessmentId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get assessment: $e');
    }
  }

  Future<List<AssessmentResult>> getUserAssessments(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Fetching user assessments from Firestore', extra: {
        'userId': userId,
      });
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('results')
          .get();
      
      stopwatch.stop();
      
      final assessments = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return AssessmentResult.fromJson(data);
      }).toList();
      
      _logger.debug('User assessments fetched successfully', extra: {
        'userId': userId,
        'assessmentCount': assessments.length,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('get_user_assessments', stopwatch.elapsed);
      return assessments;
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('get_user_assessments', e, extra: {
        'userId': userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get user assessments: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('get_user_assessments', e, extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get user assessments: $e');
    }
  }

  Future<void> updateAssessment(String userId, AssessmentResult assessment) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Updating assessment in Firestore', extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'skillLevel': assessment.skillLevel.name,
      });
      
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('results')
          .doc(assessment.sessionId)
          .update(assessment.toJson());
      
      stopwatch.stop();
      
      _logger.info('Assessment updated successfully', extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('update_assessment', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('update_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to update assessment: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('update_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessment.sessionId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to update assessment: $e');
    }
  }

  Future<void> deleteAssessment(String userId, String assessmentId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Deleting assessment from Firestore', extra: {
        'userId': userId,
        'assessmentId': assessmentId,
      });
      
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('results')
          .doc(assessmentId)
          .delete();
      
      stopwatch.stop();
      
      _logger.info('Assessment deleted successfully', extra: {
        'userId': userId,
        'assessmentId': assessmentId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('delete_assessment', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('delete_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessmentId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to delete assessment: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('delete_assessment', e, extra: {
        'userId': userId,
        'assessmentId': assessmentId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to delete assessment: $e');
    }
  }

}