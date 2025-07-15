import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/auth/models/user.dart';
import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';

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

    group('Assessment fields', () {
      test('should create User with assessment fields', () {
        // Arrange
        final currentAssessment = AssessmentResult(
          sessionId: 'test-assessment-123',
          completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
          exerciseResults: [
            ExerciseResult(
              exerciseId: 1,
              completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
              actualDuration: const Duration(seconds: 30),
              wasCompleted: true,
              analysisData: {'pitch': 85.0},
            ),
          ],
          skillLevel: SkillLevel.intermediate,
          strengths: ['pitch accuracy'],
          weaknesses: ['breath control'],
        );
        final lastAssessmentDate = DateTime.parse('2023-01-01T10:00:00Z');

        // Act
        final user = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
          currentAssessment: currentAssessment,
          lastAssessmentDate: lastAssessmentDate,
          assessmentCount: 3,
        );

        // Assert
        expect(user.currentAssessment, equals(currentAssessment));
        expect(user.lastAssessmentDate, equals(lastAssessmentDate));
        expect(user.assessmentCount, equals(3));
      });

      test('should serialize assessment fields to JSON', () {
        // Arrange
        final currentAssessment = AssessmentResult(
          sessionId: 'test-assessment-456',
          completedAt: DateTime.parse('2023-01-02T14:30:00Z'),
          exerciseResults: [],
          skillLevel: SkillLevel.beginner,
          strengths: ['enthusiasm'],
          weaknesses: ['technique'],
        );
        final lastAssessmentDate = DateTime.parse('2023-01-02T14:30:00Z');

        final user = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
          currentAssessment: currentAssessment,
          lastAssessmentDate: lastAssessmentDate,
          assessmentCount: 1,
        );

        // Act
        final json = user.toJson();

        // Assert
        expect(json['currentAssessment'], isNotNull);
        expect(json['currentAssessment']['sessionId'], equals('test-assessment-456'));
        expect(json['lastAssessmentDate'], equals('2023-01-02T14:30:00.000Z'));
        expect(json['assessmentCount'], equals(1));
      });

      test('should deserialize assessment fields from JSON', () {
        // Arrange
        final json = {
          'id': 'test-user-id',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'createdAt': DateTime.now().toIso8601String(),
          'hasActiveSubscription': false,
          'currentAssessment': {
            'sessionId': 'test-assessment-789',
            'completedAt': '2023-01-03T09:00:00.000Z',
            'exerciseResults': [],
            'skillLevel': 'advanced',
            'strengths': ['technical skill'],
            'weaknesses': ['intonation'],
            'notes': null,
          },
          'lastAssessmentDate': '2023-01-03T09:00:00.000Z',
          'assessmentCount': 5,
        };

        // Act
        final user = User.fromJson(json);

        // Assert
        expect(user.currentAssessment, isNotNull);
        expect(user.currentAssessment!.sessionId, equals('test-assessment-789'));
        expect(user.currentAssessment!.skillLevel, equals(SkillLevel.advanced));
        expect(user.lastAssessmentDate, equals(DateTime.parse('2023-01-03T09:00:00.000Z')));
        expect(user.assessmentCount, equals(5));
      });

      test('should handle null assessment fields in JSON', () {
        // Arrange
        final json = {
          'id': 'test-user-id',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'createdAt': DateTime.now().toIso8601String(),
          'hasActiveSubscription': false,
          'currentAssessment': null,
          'lastAssessmentDate': null,
          'assessmentCount': 0,
        };

        // Act
        final user = User.fromJson(json);

        // Assert
        expect(user.currentAssessment, isNull);
        expect(user.lastAssessmentDate, isNull);
        expect(user.assessmentCount, equals(0));
      });

      test('should have correct assessment status properties', () {
        // Arrange - user with assessment
        final userWithAssessment = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
          currentAssessment: AssessmentResult(
            sessionId: 'test-assessment',
            completedAt: DateTime.now(),
            exerciseResults: [],
            skillLevel: SkillLevel.intermediate,
            strengths: [],
            weaknesses: [],
          ),
          lastAssessmentDate: DateTime.now(),
          assessmentCount: 1,
        );

        // Arrange - user without assessment
        final userWithoutAssessment = User(
          id: 'test-user-id-2',
          email: 'test2@example.com',
          displayName: 'Test User 2',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
          assessmentCount: 0,
        );

        // Assert
        expect(userWithAssessment.hasCompletedAssessment, equals(true));
        expect(userWithAssessment.currentSkillLevel, equals(SkillLevel.intermediate));
        expect(userWithoutAssessment.hasCompletedAssessment, equals(false));
        expect(userWithoutAssessment.currentSkillLevel, isNull);
      });
    });
  });
}