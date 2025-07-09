import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/landing/widgets/cta_section.dart';

void main() {
  group('CTASection', () {
    testWidgets('displays Start Free Trial button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CTASection(
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Start Free Trial'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays Sign In text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CTASection(
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Already have account? Sign In'), findsOneWidget);
    });

    testWidgets('Start Free Trial button has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CTASection(
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = elevatedButton.style;
      
      expect(buttonStyle?.backgroundColor?.resolve({}), const Color(0xFF2E5266));
      expect(buttonStyle?.shape?.resolve({}), isA<RoundedRectangleBorder>());
    });

    testWidgets('Sign In text has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CTASection(
              onStartTrialPressed: () {},
              onSignInPressed: () {},
            ),
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
        MaterialApp(
          home: Scaffold(
            body: CTASection(
              onStartTrialPressed: () => wasPressed = true,
              onSignInPressed: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(wasPressed, true);
    });

    testWidgets('calls onSignInPressed when sign in text is tapped', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CTASection(
              onStartTrialPressed: () {},
              onSignInPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Already have account? Sign In'));
      expect(wasPressed, true);
    });
  });
}