import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/widgets/recording_button.dart';

void main() {
  group('RecordingButton', () {
    testWidgets('should display microphone icon when not recording', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              onPressed: () => buttonPressed = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(buttonPressed, isFalse);
      
      await tester.tap(find.byType(RecordingButton));
      await tester.pump();
      
      expect(buttonPressed, isTrue);
    });

    testWidgets('should display stop square when recording', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic), findsNothing);
      // The recording state shows a square container instead of an icon
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              onPressed: () => buttonPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RecordingButton));
      await tester.pump();

      expect(buttonPressed, isTrue);
    });

    testWidgets('should have proper red color styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Check for the red background color
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool hasRedBackground = false;
      
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.color == const Color(0xFFE53E3E)) {
          hasRedBackground = true;
          break;
        }
      }
      
      expect(hasRedBackground, isTrue);
    });

    testWidgets('should have circular shape', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      final gestureDetector = tester.widget<GestureDetector>(find.byType(GestureDetector));
      final container = gestureDetector.child as Container;
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.shape, equals(BoxShape.circle));
    });
  });
}