## Phase 2: Audio Recording/Analysis

**Core Requirements:**
- Record audio from device microphone
- Extract pitch data (fundamental frequency detection)
- Analyze timing patterns (onset detection, tempo)
- Structure analysis results for LLM consumption

**Technical Implementation:**

### Audio Recording Service
```dart
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordingService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  
  Future<void> initialize() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }
  
  Future<String?> startRecording() async {
    if (!_isRecorderInitialized) return null;
    
    final path = '${Directory.systemTemp.path}/assessment_recording.wav';
    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
      sampleRate: 44100,
    );
    return path;
  }
  
  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
  }
}
```

### Domain Models
```dart
class AudioSample {
  final String filePath;
  final Duration duration;
  final int sampleRate;
  final DateTime recordedAt;
  
  AudioSample({
    required this.filePath,
    required this.duration,
    required this.sampleRate,
    required this.recordedAt,
  });
}

class PitchAnalysis {
  final List<DetectedNote> detectedNotes;
  final double averageAccuracy;
  final List<PitchDeviation> deviations;
  
  PitchAnalysis({
    required this.detectedNotes,
    required this.averageAccuracy,
    required this.deviations,
  });
}

class DetectedNote {
  final String noteName;
  final double frequency;
  final double confidence;
  final double deviationCents;
  final Duration timestamp;
  
  DetectedNote({
    required this.noteName,
    required this.frequency,
    required this.confidence,
    required this.deviationCents,
    required this.timestamp,
  });
}

class TimingAnalysis {
  final double detectedTempo;
  final List<OnsetTime> onsets;
  final double rhythmAccuracy;
  final List<TimingDeviation> deviations;
  
  TimingAnalysis({
    required this.detectedTempo,
    required this.onsets,
    required this.rhythmAccuracy,
    required this.deviations,
  });
}
```

### Audio Analysis Service
```dart
import 'package:pitch_detector_dart/pitch_detector_dart.dart';
import 'dart:typed_data';

class AudioAnalysisService {
  final PitchDetector _pitchDetector = PitchDetector(44100, 2048);
  
  Future<PitchAnalysis> analyzePitch(String audioFilePath) async {
    // Load audio file and convert to samples
    final audioData = await _loadAudioFile(audioFilePath);
    final detectedNotes = <DetectedNote>[];
    
    // Process audio in chunks for pitch detection
    for (int i = 0; i < audioData.length - 2048; i += 1024) {
      final chunk = audioData.sublist(i, i + 2048);
      final pitchResult = _pitchDetector.getPitch(chunk);
      
      if (pitchResult.pitched) {
        final note = _frequencyToNote(pitchResult.pitch);
        detectedNotes.add(DetectedNote(
          noteName: note.name,
          frequency: pitchResult.pitch,
          confidence: pitchResult.probability,
          deviationCents: _calculateDeviationCents(pitchResult.pitch, note.frequency),
          timestamp: Duration(milliseconds: (i / 44.1).round()),
        ));
      }
    }
    
    return PitchAnalysis(
      detectedNotes: detectedNotes,
      averageAccuracy: _calculateAverageAccuracy(detectedNotes),
      deviations: _identifyPitchDeviations(detectedNotes),
    );
  }
  
  Future<TimingAnalysis> analyzeTiming(String audioFilePath) async {
    // Implement onset detection using spectral flux or energy-based methods
    final audioData = await _loadAudioFile(audioFilePath);
    final onsets = await _detectOnsets(audioData);
    final tempo = _estimateTempo(onsets);
    
    return TimingAnalysis(
      detectedTempo: tempo,
      onsets: onsets,
      rhythmAccuracy: _calculateRhythmAccuracy(onsets, tempo),
      deviations: _identifyTimingDeviations(onsets, tempo),
    );
  }
}
```

### Assessment Workflow
```dart
class AssessmentService {
  final AudioRecordingService _recording = AudioRecordingService();
  final AudioAnalysisService _analysis = AudioAnalysisService();
  
  Future<AssessmentResult> conductAssessment() async {
    await _recording.initialize();
    
    // Guided exercise 1: C Major Scale
    final scale = await _recordExercise("Play C Major Scale (one octave, quarter notes)");
    final scaleAnalysis = await _analyzeExercise(scale);
    
    // Guided exercise 2: C Major Arpeggio
    final arpeggio = await _recordExercise("Play C Major Arpeggio (one octave)");
    final arpeggioAnalysis = await _analyzeExercise(arpeggio);
    
    // Guided exercise 3: Perfect Fifth Intervals
    final intervals = await _recordExercise("Play Perfect Fifths: C-G, D-A, E-B");
    final intervalAnalysis = await _analyzeExercise(intervals);
    
    return AssessmentResult(
      scaleAnalysis: scaleAnalysis,
      arpeggioAnalysis: arpeggioAnalysis,
      intervalAnalysis: intervalAnalysis,
      overallAccuracy: _calculateOverallScore([scaleAnalysis, arpeggioAnalysis, intervalAnalysis]),
    );
  }
}
```

**Key Flutter Packages:**
- `flutter_sound: ^9.2.13`
- `permission_handler: ^10.4.3`
- `pitch_detector_dart: ^2.0.0`
- `path_provider: ^2.0.15`

**Deliverable:** Can record 3 guided exercises and output structured pitch/timing analysis data ready for LLM consumption.
