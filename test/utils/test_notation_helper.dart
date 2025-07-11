import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';

class TestNotationHelper {
  static SheetMusicData createScaleNotation({String title = 'Scale'}) {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.d,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.e,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.f,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.g,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.a,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.b,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.c,
              octave: 5,
              duration: NoteDuration.quarter,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(clef: Clef.treble, tempo: 120, title: title),
    );
  }

  static SheetMusicData createArpeggioNotation({String title = 'Arpeggio'}) {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.e,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.g,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.c,
              octave: 5,
              duration: NoteDuration.quarter,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(clef: Clef.treble, tempo: 100, title: title),
    );
  }

  static SheetMusicData createChromaticNotation() {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              accidental: Accidental.sharp,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.d,
              octave: 4,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.d,
              octave: 4,
              accidental: Accidental.sharp,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.e,
              octave: 4,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.f,
              octave: 4,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.f,
              octave: 4,
              accidental: Accidental.sharp,
              duration: NoteDuration.eighth,
            ),
            MusicalNote(
              pitch: NotePitch.g,
              octave: 4,
              duration: NoteDuration.eighth,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: 80,
        title: 'Chromatic Scale',
      ),
    );
  }

  static SheetMusicData createIntervalsNotation() {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              duration: NoteDuration.half,
            ),
            MusicalNote(
              pitch: NotePitch.f,
              octave: 4,
              duration: NoteDuration.half,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              duration: NoteDuration.half,
            ),
            MusicalNote(
              pitch: NotePitch.g,
              octave: 4,
              duration: NoteDuration.half,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: 90,
        title: 'Perfect 4ths and 5ths',
      ),
    );
  }
}
