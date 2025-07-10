import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/auth/models/user.dart';

void main() {
  group('User Model', () {
    test('should create User instance with all required fields', () {
      // Arrange
      const id = 'test-user-id';
      const email = 'test@example.com';
      const displayName = 'Test User';
      const photoURL = 'https://example.com/photo.jpg';
      final createdAt = DateTime.now();
      const hasActiveSubscription = false;
      final trialEndsAt = DateTime.now().add(const Duration(days: 14));

      // Act
      final user = User(
        id: id,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        createdAt: createdAt,
        hasActiveSubscription: hasActiveSubscription,
        trialEndsAt: trialEndsAt,
      );

      // Assert
      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.displayName, equals(displayName));
      expect(user.photoURL, equals(photoURL));
      expect(user.createdAt, equals(createdAt));
      expect(user.hasActiveSubscription, equals(hasActiveSubscription));
      expect(user.trialEndsAt, equals(trialEndsAt));
    });

    test('should create User from JSON map', () {
      // Arrange
      final createdAt = DateTime.now();
      final trialEndsAt = DateTime.now().add(const Duration(days: 14));
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoURL': 'https://example.com/photo.jpg',
        'createdAt': createdAt.toIso8601String(),
        'hasActiveSubscription': false,
        'trialEndsAt': trialEndsAt.toIso8601String(),
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, equals('test-user-id'));
      expect(user.email, equals('test@example.com'));
      expect(user.displayName, equals('Test User'));
      expect(user.photoURL, equals('https://example.com/photo.jpg'));
      expect(user.createdAt.toIso8601String(), equals(createdAt.toIso8601String()));
      expect(user.hasActiveSubscription, equals(false));
      expect(user.trialEndsAt?.toIso8601String(), equals(trialEndsAt.toIso8601String()));
    });

    test('should convert User to JSON map', () {
      // Arrange
      final createdAt = DateTime.now();
      final trialEndsAt = DateTime.now().add(const Duration(days: 14));
      final user = User(
        id: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        createdAt: createdAt,
        hasActiveSubscription: false,
        trialEndsAt: trialEndsAt,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], equals('test-user-id'));
      expect(json['email'], equals('test@example.com'));
      expect(json['displayName'], equals('Test User'));
      expect(json['photoURL'], equals('https://example.com/photo.jpg'));
      expect(json['createdAt'], equals(createdAt.toIso8601String()));
      expect(json['hasActiveSubscription'], equals(false));
      expect(json['trialEndsAt'], equals(trialEndsAt.toIso8601String()));
    });

    test('should handle null photoURL and trialEndsAt in fromJson', () {
      // Arrange
      final createdAt = DateTime.now();
      final json = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoURL': null,
        'createdAt': createdAt.toIso8601String(),
        'hasActiveSubscription': true,
        'trialEndsAt': null,
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.photoURL, isNull);
      expect(user.trialEndsAt, isNull);
      expect(user.hasActiveSubscription, equals(true));
    });

    test('should check if trial is active', () {
      // Arrange - trial still active
      final activeTrialUser = User(
        id: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: DateTime.now(),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().add(const Duration(days: 7)),
      );

      // Arrange - trial expired
      final expiredTrialUser = User(
        id: 'test-user-id-2',
        email: 'test2@example.com',
        displayName: 'Test User 2',
        createdAt: DateTime.now(),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      // Act & Assert
      expect(activeTrialUser.isTrialActive, equals(true));
      expect(expiredTrialUser.isTrialActive, equals(false));
    });

    test('should check if user has access (subscription or active trial)', () {
      // Arrange - has subscription
      final subscribedUser = User(
        id: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: DateTime.now(),
        hasActiveSubscription: true,
        trialEndsAt: null,
      );

      // Arrange - has active trial
      final trialUser = User(
        id: 'test-user-id-2',
        email: 'test2@example.com',
        displayName: 'Test User 2',
        createdAt: DateTime.now(),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().add(const Duration(days: 7)),
      );

      // Arrange - no access
      final noAccessUser = User(
        id: 'test-user-id-3',
        email: 'test3@example.com',
        displayName: 'Test User 3',
        createdAt: DateTime.now(),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      // Act & Assert
      expect(subscribedUser.hasAccess, equals(true));
      expect(trialUser.hasAccess, equals(true));
      expect(noAccessUser.hasAccess, equals(false));
    });
  });
}