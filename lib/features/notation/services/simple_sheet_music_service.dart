import 'package:injectable/injectable.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart';

/// Service for converting JSON notation data to simple_sheet_music objects
@lazySingleton
class SimpleSheetMusicService {
  /// Convert JSON notation data to SimpleSheetMusic widget data
  List<Measure> convertJsonToMeasures(Map<String, dynamic> notationJson) {
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
      throw SimpleSheetMusicException('Failed to convert JSON to measures: $e');
    }
  }
  
  /// Parse a single note from JSON data
  Note _parseNote(Map<String, dynamic> noteData) {
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
  Pitch _parsePitch(String pitchString) {
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
        throw SimpleSheetMusicException('Unsupported pitch: $pitchString');
    }
  }
  
  /// Parse duration from string
  NoteDuration _parseDuration(String durationString) {
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
        throw SimpleSheetMusicException('Unsupported duration: $durationString');
    }
  }
  
  /// Parse accidental from string
  Accidental? _parseAccidental(String? accidentalString) {
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
  KeySignatureType _parseKeySignature(String keySignatureString) {
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
  
  /// Generate a simple fallback etude with 4 measures (C major scale)
  Map<String, dynamic> generateFallbackEtude({
    String keySignature = 'cMajor',
    int tempo = 120,
  }) {
    return {
      'clef': 'treble',
      'keySignature': keySignature,
      'tempo': tempo,
      'measures': [
        {
          'notes': [
            {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
          ]
        },
        {
          'notes': [
            {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'c5', 'duration': 'quarter', 'accidental': null},
          ]
        },
        {
          'notes': [
            {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
          ]
        },
        {
          'notes': [
            {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
            {'pitch': 'c4', 'duration': 'half', 'accidental': null},
          ]
        },
      ]
    };
  }
}

/// Custom exception for simple sheet music conversion errors
class SimpleSheetMusicException implements Exception {
  final String message;
  
  const SimpleSheetMusicException(this.message);
  
  @override
  String toString() => 'SimpleSheetMusicException: $message';
}