import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/services/audio_analysis_service.dart';
import 'dart:io';

void main() {
  group('AudioAnalysisService', () {
    late AudioAnalysisService service;

    setUp(() {
      service = AudioAnalysisService();
    });

    group('AudioAnalysisResult', () {
      test('should create result with valid data', () {
        final result = AudioAnalysisResult(
          pitchData: [440.0, 441.0, 442.0],
          timingData: [0.0, 0.5, 1.0],
          avgPitch: 441.0,
          pitchStability: 1.0,
          rhythmAccuracy: 0.9,
          totalNotes: 3,
          detailedAnalysis: {'test': 'data'},
        );

        expect(result.pitchData.length, equals(3));
        expect(result.timingData.length, equals(3));
        expect(result.avgPitch, equals(441.0));
        expect(result.pitchStability, equals(1.0));
        expect(result.rhythmAccuracy, equals(0.9));
        expect(result.totalNotes, equals(3));
        expect(result.detailedAnalysis['test'], equals('data'));
      });

      test('should convert to JSON correctly', () {
        final result = AudioAnalysisResult(
          pitchData: [440.0, 441.0],
          timingData: [0.0, 0.5],
          avgPitch: 440.5,
          pitchStability: 0.5,
          rhythmAccuracy: 0.8,
          totalNotes: 2,
          detailedAnalysis: {'key': 'value'},
        );

        final json = result.toJson();
        expect(json['avgPitch'], equals(440.5));
        expect(json['pitchStability'], equals(0.5));
        expect(json['rhythmAccuracy'], equals(0.8));
        expect(json['totalNotes'], equals(2));
        expect(json['pitchDataPoints'], equals(2));
        expect(json['timingDataPoints'], equals(2));
        expect(json['detailedAnalysis'], isA<Map<String, dynamic>>());
      });
    });

    group('analyzeRecording', () {
      test('should handle non-existent file', () async {
        const fakePath = '/fake/path/recording.aac';
        
        expect(
          () async => await service.analyzeRecording(fakePath),
          throwsA(isA<Exception>()),
        );
      });

      test('should return mock analysis for development', () async {
        // Create a temporary file for testing
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/test_recording.aac');
        await tempFile.writeAsString('fake audio data');

        try {
          final result = await service.analyzeRecording(tempFile.path);
          
          expect(result, isA<AudioAnalysisResult>());
          expect(result.pitchData, isNotEmpty);
          expect(result.timingData, isNotEmpty);
          expect(result.avgPitch, greaterThan(0));
          expect(result.pitchStability, greaterThanOrEqualTo(0));
          expect(result.rhythmAccuracy, greaterThanOrEqualTo(0));
          expect(result.rhythmAccuracy, lessThanOrEqualTo(1));
          expect(result.totalNotes, greaterThan(0));
          expect(result.detailedAnalysis, isNotEmpty);
        } finally {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      });
    });

    group('analyzeRealTimeData', () {
      test('should handle empty audio data', () async {
        final result = await service.analyzeRealTimeData([]);
        
        expect(result['pitch'], equals(0.0));
        expect(result['amplitude'], equals(0.0));
      });

      test('should analyze audio data with amplitude', () async {
        final audioData = [0.1, 0.2, 0.3, 0.4, 0.5];
        final result = await service.analyzeRealTimeData(audioData);
        
        expect(result['pitch'], isA<double>());
        expect(result['amplitude'], isA<double>());
        expect(result['confidence'], isA<double>());
        expect(result['amplitude'], greaterThan(0));
      });

      test('should return zero pitch for low amplitude', () async {
        final audioData = [0.01, 0.02, 0.01, 0.02]; // Low amplitude
        final result = await service.analyzeRealTimeData(audioData);
        
        expect(result['pitch'], equals(0.0));
        expect(result['confidence'], equals(0.0));
      });

      test('should return positive pitch for high amplitude', () async {
        final audioData = [0.5, 0.6, 0.7, 0.8]; // High amplitude
        final result = await service.analyzeRealTimeData(audioData);
        
        expect(result['pitch'], greaterThan(0));
        expect(result['confidence'], greaterThan(0));
      });
    });

    group('frequencyToNote', () {
      test('should convert known frequencies to notes', () {
        expect(service.frequencyToNote(261.63), equals('C4'));
        expect(service.frequencyToNote(293.66), equals('D4'));
        expect(service.frequencyToNote(329.63), equals('E4'));
        expect(service.frequencyToNote(440.00), equals('A4'));
        expect(service.frequencyToNote(523.25), equals('C5'));
      });

      test('should handle invalid frequencies', () {
        expect(service.frequencyToNote(0), equals('N/A'));
        expect(service.frequencyToNote(-100), equals('N/A'));
      });

      test('should find closest note for approximate frequencies', () {
        expect(service.frequencyToNote(442.0), equals('A4')); // Close to A4 (440Hz)
        expect(service.frequencyToNote(260.0), equals('C4')); // Close to C4 (261.63Hz)
      });
    });

    group('Mock Analysis Generation', () {
      test('should generate consistent C major scale data', () async {
        // Create a temporary file for testing
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/test_scale.aac');
        await tempFile.writeAsString('fake scale data');

        try {
          final result = await service.analyzeRecording(tempFile.path);
          
          // Check that we get C major scale analysis
          expect(result.totalNotes, equals(8));
          expect(result.detailedAnalysis['exerciseType'], equals('C Major Scale'));
          expect(result.detailedAnalysis['expectedNotes'], isA<List>());
          expect(result.detailedAnalysis['detectedNotes'], isA<List>());
          expect(result.detailedAnalysis['recommendations'], isA<List>());
          
          final expectedNotes = result.detailedAnalysis['expectedNotes'] as List;
          expect(expectedNotes.length, equals(8));
          expect(expectedNotes.first, equals('C4'));
          expect(expectedNotes.last, equals('C5'));
        } finally {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      });

      test('should generate meaningful recommendations', () async {
        // Create a temporary file for testing
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/test_recommendations.aac');
        await tempFile.writeAsString('fake audio');

        try {
          final result = await service.analyzeRecording(tempFile.path);
          
          final recommendations = result.detailedAnalysis['recommendations'] as List<String>;
          expect(recommendations, isNotEmpty);
          expect(recommendations.every((r) => r.isNotEmpty), isTrue);
        } finally {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      });
    });

    group('Error Handling', () {
      test('should handle analysis errors gracefully', () async {
        // Test with null or invalid input
        expect(
          () async => await service.analyzeRecording(''),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle real-time analysis errors', () async {
        // Test with extreme values
        final result = await service.analyzeRealTimeData([double.infinity, double.nan]);
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('pitch'), isTrue);
        expect(result.containsKey('amplitude'), isTrue);
      });
    });
  });
}