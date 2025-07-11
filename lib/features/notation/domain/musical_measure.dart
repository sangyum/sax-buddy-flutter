import 'musical_note.dart';

/// Represents a musical measure containing notes with time and key signatures
class MusicalMeasure {
  final List<MusicalNote> notes;
  final TimeSignature timeSignature;
  final KeySignature keySignature;

  const MusicalMeasure({
    required this.notes,
    required this.timeSignature,
    this.keySignature = KeySignature.cMajor,
  });

  factory MusicalMeasure.fromJson(Map<String, dynamic> json) {
    return MusicalMeasure(
      notes: (json['notes'] as List? ?? [])
          .map((noteJson) => MusicalNote.fromJson(noteJson as Map<String, dynamic>))
          .toList(),
      timeSignature: TimeSignature.values.byName(json['timeSignature'] as String),
      keySignature: KeySignature.values.byName(json['keySignature'] as String? ?? 'cMajor'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes.map((note) => note.toJson()).toList(),
      'timeSignature': timeSignature.name,
      'keySignature': keySignature.name,
    };
  }

  @override
  String toString() {
    return 'MusicalMeasure(notes: ${notes.length}, timeSignature: ${timeSignature.name}, keySignature: ${keySignature.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MusicalMeasure &&
        _listEquals(other.notes, notes) &&
        other.timeSignature == timeSignature &&
        other.keySignature == keySignature;
  }

  @override
  int get hashCode => Object.hash(notes, timeSignature, keySignature);

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Common time signatures for musical measures
enum TimeSignature {
  fourFour,   // 4/4
  threeFour,  // 3/4
  twoFour,    // 2/4
  sixEight,   // 6/8
}

/// Key signatures commonly used in saxophone music
enum KeySignature {
  cMajor,     // No sharps or flats
  gMajor,     // 1 sharp (F#)
  dMajor,     // 2 sharps (F#, C#)
  aMajor,     // 3 sharps (F#, C#, G#)
  eMajor,     // 4 sharps (F#, C#, G#, D#)
  fMajor,     // 1 flat (Bb)
  bFlatMajor, // 2 flats (Bb, Eb)
  eFlatMajor, // 3 flats (Bb, Eb, Ab)
}