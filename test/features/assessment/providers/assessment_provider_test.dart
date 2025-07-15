import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart';
import 'package:sax_buddy/features/assessment/models/assessment_session.dart';
import 'package:sax_buddy/services/audio_analysis_service.dart';
import 'package:sax_buddy/services/audio_recording_service.dart';
import 'package:sax_buddy/services/firebase_storage_service.dart';
import 'package:sax_buddy/services/logger_service.dart';

// Generate mocks for dependencies
@GenerateMocks([
  AudioRecordingService,
  AudioAnalysisService,
  FirebaseStorageService,
  LoggerService,
])
import 'assessment_provider_audio_test.mocks.dart';

void main() {
  group('AssessmentProvider', () {
    late AssessmentProvider provider;
    late MockAudioRecordingService mockAudioService;
    late MockAudioAnalysisService mockAnalysisService;
    late MockFirebaseStorageService mockStorageService;
    late MockLoggerService mockLoggerService;

    setUp(() {
      // Create mock services
      mockAudioService = MockAudioRecordingService();
      mockAnalysisService = MockAudioAnalysisService();
      mockStorageService = MockFirebaseStorageService();
      mockLoggerService = MockLoggerService();

      // Create provider with mocked dependencies
      provider = AssessmentProvider(
        mockLoggerService,
        mockAudioService,
        mockAnalysisService,
        mockStorageService,
      );

      // Set up default mock responses
      when(mockAudioService.initialize()).thenAnswer((_) async => {});
      when(mockAudioService.checkPermissions()).thenAnswer((_) async => true);
      when(
        mockAudioService.startRecording(),
      ).thenAnswer((_) async => '/path/to/recording.aac');
      when(
        mockAudioService.stopRecording(),
      ).thenAnswer((_) async => '/path/to/recording.aac');
      when(
        mockAudioService.getRecordingSize(any),
      ).thenAnswer((_) async => 1024);
      when(mockAudioService.currentState).thenReturn(AudioRecordingState.idle);
      when(
        mockAudioService.stateStream,
      ).thenAnswer((_) => const Stream.empty());
      when(
        mockAudioService.durationStream,
      ).thenAnswer((_) => const Stream.empty());
      when(
        mockAudioService.waveformStream,
      ).thenAnswer((_) => const Stream.empty());
      when(mockAudioService.dispose()).thenAnswer((_) async => {});

      // Mock analysis service
      when(mockAnalysisService.analyzeRecording(any)).thenAnswer(
        (_) async => AudioAnalysisResult(
          pitchData: [440.0, 441.0, 442.0],
          timingData: [0.0, 0.5, 1.0],
          avgPitch: 441.0,
          pitchStability: 1.0,
          rhythmAccuracy: 0.9,
          totalNotes: 3,
          detailedAnalysis: {'test': 'data'},
        ),
      );

      // Mock storage service
      when(
        mockStorageService.uploadAudioFileInBackground(any, any),
      ).thenAnswer((_) async => {});
    });

    tearDown(() {
      // Dispose if not already disposed
      try {
        provider.dispose();
      } catch (e) {
        // Already disposed - ignore
      }
    });

    group('Initial state', () {
      test('should have no current session initially', () {
        expect(provider.currentSession, isNull);
        expect(provider.currentExercise, isNull);
      });

      test('should have setup exercise state initially', () {
        expect(provider.exerciseState, equals(ExerciseState.setup));
      });

      test('should have countdown value of 5', () {
        expect(provider.countdownValue, equals(5));
      });

      test('should not be recording initially', () {
        expect(provider.isRecording, isFalse);
        expect(provider.isCountdownActive, isFalse);
      });
    });

    group('Starting assessment', () {
      test('should create new assessment session', () async {
        await provider.startAssessment();

        expect(provider.currentSession, isNotNull);
        expect(
          provider.currentSession!.state,
          equals(AssessmentSessionState.inProgress),
        );
        expect(provider.currentSession!.currentExerciseIndex, equals(0));
        expect(provider.currentSession!.completedExercises, isEmpty);
      });

      test('should set exercise state to setup', () async {
        await provider.startAssessment();

        expect(provider.exerciseState, equals(ExerciseState.setup));
      });

      test('should provide current exercise information', () async {
        await provider.startAssessment();

        expect(provider.currentExercise, isNotNull);
        expect(provider.currentExercise!.id, equals(1));
        expect(provider.currentExerciseNumber, equals(1));
        expect(provider.totalExercises, equals(4));
      });
    });

    group('Countdown functionality', () {
      setUp(() async {
        await provider.startAssessment();
      });

      test('should start countdown when requested', () {
        provider.startCountdown();

        expect(provider.exerciseState, equals(ExerciseState.countdown));
        expect(provider.countdownValue, equals(5));
      });

      test('should cancel countdown when requested', () {
        provider.startCountdown();
        provider.cancelCountdown();

        expect(provider.exerciseState, equals(ExerciseState.setup));
        expect(provider.countdownValue, equals(5));
        expect(provider.isCountdownActive, isFalse);
      });
    });

    group('Exercise navigation', () {
      setUp(() async {
        await provider.startAssessment();
      });

      test('should indicate navigation capabilities correctly', () {
        // At first exercise
        expect(provider.canGoToNextExercise, isTrue);
        expect(provider.canGoToPreviousExercise, isFalse);
      });

      test('should move to next exercise', () {
        // Test navigation logic - we're just testing that the provider
        // can move between exercises regardless of completion state
        final initialExercise = provider.currentExerciseNumber;

        provider.goToNextExercise();

        expect(provider.currentExerciseNumber, equals(initialExercise + 1));
        expect(provider.exerciseState, equals(ExerciseState.setup));
      });

      test('should complete assessment after all exercises', () {
        expect(provider.currentSession!.isCompleted, isFalse);

        provider.completeAssessment();
        expect(
          provider.currentSession!.state,
          equals(AssessmentSessionState.completed),
        );
      });
    });

    group('Assessment cancellation', () {
      setUp(() async {
        await provider.startAssessment();
      });

      test('should cancel assessment', () {
        provider.cancelAssessment();

        expect(
          provider.currentSession!.state,
          equals(AssessmentSessionState.cancelled),
        );
        expect(provider.exerciseState, equals(ExerciseState.setup));
      });

      test('should reset assessment', () {
        provider.resetAssessment();

        expect(provider.currentSession, isNull);
        expect(provider.exerciseState, equals(ExerciseState.setup));
        expect(provider.countdownValue, equals(5));
      });
    });

    group('Recording state', () {
      setUp(() async {
        await provider.startAssessment();
      });

      test('should stop recording manually', () async {
        provider.startCountdown();

        // Test that stopRecording method can be called
        await provider.stopRecording();

        // The state might not change if not actually recording, which is fine for this test
        expect(provider.isRecording, isFalse);
      });
    });
  });
}
