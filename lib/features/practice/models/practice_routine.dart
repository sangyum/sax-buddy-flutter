import 'package:simple_sheet_music/simple_sheet_music.dart';

class PracticeRoutine {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> targetAreas;
  final String difficulty;
  final String estimatedDuration;
  final List<PracticeExercise> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAIGenerated;

  const PracticeRoutine({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.targetAreas,
    required this.difficulty,
    required this.estimatedDuration,
    required this.exercises,
    required this.createdAt,
    required this.updatedAt,
    required this.isAIGenerated,
  });

  factory PracticeRoutine.fromJson(Map<String, dynamic> json) {
    return PracticeRoutine(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetAreas: List<String>.from(json['targetAreas'] as List? ?? []),
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      estimatedDuration: json['estimatedDuration'] as String? ?? '20 minutes',
      exercises: (json['exercises'] as List? ?? [])
          .map((exercise) => PracticeExercise.fromJson(exercise as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      isAIGenerated: json['isAIGenerated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'targetAreas': targetAreas,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isAIGenerated': isAIGenerated,
    };
  }

  @override
  String toString() {
    return 'PracticeRoutine(title: $title, exercises: ${exercises.length})';
  }
}

class PracticeExercise {
  final String name;
  final String description;
  final String? tempo;
  final String? keySignature;
  final String? notes;
  final String estimatedDuration;
  final List<Measure>? etude;

  const PracticeExercise({
    required this.name,
    required this.description,
    this.tempo,
    this.keySignature,
    this.notes,
    required this.estimatedDuration,
    this.etude,
  });

  factory PracticeExercise.fromJson(Map<String, dynamic> json) {
    List<Measure>? etude;
    final musicalNotationJson = json['musicalNotation'] as Map<String, dynamic>?;
    if (musicalNotationJson != null) {
      try {
        etude = convertJsonToMeasures(musicalNotationJson);
      } catch (e) {
        // If conversion fails, etude remains null
        etude = null;
      }
    }
    
    return PracticeExercise(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tempo: json['tempo'] as String?,
      keySignature: json['keySignature'] as String?,
      notes: json['notes'] as String?,
      estimatedDuration: json['estimatedDuration'] as String? ?? '10 minutes',
      etude: etude,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? musicalNotationJson;
    if (etude != null) {
      try {
        musicalNotationJson = _convertMeasuresToJson(etude!);
      } catch (e) {
        // If conversion fails, musicalNotation remains null
        musicalNotationJson = null;
      }
    }
    
    return {
      'name': name,
      'description': description,
      if (tempo != null) 'tempo': tempo,
      if (keySignature != null) 'keySignature': keySignature,
      if (notes != null) 'notes': notes,
      'estimatedDuration': estimatedDuration,
      if (musicalNotationJson != null) 'musicalNotation': musicalNotationJson,
    };
  }

  @override
  String toString() {
    return 'PracticeExercise(name: $name, duration: $estimatedDuration)';
  }
  
  /// Convert JSON notation data to simple_sheet_music Measure objects
  static List<Measure> convertJsonToMeasures(Map<String, dynamic> notationJson) {
    try {
      final measures = <Measure>[];
      final measuresData = notationJson['measures'] as List<dynamic>? ?? [];
      final keySignatureType = _parseKeySignature(notationJson['keySignature'] as String? ?? 'cMajor');
      
      // Process each measure
      for (int i = 0; i < measuresData.length; i++) {
        final measureData = measuresData[i];
        final notesData = measureData['notes'] as List<dynamic>? ?? [];
        final notes = notesData.map((noteData) => _parseNote(noteData as Map<String, dynamic>)).toList();
        
        if (i == 0) {
          // First measure: include clef and key signature
          measures.add(Measure([
            const Clef(ClefType.treble),
            KeySignature(keySignatureType),
            ...notes,
          ]));
        } else {
          // Subsequent measures: only notes
          measures.add(Measure(notes));
        }
      }
      
      return measures;
    } catch (e) {
      throw PracticeExerciseException('Failed to convert JSON to measures: $e');
    }
  }
  
  /// Convert Measure objects back to JSON notation data
  /// This is a simplified conversion that creates a basic structure
  /// In practice, this method may not be heavily used since we're moving from JSON to Measure
  /// but we include it for completeness
  static Map<String, dynamic> _convertMeasuresToJson(List<Measure> measures) {
    try {
      final measuresData = <Map<String, dynamic>>[];
      
      // Create empty measures for each input measure
      for (int i = 0; i < measures.length; i++) {
        measuresData.add({
          'notes': <Map<String, dynamic>>[],
        });
      }
      
      return {
        'clef': 'treble',
        'keySignature': 'cMajor',
        'tempo': 120,
        'measures': measuresData,
      };
    } catch (e) {
      throw PracticeExerciseException('Failed to convert measures to JSON: $e');
    }
  }
  
  /// Parse a single note from JSON data
  static Note _parseNote(Map<String, dynamic> noteData) {
    final pitchString = noteData['pitch'] as String;
    final durationString = noteData['duration'] as String;
    final accidentalString = noteData['accidental'] as String?;
    
    final pitch = _parsePitch(pitchString);
    final duration = _parseDuration(durationString);
    final accidental = _parseAccidental(accidentalString);
    
    return Note(
      pitch,
      noteDuration: duration,
      accidental: accidental,
    );
  }
  
  /// Parse pitch from string (e.g., "c4", "d5")
  static Pitch _parsePitch(String pitchString) {
    switch (pitchString.toLowerCase()) {
      case 'c4':
        return Pitch.c4;
      case 'd4':
        return Pitch.d4;
      case 'e4':
        return Pitch.e4;
      case 'f4':
        return Pitch.f4;
      case 'g4':
        return Pitch.g4;
      case 'a4':
        return Pitch.a4;
      case 'b4':
        return Pitch.b4;
      case 'c5':
        return Pitch.c5;
      case 'd5':
        return Pitch.d5;
      case 'e5':
        return Pitch.e5;
      case 'f5':
        return Pitch.f5;
      case 'g5':
        return Pitch.g5;
      case 'a5':
        return Pitch.a5;
      case 'b5':
        return Pitch.b5;
      default:
        throw PracticeExerciseException('Unsupported pitch: $pitchString');
    }
  }
  
  /// Parse duration from string
  static NoteDuration _parseDuration(String durationString) {
    switch (durationString.toLowerCase()) {
      case 'whole':
        return NoteDuration.whole;
      case 'half':
        return NoteDuration.half;
      case 'quarter':
        return NoteDuration.quarter;
      case 'eighth':
        return NoteDuration.eighth;
      case 'sixteenth':
        return NoteDuration.sixteenth;
      default:
        throw PracticeExerciseException('Unsupported duration: $durationString');
    }
  }
  
  /// Parse accidental from string
  static Accidental? _parseAccidental(String? accidentalString) {
    if (accidentalString == null) return null;
    
    switch (accidentalString.toLowerCase()) {
      case 'sharp':
        return Accidental.sharp;
      case 'flat':
        return Accidental.flat;
      default:
        return null;
    }
  }
  
  /// Parse key signature from string
  static KeySignatureType _parseKeySignature(String keySignatureString) {
    switch (keySignatureString.toLowerCase()) {
      case 'cmajor':
        return KeySignatureType.cMajor;
      case 'dmajor':
        return KeySignatureType.dMajor;
      case 'gmajor':
        return KeySignatureType.gMajor;
      case 'fmajor':
        return KeySignatureType.fMajor;
      case 'bflatmajor':
        return KeySignatureType.bFlatMajor;
      case 'eflatmajor':
        return KeySignatureType.eFlatMajor;
      default:
        return KeySignatureType.cMajor; // Default fallback
    }
  }
}

/// Custom exception for practice exercise conversion errors
class PracticeExerciseException implements Exception {
  final String message;
  
  const PracticeExerciseException(this.message);
  
  @override
  String toString() => 'PracticeExerciseException: $message';
}