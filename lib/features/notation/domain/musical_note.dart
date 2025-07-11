/// Represents a musical note with pitch, octave, accidental, and duration
class MusicalNote {
  final NotePitch pitch;
  final int octave;
  final Accidental accidental;
  final NoteDuration duration;

  const MusicalNote({
    required this.pitch,
    required this.octave,
    this.accidental = Accidental.natural,
    required this.duration,
  });

  factory MusicalNote.fromJson(Map<String, dynamic> json) {
    return MusicalNote(
      pitch: NotePitch.values.byName(json['pitch'] as String),
      octave: json['octave'] as int,
      accidental: Accidental.values.byName(json['accidental'] as String? ?? 'natural'),
      duration: NoteDuration.values.byName(json['duration'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pitch': pitch.name,
      'octave': octave,
      'accidental': accidental.name,
      'duration': duration.name,
    };
  }

  @override
  String toString() {
    final accidentalSymbol = accidental == Accidental.sharp
        ? '#'
        : accidental == Accidental.flat
            ? 'b'
            : '';
    return 'MusicalNote(${pitch.name.toUpperCase()}$accidentalSymbol$octave, ${duration.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MusicalNote &&
        other.pitch == pitch &&
        other.octave == octave &&
        other.accidental == accidental &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(pitch, octave, accidental, duration);
}

/// Musical pitch classes (natural notes)
enum NotePitch {
  c,
  d,
  e,
  f,
  g,
  a,
  b,
}

/// Accidentals for musical notes
enum Accidental {
  natural,
  sharp,
  flat,
}

/// Standard note durations
enum NoteDuration {
  whole,
  half,
  quarter,
  eighth,
  sixteenth,
}