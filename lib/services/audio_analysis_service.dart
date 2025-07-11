import 'dart:io';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';
import 'dart:math' as math;

class AudioAnalysisResult {
  final List<double> pitchData;
  final List<double> timingData;
  final double avgPitch;
  final double pitchStability;
  final double rhythmAccuracy;
  final int totalNotes;
  final Map<String, dynamic> detailedAnalysis;

  AudioAnalysisResult({
    required this.pitchData,
    required this.timingData,
    required this.avgPitch,
    required this.pitchStability,
    required this.rhythmAccuracy,
    required this.totalNotes,
    required this.detailedAnalysis,
  });

  Map<String, dynamic> toJson() {
    return {
      'avgPitch': avgPitch,
      'pitchStability': pitchStability,
      'rhythmAccuracy': rhythmAccuracy,
      'totalNotes': totalNotes,
      'pitchDataPoints': pitchData.length,
      'timingDataPoints': timingData.length,
      'detailedAnalysis': detailedAnalysis,
    };
  }
}

@lazySingleton
class AudioAnalysisService {
  final LoggerService _logger;

  AudioAnalysisService(this._logger);

  /// Analyze recorded audio file for pitch and timing accuracy
  Future<AudioAnalysisResult> analyzeRecording(String filePath) async {
    try {
      _logger.debug('Starting audio analysis for: $filePath');
      
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Audio file not found: $filePath');
      }

      // For now, we'll create a mock analysis since full audio file processing
      // requires more complex audio decoding libraries
      // In a real implementation, you would decode the audio file and process it
      final mockAnalysis = await _createMockAnalysis();
      
      _logger.debug('Audio analysis completed');
      return mockAnalysis;
      
    } catch (e) {
      _logger.error('Audio analysis failed: $e');
      rethrow;
    }
  }

  /// Analyze real-time audio data (for live feedback)
  Future<Map<String, dynamic>> analyzeRealTimeData(List<double> audioData) async {
    try {
      if (audioData.isEmpty) {
        return {'pitch': 0.0, 'amplitude': 0.0};
      }

      // For now, we'll use a simplified approach without pitch detection
      // In a production app, you would integrate a proper pitch detection library
      
      // Calculate amplitude (volume)
      final amplitude = _calculateAmplitude(audioData);
      
      // Mock pitch detection based on amplitude
      final mockPitch = amplitude > 0.1 ? 440.0 + (amplitude * 100) : 0.0;
      
      return {
        'pitch': mockPitch,
        'amplitude': amplitude,
        'confidence': amplitude > 0.1 ? 0.8 : 0.0,
      };
      
    } catch (e) {
      _logger.error('Real-time analysis failed: $e');
      return {'pitch': 0.0, 'amplitude': 0.0, 'confidence': 0.0};
    }
  }

  /// Create mock analysis for development purposes
  Future<AudioAnalysisResult> _createMockAnalysis() async {
    // Simulate processing time
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock pitch data (simulating a C major scale)
    final List<double> mockPitchData = _generateMockPitchData();
    
    // Generate mock timing data
    final List<double> mockTimingData = _generateMockTimingData();
    
    // Calculate mock metrics
    final avgPitch = mockPitchData.fold(0.0, (sum, pitch) => sum + pitch) / mockPitchData.length;
    final pitchStability = _calculatePitchStability(mockPitchData);
    final rhythmAccuracy = _calculateRhythmAccuracy(mockTimingData);
    
    return AudioAnalysisResult(
      pitchData: mockPitchData,
      timingData: mockTimingData,
      avgPitch: avgPitch,
      pitchStability: pitchStability,
      rhythmAccuracy: rhythmAccuracy,
      totalNotes: 8, // C major scale has 8 notes
      detailedAnalysis: {
        'exerciseType': 'C Major Scale',
        'expectedNotes': ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'],
        'detectedNotes': _generateDetectedNotes(),
        'pitchDeviation': _calculatePitchDeviation(mockPitchData),
        'timingDeviation': _calculateTimingDeviation(mockTimingData),
        'recommendations': _generateRecommendations(pitchStability, rhythmAccuracy),
      },
    );
  }

  /// Generate mock pitch data for C major scale
  List<double> _generateMockPitchData() {
    // C major scale frequencies (Hz)
    const cMajorScale = [
      261.63, // C4
      293.66, // D4
      329.63, // E4
      349.23, // F4
      392.00, // G4
      440.00, // A4
      493.88, // B4
      523.25, // C5
    ];
    
    final random = math.Random();
    return cMajorScale.map((freq) {
      // Add some variation to simulate real performance
      final variation = random.nextDouble() * 10 - 5; // ±5 Hz variation
      return freq + variation;
    }).toList();
  }

  /// Generate mock timing data
  List<double> _generateMockTimingData() {
    final random = math.Random();
    return List.generate(8, (index) {
      // Expected timing: 0.5 seconds per note
      final expectedTime = index * 0.5;
      final variation = random.nextDouble() * 0.1 - 0.05; // ±0.05s variation
      return expectedTime + variation;
    });
  }

  /// Calculate pitch stability (lower is better)
  double _calculatePitchStability(List<double> pitchData) {
    if (pitchData.length < 2) return 0.0;
    
    double totalDeviation = 0.0;
    for (int i = 1; i < pitchData.length; i++) {
      totalDeviation += (pitchData[i] - pitchData[i - 1]).abs();
    }
    
    return totalDeviation / (pitchData.length - 1);
  }

  /// Calculate rhythm accuracy (closer to 1.0 is better)
  double _calculateRhythmAccuracy(List<double> timingData) {
    if (timingData.length < 2) return 1.0;
    
    // Calculate expected intervals (should be consistent)
    final expectedInterval = timingData.last / (timingData.length - 1);
    
    double totalDeviation = 0.0;
    for (int i = 1; i < timingData.length; i++) {
      final actualInterval = timingData[i] - timingData[i - 1];
      totalDeviation += (actualInterval - expectedInterval).abs();
    }
    
    final averageDeviation = totalDeviation / (timingData.length - 1);
    return math.max(0.0, 1.0 - (averageDeviation / expectedInterval));
  }

  /// Calculate amplitude from audio data
  double _calculateAmplitude(List<double> audioData) {
    if (audioData.isEmpty) return 0.0;
    
    double sum = 0.0;
    for (final sample in audioData) {
      sum += sample.abs();
    }
    
    return sum / audioData.length;
  }

  /// Generate detected notes for mock analysis
  List<String> _generateDetectedNotes() {
    return ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'];
  }

  /// Calculate pitch deviation metrics
  Map<String, double> _calculatePitchDeviation(List<double> pitchData) {
    if (pitchData.isEmpty) return {'mean': 0.0, 'max': 0.0, 'std': 0.0};
    
    final mean = pitchData.fold(0.0, (sum, pitch) => sum + pitch) / pitchData.length;
    final max = pitchData.fold(0.0, (max, pitch) => math.max(max, pitch));
    
    // Calculate standard deviation
    final variance = pitchData.fold(0.0, (sum, pitch) => sum + math.pow(pitch - mean, 2)) / pitchData.length;
    final std = math.sqrt(variance);
    
    return {
      'mean': mean,
      'max': max,
      'std': std,
    };
  }

  /// Calculate timing deviation metrics
  Map<String, double> _calculateTimingDeviation(List<double> timingData) {
    if (timingData.length < 2) return {'mean': 0.0, 'max': 0.0, 'std': 0.0};
    
    final intervals = <double>[];
    for (int i = 1; i < timingData.length; i++) {
      intervals.add(timingData[i] - timingData[i - 1]);
    }
    
    final mean = intervals.fold(0.0, (sum, interval) => sum + interval) / intervals.length;
    final max = intervals.fold(0.0, (max, interval) => math.max(max, interval));
    
    final variance = intervals.fold(0.0, (sum, interval) => sum + math.pow(interval - mean, 2)) / intervals.length;
    final std = math.sqrt(variance);
    
    return {
      'mean': mean,
      'max': max,
      'std': std,
    };
  }

  /// Generate practice recommendations based on analysis
  List<String> _generateRecommendations(double pitchStability, double rhythmAccuracy) {
    final recommendations = <String>[];
    
    if (pitchStability > 20) {
      recommendations.add('Focus on pitch accuracy - practice scales slowly');
    }
    
    if (rhythmAccuracy < 0.8) {
      recommendations.add('Work on timing - practice with a metronome');
    }
    
    if (pitchStability <= 10 && rhythmAccuracy >= 0.9) {
      recommendations.add('Excellent performance! Try more challenging exercises');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Good performance! Continue practicing regularly');
    }
    
    return recommendations;
  }

  /// Convert frequency to musical note
  String frequencyToNote(double frequency) {
    if (frequency <= 0) return 'N/A';
    
    // Note frequencies for 4th octave
    const noteFrequencies = {
      'C4': 261.63,
      'C#4': 277.18,
      'D4': 293.66,
      'D#4': 311.13,
      'E4': 329.63,
      'F4': 349.23,
      'F#4': 369.99,
      'G4': 392.00,
      'G#4': 415.30,
      'A4': 440.00,
      'A#4': 466.16,
      'B4': 493.88,
      'C5': 523.25,
    };
    
    String closestNote = 'N/A';
    double minDifference = double.infinity;
    
    for (final entry in noteFrequencies.entries) {
      final difference = (frequency - entry.value).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNote = entry.key;
      }
    }
    
    return closestNote;
  }
}