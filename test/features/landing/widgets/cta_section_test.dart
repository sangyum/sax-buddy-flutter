import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/landing/widgets/cta_section.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<UserRepository>(), MockSpec<LoggerService>()])
import 'cta_section_test.mocks.dart';

void main() {
  group('CTASection', () {
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

    Widget createTestWidget({required CTASection child}) {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: Scaffold(body: child),
        ),
      );
    }
    testWidgets('displays Start Free Trial button', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CTASection(
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      expect(find.text('Sign up for free trial'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays Sign In text', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CTASection(
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      expect(find.text('Already have account? Sign In'), findsOneWidget);
    });

    testWidgets('Start Free Trial button has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CTASection(
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = elevatedButton.style;
      
      expect(buttonStyle?.backgroundColor?.resolve({}), Colors.white);
      expect(buttonStyle?.shape?.resolve({}), isA<RoundedRectangleBorder>());
    });

    testWidgets('Sign In text has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CTASection(
            onStartTrialPressed: () {},
            onSignInPressed: () {},
          ),
        ),
      );

      final signInText = tester.widget<Text>(find.text('Already have account? Sign In'));
      expect(signInText.style?.color, const Color(0xFF2E5266));
      expect(signInText.style?.fontSize, 14);
    });

    testWidgets('calls onStartTrialPressed when button is tapped', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        createTestWidget(
          child: CTASection(
            onStartTrialPressed: () => wasPressed = true,
            onSignInPressed: () {},
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(wasPressed, true);
    });

    testWidgets('calls onSignInPressed when sign in text is tapped', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        createTestWidget(
          child: CTASection(
            onStartTrialPressed: () {},
            onSignInPressed: () => wasPressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Already have account? Sign In'));
      expect(wasPressed, true);
    });
  });
}