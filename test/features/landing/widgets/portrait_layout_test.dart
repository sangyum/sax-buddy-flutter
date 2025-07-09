import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/landing/widgets/portrait_layout.dart';

void main() {
  group('PortraitLayout', () {
    testWidgets('displays all components in portrait layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PortraitLayout(
              logoSize: 100,
              titleFontSize: 28,
              subtitleFontSize: 16,
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
          ),
        ),
      );

      // Verify all components are present
      expect(find.byType(Image), findsOneWidget); // Logo
      expect(find.text('SaxAI Coach'), findsOneWidget); // Title
      expect(find.text('AI-powered practice routines'), findsOneWidget); // Subtitle
      expect(find.text('Audio Analysis'), findsOneWidget); // Feature card
      expect(find.text('AI Routines'), findsOneWidget); // Feature card
      expect(find.text('Start Free Trial'), findsOneWidget); // CTA button
      expect(find.text('Already have account? Sign In'), findsOneWidget); // Sign in
    });

    testWidgets('uses Column layout for portrait mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PortraitLayout(
              logoSize: 100,
              titleFontSize: 28,
              subtitleFontSize: 16,
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
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
        MaterialApp(
          home: Scaffold(
            body: PortraitLayout(
              logoSize: 140,
              titleFontSize: 36,
              subtitleFontSize: 20,
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
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
        MaterialApp(
          home: Scaffold(
            body: PortraitLayout(
              logoSize: 100,
              titleFontSize: 28,
              subtitleFontSize: 16,
              onStartTrialPressed: () => startTrialPressed = true,
              onSignInPressed: () => signInPressed = true,
            ),
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