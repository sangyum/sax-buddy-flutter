import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sax_buddy/features/assessment/repositories/assessment_repository.dart';
import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';

import 'assessment_repository_test.mocks.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot, QuerySnapshot, QueryDocumentSnapshot, LoggerService])
void main() {
  group('AssessmentRepository', () {
    late AssessmentRepository repository;
    late MockFirebaseFirestore mockFirestore;
    late MockLoggerService mockLogger;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockUserDoc;
    late MockCollectionReference<Map<String, dynamic>> mockUserAssessments;
    late MockDocumentReference<Map<String, dynamic>> mockAssessmentDoc;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocSnapshot;

    const userId = 'test-user-123';
    const assessmentId = 'test-assessment-456';
    
    late AssessmentResult testAssessment;
    late Map<String, dynamic> testAssessmentJson;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockLogger = MockLoggerService();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockUserDoc = MockDocumentReference<Map<String, dynamic>>();
      mockUserAssessments = MockCollectionReference<Map<String, dynamic>>();
      mockAssessmentDoc = MockDocumentReference<Map<String, dynamic>>();
      mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

      // Setup test data
      testAssessment = AssessmentResult(
        sessionId: assessmentId,
        completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
        exerciseResults: [
          ExerciseResult(
            exerciseId: 1,
            completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
            actualDuration: const Duration(seconds: 30),
            wasCompleted: true,
            analysisData: {
              'pitch': 85.0,
              'timing': 90.0,
            },
            audioRecordingUrl: 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac',
          ),
        ],
        skillLevel: SkillLevel.intermediate,
        strengths: ['pitch accuracy', 'timing consistency'],
        weaknesses: ['breath control'],
        notes: 'Good performance with room for improvement.',
      );

      testAssessmentJson = testAssessment.toJson();

      // Setup Firestore mock chain for the tests
      when(mockFirestore.collection('assessments')).thenReturn(mockCollection);
      when(mockCollection.doc(userId)).thenReturn(mockUserDoc);
      when(mockCollection.doc('current-user')).thenReturn(mockUserDoc);
      when(mockUserDoc.collection('results')).thenReturn(mockUserAssessments);
      when(mockUserAssessments.doc(assessmentId)).thenReturn(mockAssessmentDoc);
      when(mockUserAssessments.doc('test-audio-session')).thenReturn(mockAssessmentDoc);
      when(mockUserAssessments.doc('test-no-audio-session')).thenReturn(mockAssessmentDoc);
      when(mockUserAssessments.doc('test-audio-retrieval')).thenReturn(mockAssessmentDoc);

      repository = AssessmentRepository(mockFirestore, mockLogger);
    });

    group('createAssessment', () {
      test('should create assessment successfully', () async {
        // Arrange
        when(mockAssessmentDoc.set(any)).thenAnswer((_) async => {});

        // Act
        await repository.createAssessment(userId, testAssessment);

        // Assert
        verify(mockAssessmentDoc.set(testAssessmentJson)).called(1);
        verify(mockLogger.info('Creating assessment in Firestore', extra: anyNamed('extra'))).called(1);
        verify(mockLogger.info('Assessment created successfully', extra: anyNamed('extra'))).called(1);
      });

      test('should handle FirebaseException on create', () async {
        // Arrange
        final firebaseException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );
        when(mockAssessmentDoc.set(any)).thenThrow(firebaseException);

        // Act & Assert
        expect(
          () => repository.createAssessment(userId, testAssessment),
          throwsA(isA<RepositoryException>()),
        );
        verify(mockLogger.logError('create_assessment', firebaseException, extra: anyNamed('extra'))).called(1);
      });

      test('should handle generic exception on create', () async {
        // Arrange
        final genericException = Exception('Network error');
        when(mockAssessmentDoc.set(any)).thenThrow(genericException);

        // Act & Assert
        expect(
          () => repository.createAssessment(userId, testAssessment),
          throwsA(isA<RepositoryException>()),
        );
        verify(mockLogger.logError('create_assessment', genericException, extra: anyNamed('extra'))).called(1);
      });

      test('should persist audioRecordingUrl in ExerciseResult', () async {
        // Arrange
        const audioUrl = 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac';
        final assessmentWithAudio = AssessmentResult(
          sessionId: 'test-audio-session',
          completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
          exerciseResults: [
            ExerciseResult(
              exerciseId: 1,
              completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
              actualDuration: const Duration(seconds: 30),
              wasCompleted: true,
              analysisData: {'pitch': 85.0},
              audioRecordingUrl: audioUrl,
            ),
          ],
          skillLevel: SkillLevel.intermediate,
          strengths: ['audio captured'],
          weaknesses: [],
          notes: 'Audio recording test',
        );

        when(mockAssessmentDoc.set(any)).thenAnswer((_) async => {});

        // Act
        await repository.createAssessment(userId, assessmentWithAudio);

        // Assert - Verify that the JSON includes the audioRecordingUrl
        final capturedData = verify(mockAssessmentDoc.set(captureAny)).captured.single as Map<String, dynamic>;
        final exerciseResults = capturedData['exerciseResults'] as List;
        final firstExercise = exerciseResults.first as Map<String, dynamic>;
        
        expect(firstExercise['audioRecordingUrl'], equals(audioUrl));
        expect(firstExercise['analysisData'], isA<Map<String, dynamic>>());
        expect((firstExercise['analysisData'] as Map)['pitch'], equals(85.0));
      });

      test('should handle null audioRecordingUrl in ExerciseResult', () async {
        // Arrange
        final assessmentWithoutAudio = AssessmentResult(
          sessionId: 'test-no-audio-session',
          completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
          exerciseResults: [
            ExerciseResult(
              exerciseId: 1,
              completedAt: DateTime.parse('2023-01-01T10:00:00Z'),
              actualDuration: const Duration(seconds: 30),
              wasCompleted: true,
              analysisData: {'pitch': 85.0},
              audioRecordingUrl: null,
            ),
          ],
          skillLevel: SkillLevel.intermediate,
          strengths: ['completed exercise'],
          weaknesses: [],
          notes: 'No audio recording test',
        );

        when(mockAssessmentDoc.set(any)).thenAnswer((_) async => {});

        // Act
        await repository.createAssessment(userId, assessmentWithoutAudio);

        // Assert - Verify that audioRecordingUrl is not included when null
        final capturedData = verify(mockAssessmentDoc.set(captureAny)).captured.single as Map<String, dynamic>;
        final exerciseResults = capturedData['exerciseResults'] as List;
        final firstExercise = exerciseResults.first as Map<String, dynamic>;
        
        expect(firstExercise.containsKey('audioRecordingUrl'), isFalse);
        expect(firstExercise['analysisData'], isA<Map<String, dynamic>>());
      });
    });

    group('getAssessment', () {
      test('should get assessment successfully', () async {
        // Arrange
        when(mockAssessmentDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(testAssessmentJson);

        // Act
        final result = await repository.getAssessment(userId, assessmentId);

        // Assert
        expect(result, isNotNull);
        expect(result!.sessionId, equals(assessmentId));
        expect(result.skillLevel, equals(SkillLevel.intermediate));
        verify(mockLogger.debug('Fetching assessment from Firestore', extra: anyNamed('extra'))).called(1);
        verify(mockLogger.debug('Assessment fetched successfully', extra: anyNamed('extra'))).called(1);
      });

      test('should return null when assessment does not exist', () async {
        // Arrange
        when(mockAssessmentDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        // Act
        final result = await repository.getAssessment(userId, assessmentId);

        // Assert
        expect(result, isNull);
        verify(mockLogger.info('Assessment not found in Firestore', extra: anyNamed('extra'))).called(1);
      });

      test('should return null when assessment data is null', () async {
        // Arrange
        when(mockAssessmentDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(null);

        // Act
        final result = await repository.getAssessment(userId, assessmentId);

        // Assert
        expect(result, isNull);
        verify(mockLogger.warning('Assessment document exists but has no data', extra: anyNamed('extra'))).called(1);
      });

      test('should handle FirebaseException on get', () async {
        // Arrange
        final firebaseException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );
        when(mockAssessmentDoc.get()).thenThrow(firebaseException);

        // Act & Assert
        expect(
          () => repository.getAssessment(userId, assessmentId),
          throwsA(isA<RepositoryException>()),
        );
        verify(mockLogger.logError('get_assessment', firebaseException, extra: anyNamed('extra'))).called(1);
      });

      test('should retrieve assessment with audioRecordingUrl correctly', () async {
        // Arrange
        const audioUrl = 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac';
        final assessmentWithAudioJson = {
          'sessionId': 'test-audio-retrieval',
          'completedAt': '2023-01-01T10:00:00.000Z',
          'exerciseResults': [
            {
              'exerciseId': 1,
              'completedAt': '2023-01-01T10:00:00.000Z',
              'actualDuration': 30000,
              'wasCompleted': true,
              'analysisData': {'pitch': 85.0},
              'audioRecordingUrl': audioUrl,
            }
          ],
          'skillLevel': 'intermediate',
          'strengths': ['audio captured'],
          'weaknesses': [],
          'notes': 'Audio recording test',
        };

        when(mockAssessmentDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(assessmentWithAudioJson);

        // Act
        final result = await repository.getAssessment(userId, 'test-audio-retrieval');

        // Assert
        expect(result, isNotNull);
        expect(result!.exerciseResults, hasLength(1));
        expect(result.exerciseResults.first.audioRecordingUrl, equals(audioUrl));
        expect(result.exerciseResults.first.analysisData!['pitch'], equals(85.0));
      });
    });

    group('getUserAssessments', () {
      test('should get user assessments successfully', () async {
        // Arrange
        when(mockUserAssessments.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
        when(mockQueryDocSnapshot.data()).thenReturn(testAssessmentJson);

        // Act
        final result = await repository.getUserAssessments(userId);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.sessionId, equals(assessmentId));
        verify(mockLogger.debug('Fetching user assessments from Firestore', extra: anyNamed('extra'))).called(1);
        verify(mockLogger.debug('User assessments fetched successfully', extra: anyNamed('extra'))).called(1);
      });

      test('should return empty list when no assessments exist', () async {
        // Arrange
        when(mockUserAssessments.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await repository.getUserAssessments(userId);

        // Assert
        expect(result, isEmpty);
        verify(mockLogger.debug('User assessments fetched successfully', extra: anyNamed('extra'))).called(1);
      });

      test('should handle FirebaseException on getUserAssessments', () async {
        // Arrange
        final firebaseException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );
        when(mockUserAssessments.get()).thenThrow(firebaseException);

        // Act & Assert
        expect(
          () => repository.getUserAssessments(userId),
          throwsA(isA<RepositoryException>()),
        );
        verify(mockLogger.logError('get_user_assessments', firebaseException, extra: anyNamed('extra'))).called(1);
      });
    });

    group('updateAssessment', () {
      test('should update assessment successfully', () async {
        // Arrange
        when(mockAssessmentDoc.update(any)).thenAnswer((_) async => {});

        // Act
        await repository.updateAssessment(userId, testAssessment);

        // Assert
        verify(mockAssessmentDoc.update(testAssessmentJson)).called(1);
        verify(mockLogger.info('Updating assessment in Firestore', extra: anyNamed('extra'))).called(1);
        verify(mockLogger.info('Assessment updated successfully', extra: anyNamed('extra'))).called(1);
      });

      test('should handle FirebaseException on update', () async {
        // Arrange
        final firebaseException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );
        when(mockAssessmentDoc.update(any)).thenThrow(firebaseException);

        // Act & Assert
        expect(
          () => repository.updateAssessment(userId, testAssessment),
          throwsA(isA<RepositoryException>()),
        );
        verify(mockLogger.logError('update_assessment', firebaseException, extra: anyNamed('extra'))).called(1);
      });
    });

    group('deleteAssessment', () {
      test('should delete assessment successfully', () async {
        // Arrange
        when(mockAssessmentDoc.delete()).thenAnswer((_) async => {});

        // Act
        await repository.deleteAssessment(userId, assessmentId);

        // Assert
        verify(mockAssessmentDoc.delete()).called(1);
        verify(mockLogger.info('Deleting assessment from Firestore', extra: anyNamed('extra'))).called(1);
        verify(mockLogger.info('Assessment deleted successfully', extra: anyNamed('extra'))).called(1);
      });

      test('should handle FirebaseException on delete', () async {
        // Arrange
        final firebaseException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );
        when(mockAssessmentDoc.delete()).thenThrow(firebaseException);

        // Act & Assert
        expect(
          () => repository.deleteAssessment(userId, assessmentId),
          throwsA(isA<RepositoryException>()),
        );
        verify(mockLogger.logError('delete_assessment', firebaseException, extra: anyNamed('extra'))).called(1);
      });
    });
  });
}