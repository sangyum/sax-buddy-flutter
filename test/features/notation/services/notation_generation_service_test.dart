import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/notation/services/notation_generation_service.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';

void main() {
  group('NotationGenerationService', () {
    late NotationGenerationService service;

    setUp(() {
      service = NotationGenerationService();
    });

    group('Scale Generation', () {
      test('should generate C Major scale notation', () {
        final result = service.generateScaleNotation(
          key: 'C',
          scaleType: ScaleType.major,
          octave: 4,
          tempo: 120,
        );

        expect(result, isNotNull);
        expect(result.metadata.title, equals('C Major Scale'));
        expect(result.metadata.tempo, equals(120));
        expect(result.metadata.clef, equals(Clef.treble));
        expect(result.measures.length, equals(2)); // Up and down scale

        // Check first measure (C-D-E-F)
        final firstMeasure = result.measures[0];
        expect(firstMeasure.notes.length, equals(4));
        expect(firstMeasure.notes[0].pitch, equals(NotePitch.c));
        expect(firstMeasure.notes[1].pitch, equals(NotePitch.d));
        expect(firstMeasure.notes[2].pitch, equals(NotePitch.e));
        expect(firstMeasure.notes[3].pitch, equals(NotePitch.f));

        // Check second measure (G-A-B-C)
        final secondMeasure = result.measures[1];
        expect(secondMeasure.notes.length, equals(4));
        expect(secondMeasure.notes[0].pitch, equals(NotePitch.g));
        expect(secondMeasure.notes[1].pitch, equals(NotePitch.a));
        expect(secondMeasure.notes[2].pitch, equals(NotePitch.b));
        expect(secondMeasure.notes[3].pitch, equals(NotePitch.c));
        expect(secondMeasure.notes[3].octave, equals(5)); // Higher octave
      });

      test('should generate G Major scale notation with sharps', () {
        final result = service.generateScaleNotation(
          key: 'G',
          scaleType: ScaleType.major,
          octave: 4,
          tempo: 100,
        );

        expect(result.metadata.title, equals('G Major Scale'));
        expect(result.measures[0].keySignature, equals(KeySignature.gMajor));
        
        // Check that F# is included
        final allNotes = result.measures.expand((m) => m.notes).toList();
        final fSharpNote = allNotes.firstWhere(
          (note) => note.pitch == NotePitch.f && note.accidental == Accidental.sharp,
        );
        expect(fSharpNote, isNotNull);
      });

      test('should generate F Major scale notation with flats', () {
        final result = service.generateScaleNotation(
          key: 'F',
          scaleType: ScaleType.major,
          octave: 4,
          tempo: 80,
        );

        expect(result.metadata.title, equals('F Major Scale'));
        expect(result.measures[0].keySignature, equals(KeySignature.fMajor));
        
        // Check that Bb is included
        final allNotes = result.measures.expand((m) => m.notes).toList();
        final bFlatNote = allNotes.firstWhere(
          (note) => note.pitch == NotePitch.b && note.accidental == Accidental.flat,
        );
        expect(bFlatNote, isNotNull);
      });

      test('should generate chromatic scale notation', () {
        final result = service.generateScaleNotation(
          key: 'C',
          scaleType: ScaleType.chromatic,
          octave: 4,
          tempo: 90,
        );

        expect(result.metadata.title, equals('C Chromatic Scale'));
        expect(result.measures.length, equals(3)); // More notes need more measures

        final allNotes = result.measures.expand((m) => m.notes).toList();
        expect(allNotes.length, equals(12)); // 12 semitones

        // Should include C, C#, D, D#, E, F, F#, G, G#, A, A#, B
        expect(allNotes[0].pitch, equals(NotePitch.c));
        expect(allNotes[1].pitch, equals(NotePitch.c));
        expect(allNotes[1].accidental, equals(Accidental.sharp));
        expect(allNotes[2].pitch, equals(NotePitch.d));
      });

      test('should handle different note durations', () {
        final result = service.generateScaleNotation(
          key: 'C',
          scaleType: ScaleType.major,
          octave: 4,
          tempo: 120,
          noteDuration: NoteDuration.eighth,
        );

        final allNotes = result.measures.expand((m) => m.notes).toList();
        expect(allNotes.every((note) => note.duration == NoteDuration.eighth), isTrue);
      });
    });

    group('Arpeggio Generation', () {
      test('should generate C Major arpeggio notation', () {
        final result = service.generateArpeggioNotation(
          key: 'C',
          chordType: ChordType.major,
          octave: 4,
          tempo: 100,
        );

        expect(result.metadata.title, equals('C Major Arpeggio'));
        expect(result.metadata.tempo, equals(100));
        expect(result.measures.length, equals(1));

        final notes = result.measures[0].notes;
        expect(notes.length, equals(4)); // Root, 3rd, 5th, octave
        expect(notes[0].pitch, equals(NotePitch.c)); // Root
        expect(notes[1].pitch, equals(NotePitch.e)); // Major 3rd
        expect(notes[2].pitch, equals(NotePitch.g)); // Perfect 5th
        expect(notes[3].pitch, equals(NotePitch.c)); // Octave
        expect(notes[3].octave, equals(5));
      });

      test('should generate D minor arpeggio notation', () {
        final result = service.generateArpeggioNotation(
          key: 'D',
          chordType: ChordType.minor,
          octave: 4,
          tempo: 110,
        );

        expect(result.metadata.title, equals('D Minor Arpeggio'));
        
        final notes = result.measures[0].notes;
        expect(notes[0].pitch, equals(NotePitch.d)); // Root
        expect(notes[1].pitch, equals(NotePitch.f)); // Minor 3rd
        expect(notes[2].pitch, equals(NotePitch.a)); // Perfect 5th
        expect(notes[3].pitch, equals(NotePitch.d)); // Octave
      });

      test('should generate seventh chord arpeggio', () {
        final result = service.generateArpeggioNotation(
          key: 'G',
          chordType: ChordType.dominant7,
          octave: 4,
          tempo: 95,
        );

        expect(result.metadata.title, equals('G Dominant 7th Arpeggio'));
        
        final notes = result.measures[0].notes;
        expect(notes.length, equals(4)); // Root, 3rd, 5th, 7th
        expect(notes[0].pitch, equals(NotePitch.g)); // Root
        expect(notes[1].pitch, equals(NotePitch.b)); // Major 3rd
        expect(notes[2].pitch, equals(NotePitch.d)); // Perfect 5th
        expect(notes[3].pitch, equals(NotePitch.f)); // Minor 7th
      });
    });

    group('Long Tone Generation', () {
      test('should generate long tone exercise', () {
        final result = service.generateLongToneNotation(
          notes: ['C4', 'F4', 'G4'],
          tempo: 60,
          noteDuration: NoteDuration.whole,
        );

        expect(result.metadata.title, equals('Long Tone Exercise'));
        expect(result.measures.length, equals(3)); // One measure per note

        expect(result.measures[0].notes[0].pitch, equals(NotePitch.c));
        expect(result.measures[0].notes[0].duration, equals(NoteDuration.whole));
        expect(result.measures[1].notes[0].pitch, equals(NotePitch.f));
        expect(result.measures[2].notes[0].pitch, equals(NotePitch.g));
      });
    });

    group('Interval Training Generation', () {
      test('should generate perfect 4ths interval exercise', () {
        final result = service.generateIntervalNotation(
          startNote: 'C4',
          intervalType: IntervalType.perfect4th,
          repetitions: 3,
          tempo: 90,
        );

        expect(result.metadata.title, equals('Perfect 4th Intervals'));
        expect(result.measures.length, equals(3));

        // First interval: C-F
        expect(result.measures[0].notes[0].pitch, equals(NotePitch.c));
        expect(result.measures[0].notes[1].pitch, equals(NotePitch.f));
      });

      test('should generate perfect 5ths interval exercise', () {
        final result = service.generateIntervalNotation(
          startNote: 'C4',
          intervalType: IntervalType.perfect5th,
          repetitions: 2,
          tempo: 100,
        );

        expect(result.metadata.title, equals('Perfect 5th Intervals'));
        
        // First interval: C-G
        expect(result.measures[0].notes[0].pitch, equals(NotePitch.c));
        expect(result.measures[0].notes[1].pitch, equals(NotePitch.g));
      });
    });

    group('Error Handling', () {
      test('should throw exception for invalid key', () {
        expect(
          () => service.generateScaleNotation(
            key: 'X',
            scaleType: ScaleType.major,
            octave: 4,
            tempo: 120,
          ),
          throwsA(isA<NotationGenerationException>()),
        );
      });

      test('should throw exception for invalid octave range', () {
        expect(
          () => service.generateScaleNotation(
            key: 'C',
            scaleType: ScaleType.major,
            octave: 10, // Too high
            tempo: 120,
          ),
          throwsA(isA<NotationGenerationException>()),
        );
      });

      test('should throw exception for invalid tempo', () {
        expect(
          () => service.generateScaleNotation(
            key: 'C',
            scaleType: ScaleType.major,
            octave: 4,
            tempo: 0, // Invalid tempo
          ),
          throwsA(isA<NotationGenerationException>()),
        );
      });
    });

    group('Utility Methods', () {
      test('should correctly parse note strings', () {
        final note1 = service.parseNoteString('C4');
        expect(note1.pitch, equals(NotePitch.c));
        expect(note1.octave, equals(4));
        expect(note1.accidental, equals(Accidental.natural));

        final note2 = service.parseNoteString('F#5');
        expect(note2.pitch, equals(NotePitch.f));
        expect(note2.octave, equals(5));
        expect(note2.accidental, equals(Accidental.sharp));

        final note3 = service.parseNoteString('Bb3');
        expect(note3.pitch, equals(NotePitch.b));
        expect(note3.octave, equals(3));
        expect(note3.accidental, equals(Accidental.flat));
      });

      test('should get correct key signature for keys', () {
        expect(service.getKeySignature('C'), equals(KeySignature.cMajor));
        expect(service.getKeySignature('G'), equals(KeySignature.gMajor));
        expect(service.getKeySignature('F'), equals(KeySignature.fMajor));
        expect(service.getKeySignature('D'), equals(KeySignature.dMajor));
      });
    });
  });
}