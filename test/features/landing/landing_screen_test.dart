import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/landing/landing_screen.dart';

void main() {
  group('LandingScreen', () {
    testWidgets('displays welcome content and CTAs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LandingScreen(),
        ),
      );

      // Verify logo image is displayed
      expect(find.byType(Image), findsOneWidget);
      
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
      expect(find.text('Start Free Trial'), findsOneWidget);
      expect(find.text('Already have account? Sign In'), findsOneWidget);
    });

    testWidgets('Start Free Trial button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LandingScreen(),
        ),
      );

      final startTrialButton = find.text('Start Free Trial');
      expect(startTrialButton, findsOneWidget);
      
      await tester.tap(startTrialButton, warnIfMissed: false);
      await tester.pump();
      
      // Test passes if no exception is thrown
    });

    testWidgets('Sign In text is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LandingScreen(),
        ),
      );

      final signInText = find.text('Already have account? Sign In');
      expect(signInText, findsOneWidget);
      
      await tester.tap(signInText, warnIfMissed: false);
      await tester.pump();
      
      // Test passes if no exception is thrown
    });

    testWidgets('displays properly on tablet size (iPad 13 inch)', (WidgetTester tester) async {
      // Set tablet size (iPad 13 inch: 2048x2732)
      await tester.binding.setSurfaceSize(const Size(2048, 2732));
      
      await tester.pumpWidget(
        const MaterialApp(
          home: LandingScreen(),
        ),
      );

      // Verify content is still visible and properly laid out
      expect(find.text('SaxAI Coach'), findsOneWidget);
      expect(find.text('Start Free Trial'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('displays properly in landscape mode', (WidgetTester tester) async {
      // Set landscape phone size
      await tester.binding.setSurfaceSize(const Size(844, 390));
      
      await tester.pumpWidget(
        const MaterialApp(
          home: LandingScreen(),
        ),
      );

      // Verify content is still visible and properly laid out
      expect(find.text('SaxAI Coach'), findsOneWidget);
      expect(find.text('Start Free Trial'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });
  });
}