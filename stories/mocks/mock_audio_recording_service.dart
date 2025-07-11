import 'dart:async';

import 'package:sax_buddy/services/audio_recording_service.dart';

class MockAudioRecordingService implements AudioRecordingService {
  final _stateController = StreamController<AudioRecordingState>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();

  @override
  Stream<AudioRecordingState> get stateStream => _stateController.stream;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<List<double>> get waveformStream => _waveformController.stream;

  @override
  Future<void> initialize() async {
    // Mock initialization
  }

  @override
  Future<bool> checkPermissions() async {
    return true; // Always grant permissions in mock
  }

  @override
  Future<String?> startRecording() async {
    _stateController.add(AudioRecordingState.recording);
    // Simulate waveform data
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_stateController.isClosed &&
          _stateController.hasListener &&
          currentState == AudioRecordingState.recording) {
        _waveformController.add(
          List.generate(20, (index) => (index % 5) * 0.1 + 0.1),
        );
      } else {
        timer.cancel();
      }
    });
    return 'mock_recording_path.aac';
  }

  @override
  Future<String?> stopRecording() async {
    _stateController.add(AudioRecordingState.stopped);
    return null;
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _durationController.close();
    await _waveformController.close();
  }

  @override
  Future<bool> deleteRecording(String path) async {
    return true;
  }

  @override
  Future<int> getRecordingSize(String path) async {
    return 1024; // Mock size
  }

  Future<String> get recordingPath async => 'mock_recording_path.aac';

  @override
  Future<void> pauseRecording() async {
    _stateController.add(AudioRecordingState.paused);
  }

  @override
  Future<void> resumeRecording() async {
    _stateController.add(AudioRecordingState.recording);
  }

  @override
  // TODO: implement currentRecordingPath
  String? get currentRecordingPath => throw UnimplementedError();

  @override
  // TODO: implement currentState
  AudioRecordingState get currentState => throw UnimplementedError();

  @override
  // TODO: implement isPaused
  bool get isPaused => throw UnimplementedError();

  @override
  // TODO: implement isRecording
  bool get isRecording => throw UnimplementedError();

  @override
  // TODO: implement recordedDuration
  Duration? get recordedDuration => throw UnimplementedError();
}
