import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/landing/widgets/title_section.dart';

void main() {
  group('TitleSection', () {
    testWidgets('displays app name with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TitleSection(
              titleFontSize: 28,
              subtitleFontSize: 16,
            ),
          ),
        ),
      );

      expect(find.text('SaxAI Coach'), findsOneWidget);
      
      final titleWidget = tester.widget<Text>(find.text('SaxAI Coach'));
      expect(titleWidget.style?.fontSize, 28);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, const Color(0xFF2E5266));
    });

    testWidgets('displays tagline with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TitleSection(
              titleFontSize: 28,
              subtitleFontSize: 16,
            ),
          ),
        ),
      );

      expect(find.text('AI-powered practice routines'), findsOneWidget);
      expect(find.text('for self-taught saxophonists'), findsOneWidget);
      
      final subtitleWidget = tester.widget<Text>(find.text('AI-powered practice routines'));
      expect(subtitleWidget.style?.fontSize, 16);
      expect(subtitleWidget.style?.color, const Color(0xFF757575));
    });

    testWidgets('adapts to custom font sizes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TitleSection(
              titleFontSize: 36,
              subtitleFontSize: 20,
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('SaxAI Coach'));
      expect(titleWidget.style?.fontSize, 36);
      
      final subtitleWidget = tester.widget<Text>(find.text('AI-powered practice routines'));
      expect(subtitleWidget.style?.fontSize, 20);
    });
  });
}