import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';
import 'package:sax_buddy/features/auth/models/user.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
import 'user_repository_test.mocks.dart';

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();
      mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      
      userRepository = UserRepository(firestore: mockFirestore);
      
      when(mockFirestore.collection('users')).thenReturn(mockCollection);
    });

    group('createUser', () {
      test('should create a new user in Firestore', () async {
        // Arrange
        final user = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
          trialEndsAt: DateTime.now().add(const Duration(days: 14)),
        );

        when(mockCollection.doc(user.id)).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenAnswer((_) async {});

        // Act
        await userRepository.createUser(user);

        // Assert
        verify(mockCollection.doc(user.id)).called(1);
        verify(mockDocument.set(user.toJson())).called(1);
      });

      test('should throw RepositoryException when Firestore create fails', () async {
        // Arrange
        final user = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
        );

        when(mockCollection.doc(user.id)).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenThrow(FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Missing or insufficient permissions.',
        ));

        // Act & Assert
        expect(
          () => userRepository.createUser(user),
          throwsA(isA<RepositoryException>()),
        );
      });
    });

    group('getUser', () {
      test('should return User when document exists', () async {
        // Arrange
        const userId = 'test-user-id';
        final userData = {
          'id': userId,
          'email': 'test@example.com',
          'displayName': 'Test User',
          'photoURL': 'https://example.com/photo.jpg',
          'createdAt': DateTime.now().toIso8601String(),
          'hasActiveSubscription': false,
          'trialEndsAt': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
        };

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data()).thenReturn(userData);

        // Act
        final result = await userRepository.getUser(userId);

        // Assert
        expect(result, isA<User>());
        expect(result?.id, equals(userId));
        expect(result?.email, equals('test@example.com'));
        verify(mockCollection.doc(userId)).called(1);
        verify(mockDocument.get()).called(1);
      });

      test('should return null when document does not exist', () async {
        // Arrange
        const userId = 'non-existent-user';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(false);

        // Act
        final result = await userRepository.getUser(userId);

        // Assert
        expect(result, isNull);
        verify(mockCollection.doc(userId)).called(1);
        verify(mockDocument.get()).called(1);
      });

      test('should throw RepositoryException when Firestore get fails', () async {
        // Arrange
        const userId = 'test-user-id';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.get()).thenThrow(FirebaseException(
          plugin: 'cloud_firestore',
          code: 'unavailable',
          message: 'The service is currently unavailable.',
        ));

        // Act & Assert
        expect(
          () => userRepository.getUser(userId),
          throwsA(isA<RepositoryException>()),
        );
      });
    });

    group('updateUser', () {
      test('should update user in Firestore', () async {
        // Arrange
        final user = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Updated User',
          photoURL: 'https://example.com/new-photo.jpg',
          createdAt: DateTime.now(),
          hasActiveSubscription: true,
          trialEndsAt: null,
        );

        when(mockCollection.doc(user.id)).thenReturn(mockDocument);
        when(mockDocument.update(any)).thenAnswer((_) async {});

        // Act
        await userRepository.updateUser(user);

        // Assert
        verify(mockCollection.doc(user.id)).called(1);
        verify(mockDocument.update(user.toJson())).called(1);
      });

      test('should throw RepositoryException when Firestore update fails', () async {
        // Arrange
        final user = User(
          id: 'test-user-id',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime.now(),
          hasActiveSubscription: false,
        );

        when(mockCollection.doc(user.id)).thenReturn(mockDocument);
        when(mockDocument.update(any)).thenThrow(FirebaseException(
          plugin: 'cloud_firestore',
          code: 'not-found',
          message: 'No document to update.',
        ));

        // Act & Assert
        expect(
          () => userRepository.updateUser(user),
          throwsA(isA<RepositoryException>()),
        );
      });
    });

    group('deleteUser', () {
      test('should delete user from Firestore', () async {
        // Arrange
        const userId = 'test-user-id';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.delete()).thenAnswer((_) async {});

        // Act
        await userRepository.deleteUser(userId);

        // Assert
        verify(mockCollection.doc(userId)).called(1);
        verify(mockDocument.delete()).called(1);
      });

      test('should throw RepositoryException when Firestore delete fails', () async {
        // Arrange
        const userId = 'test-user-id';

        when(mockCollection.doc(userId)).thenReturn(mockDocument);
        when(mockDocument.delete()).thenThrow(FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Missing or insufficient permissions.',
        ));

        // Act & Assert
        expect(
          () => userRepository.deleteUser(userId),
          throwsA(isA<RepositoryException>()),
        );
      });
    });
  });
}