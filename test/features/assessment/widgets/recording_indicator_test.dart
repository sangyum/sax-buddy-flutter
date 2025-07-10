import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/widgets/recording_indicator.dart';

void main() {
  group('RecordingIndicator', () {
    testWidgets('should display REC text and red circle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecordingIndicator(),
          ),
        ),
      );

      expect(find.text('REC'), findsOneWidget);
      
      // Check for the red circle container
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool hasRedCircle = false;
      
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.color == const Color(0xFFE53E3E) && 
            decoration?.shape == BoxShape.circle) {
          hasRedCircle = true;
          break;
        }
      }
      
      expect(hasRedCircle, isTrue);
    });

    testWidgets('should have proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecordingIndicator(),
          ),
        ),
      );

      final recText = tester.widget<Text>(find.text('REC'));
      expect(recText.style?.color, equals(const Color(0xFFE53E3E)));
      expect(recText.style?.fontSize, equals(12));
      expect(recText.style?.fontWeight, equals(FontWeight.w600));
    });
  });
}