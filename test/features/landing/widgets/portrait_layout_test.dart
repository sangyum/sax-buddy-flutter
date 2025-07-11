import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/landing/widgets/portrait_layout.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<UserRepository>(), MockSpec<LoggerService>()])
import 'portrait_layout_test.mocks.dart';

void main() {
  group('PortraitLayout', () {
    late MockAuthService mockAuthService;
    late MockUserRepository mockUserRepository;
    late MockLoggerService mockLogger;
    late AuthProvider authProvider;

    setUpAll(() {
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
    });

    setUp(() {
      
      
      mockAuthService = MockAuthService();
      mockUserRepository = MockUserRepository();
      mockLogger = MockLoggerService();
      authProvider = AuthProvider(
        mockAuthService,
        mockUserRepository,
        mockLogger,
      );
      
      when(mockAuthService.getCurrentUser()).thenReturn(null);
      when(mockAuthService.authStateChanges()).thenAnswer((_) => Stream.value(null));
    });

    Widget createTestWidget({required PortraitLayout child}) {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: Scaffold(body: child),
        ),
      );
    }

    testWidgets('displays all components in portrait layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PortraitLayout(
            logoSize: 100,
            titleFontSize: 28,
            subtitleFontSize: 16,
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      // Verify all components are present
      expect(find.byType(Image), findsWidgets); // Logo and Google button image
      expect(find.text('SaxAI Coach'), findsOneWidget); // Title
      expect(find.text('AI-powered practice routines'), findsOneWidget); // Subtitle
      expect(find.text('Audio Analysis'), findsOneWidget); // Feature card
      expect(find.text('AI Routines'), findsOneWidget); // Feature card
      expect(find.text('Sign up for free trial'), findsOneWidget); // CTA button
      expect(find.text('Already have account? Sign In'), findsOneWidget); // Sign in
    });

    testWidgets('uses Column layout for portrait mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PortraitLayout(
            logoSize: 100,
            titleFontSize: 28,
            subtitleFontSize: 16,
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      // Verify it's using Column layout (main layout is Column-based)
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      // Note: Row widgets exist from feature cards, so we don't check for absence
    });

    testWidgets('passes correct parameters to child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PortraitLayout(
            logoSize: 140,
            titleFontSize: 36,
            subtitleFontSize: 20,
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      // Verify the custom sizes are used
      final titleWidget = tester.widget<Text>(find.text('SaxAI Coach'));
      expect(titleWidget.style?.fontSize, 36);
      
      final subtitleWidget = tester.widget<Text>(find.text('AI-powered practice routines'));
      expect(subtitleWidget.style?.fontSize, 20);
    });

    testWidgets('handles button callbacks correctly', (WidgetTester tester) async {
      bool startTrialPressed = false;
      bool signInPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: PortraitLayout(
            logoSize: 100,
            titleFontSize: 28,
            subtitleFontSize: 16,
            onStartTrialPressed: () => startTrialPressed = true,
            onSignInPressed: () => signInPressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(startTrialPressed, true);

      await tester.tap(find.text('Already have account? Sign In'));
      expect(signInPressed, true);
    });
  });
}