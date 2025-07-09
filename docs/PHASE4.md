## Phase 4: Notation + Audio Synthesis

**Core Requirements:**
- Render generated exercises as sheet music notation
- Synthesize reference audio from exercise data
- Playback controls with visual synchronization
- Convert LLM-generated exercise data to musical notation

**Technical Implementation:**

### Dependencies
```yaml
dependencies:
  flutter_midi: ^1.0.0
  audioplayers: ^5.2.1
  flutter_svg: ^2.0.9
  path_provider: ^2.1.2
  flutter_sound: ^9.2.13  # Already included from Phase 2
```

### Domain Models for Notation
```dart
class MusicalNote {
  final String noteName;  // "C4", "D#4", etc.
  final Duration duration; // quarter, eighth, etc.
  final int midiNumber;
  final double frequency;
  
  MusicalNote({
    required this.noteName,
    required this.duration,
    required this.midiNumber,
    required this.frequency,
  });
  
  factory MusicalNote.fromString(String noteString) {
    // Parse "C4" -> note name and octave
    final noteMap = {
      'C': 60, 'C#': 61, 'D': 62, 'D#': 63, 'E': 64, 'F': 65,
      'F#': 66, 'G': 67, 'G#': 68, 'A': 69, 'A#': 70, 'B': 71
    };
    
    final note = noteString.substring(0, noteString.length - 1);
    final octave = int.parse(noteString.substring(noteString.length - 1));
    final midiNumber = noteMap[note]! + (octave - 4) * 12;
    
    return MusicalNote(
      noteName: noteString,
      duration: const Duration(milliseconds: 500), // Default quarter note
      midiNumber: midiNumber,
      frequency: 440 * pow(2, (midiNumber - 69) / 12),
    );
  }
}

class Measure {
  final List<MusicalNote> notes;
  final TimeSignature timeSignature;
  final int measureNumber;
  
  Measure({
    required this.notes,
    required this.timeSignature,
    required this.measureNumber,
  });
}

class TimeSignature {
  final int numerator;
  final int denominator;
  
  TimeSignature(this.numerator, this.denominator);
  
  Duration get beatDuration => Duration(
    milliseconds: (60000 / (4 * denominator / 4)).round()
  );
}

class NotationData {
  final List<Measure> measures;
  final String keySignature;
  final TimeSignature timeSignature;
  final int bpm;
  
  NotationData({
    required this.measures,
    required this.keySignature,
    required this.timeSignature,
    required this.bpm,
  });
}
```

### Exercise to Notation Converter
```dart
class ExerciseConverter {
  NotationData convertExerciseToNotation(Exercise exercise) {
    final notes = exercise.notes.map((noteString) => 
      MusicalNote.fromString(noteString)
    ).toList();
    
    // Group notes into measures based on time signature
    final timeSignature = TimeSignature(4, 4); // Default 4/4
    final measures = _groupNotesIntoMeasures(notes, timeSignature);
    
    return NotationData(
      measures: measures,
      keySignature: exercise.keySignature,
      timeSignature: timeSignature,
      bpm: exercise.bpm,
    );
  }
  
  List<Measure> _groupNotesIntoMeasures(
    List<MusicalNote> notes, 
    TimeSignature timeSignature
  ) {
    final measures = <Measure>[];
    final notesPerMeasure = timeSignature.numerator;
    
    for (int i = 0; i < notes.length; i += notesPerMeasure) {
      final measureNotes = notes.skip(i).take(notesPerMeasure).toList();
      measures.add(Measure(
        notes: measureNotes,
        timeSignature: timeSignature,
        measureNumber: (i / notesPerMeasure).floor() + 1,
      ));
    }
    
    return measures;
  }
}
```

