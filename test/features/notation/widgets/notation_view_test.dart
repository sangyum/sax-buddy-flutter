import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

void main() {
  group('NotationView', () {

    testWidgets('should display notation view with measures', (WidgetTester tester) async {
      final musicalNotation = {
        'clef': 'treble',
        'keySignature': 'cMajor',
        'tempo': 120,
        'measures': [
          {
            'notes': [
              {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
              {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
              {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
              {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
            ]
          },
        ]
      };

      final measures = PracticeExercise.convertJsonToMeasures(musicalNotation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: measures,
              tempo: 120,
              title: 'Test Exercise',
            ),
          ),
        ),
      );

      // Verify the notation view is displayed
      expect(find.byType(NotationView), findsOneWidget);
      
      // Verify that there's a Container that holds the notation
      expect(find.byType(Container), findsWidgets);
      
      // Verify title and tempo are displayed
      expect(find.text('Test Exercise'), findsOneWidget);
      expect(find.text('♩ = 120'), findsOneWidget);
    });

    testWidgets('should handle null measures data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: null,
            ),
          ),
        ),
      );

      // Should show placeholder or empty state
      expect(find.byType(NotationView), findsOneWidget);
      expect(find.text('No notation available'), findsOneWidget);
    });

    testWidgets('should handle empty measures list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: [],
            ),
          ),
        ),
      );

      // Should show placeholder or empty state
      expect(find.byType(NotationView), findsOneWidget);
      expect(find.text('No notation available'), findsOneWidget);
    });

    testWidgets('should display loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: null,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should use default tempo when not provided', (WidgetTester tester) async {
      final musicalNotation = {
        'clef': 'treble',
        'keySignature': 'cMajor',
        'measures': [
          {
            'notes': [
              {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
            ]
          },
        ]
      };

      final measures = PracticeExercise.convertJsonToMeasures(musicalNotation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: measures,
            ),
          ),
        ),
      );

      expect(find.text('♩ = 120'), findsOneWidget);
    });

    testWidgets('should use default title when not provided', (WidgetTester tester) async {
      final musicalNotation = {
        'clef': 'treble',
        'keySignature': 'cMajor',
        'measures': [
          {
            'notes': [
              {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
            ]
          },
        ]
      };

      final measures = PracticeExercise.convertJsonToMeasures(musicalNotation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: measures,
            ),
          ),
        ),
      );

      expect(find.text('Musical Exercise'), findsOneWidget);
    });

    testWidgets('should always show title and tempo when provided', (WidgetTester tester) async {
      final musicalNotation = {
        'clef': 'treble',
        'keySignature': 'cMajor',
        'measures': [
          {
            'notes': [
              {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
            ]
          },
        ]
      };

      final measures = PracticeExercise.convertJsonToMeasures(musicalNotation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: measures,
              title: 'Test Title',
              tempo: 140,
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('♩ = 140'), findsOneWidget);
    });

    testWidgets('should show SimpleSheetMusic widget when measures provided', (WidgetTester tester) async {
      final musicalNotation = {
        'clef': 'treble',
        'keySignature': 'cMajor',
        'tempo': 120,
        'measures': [
          {
            'notes': [
              {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
            ]
          },
        ]
      };

      final measures = PracticeExercise.convertJsonToMeasures(musicalNotation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotationView(
              measures: measures,
            ),
          ),
        ),
      );

      // Should render SimpleSheetMusic widget
      expect(find.byType(SimpleSheetMusic), findsOneWidget);
    });
  });
}