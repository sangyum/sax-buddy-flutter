import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';

enum AudioRecordingState { idle, recording, paused, stopped }

@injectable
class AudioRecordingService {
  final LoggerService _logger;

  AudioRecordingService(this._logger);
  RecorderController? _recorderController;
  String? _currentRecordingPath;
  AudioRecordingState _state = AudioRecordingState.idle;
  bool _isDisposed = false;

  // Stream controllers for real-time updates
  final StreamController<AudioRecordingState> _stateController =
      StreamController<AudioRecordingState>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<List<double>> _waveformController =
      StreamController<List<double>>.broadcast();

  // Getters for streams
  Stream<AudioRecordingState> get stateStream => _stateController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<List<double>> get waveformStream => _waveformController.stream;

  // Current state getter
  AudioRecordingState get currentState => _state;
  String? get currentRecordingPath => _currentRecordingPath;

  /// Initialize the audio recording service
  Future<void> initialize() async {
    try {
      _recorderController = RecorderController();
      _logger.debug('AudioRecordingService initialized');
    } catch (e) {
      _logger.error('Failed to initialize AudioRecordingService: $e');
      rethrow;
    }
  }

  /// Check and request microphone permissions
  Future<bool> checkPermissions() async {
    try {
      final status = await Permission.microphone.status;

      if (status.isDenied) {
        final result = await Permission.microphone.request();
        return result.isGranted;
      }

      return status.isGranted;
    } catch (e) {
      _logger.error('Error checking microphone permissions: $e');
      return false;
    }
  }

  /// Generate a unique file path for recording
  Future<String> _generateRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/recordings');

    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${recordingsDir.path}/recording_$timestamp.aac';
  }

  /// Start recording audio
  Future<String?> startRecording() async {
    try {
      if (_state == AudioRecordingState.recording) {
        _logger.warning('Already recording');
        return null;
      }

      // Check permissions
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        throw Exception('Microphone permission denied');
      }

      // Generate recording path
      _currentRecordingPath = await _generateRecordingPath();

      // Start recording
      await _recorderController?.record(
        path: _currentRecordingPath!,
        androidEncoder: AndroidEncoder.aac,
        iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        sampleRate: 44100,
        bitRate: 64000,
      );

      _updateState(AudioRecordingState.recording);
      _startWaveformUpdates();
      _startDurationUpdates();

      _logger.debug('Recording started: $_currentRecordingPath');
      return _currentRecordingPath;
    } catch (e) {
      _logger.error('Failed to start recording: $e');
      _updateState(AudioRecordingState.idle);
      rethrow;
    }
  }

  /// Stop recording audio
  Future<String?> stopRecording() async {
    try {
      if (_state != AudioRecordingState.recording) {
        _logger.warning('Not currently recording');
        return null;
      }

      final path = await _recorderController?.stop();
      _updateState(AudioRecordingState.stopped);

      _logger.debug('Recording stopped: $path');
      return path;
    } catch (e) {
      _logger.error('Failed to stop recording: $e');
      _updateState(AudioRecordingState.idle);
      rethrow;
    }
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    try {
      if (_state != AudioRecordingState.recording) {
        _logger.warning('Not currently recording');
        return;
      }

      await _recorderController?.pause();
      _updateState(AudioRecordingState.paused);

      _logger.debug('Recording paused');
    } catch (e) {
      _logger.error('Failed to pause recording: $e');
      rethrow;
    }
  }

  /// Resume recording (Note: audio_waveforms doesn't support resume)
  Future<void> resumeRecording() async {
    _logger.warning('Resume recording not supported by audio_waveforms');
    // For now, we'll need to restart recording
    // This is a limitation of the current audio_waveforms package
  }

  /// Start real-time waveform updates
  void _startWaveformUpdates() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_state != AudioRecordingState.recording) {
        timer.cancel();
        return;
      }

      try {
        final waveform = _recorderController?.waveData ?? [];
        _waveformController.add(waveform);
      } catch (e) {
        _logger.error('Error getting waveform data: $e');
      }
    });
  }

  /// Start duration updates
  void _startDurationUpdates() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_state != AudioRecordingState.recording) {
        timer.cancel();
        return;
      }

      try {
        final duration = _recorderController?.recordedDuration ?? Duration.zero;
        _durationController.add(duration);
      } catch (e) {
        _logger.error('Error getting recorded duration: $e');
      }
    });
  }

  /// Update recording state and notify listeners
  void _updateState(AudioRecordingState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  /// Get recording duration
  Duration? get recordedDuration => _recorderController?.recordedDuration;

  /// Check if currently recording
  bool get isRecording => _state == AudioRecordingState.recording;

  /// Check if recording is paused
  bool get isPaused => _state == AudioRecordingState.paused;

  /// Clean up resources
  Future<void> dispose() async {
    try {
      if (!_isDisposed) {
        await _recorderController?.stop();
        _recorderController?.dispose();

        await _stateController.close();
        await _durationController.close();
        await _waveformController.close();

        _isDisposed = true;
      }
      _logger.debug('AudioRecordingService disposed');
    } catch (e) {
      _logger.error('Error disposing AudioRecordingService: $e');
    }
  }

  /// Delete a recording file
  Future<bool> deleteRecording(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        _logger.debug('Recording deleted: $path');
        return true;
      }
      return false;
    } catch (e) {
      _logger.error('Failed to delete recording: $e');
      return false;
    }
  }

  /// Get file size of a recording
  Future<int?> getRecordingSize(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      _logger.error('Failed to get recording size: $e');
      return null;
    }
  }
}
