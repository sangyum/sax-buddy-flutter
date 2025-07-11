import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';

void main() {
  group('MusicalNote', () {
    test('should create a musical note with all properties', () {
      const note = MusicalNote(
        pitch: NotePitch.c,
        octave: 4,
        accidental: Accidental.sharp,
        duration: NoteDuration.quarter,
      );

      expect(note.pitch, equals(NotePitch.c));
      expect(note.octave, equals(4));
      expect(note.accidental, equals(Accidental.sharp));
      expect(note.duration, equals(NoteDuration.quarter));
    });

    test('should create a natural note without accidental', () {
      const note = MusicalNote(
        pitch: NotePitch.a,
        octave: 4,
        duration: NoteDuration.whole,
      );

      expect(note.pitch, equals(NotePitch.a));
      expect(note.octave, equals(4));
      expect(note.accidental, equals(Accidental.natural));
      expect(note.duration, equals(NoteDuration.whole));
    });

    test('should convert to and from JSON', () {
      const originalNote = MusicalNote(
        pitch: NotePitch.f,
        octave: 5,
        accidental: Accidental.flat,
        duration: NoteDuration.eighth,
      );

      final json = originalNote.toJson();
      final reconstructedNote = MusicalNote.fromJson(json);

      expect(reconstructedNote.pitch, equals(originalNote.pitch));
      expect(reconstructedNote.octave, equals(originalNote.octave));
      expect(reconstructedNote.accidental, equals(originalNote.accidental));
      expect(reconstructedNote.duration, equals(originalNote.duration));
    });

    test('should handle different note durations', () {
      const wholeNote = MusicalNote(
        pitch: NotePitch.c,
        octave: 4,
        duration: NoteDuration.whole,
      );

      const halfNote = MusicalNote(
        pitch: NotePitch.c,
        octave: 4,
        duration: NoteDuration.half,
      );

      expect(wholeNote.duration, equals(NoteDuration.whole));
      expect(halfNote.duration, equals(NoteDuration.half));
    });

    test('should have proper string representation', () {
      const note = MusicalNote(
        pitch: NotePitch.c,
        octave: 4,
        accidental: Accidental.sharp,
        duration: NoteDuration.quarter,
      );

      expect(note.toString(), contains('C#4'));
      expect(note.toString(), contains('quarter'));
    });
  });

  group('NotePitch', () {
    test('should have all chromatic pitches', () {
      expect(NotePitch.values.length, equals(7));
      expect(NotePitch.values, contains(NotePitch.c));
      expect(NotePitch.values, contains(NotePitch.d));
      expect(NotePitch.values, contains(NotePitch.e));
      expect(NotePitch.values, contains(NotePitch.f));
      expect(NotePitch.values, contains(NotePitch.g));
      expect(NotePitch.values, contains(NotePitch.a));
      expect(NotePitch.values, contains(NotePitch.b));
    });
  });

  group('Accidental', () {
    test('should have natural, sharp, and flat', () {
      expect(Accidental.values.length, equals(3));
      expect(Accidental.values, contains(Accidental.natural));
      expect(Accidental.values, contains(Accidental.sharp));
      expect(Accidental.values, contains(Accidental.flat));
    });
  });

  group('NoteDuration', () {
    test('should have standard note durations', () {
      expect(NoteDuration.values.length, equals(5));
      expect(NoteDuration.values, contains(NoteDuration.whole));
      expect(NoteDuration.values, contains(NoteDuration.half));
      expect(NoteDuration.values, contains(NoteDuration.quarter));
      expect(NoteDuration.values, contains(NoteDuration.eighth));
      expect(NoteDuration.values, contains(NoteDuration.sixteenth));
    });
  });
}