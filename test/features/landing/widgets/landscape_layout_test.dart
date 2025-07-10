import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/landing/widgets/landscape_layout.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<UserRepository>()])
import 'landscape_layout_test.mocks.dart';

void main() {
  group('LandscapeLayout', () {
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

    Widget createTestWidget({required LandscapeLayout child}) {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: Scaffold(body: child),
        ),
      );
    }
    testWidgets('displays all components in landscape layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: LandscapeLayout(
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

    testWidgets('uses Row layout for landscape mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: LandscapeLayout(
            logoSize: 100,
            titleFontSize: 28,
            subtitleFontSize: 16,
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      // Verify it's using Row layout with two Expanded widgets
      expect(find.byType(Row), findsWidgets); // Multiple rows exist (main + feature cards)
      expect(find.byType(Expanded), findsNWidgets(2)); // Main layout has 2 Expanded widgets
    });

    testWidgets('separates logo/title from features/CTA in landscape', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: LandscapeLayout(
            logoSize: 100,
            titleFontSize: 28,
            subtitleFontSize: 16,
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      // Verify layout structure - main row has 2 Expanded widgets + SizedBox
      final mainRow = tester.widget<Row>(find.byType(Row).first);
      expect(mainRow.children.length, 3); // Two Expanded widgets + SizedBox spacing
      
      // Check that we have columns for the main layout
      expect(find.byType(Column), findsWidgets); // Multiple columns (left, right, feature cards)
    });

    testWidgets('passes correct parameters to child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: LandscapeLayout(
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
          child: LandscapeLayout(
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