import 'package:sax_buddy/features/auth/models/user.dart';

/// Mock UserRepository for Storybook
class MockUserRepository {
  final Map<String, User> _users = {};

  Future<void> createUser(User user) async {
    _users[user.id] = user;
  }

  Future<User?> getUser(String userId) async {
    return _users[userId];
  }

  Future<void> updateUser(User user) async {
    _users[user.id] = user;
  }

  Future<void> deleteUser(String userId) async {
    _users.remove(userId);
  }
}