### Notation Renderer (SVG-based)
```dart
import 'package:flutter_svg/flutter_svg.dart';

class NotationRenderer extends StatelessWidget {
  final NotationData notation;
  final int? highlightedNoteIndex;
  
  const NotationRenderer({
    Key? key,
    required this.notation,
    this.highlightedNoteIndex,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: CustomPaint(
        painter: StaffPainter(notation, highlightedNoteIndex),
        child: Container(),
      ),
    );
  }
}

class StaffPainter extends CustomPainter {
  final NotationData notation;
  final int? highlightedNoteIndex;
  
  StaffPainter(this.notation, this.highlightedNoteIndex);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Draw staff lines (5 lines)
    final staffHeight = size.height * 0.6;
    final staffTop = size.height * 0.2;
    final lineSpacing = staffHeight / 4;
    
    for (int i = 0; i < 5; i++) {
      final y = staffTop + (i * lineSpacing);
      canvas.drawLine(
        Offset(20, y),
        Offset(size.width - 20, y),
        paint,
      );
    }
    
    // Draw treble clef
    _drawTrebleClef(canvas, paint, staffTop, lineSpacing);
    
    // Draw key signature
    _drawKeySignature(canvas, paint, staffTop, lineSpacing);
    
    // Draw notes
    _drawNotes(canvas, paint, size, staffTop, lineSpacing);
  }
  
  void _drawTrebleClef(Canvas canvas, Paint paint, double staffTop, double lineSpacing) {
    // Simplified treble clef - in production, use SVG or custom path
    final textPainter = TextPainter(
      text: TextSpan(
        text: '𝄞',
        style: TextStyle(
          fontSize: lineSpacing * 3,
          color: Colors.black,
          fontFamily: 'MusicFont', // Would need music font
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(25, staffTop - lineSpacing * 0.5));
  }
  
  void _drawKeySignature(Canvas canvas, Paint paint, double staffTop, double lineSpacing) {
    // Draw sharps/flats based on key signature
    final keySignatureMap = {
      'G': 1, 'D': 2, 'A': 3, 'E': 4, 'B': 5, 'F#': 6, 'C#': 7,
      'F': -1, 'Bb': -2, 'Eb': -3, 'Ab': -4, 'Db': -5, 'Gb': -6, 'Cb': -7,
    };
    
    final accidentals = keySignatureMap[notation.keySignature] ?? 0;
    double xOffset = 60;
    
    // Draw sharps or flats
    for (int i = 0; i < accidentals.abs(); i++) {
      final symbol = accidentals > 0 ? '♯' : '♭';
      final textPainter = TextPainter(
        text: TextSpan(
          text: symbol,
          style: TextStyle(fontSize: lineSpacing * 1.2, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(xOffset, staffTop + lineSpacing));
      xOffset += 15;
    }
  }
  
  void _drawNotes(Canvas canvas, Paint paint, Size size, double staffTop, double lineSpacing) {
    double xOffset = 100;
    final noteSpacing = (size.width - 140) / notation.measures.expand((m) => m.notes).length;
    
    int noteIndex = 0;
    for (final measure in notation.measures) {
      for (final note in measure.notes) {
        final isHighlighted = noteIndex == highlightedNoteIndex;
        
        // Calculate note position on staff
        final notePosition = _getNoteStaffPosition(note.noteName, staffTop, lineSpacing);
        
        // Draw note head
        final notePaint = Paint()
          ..color = isHighlighted ? Colors.red : Colors.black
          ..style = PaintingStyle.fill;
        
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(xOffset, notePosition),
            width: 8,
            height: 6,
          ),
          notePaint,
        );
        
        // Draw stem
        canvas.drawLine(
          Offset(xOffset + 4, notePosition),
          Offset(xOffset + 4, notePosition - lineSpacing * 2),
          notePaint..style = PaintingStyle.stroke..strokeWidth = 1.5,
        );
        
        xOffset += noteSpacing;
        noteIndex++;
      }
    }
  }
  
  double _getNoteStaffPosition(String noteName, double staffTop, double lineSpacing) {
    // Map note names to staff positions
    final notePositions = {
      'C4': staffTop + lineSpacing * 5, // Below staff
      'D4': staffTop + lineSpacing * 4.5,
      'E4': staffTop + lineSpacing * 4,
      'F4': staffTop + lineSpacing * 3.5,
      'G4': staffTop + lineSpacing * 3,
      'A4': staffTop + lineSpacing * 2.5,
      'B4': staffTop + lineSpacing * 2,
      'C5': staffTop + lineSpacing * 1.5,
      // Add more as needed
    };
    
    return notePositions[noteName] ?? staffTop + lineSpacing * 3;
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
```

