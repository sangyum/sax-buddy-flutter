import 'package:injectable/injectable.dart';
import '../domain/musical_note.dart';
import '../domain/musical_measure.dart';
import '../domain/sheet_music_data.dart';

/// Service for generating musical notation from exercise descriptions
@lazySingleton
class NotationGenerationService {
  /// Generates scale notation based on key and scale type
  SheetMusicData generateScaleNotation({
    required String key,
    required ScaleType scaleType,
    required int octave,
    required int tempo,
    NoteDuration noteDuration = NoteDuration.quarter,
  }) {
    _validateInputs(key: key, octave: octave, tempo: tempo);

    final keySignature = getKeySignature(key);
    final scaleNotes = _generateScaleNotes(key, scaleType, octave, noteDuration);
    final measures = _createMeasuresFromNotes(scaleNotes, keySignature);
    
    final title = _getScaleTitle(key, scaleType);
    
    return SheetMusicData(
      measures: measures,
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: tempo,
        title: title,
      ),
    );
  }

  /// Generates arpeggio notation for chord types
  SheetMusicData generateArpeggioNotation({
    required String key,
    required ChordType chordType,
    required int octave,
    required int tempo,
    NoteDuration noteDuration = NoteDuration.quarter,
  }) {
    _validateInputs(key: key, octave: octave, tempo: tempo);

    final keySignature = getKeySignature(key);
    final arpeggioNotes = _generateArpeggioNotes(key, chordType, octave, noteDuration);
    final measure = MusicalMeasure(
      notes: arpeggioNotes,
      timeSignature: TimeSignature.fourFour,
      keySignature: keySignature,
    );
    
    final title = _getArpeggioTitle(key, chordType);
    
    return SheetMusicData(
      measures: [measure],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: tempo,
        title: title,
      ),
    );
  }

  /// Generates long tone exercise notation
  SheetMusicData generateLongToneNotation({
    required List<String> notes,
    required int tempo,
    NoteDuration noteDuration = NoteDuration.whole,
  }) {
    _validateTempo(tempo);

    final measures = notes.map((noteString) {
      final note = parseNoteString(noteString);
      return MusicalMeasure(
        notes: [note.copyWith(duration: noteDuration)],
        timeSignature: TimeSignature.fourFour,
        keySignature: KeySignature.cMajor,
      );
    }).toList();

    return SheetMusicData(
      measures: measures,
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: tempo,
        title: 'Long Tone Exercise',
      ),
    );
  }

  /// Generates interval training exercise notation
  SheetMusicData generateIntervalNotation({
    required String startNote,
    required IntervalType intervalType,
    required int repetitions,
    required int tempo,
    NoteDuration noteDuration = NoteDuration.half,
  }) {
    _validateTempo(tempo);

    final baseNote = parseNoteString(startNote);
    final measures = <MusicalMeasure>[];

    for (int i = 0; i < repetitions; i++) {
      final secondNote = _getIntervalNote(baseNote, intervalType);
      final measure = MusicalMeasure(
        notes: [
          baseNote.copyWith(duration: noteDuration),
          secondNote.copyWith(duration: noteDuration),
        ],
        timeSignature: TimeSignature.fourFour,
        keySignature: KeySignature.cMajor,
      );
      measures.add(measure);
    }

    final title = _getIntervalTitle(intervalType);
    
    return SheetMusicData(
      measures: measures,
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: tempo,
        title: title,
      ),
    );
  }

  /// Parses a note string like 'C4', 'F#5', 'Bb3' into a MusicalNote
  MusicalNote parseNoteString(String noteString) {
    if (noteString.length < 2) {
      throw NotationGenerationException('Invalid note string: $noteString');
    }

    final pitchChar = noteString[0].toLowerCase();
    final pitch = _charToPitch(pitchChar);
    
    String remainingString = noteString.substring(1);
    Accidental accidental = Accidental.natural;
    
    // Check for accidental
    if (remainingString.startsWith('#')) {
      accidental = Accidental.sharp;
      remainingString = remainingString.substring(1);
    } else if (remainingString.startsWith('b')) {
      accidental = Accidental.flat;
      remainingString = remainingString.substring(1);
    }
    
    final octave = int.tryParse(remainingString);
    if (octave == null) {
      throw NotationGenerationException('Invalid octave in note string: $noteString');
    }

    return MusicalNote(
      pitch: pitch,
      octave: octave,
      accidental: accidental,
      duration: NoteDuration.quarter, // Default duration
    );
  }

  /// Gets the appropriate key signature for a given key
  KeySignature getKeySignature(String key) {
    switch (key.toUpperCase()) {
      case 'C':
        return KeySignature.cMajor;
      case 'G':
        return KeySignature.gMajor;
      case 'D':
        return KeySignature.dMajor;
      case 'A':
        return KeySignature.aMajor;
      case 'E':
        return KeySignature.eMajor;
      case 'F':
        return KeySignature.fMajor;
      case 'BB':
      case 'B♭':
        return KeySignature.bFlatMajor;
      case 'EB':
      case 'E♭':
        return KeySignature.eFlatMajor;
      default:
        throw NotationGenerationException('Unsupported key: $key');
    }
  }

  // Private helper methods
  
  void _validateInputs({required String key, required int octave, required int tempo}) {
    _validateKey(key);
    _validateOctave(octave);
    _validateTempo(tempo);
  }

  void _validateKey(String key) {
    final validKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'BB', 'EB'];
    if (!validKeys.contains(key.toUpperCase())) {
      throw NotationGenerationException('Invalid key: $key');
    }
  }

  void _validateOctave(int octave) {
    if (octave < 1 || octave > 8) {
      throw NotationGenerationException('Invalid octave: $octave. Must be between 1 and 8');
    }
  }

  void _validateTempo(int tempo) {
    if (tempo < 30 || tempo > 300) {
      throw NotationGenerationException('Invalid tempo: $tempo. Must be between 30 and 300 BPM');
    }
  }

  NotePitch _charToPitch(String char) {
    switch (char.toLowerCase()) {
      case 'c':
        return NotePitch.c;
      case 'd':
        return NotePitch.d;
      case 'e':
        return NotePitch.e;
      case 'f':
        return NotePitch.f;
      case 'g':
        return NotePitch.g;
      case 'a':
        return NotePitch.a;
      case 'b':
        return NotePitch.b;
      default:
        throw NotationGenerationException('Invalid pitch: $char');
    }
  }

  NotePitch _keyToPitch(String key) {
    final keyUpper = key.toUpperCase();
    if (keyUpper == 'BB' || keyUpper == 'B♭') {
      return NotePitch.b;
    } else if (keyUpper == 'EB' || keyUpper == 'E♭') {
      return NotePitch.e;
    } else if (keyUpper.length == 1) {
      return _charToPitch(keyUpper);
    } else {
      throw NotationGenerationException('Invalid key: $key');
    }
  }

  List<MusicalNote> _generateScaleNotes(String key, ScaleType scaleType, int octave, NoteDuration duration) {
    switch (scaleType) {
      case ScaleType.major:
        return _generateMajorScale(key, octave, duration);
      case ScaleType.minor:
        return _generateMinorScale(key, octave, duration);
      case ScaleType.chromatic:
        return _generateChromaticScale(key, octave, duration);
    }
  }

  List<MusicalNote> _generateMajorScale(String key, int octave, NoteDuration duration) {
    final startPitch = _keyToPitch(key);
    final keySignature = getKeySignature(key);
    
    // Major scale intervals: W-W-H-W-W-W-H (W=whole step, H=half step)
    final intervals = [0, 2, 4, 5, 7, 9, 11, 12]; // Semitones from root
    
    return intervals.map((semitones) {
      final noteInfo = _getNoteFromSemitones(startPitch, octave, semitones, keySignature);
      return MusicalNote(
        pitch: noteInfo.pitch,
        octave: noteInfo.octave,
        accidental: noteInfo.accidental,
        duration: duration,
      );
    }).toList();
  }

  List<MusicalNote> _generateMinorScale(String key, int octave, NoteDuration duration) {
    final startPitch = _keyToPitch(key);
    
    // Natural minor scale intervals: W-H-W-W-H-W-W
    final intervals = [0, 2, 3, 5, 7, 8, 10, 12]; // Semitones from root
    
    return intervals.map((semitones) {
      final noteInfo = _getNoteFromSemitones(startPitch, octave, semitones, KeySignature.cMajor);
      return MusicalNote(
        pitch: noteInfo.pitch,
        octave: noteInfo.octave,
        accidental: noteInfo.accidental,
        duration: duration,
      );
    }).toList();
  }

  List<MusicalNote> _generateChromaticScale(String key, int octave, NoteDuration duration) {
    final startPitch = _keyToPitch(key);
    
    // Chromatic scale: all 12 semitones starting from the key
    final intervals = List.generate(12, (i) => i);
    
    return intervals.map((semitones) {
      final noteInfo = _getNoteFromSemitones(startPitch, octave, semitones, KeySignature.cMajor);
      return MusicalNote(
        pitch: noteInfo.pitch,
        octave: noteInfo.octave,
        accidental: noteInfo.accidental,
        duration: duration,
      );
    }).toList();
  }

  List<MusicalNote> _generateArpeggioNotes(String key, ChordType chordType, int octave, NoteDuration duration) {
    final rootPitch = _keyToPitch(key);
    final keySignature = getKeySignature(key);
    
    List<int> intervals;
    switch (chordType) {
      case ChordType.major:
        intervals = [0, 4, 7, 12]; // Root, Major 3rd, Perfect 5th, Octave
        break;
      case ChordType.minor:
        intervals = [0, 3, 7, 12]; // Root, Minor 3rd, Perfect 5th, Octave
        break;
      case ChordType.dominant7:
        intervals = [0, 4, 7, 10]; // Root, Major 3rd, Perfect 5th, Minor 7th
        break;
    }
    
    return intervals.map((semitones) {
      final noteInfo = _getNoteFromSemitones(rootPitch, octave, semitones, keySignature);
      return MusicalNote(
        pitch: noteInfo.pitch,
        octave: noteInfo.octave,
        accidental: noteInfo.accidental,
        duration: duration,
      );
    }).toList();
  }

  ({NotePitch pitch, int octave, Accidental accidental}) _getNoteFromSemitones(
    NotePitch startPitch, 
    int startOctave, 
    int semitones,
    KeySignature keySignature,
  ) {
    // Convert pitch to semitone number (C=0, C#=1, D=2, etc.)
    final startSemitone = _pitchToSemitone(startPitch);
    final targetSemitone = (startSemitone + semitones) % 12;
    final octaveIncrease = (startSemitone + semitones) ~/ 12;
    final targetOctave = startOctave + octaveIncrease;
    
    final (pitch, accidental) = _semitoneToNote(targetSemitone, keySignature);
    
    return (pitch: pitch, octave: targetOctave, accidental: accidental);
  }

  int _pitchToSemitone(NotePitch pitch) {
    switch (pitch) {
      case NotePitch.c:
        return 0;
      case NotePitch.d:
        return 2;
      case NotePitch.e:
        return 4;
      case NotePitch.f:
        return 5;
      case NotePitch.g:
        return 7;
      case NotePitch.a:
        return 9;
      case NotePitch.b:
        return 11;
    }
  }

  (NotePitch, Accidental) _semitoneToNote(int semitone, KeySignature keySignature) {
    // Prefer sharps or flats based on key signature
    final preferSharps = _shouldPreferSharps(keySignature);
    
    switch (semitone) {
      case 0:
        return (NotePitch.c, Accidental.natural);
      case 1:
        return preferSharps ? (NotePitch.c, Accidental.sharp) : (NotePitch.d, Accidental.flat);
      case 2:
        return (NotePitch.d, Accidental.natural);
      case 3:
        return preferSharps ? (NotePitch.d, Accidental.sharp) : (NotePitch.e, Accidental.flat);
      case 4:
        return (NotePitch.e, Accidental.natural);
      case 5:
        return (NotePitch.f, Accidental.natural);
      case 6:
        return preferSharps ? (NotePitch.f, Accidental.sharp) : (NotePitch.g, Accidental.flat);
      case 7:
        return (NotePitch.g, Accidental.natural);
      case 8:
        return preferSharps ? (NotePitch.g, Accidental.sharp) : (NotePitch.a, Accidental.flat);
      case 9:
        return (NotePitch.a, Accidental.natural);
      case 10:
        return preferSharps ? (NotePitch.a, Accidental.sharp) : (NotePitch.b, Accidental.flat);
      case 11:
        return (NotePitch.b, Accidental.natural);
      default:
        throw NotationGenerationException('Invalid semitone: $semitone');
    }
  }

  bool _shouldPreferSharps(KeySignature keySignature) {
    // Keys with sharps prefer sharps, keys with flats prefer flats
    // C Major (no accidentals) defaults to sharps for chromatic scales
    final sharpKeys = [KeySignature.cMajor, KeySignature.gMajor, KeySignature.dMajor, KeySignature.aMajor, KeySignature.eMajor];
    return sharpKeys.contains(keySignature);
  }

  List<MusicalMeasure> _createMeasuresFromNotes(List<MusicalNote> notes, KeySignature keySignature) {
    final measures = <MusicalMeasure>[];
    final notesPerMeasure = 4; // 4/4 time with quarter notes
    
    for (int i = 0; i < notes.length; i += notesPerMeasure) {
      final measureNotes = notes.skip(i).take(notesPerMeasure).toList();
      measures.add(MusicalMeasure(
        notes: measureNotes,
        timeSignature: TimeSignature.fourFour,
        keySignature: keySignature,
      ));
    }
    
    return measures;
  }

  MusicalNote _getIntervalNote(MusicalNote baseNote, IntervalType intervalType) {
    int semitones;
    switch (intervalType) {
      case IntervalType.perfect4th:
        semitones = 5;
        break;
      case IntervalType.perfect5th:
        semitones = 7;
        break;
      case IntervalType.octave:
        semitones = 12;
        break;
    }
    
    final noteInfo = _getNoteFromSemitones(baseNote.pitch, baseNote.octave, semitones, KeySignature.cMajor);
    return MusicalNote(
      pitch: noteInfo.pitch,
      octave: noteInfo.octave,
      accidental: noteInfo.accidental,
      duration: baseNote.duration,
    );
  }

  String _getScaleTitle(String key, ScaleType scaleType) {
    final scaleTypeName = switch (scaleType) {
      ScaleType.major => 'Major',
      ScaleType.minor => 'Minor',
      ScaleType.chromatic => 'Chromatic',
    };
    return '$key $scaleTypeName Scale';
  }

  String _getArpeggioTitle(String key, ChordType chordType) {
    final chordTypeName = switch (chordType) {
      ChordType.major => 'Major',
      ChordType.minor => 'Minor',
      ChordType.dominant7 => 'Dominant 7th',
    };
    return '$key $chordTypeName Arpeggio';
  }

  String _getIntervalTitle(IntervalType intervalType) {
    final intervalName = switch (intervalType) {
      IntervalType.perfect4th => 'Perfect 4th',
      IntervalType.perfect5th => 'Perfect 5th',
      IntervalType.octave => 'Octave',
    };
    return '$intervalName Intervals';
  }
}

// Extension to add copyWith method to MusicalNote
extension MusicalNoteExtension on MusicalNote {
  MusicalNote copyWith({
    NotePitch? pitch,
    int? octave,
    Accidental? accidental,
    NoteDuration? duration,
  }) {
    return MusicalNote(
      pitch: pitch ?? this.pitch,
      octave: octave ?? this.octave,
      accidental: accidental ?? this.accidental,
      duration: duration ?? this.duration,
    );
  }
}

// Enums for different types of musical generation

enum ScaleType {
  major,
  minor,
  chromatic,
}

enum ChordType {
  major,
  minor,
  dominant7,
}

enum IntervalType {
  perfect4th,
  perfect5th,
  octave,
}

// Custom exception for notation generation errors
class NotationGenerationException implements Exception {
  final String message;
  
  const NotationGenerationException(this.message);
  
  @override
  String toString() => 'NotationGenerationException: $message';
}