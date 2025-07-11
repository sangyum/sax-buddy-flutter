import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/practice/repositories/practice_routine_repository.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  QueryDocumentSnapshot,
  LoggerService,
])
import 'practice_routine_repository_test.mocks.dart';

void main() {
  group('PracticeRoutineRepository', () {
    late PracticeRoutineRepository repository;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
    late MockLoggerService mockLogger;

    setUpAll(() {
      // Initialize environment for logger
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
    });

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();
      mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      mockLogger = MockLoggerService();
      
      repository = PracticeRoutineRepository(mockFirestore, mockLogger);
      
      when(mockFirestore.collection('practice_routines')).thenReturn(mockCollection);
    });

    group('createRoutine', () {
      test('should create a new practice routine in Firestore', () async {
        // Arrange
        final routine = PracticeRoutine(
          id: 'routine-123',
          userId: 'user-456',
          title: 'Test Routine',
          description: 'A test practice routine',
          targetAreas: ['scales', 'timing'],
          difficulty: 'intermediate',
          estimatedDuration: '20 minutes',
          exercises: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAIGenerated: true,
        );

        when(mockCollection.doc('user-456')).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.doc('routine-123')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenAnswer((_) async {});

        // Act
        await repository.createRoutine(routine);

        // Assert
        verify(mockCollection.doc('user-456')).called(1);
        verify(mockDocument.collection('routines')).called(1);
        verify(mockCollection.doc('routine-123')).called(1);
        verify(mockDocument.set(routine.toJson())).called(1);
      });

      test('should throw RepositoryException when Firestore create fails', () async {
        // Arrange
        final routine = PracticeRoutine(
          id: 'routine-123',
          userId: 'user-456',
          title: 'Test Routine',
          description: 'A test practice routine',
          targetAreas: ['scales'],
          difficulty: 'intermediate',
          estimatedDuration: '20 minutes',
          exercises: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAIGenerated: true,
        );

        when(mockCollection.doc('user-456')).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.doc('routine-123')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenThrow(FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Missing or insufficient permissions.',
        ));

        // Act & Assert
        expect(
          () => repository.createRoutine(routine),
          throwsA(isA<RepositoryException>()),
        );
      });
    });

    group('getRoutine', () {
      test('should return PracticeRoutine when document exists', () async {
        // Arrange
        const userId = 'user-456';
        const routineId = 'routine-123';
        final routineData = {
          'id': routineId,
          'userId': userId,
          'title': 'Test Routine',
          'description': 'A test practice routine',
          'targetAreas': ['scales', 'timing'],
          'difficulty': 'intermediate',
          'estimatedDuration': '20 minutes',
          'exercises': [],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'isAIGenerated': true,
        };

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.doc(routineId)).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data()).thenReturn(routineData);

        // Act
        final result = await repository.getRoutine(userId, routineId);

        // Assert
        expect(result, isA<PracticeRoutine>());
        expect(result?.id, equals(routineId));
        expect(result?.userId, equals(userId));
        expect(result?.title, equals('Test Routine'));
      });

      test('should return null when document does not exist', () async {
        // Arrange
        const userId = 'user-456';
        const routineId = 'non-existent-routine';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.doc(routineId)).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(false);

        // Act
        final result = await repository.getRoutine(userId, routineId);

        // Assert
        expect(result, isNull);
      });
    });

    group('getUserRoutines', () {
      test('should return list of practice routines for user', () async {
        // Arrange
        const userId = 'user-456';
        final routineData = {
          'id': 'routine-123',
          'userId': userId,
          'title': 'Test Routine',
          'description': 'A test practice routine',
          'targetAreas': ['scales'],
          'difficulty': 'intermediate',
          'estimatedDuration': '20 minutes',
          'exercises': [],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'isAIGenerated': true,
        };

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(routineData);

        // Act
        final result = await repository.getUserRoutines(userId);

        // Assert
        expect(result, isA<List<PracticeRoutine>>());
        expect(result.length, equals(1));
        expect(result.first.id, equals('routine-123'));
        expect(result.first.userId, equals(userId));
      });

      test('should return empty list when user has no routines', () async {
        // Arrange
        const userId = 'user-456';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await repository.getUserRoutines(userId);

        // Assert
        expect(result, isA<List<PracticeRoutine>>());
        expect(result.length, equals(0));
      });
    });

    group('updateRoutine', () {
      test('should update practice routine in Firestore', () async {
        // Arrange
        final routine = PracticeRoutine(
          id: 'routine-123',
          userId: 'user-456',
          title: 'Updated Routine',
          description: 'An updated practice routine',
          targetAreas: ['scales', 'timing'],
          difficulty: 'advanced',
          estimatedDuration: '30 minutes',
          exercises: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAIGenerated: true,
        );

        when(mockCollection.doc(routine.userId)).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.doc(routine.id)).thenReturn(mockDocument);
        when(mockDocument.update(any)).thenAnswer((_) async {});

        // Act
        await repository.updateRoutine(routine);

        // Assert
        verify(mockDocument.update(routine.toJson())).called(1);
      });
    });

    group('deleteRoutine', () {
      test('should delete practice routine from Firestore', () async {
        // Arrange
        const userId = 'user-456';
        const routineId = 'routine-123';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.collection('routines')).thenReturn(mockCollection);
        when(mockCollection.doc(routineId)).thenReturn(mockDocument);
        when(mockDocument.delete()).thenAnswer((_) async {});

        // Act
        await repository.deleteRoutine(userId, routineId);

        // Assert
        verify(mockDocument.delete()).called(1);
      });
    });
  });
}