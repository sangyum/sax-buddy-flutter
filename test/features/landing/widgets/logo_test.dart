import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/landing/widgets/logo.dart';

void main() {
  group('Logo', () {
    testWidgets('displays logo image with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Logo(size: 100),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints, BoxConstraints.tight(const Size(100, 100)));
    });

    testWidgets('displays logo with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Logo(size: 140),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints, BoxConstraints.tight(const Size(140, 140)));
    });

    testWidgets('has gradient background and shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Logo(size: 100),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });
  });
}