import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';

void main() {
  group('SheetMusicData', () {
    test('should create sheet music with measures and metadata', () {
      const measures = [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.whole),
          ],
          timeSignature: TimeSignature.fourFour,
        ),
      ];

      const metadata = NotationMetadata(
        clef: Clef.treble,
        tempo: 120,
        title: 'C Major Scale',
      );

      const sheetMusic = SheetMusicData(
        measures: measures,
        metadata: metadata,
      );

      expect(sheetMusic.measures.length, equals(1));
      expect(sheetMusic.metadata.clef, equals(Clef.treble));
      expect(sheetMusic.metadata.tempo, equals(120));
      expect(sheetMusic.metadata.title, equals('C Major Scale'));
    });

    test('should convert to and from JSON', () {
      const originalSheetMusic = SheetMusicData(
        measures: [
          MusicalMeasure(
            notes: [
              MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
              MusicalNote(pitch: NotePitch.a, octave: 4, duration: NoteDuration.quarter),
            ],
            timeSignature: TimeSignature.threeFour,
            keySignature: KeySignature.gMajor,
          ),
        ],
        metadata: NotationMetadata(
          clef: Clef.treble,
          tempo: 100,
          title: 'G Major Exercise',
        ),
      );

      final json = originalSheetMusic.toJson();
      final reconstructedSheetMusic = SheetMusicData.fromJson(json);

      expect(reconstructedSheetMusic.measures.length, equals(originalSheetMusic.measures.length));
      expect(reconstructedSheetMusic.metadata.title, equals(originalSheetMusic.metadata.title));
      expect(reconstructedSheetMusic.metadata.tempo, equals(originalSheetMusic.metadata.tempo));
    });

    test('should handle multiple measures', () {
      const measures = [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.a, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.b, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.c, octave: 5, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
        ),
      ];

      const sheetMusic = SheetMusicData(
        measures: measures,
        metadata: NotationMetadata(
          clef: Clef.treble,
          tempo: 80,
          title: 'C Major Scale - Two Measures',
        ),
      );

      expect(sheetMusic.measures.length, equals(2));
      expect(sheetMusic.measures[0].notes.length, equals(4));
      expect(sheetMusic.measures[1].notes.length, equals(4));
    });
  });

  group('NotationMetadata', () {
    test('should create metadata with default values', () {
      const metadata = NotationMetadata(
        clef: Clef.treble,
        tempo: 120,
        title: 'Test Exercise',
      );

      expect(metadata.clef, equals(Clef.treble));
      expect(metadata.tempo, equals(120));
      expect(metadata.title, equals('Test Exercise'));
      expect(metadata.composer, isNull);
    });

    test('should create metadata with all properties', () {
      const metadata = NotationMetadata(
        clef: Clef.treble,
        tempo: 90,
        title: 'Saxophone Study',
        composer: 'Practice App',
      );

      expect(metadata.composer, equals('Practice App'));
    });

    test('should convert to and from JSON', () {
      const originalMetadata = NotationMetadata(
        clef: Clef.treble,
        tempo: 110,
        title: 'JSON Test',
        composer: 'Test Suite',
      );

      final json = originalMetadata.toJson();
      final reconstructedMetadata = NotationMetadata.fromJson(json);

      expect(reconstructedMetadata.clef, equals(originalMetadata.clef));
      expect(reconstructedMetadata.tempo, equals(originalMetadata.tempo));
      expect(reconstructedMetadata.title, equals(originalMetadata.title));
      expect(reconstructedMetadata.composer, equals(originalMetadata.composer));
    });
  });

  group('Clef', () {
    test('should have treble clef for saxophone', () {
      expect(Clef.values, contains(Clef.treble));
      expect(Clef.values, contains(Clef.bass));
    });
  });
}