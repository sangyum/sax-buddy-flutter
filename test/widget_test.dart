import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sax_buddy/features/landing/landing_screen.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/auth/services/auth_service.dart';
import 'package:sax_buddy/features/auth/repositories/user_repository.dart';

void main() {
  testWidgets('App starts with landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(
              authService: AuthService(),
              userRepository: UserRepository(),
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
    expect(find.text('Accelerate your saxophone learning'), findsOneWidget);
    expect(find.text('Sign up for free trial'), findsOneWidget);
  });
}
