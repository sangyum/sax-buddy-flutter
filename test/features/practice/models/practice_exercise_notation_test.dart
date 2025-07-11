import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';

void main() {
  group('PracticeExercise with Sheet Music Data', () {
    test('should create exercise without sheet music data (backward compatibility)', () {
      const exercise = PracticeExercise(
        name: 'C Major Scale',
        description: 'Practice C major scale at slow tempo',
        tempo: '80 BPM',
        keySignature: 'C Major',
        notes: 'C-D-E-F-G-A-B-C',
        estimatedDuration: '10 minutes',
      );

      expect(exercise.name, equals('C Major Scale'));
      expect(exercise.sheetMusicData, isNull);
      expect(exercise.tempo, equals('80 BPM'));
      expect(exercise.keySignature, equals('C Major'));
    });

    test('should create exercise with sheet music data', () {
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
          tempo: 80,
          title: 'C Major Scale',
        ),
      );

      const exercise = PracticeExercise(
        name: 'C Major Scale',
        description: 'Practice C major scale with notation',
        tempo: '80 BPM',
        keySignature: 'C Major',
        estimatedDuration: '10 minutes',
        sheetMusicData: sheetMusicData,
      );

      expect(exercise.sheetMusicData, isNotNull);
      expect(exercise.sheetMusicData!.measures.length, equals(1));
      expect(exercise.sheetMusicData!.metadata.title, equals('C Major Scale'));
      expect(exercise.sheetMusicData!.metadata.tempo, equals(80));
    });

    test('should convert exercise with sheet music data to and from JSON', () {
      const originalExercise = PracticeExercise(
        name: 'G Major Arpeggio',
        description: 'Practice G major arpeggio with notation',
        tempo: '100 BPM',
        keySignature: 'G Major',
        estimatedDuration: '8 minutes',
        sheetMusicData: SheetMusicData(
          measures: [
            MusicalMeasure(
              notes: [
                MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
                MusicalNote(pitch: NotePitch.b, octave: 4, duration: NoteDuration.quarter),
                MusicalNote(pitch: NotePitch.d, octave: 5, duration: NoteDuration.quarter),
                MusicalNote(pitch: NotePitch.g, octave: 5, duration: NoteDuration.quarter),
              ],
              timeSignature: TimeSignature.fourFour,
              keySignature: KeySignature.gMajor,
            ),
          ],
          metadata: NotationMetadata(
            clef: Clef.treble,
            tempo: 100,
            title: 'G Major Arpeggio',
          ),
        ),
      );

      final json = originalExercise.toJson();
      final reconstructedExercise = PracticeExercise.fromJson(json);

      expect(reconstructedExercise.name, equals(originalExercise.name));
      expect(reconstructedExercise.sheetMusicData, isNotNull);
      expect(reconstructedExercise.sheetMusicData!.measures.length, equals(1));
      expect(reconstructedExercise.sheetMusicData!.metadata.title, equals('G Major Arpeggio'));
    });

    test('should handle JSON without sheet music data (backward compatibility)', () {
      final json = {
        'name': 'Long Tones',
        'description': 'Practice sustained notes',
        'tempo': '60 BPM',
        'keySignature': 'C Major',
        'estimatedDuration': '5 minutes',
      };

      final exercise = PracticeExercise.fromJson(json);

      expect(exercise.name, equals('Long Tones'));
      expect(exercise.sheetMusicData, isNull);
      expect(exercise.tempo, equals('60 BPM'));
    });

    test('should include sheet music data in JSON when present', () {
      const exercise = PracticeExercise(
        name: 'Test Exercise',
        description: 'Test description',
        estimatedDuration: '5 minutes',
        sheetMusicData: SheetMusicData(
          measures: [
            MusicalMeasure(
              notes: [
                MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.whole),
              ],
              timeSignature: TimeSignature.fourFour,
            ),
          ],
          metadata: NotationMetadata(
            clef: Clef.treble,
            tempo: 120,
            title: 'Test',
          ),
        ),
      );

      final json = exercise.toJson();

      expect(json['sheetMusicData'], isNotNull);
      expect(json['sheetMusicData']['measures'], isNotNull);
      expect(json['sheetMusicData']['metadata'], isNotNull);
    });
  });
}