import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/landing/landing_screen.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<UserRepository>()])
import 'landing_screen_test.mocks.dart';

void main() {
  group('LandingScreen', () {
    late MockAuthService mockAuthService;
    late MockUserRepository mockUserRepository;
    late AuthProvider authProvider;

    setUpAll(() {
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
    });

    setUp(() {
      LoggerService.resetForTesting();
      
      mockAuthService = MockAuthService();
      mockUserRepository = MockUserRepository();
      authProvider = AuthProvider(
        authService: mockAuthService,
        userRepository: mockUserRepository,
      );
      
      when(mockAuthService.getCurrentUser()).thenReturn(null);
      when(mockAuthService.authStateChanges()).thenAnswer((_) => Stream.value(null));
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: const LandingScreen(),
        ),
      );
    }

    testWidgets('displays welcome content and CTAs', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify logo image is displayed (now includes Google button image)
      expect(find.byType(Image), findsWidgets);
      
      // Verify app name and tagline
      expect(find.text('SaxAI Coach'), findsOneWidget);
      expect(find.text('AI-powered practice routines'), findsOneWidget);
      expect(find.text('for self-taught saxophonists'), findsOneWidget);

      // Verify feature cards
      expect(find.text('Audio Analysis'), findsOneWidget);
      expect(find.text('Real-time feedback'), findsOneWidget);
      expect(find.text('AI Routines'), findsOneWidget);
      expect(find.text('Personalized exercises'), findsOneWidget);

      // Verify CTAs
      expect(find.text('Sign up for free trial'), findsOneWidget);
      expect(find.text('Already have account? Sign In'), findsOneWidget);
    });

    testWidgets('Start Free Trial button triggers Google sign-in', (WidgetTester tester) async {
      when(mockAuthService.signInWithGoogle()).thenAnswer((_) async => null);

      // Set larger viewport to fit all content
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      
      await tester.pumpWidget(createTestWidget());

      final startTrialButton = find.text('Sign up for free trial');
      expect(startTrialButton, findsOneWidget);
      
      // Ensure button is visible before tapping
      await tester.ensureVisible(startTrialButton);
      await tester.tap(startTrialButton);
      await tester.pumpAndSettle();
      
      verify(mockAuthService.signInWithGoogle()).called(1);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Sign In text triggers Google sign-in', (WidgetTester tester) async {
      when(mockAuthService.signInWithGoogle()).thenAnswer((_) async => null);

      // Set larger viewport to fit all content
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      
      await tester.pumpWidget(createTestWidget());

      final signInText = find.text('Already have account? Sign In');
      expect(signInText, findsOneWidget);
      
      // Ensure text is visible before tapping
      await tester.ensureVisible(signInText);
      await tester.tap(signInText);
      await tester.pumpAndSettle();
      
      verify(mockAuthService.signInWithGoogle()).called(1);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('displays properly on tablet size (iPad 13 inch)', (WidgetTester tester) async {
      // Set tablet size (iPad 13 inch: 2048x2732)
      await tester.binding.setSurfaceSize(const Size(2048, 2732));
      
      await tester.pumpWidget(createTestWidget());

      // Verify content is still visible and properly laid out
      expect(find.text('SaxAI Coach'), findsOneWidget);
      expect(find.text('Sign up for free trial'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('displays properly in landscape mode', (WidgetTester tester) async {
      // Set landscape phone size
      await tester.binding.setSurfaceSize(const Size(844, 390));
      
      await tester.pumpWidget(createTestWidget());

      // Verify content is still visible and properly laid out
      expect(find.text('SaxAI Coach'), findsOneWidget);
      expect(find.text('Sign up for free trial'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });
  });
}