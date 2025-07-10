import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../../../services/logger_service.dart';

class RepositoryException implements Exception {
  final String message;
  final String? code;

  const RepositoryException(this.message, {this.code});

  @override
  String toString() => 'RepositoryException: $message';
}

class UserRepository {
  final FirebaseFirestore _firestore;
  final LoggerService _logger = LoggerService.instance;
  static const String _collection = 'users';

  UserRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Creating user in Firestore', extra: {
        'userId': user.id,
        'email': user.email,
        'hasActiveSubscription': user.hasActiveSubscription,
      });
      
      await _firestore.collection(_collection).doc(user.id).set(user.toJson());
      stopwatch.stop();
      
      _logger.info('User created successfully', extra: {
        'userId': user.id,
        'email': user.email,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('create_user', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('create_user', e, extra: {
        'userId': user.id,
        'email': user.email,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to create user: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('create_user', e, extra: {
        'userId': user.id,
        'email': user.email,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to create user: $e');
    }
  }

  Future<User?> getUser(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('Fetching user from Firestore', extra: {'userId': userId});
      
      final doc = await _firestore.collection(_collection).doc(userId).get();
      stopwatch.stop();
      
      if (!doc.exists) {
        _logger.info('User not found in Firestore', extra: {
          'userId': userId,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        return null;
      }

      final data = doc.data();
      if (data == null) {
        _logger.warning('User document exists but has no data', extra: {
          'userId': userId,
          'durationMs': stopwatch.elapsedMilliseconds,
        });
        return null;
      }

      final user = User.fromJson(data);
      _logger.debug('User fetched successfully', extra: {
        'userId': userId,
        'email': user.email,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('get_user', stopwatch.elapsed);
      return user;
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('get_user', e, extra: {
        'userId': userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get user: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('get_user', e, extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to get user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Updating user in Firestore', extra: {
        'userId': user.id,
        'email': user.email,
        'hasActiveSubscription': user.hasActiveSubscription,
      });
      
      await _firestore.collection(_collection).doc(user.id).update(user.toJson());
      stopwatch.stop();
      
      _logger.info('User updated successfully', extra: {
        'userId': user.id,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('update_user', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('update_user', e, extra: {
        'userId': user.id,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to update user: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('update_user', e, extra: {
        'userId': user.id,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('Deleting user from Firestore', extra: {'userId': userId});
      
      await _firestore.collection(_collection).doc(userId).delete();
      stopwatch.stop();
      
      _logger.info('User deleted successfully', extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      
      _logger.logPerformance('delete_user', stopwatch.elapsed);
    } on FirebaseException catch (e) {
      stopwatch.stop();
      _logger.logError('delete_user', e, extra: {
        'userId': userId,
        'code': e.code,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to delete user: ${e.message}', code: e.code);
    } catch (e) {
      stopwatch.stop();
      _logger.logError('delete_user', e, extra: {
        'userId': userId,
        'durationMs': stopwatch.elapsedMilliseconds,
      });
      throw RepositoryException('Failed to delete user: $e');
    }
  }
}