import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/models/user.dart' as app_user;
import 'package:sax_buddy/services/logger_service.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  LoggerService,
])
import 'auth_service_test.mocks.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockFirebaseUser;
    late MockUserCredential mockUserCredential;
    late MockLoggerService mockLogger;

    setUpAll(() {
      // Initialize environment for logger
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
    });

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockLogger = MockLoggerService();
      
      authService = AuthService(mockFirebaseAuth, mockLogger);
    });

    group('signInWithGoogle', () {
      test('should return app_user.User when Google sign-in is successful', () async {
        // Arrange
        const uid = 'test-uid';
        const email = 'test@example.com';
        const displayName = 'Test User';
        const photoURL = 'https://example.com/photo.jpg';

        when(mockFirebaseAuth.signInWithProvider(any)).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        
        when(mockFirebaseUser.uid).thenReturn(uid);
        when(mockFirebaseUser.email).thenReturn(email);
        when(mockFirebaseUser.displayName).thenReturn(displayName);
        when(mockFirebaseUser.photoURL).thenReturn(photoURL);

        // Act
        final result = await authService.signInWithGoogle();

        // Assert
        expect(result, isA<app_user.User>());
        expect(result?.id, equals(uid));
        expect(result?.email, equals(email));
        expect(result?.displayName, equals(displayName));
        expect(result?.photoURL, equals(photoURL));
        verify(mockFirebaseAuth.signInWithProvider(any)).called(1);
      });

      test('should throw AuthException when Firebase sign-in fails', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithProvider(any))
            .thenThrow(FirebaseAuthException(code: 'invalid-credential'));

        // Act & Assert
        expect(
          () => authService.signInWithGoogle(),
          throwsA(isA<AuthException>()),
        );
      });

      test('should throw AuthException when user is null after sign-in', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithProvider(any)).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(null);

        // Act & Assert
        expect(
          () => authService.signInWithGoogle(),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('signOut', () {
      test('should sign out from Firebase', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // Act
        await authService.signOut();

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
      });

      test('should handle sign out errors gracefully', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Firebase error'));

        // Act & Assert
        expect(
          () => authService.signOut(),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('getCurrentUser', () {
      test('should return app_user.User when Firebase user exists', () {
        // Arrange
        const uid = 'test-uid';
        const email = 'test@example.com';
        const displayName = 'Test User';
        const photoURL = 'https://example.com/photo.jpg';

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.uid).thenReturn(uid);
        when(mockFirebaseUser.email).thenReturn(email);
        when(mockFirebaseUser.displayName).thenReturn(displayName);
        when(mockFirebaseUser.photoURL).thenReturn(photoURL);

        // Act
        final result = authService.getCurrentUser();

        // Assert
        expect(result, isA<app_user.User>());
        expect(result?.id, equals(uid));
        expect(result?.email, equals(email));
        expect(result?.displayName, equals(displayName));
        expect(result?.photoURL, equals(photoURL));
      });

      test('should return null when no Firebase user exists', () {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = authService.getCurrentUser();

        // Assert
        expect(result, isNull);
      });
    });

    group('authStateChanges', () {
      test('should emit auth state changes stream', () {
        // Arrange
        final mockStream = Stream<User?>.fromIterable([null, mockFirebaseUser]);
        when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => mockStream);
        when(mockFirebaseUser.uid).thenReturn('test-uid');
        when(mockFirebaseUser.email).thenReturn('test@example.com');
        when(mockFirebaseUser.displayName).thenReturn('Test User');
        when(mockFirebaseUser.photoURL).thenReturn(null);

        // Act
        final stream = authService.authStateChanges();

        // Assert
        expect(stream, isA<Stream<app_user.User?>>());
      });
    });
  });
}