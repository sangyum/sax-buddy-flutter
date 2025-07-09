import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/landing/widgets/feature_cards.dart';

void main() {
  group('FeatureCards', () {
    testWidgets('displays both feature cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeatureCards(),
          ),
        ),
      );

      expect(find.text('Audio Analysis'), findsOneWidget);
      expect(find.text('Real-time feedback'), findsOneWidget);
      expect(find.text('AI Routines'), findsOneWidget);
      expect(find.text('Personalized exercises'), findsOneWidget);
    });

    testWidgets('displays feature cards with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeatureCards(),
          ),
        ),
      );

      // Check that containers have the correct styling
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Filter for feature card containers (they have specific decoration)
      final featureCardContainers = containers.where((container) {
        final decoration = container.decoration as BoxDecoration?;
        return decoration != null && 
               decoration.color == Colors.white && 
               decoration.border != null;
      });

      expect(featureCardContainers.length, 2);
    });

    testWidgets('displays icons with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeatureCards(),
          ),
        ),
      );

      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(icons.length, 2);
      
      for (final icon in icons) {
        expect(icon.color, const Color(0xFF2E5266));
        expect(icon.size, 20);
      }
    });

    testWidgets('displays circular icon backgrounds', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeatureCards(),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Find icon background containers
      final iconBackgrounds = containers.where((container) {
        final decoration = container.decoration as BoxDecoration?;
        return decoration != null && 
               decoration.shape == BoxShape.circle && 
               decoration.color == const Color(0xFFE8F4F8);
      });

      expect(iconBackgrounds.length, 2);
    });
  });
}