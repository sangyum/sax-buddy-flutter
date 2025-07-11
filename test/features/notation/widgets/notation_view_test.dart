import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';

void main() {
  group('NotationView', () {
    testWidgets('should display notation view with sheet music data', (WidgetTester tester) async {
      const sheetMusicData = SheetMusicData(
        measures: [
          MusicalMeasure(
            notes: [
              MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
              MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.quarter),
              MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.quarter),
              MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.quarter),
            ],
            timeSignature: TimeSignature.fourFour,
            keySignature: KeySignature.cMajor,
          ),
        ],
        metadata: NotationMetadata(
          clef: Clef.treble,
          tempo: 120,
          title: 'C Major Scale',
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotationView(sheetMusicData: sheetMusicData),
          ),
        ),
      );

      // Verify the notation view is displayed
      expect(find.byType(NotationView), findsOneWidget);
      
      // Verify that there's a Container that holds the notation
      expect(find.byType(Container), findsWidgets);
      
      // For now, just check that the widget doesn't crash
      // Later we'll add more specific tests when we integrate with simple_sheet_music
    });

    testWidgets('should handle null sheet music data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotationView(sheetMusicData: null),
          ),
        ),
      );

      // Should show placeholder or empty state
      expect(find.byType(NotationView), findsOneWidget);
      expect(find.text('No notation available'), findsOneWidget);
    });

    testWidgets('should display loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotationView(
              sheetMusicData: null,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}