import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';

void main() {
  group('MusicalMeasure', () {
    test('should create a measure with notes and time signature', () {
      const notes = [
        MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
        MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.quarter),
        MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.quarter),
        MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.quarter),
      ];

      const measure = MusicalMeasure(
        notes: notes,
        timeSignature: TimeSignature.fourFour,
      );

      expect(measure.notes.length, equals(4));
      expect(measure.timeSignature, equals(TimeSignature.fourFour));
      expect(measure.keySignature, equals(KeySignature.cMajor));
    });

    test('should create a measure with custom key signature', () {
      const notes = [
        MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.whole),
      ];

      const measure = MusicalMeasure(
        notes: notes,
        timeSignature: TimeSignature.fourFour,
        keySignature: KeySignature.gMajor,
      );

      expect(measure.keySignature, equals(KeySignature.gMajor));
    });

    test('should convert to and from JSON', () {
      const originalMeasure = MusicalMeasure(
        notes: [
          MusicalNote(pitch: NotePitch.a, octave: 4, duration: NoteDuration.half),
          MusicalNote(pitch: NotePitch.b, octave: 4, duration: NoteDuration.half),
        ],
        timeSignature: TimeSignature.threeFour,
        keySignature: KeySignature.fMajor,
      );

      final json = originalMeasure.toJson();
      final reconstructedMeasure = MusicalMeasure.fromJson(json);

      expect(reconstructedMeasure.notes.length, equals(originalMeasure.notes.length));
      expect(reconstructedMeasure.timeSignature, equals(originalMeasure.timeSignature));
      expect(reconstructedMeasure.keySignature, equals(originalMeasure.keySignature));
    });

    test('should handle empty measures', () {
      const measure = MusicalMeasure(
        notes: [],
        timeSignature: TimeSignature.fourFour,
      );

      expect(measure.notes.isEmpty, isTrue);
    });
  });

  group('TimeSignature', () {
    test('should have common time signatures', () {
      expect(TimeSignature.values, contains(TimeSignature.fourFour));
      expect(TimeSignature.values, contains(TimeSignature.threeFour));
      expect(TimeSignature.values, contains(TimeSignature.twoFour));
      expect(TimeSignature.values, contains(TimeSignature.sixEight));
    });
  });

  group('KeySignature', () {
    test('should have major key signatures', () {
      expect(KeySignature.values, contains(KeySignature.cMajor));
      expect(KeySignature.values, contains(KeySignature.gMajor));
      expect(KeySignature.values, contains(KeySignature.dMajor));
      expect(KeySignature.values, contains(KeySignature.fMajor));
      expect(KeySignature.values, contains(KeySignature.bFlatMajor));
    });
  });
}