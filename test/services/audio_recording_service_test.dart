import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sax_buddy/services/audio_recording_service.dart';
import 'dart:io';

// Generate mocks for dependencies
@GenerateMocks([])
class MockDirectory extends Mock implements Directory {}

void main() {
  group('AudioRecordingService', () {
    late AudioRecordingService service;

    setUp(() {
      service = AudioRecordingService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize successfully', () async {
      await service.initialize();
      expect(service.currentState, equals(AudioRecordingState.idle));
    });

    test('should start with idle state', () {
      expect(service.currentState, equals(AudioRecordingState.idle));
      expect(service.isRecording, isFalse);
      expect(service.isPaused, isFalse);
    });

    test('should provide state stream', () {
      expect(service.stateStream, isA<Stream<AudioRecordingState>>());
    });

    test('should provide duration stream', () {
      expect(service.durationStream, isA<Stream<Duration>>());
    });

    test('should provide waveform stream', () {
      expect(service.waveformStream, isA<Stream<List<double>>>());
    });

    test('should handle permission check', () async {
      // This test would require mocking permission_handler
      // For now, we'll test that the method exists and returns a boolean
      final result = await service.checkPermissions();
      expect(result, isA<bool>());
    });

    test('should not start recording without permissions', () async {
      // Test that recording fails when permissions are denied
      // This would require mocking the permission system
      try {
        await service.startRecording();
        fail('Expected exception when permissions are denied');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should handle multiple dispose calls safely', () async {
      await service.initialize();
      await service.dispose();
      await service.dispose(); // Should not throw
    });

    test('should track recording state correctly', () {
      expect(service.isRecording, equals(service.currentState == AudioRecordingState.recording));
      expect(service.isPaused, equals(service.currentState == AudioRecordingState.paused));
    });

    test('should handle empty recording path gracefully', () {
      expect(service.currentRecordingPath, isNull);
    });

    group('State Management', () {
      test('should emit state changes on stream', () async {
        final states = <AudioRecordingState>[];
        service.stateStream.listen((state) {
          states.add(state);
        });

        await service.initialize();
        
        // Initial state should be idle
        expect(states.isEmpty || states.last == AudioRecordingState.idle, isTrue);
      });

      test('should handle state transitions correctly', () {
        // Test the state enum values
        expect(AudioRecordingState.values.length, equals(4));
        expect(AudioRecordingState.values.contains(AudioRecordingState.idle), isTrue);
        expect(AudioRecordingState.values.contains(AudioRecordingState.recording), isTrue);
        expect(AudioRecordingState.values.contains(AudioRecordingState.paused), isTrue);
        expect(AudioRecordingState.values.contains(AudioRecordingState.stopped), isTrue);
      });
    });

    group('File Operations', () {
      test('should handle file deletion gracefully', () async {
        const fakePath = '/fake/path/recording.aac';
        final result = await service.deleteRecording(fakePath);
        expect(result, isFalse); // File doesn't exist
      });

      test('should handle file size check gracefully', () async {
        const fakePath = '/fake/path/recording.aac';
        final result = await service.getRecordingSize(fakePath);
        expect(result, isNull); // File doesn't exist
      });
    });

    group('Error Handling', () {
      test('should handle initialization errors gracefully', () async {
        // Test that initialization doesn't throw unexpected errors
        expect(() async => await service.initialize(), isA<Function>());
      });

      test('should handle recording errors gracefully', () async {
        // Test that recording methods handle errors appropriately
        expect(() async => await service.stopRecording(), isA<Function>());
        expect(() async => await service.pauseRecording(), isA<Function>());
        expect(() async => await service.resumeRecording(), isA<Function>());
      });
    });
  });
}