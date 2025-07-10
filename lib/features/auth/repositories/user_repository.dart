import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class RepositoryException implements Exception {
  final String message;
  final String? code;

  const RepositoryException(this.message, {this.code});

  @override
  String toString() => 'RepositoryException: $message';
}

class UserRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'users';

  UserRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw RepositoryException('Failed to create user: ${e.message}', code: e.code);
    } catch (e) {
      throw RepositoryException('Failed to create user: $e');
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      
      if (!doc.exists) {
        return null;
      }

      final data = doc.data();
      if (data == null) {
        return null;
      }

      return User.fromJson(data);
    } on FirebaseException catch (e) {
      throw RepositoryException('Failed to get user: ${e.message}', code: e.code);
    } catch (e) {
      throw RepositoryException('Failed to get user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).update(user.toJson());
    } on FirebaseException catch (e) {
      throw RepositoryException('Failed to update user: ${e.message}', code: e.code);
    } catch (e) {
      throw RepositoryException('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } on FirebaseException catch (e) {
      throw RepositoryException('Failed to delete user: ${e.message}', code: e.code);
    } catch (e) {
      throw RepositoryException('Failed to delete user: $e');
    }
  }
}