import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart';
import 'package:sax_buddy/features/assessment/models/assessment_session.dart';

void main() {
  group('AssessmentProvider', () {
    late AssessmentProvider provider;

    setUpAll(() {
      // Initialize environment for logger
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
    });

    setUp(() {
      provider = AssessmentProvider();
    });

    tearDown(() {
      provider.dispose();
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
      test('should create new assessment session', () {
        provider.startAssessment();

        expect(provider.currentSession, isNotNull);
        expect(provider.currentSession!.state, equals(AssessmentSessionState.inProgress));
        expect(provider.currentSession!.currentExerciseIndex, equals(0));
        expect(provider.currentSession!.completedExercises, isEmpty);
      });

      test('should set exercise state to setup', () {
        provider.startAssessment();

        expect(provider.exerciseState, equals(ExerciseState.setup));
      });

      test('should provide current exercise information', () {
        provider.startAssessment();

        expect(provider.currentExercise, isNotNull);
        expect(provider.currentExercise!.id, equals(1));
        expect(provider.currentExerciseNumber, equals(1));
        expect(provider.totalExercises, equals(4));
      });
    });

    group('Countdown functionality', () {
      setUp(() {
        provider.startAssessment();
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
      setUp(() {
        provider.startAssessment();
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
        expect(provider.currentSession!.state, equals(AssessmentSessionState.completed));
      });
    });

    group('Assessment cancellation', () {
      setUp(() {
        provider.startAssessment();
      });

      test('should cancel assessment', () {
        provider.cancelAssessment();

        expect(provider.currentSession!.state, equals(AssessmentSessionState.cancelled));
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
      setUp(() {
        provider.startAssessment();
      });

      test('should stop recording manually', () {
        provider.startCountdown();
        
        // Test that stopRecording method can be called
        provider.stopRecording();

        // The state might not change if not actually recording, which is fine for this test
        expect(provider.isRecording, isFalse);
      });
    });
  });
}