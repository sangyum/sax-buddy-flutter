import 'package:flutter/material.dart';
import 'package:sax_buddy/services/audio_recording_service.dart';
import '../models/assessment_exercise.dart';
import '../models/exercise_state.dart';
import '../widgets/exercise_progress_indicator.dart';
import '../widgets/exercise_content.dart';
import '../widgets/exercise_navigation_buttons.dart';
import '../widgets/recording_indicator.dart';

class ExercisePresentation extends StatelessWidget {
  final AssessmentExercise? currentExercise;
  final ExerciseState exerciseState;
  final int currentExerciseNumber;
  final int totalExercises;
  final bool isRecording;
  final int? countdownValue;
  final AudioRecordingService audioService;
  final bool canGoToPreviousExercise;
  final bool canGoToNextExercise;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback? onCancelCountdown;
  final VoidCallback? onPreviousExercise;
  final VoidCallback? onNextExercise;
  final VoidCallback onCompleteAssessment;
  final VoidCallback onExit;

  const ExercisePresentation({
    super.key,
    required this.currentExercise,
    required this.exerciseState,
    required this.currentExerciseNumber,
    required this.totalExercises,
    required this.isRecording,
    this.countdownValue,
    required this.audioService,
    required this.canGoToPreviousExercise,
    required this.canGoToNextExercise,
    required this.onStartRecording,
    required this.onStopRecording,
    this.onCancelCountdown,
    this.onPreviousExercise,
    this.onNextExercise,
    required this.onCompleteAssessment,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Assessment'),
        backgroundColor: const Color(0xFF2E5266),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onExit,
        ),
      ),
      body: currentExercise == null
          ? const Center(
              child: Text('No exercise available'),
            )
          : Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ExerciseProgressIndicator(
                    currentExercise: currentExerciseNumber,
                    totalExercises: totalExercises,
                  ),
                ),
                const SizedBox(height: 24),
                if (isRecording)
                  const RecordingIndicator(),
                Expanded(
                  child: ExerciseContent(
                    exerciseState: exerciseState,
                    exercise: currentExercise!,
                    exerciseNumber: currentExerciseNumber,
                    onStartRecording: onStartRecording,
                    onStopRecording: onStopRecording,
                    audioService: audioService,
                    countdownValue: countdownValue,
                    onCancelCountdown: onCancelCountdown,
                  ),
                ),
                ExerciseNavigationButtons(
                  exerciseState: exerciseState,
                  canGoToPreviousExercise: canGoToPreviousExercise,
                  canGoToNextExercise: canGoToNextExercise,
                  onPreviousExercise: onPreviousExercise,
                  onNextExercise: onNextExercise,
                  onCompleteAssessment: onCompleteAssessment,
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
