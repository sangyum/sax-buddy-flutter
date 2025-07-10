import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/widgets/countdown_overlay_button.dart';

void main() {
  group('CountdownOverlayButton', () {
    testWidgets('should display countdown value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownOverlayButton(
              countdownValue: 3,
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.text('Get ready to play...'), findsOneWidget);
    });

    testWidgets('should display microphone icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownOverlayButton(
              countdownValue: 5,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('should show cancel button when onCancel is provided', (WidgetTester tester) async {
      bool cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountdownOverlayButton(
              countdownValue: 2,
              onCancel: () => cancelCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      
      await tester.tap(find.text('Cancel'));
      expect(cancelCalled, isTrue);
    });

    testWidgets('should not show cancel button when onCancel is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownOverlayButton(
              countdownValue: 1,
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('should have correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownOverlayButton(
              countdownValue: 4,
            ),
          ),
        ),
      );

      // Check that countdown overlay is present
      final countdownText = find.text('4');
      expect(countdownText, findsOneWidget);
      
      // Check that countdown text has correct style
      final textWidget = tester.widget<Text>(countdownText);
      expect(textWidget.style?.fontSize, equals(36));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(textWidget.style?.color, equals(Colors.white));
    });
  });
}