### Audio Synthesis Service
```dart
import 'package:flutter_midi/flutter_midi.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

class AudioSynthesisService {
  final FlutterMidi _flutterMidi = FlutterMidi();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (!_isInitialized) {
      // Load a basic soundfont for synthesis
      await _flutterMidi.prepare(sf2: null); // Use default soundfont
      _isInitialized = true;
    }
  }
  
  Future<String> synthesizeExercise(Exercise exercise, NotationData notation) async {
    await initialize();
    
    // Generate MIDI sequence
    final midiData = await _generateMidiSequence(exercise, notation);
    
    // Convert to audio file
    final audioPath = await _renderMidiToAudio(midiData, exercise.bpm);
    
    return audioPath;
  }
  
  Future<Uint8List> _generateMidiSequence(Exercise exercise, NotationData notation) async {
    // Create MIDI file programmatically
    final notes = exercise.notes.map((noteString) => 
      MusicalNote.fromString(noteString)
    ).toList();
    
    // Calculate timing based on BPM and rhythm
    final beatDuration = (60000 / exercise.bpm).round(); // ms per beat
    final noteDuration = _getRhythmDuration(exercise.rhythm, beatDuration);
    
    // Generate MIDI events
    final midiEvents = <Map<String, dynamic>>[];
    int currentTime = 0;
    
    for (final note in notes) {
      // Note on event
      midiEvents.add({
        'type': 'noteOn',
        'time': currentTime,
        'note': note.midiNumber,
        'velocity': 80,
      });
      
      // Note off event
      midiEvents.add({
        'type': 'noteOff',
        'time': currentTime + noteDuration,
        'note': note.midiNumber,
        'velocity': 0,
      });
      
      currentTime += noteDuration;
    }
    
    return _encodeMidiFile(midiEvents);
  }
  
  int _getRhythmDuration(String rhythm, int beatDuration) {
    switch (rhythm) {
      case 'quarter':
        return beatDuration;
      case 'eighth':
        return beatDuration ~/ 2;
      case 'dotted_quarter':
        return (beatDuration * 1.5).round();
      case 'mixed':
        return beatDuration; // Default to quarter notes
      default:
        return beatDuration;
    }
  }
  
  Future<String> _renderMidiToAudio(Uint8List midiData, int bpm) async {
    // This would typically involve:
    // 1. Using flutter_midi to play MIDI through soundfont
    // 2. Recording the output to audio file
    // 3. Returning the file path
    
    // For MVP, we can use a simpler approach:
    final directory = await getTemporaryDirectory();
    final audioPath = '${directory.path}/exercise_${DateTime.now().millisecondsSinceEpoch}.wav';
    
    // Simplified: Use flutter_midi to generate audio
    await _flutterMidi.prepare(sf2: null);
    
    // In a real implementation, you'd record the MIDI playback
    // For now, return a placeholder path
    return audioPath;
  }
  
  Uint8List _encodeMidiFile(List<Map<String, dynamic>> events) {
    // Simplified MIDI file encoding
    // In production, use a proper MIDI library like 'midi_dart'
    final buffer = BytesBuilder();
    
    // MIDI header
    buffer.add([0x4D, 0x54, 0x68, 0x64]); // "MThd"
    buffer.add([0x00, 0x00, 0x00, 0x06]); // Header length
    buffer.add([0x00, 0x00]); // Format type 0
    buffer.add([0x00, 0x01]); // Number of tracks
    buffer.add([0x01, 0xE0]); // Ticks per quarter note
    
    // Track chunk would be added here with proper MIDI encoding
    // For MVP, return minimal valid MIDI
    
    return buffer.toBytes();
  }
}
```

### Playback Controller with Visual Sync
```dart
class PlaybackController extends StatefulWidget {
  final Exercise exercise;
  final NotationData notation;
  
  const PlaybackController({
    Key? key,
    required this.exercise,
    required this.notation,
  }) : super(key: key);
  
  @override
  _PlaybackControllerState createState() => _PlaybackControllerState();
}

class _PlaybackControllerState extends State<PlaybackController> {
  final AudioSynthesisService _synthesisService = AudioSynthesisService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isPlaying = false;
  bool _isLoading = false;
  int _currentNoteIndex = 0;
  String? _audioPath;
  Timer? _highlightTimer;
  
  @override
  void initState() {
    super.initState();
    _generateAudio();
  }
  
  Future<void> _generateAudio() async {
    setState(() => _isLoading = true);
    
    try {
      _audioPath = await _synthesisService.synthesizeExercise(
        widget.exercise, 
        widget.notation
      );
    } catch (e) {
      print('Error generating audio: $e');
    }
    
    setState(() => _isLoading = false);
  }
  
  Future<void> _togglePlayback() async {
    if (_audioPath == null) return;
    
    if (_isPlaying) {
      await _audioPlayer.stop();
      _highlightTimer?.cancel();
      setState(() {
        _isPlaying = false;
        _currentNoteIndex = 0;
      });
    } else {
      await _audioPlayer.play(DeviceFileSource(_audioPath!));
      _startNoteHighlighting();
      setState(() => _isPlaying = true);
    }
  }
  
  void _startNoteHighlighting() {
    final totalNotes = widget.notation.measures
        .expand((measure) => measure.notes)
        .length;
    
    final noteDuration = _calculateNoteDuration();
    
    _highlightTimer = Timer.periodic(Duration(milliseconds: noteDuration), (timer) {
      if (_currentNoteIndex < totalNotes - 1) {
        setState(() => _currentNoteIndex++);
      } else {
        timer.cancel();
        setState(() {
          _isPlaying = false;
          _currentNoteIndex = 0;
        });
      }
    });
  }
  
  int _calculateNoteDuration() {
    final beatDuration = 60000 ~/ widget.exercise.bpm;
    switch (widget.exercise.rhythm) {
      case 'quarter':
        return beatDuration;
      case 'eighth':
        return beatDuration ~/ 2;
      default:
        return beatDuration;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotationRenderer(
          notation: widget.notation,
          highlightedNoteIndex: _currentNoteIndex,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              IconButton(
                onPressed: _togglePlayback,
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                iconSize: 48,
              ),
          ],
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _highlightTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
```

**Key Dependencies:**
- `flutter_midi: ^1.0.0`
- `audioplayers: ^5.2.1`
- `flutter_svg: ^2.0.9`
- `path_provider: ^2.1.2`

**Deliverable:** Complete exercise display with visual notation and synchronized audio playback, ready for user practice sessions.
