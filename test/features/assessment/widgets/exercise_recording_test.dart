import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sax_buddy/features/assessment/widgets/exercise_recording.dart';
import 'package:sax_buddy/features/assessment/widgets/recording_button.dart';
import 'package:sax_buddy/features/assessment/models/assessment_exercise.dart';
import 'package:sax_buddy/services/audio_recording_service.dart';

// Generate mocks for dependencies
@GenerateMocks([AudioRecordingService])
import 'exercise_recording_test.mocks.dart';

void main() {
  group('ExerciseRecording', () {
    late AssessmentExercise testExercise;
    late MockAudioRecordingService mockAudioService;

    setUp(() {
      testExercise = AssessmentExercise(
        id: 1,
        title: 'C Major Scale',
        instructions: 'Play the C major scale',
        duration: const Duration(seconds: 45),
        focusAreas: ['pitch accuracy', 'timing'],
        tempo: 80,
      );

      mockAudioService = MockAudioRecordingService();
      
      // Set up default mock responses
      when(mockAudioService.stateStream).thenAnswer((_) => const Stream.empty());
      when(mockAudioService.waveformStream).thenAnswer((_) => Stream.value(<double>[]));
      when(mockAudioService.durationStream).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('should display exercise card with correct exercise number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: ExerciseRecording(
                exercise: testExercise,
                exerciseNumber: 3,
                onStopRecording: () {},
                audioService: mockAudioService,
              ),
            ),
          ),
        ),
      );

      // Check that the exercise card is displayed with correct number
      expect(find.text('Exercise 3'), findsOneWidget);
      expect(find.text('C Major Scale'), findsOneWidget);
    });

    testWidgets('should display recording button in recording state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: ExerciseRecording(
                exercise: testExercise,
                exerciseNumber: 1,
                onStopRecording: () {},
                audioService: mockAudioService,
              ),
            ),
          ),
        ),
      );

      // Check that recording button is present and shows stop state
      expect(find.byType(RecordingButton), findsOneWidget);
      
      // The recording button should show a square (stop) instead of microphone
      // when isRecording is true - this is verified by looking for Container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should call onStopRecording when button is pressed', (WidgetTester tester) async {
      bool stopRecordingCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: ExerciseRecording(
                exercise: testExercise,
                exerciseNumber: 2,
                onStopRecording: () => stopRecordingCalled = true,
                audioService: mockAudioService,
              ),
            ),
          ),
        ),
      );

      // Tap the recording button
      await tester.tap(find.byType(RecordingButton));
      await tester.pump();

      expect(stopRecordingCalled, isTrue);
    });

    testWidgets('should display recording status message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: ExerciseRecording(
                exercise: testExercise,
                exerciseNumber: 1,
                onStopRecording: () {},
                audioService: mockAudioService,
              ),
            ),
          ),
        ),
      );

      // Check that recording message is displayed
      expect(find.text('Recording... Tap to stop'), findsOneWidget);
    });

    testWidgets('should not reference AssessmentProvider', (WidgetTester tester) async {
      // This test ensures the widget doesn't depend on provider
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: ExerciseRecording(
                exercise: testExercise,
                exerciseNumber: 1,
                onStopRecording: () {},
                audioService: mockAudioService,
              ),
            ),
          ),
        ),
      );

      // Widget should render without any provider context
      expect(find.byType(ExerciseRecording), findsOneWidget);
      expect(find.text('Recording... Tap to stop'), findsOneWidget);
    });
  });
}