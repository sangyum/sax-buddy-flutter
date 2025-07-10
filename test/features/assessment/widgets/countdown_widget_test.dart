import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/widgets/countdown_widget.dart';

void main() {
  group('CountdownWidget', () {
    testWidgets('should display countdown value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownWidget(countdownValue: 3),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.text('Get ready to play...'), findsOneWidget);
    });

    testWidgets('should display different countdown values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownWidget(countdownValue: 1),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('3'), findsNothing);
    });

    testWidgets('should show cancel button when onCancel is provided', (WidgetTester tester) async {
      bool cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountdownWidget(
              countdownValue: 5,
              onCancel: () => cancelCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      
      await tester.tap(find.text('Cancel'));
      await tester.pump();
      
      expect(cancelCalled, isTrue);
    });

    testWidgets('should not show cancel button when onCancel is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownWidget(countdownValue: 5),
          ),
        ),
      );

      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('should have proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownWidget(countdownValue: 3),
          ),
        ),
      );

      // Find the countdown number
      final countdownText = tester.widget<Text>(find.text('3'));
      expect(countdownText.style?.fontSize, equals(48));
      expect(countdownText.style?.fontWeight, equals(FontWeight.bold));
      expect(countdownText.style?.color, equals(const Color(0xFF2E5266)));
    });
  });
}