import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sax_buddy/features/landing/landing_screen.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<UserRepository>()])
import 'widget_test.mocks.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
  });

  setUp(() {
    LoggerService.resetForTesting();
  });

  testWidgets('App starts with landing screen', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    final mockUserRepository = MockUserRepository();
    
    when(mockAuthService.getCurrentUser()).thenReturn(null);
    when(mockAuthService.authStateChanges()).thenAnswer((_) => Stream.value(null));
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(
              authService: mockAuthService,
              userRepository: mockUserRepository,
            ),
          ),
        ],
        child: const MaterialApp(
          home: LandingScreen(),
        ),
      ),
    );

    // Wait for the widget to build
    await tester.pumpAndSettle();

    // Verify that the landing screen is displayed
    expect(find.text('SaxAI Coach'), findsOneWidget);
    expect(find.text('Sign up for free trial'), findsOneWidget);
  });
}
