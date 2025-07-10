import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../providers/assessment_provider.dart';
import 'exercise_card.dart';
import 'recording_button.dart';
import 'waveform_placeholder.dart';

class ExerciseRecordingState extends StatelessWidget {
  final AssessmentProvider provider;
  final AssessmentExercise exercise;

  const ExerciseRecordingState({
    super.key,
    required this.provider,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ExerciseCard(
          exercise: exercise,
          exerciseNumber: provider.currentExerciseNumber,
        ),
        const Spacer(),
        RecordingButton(
          isRecording: true,
          onPressed: provider.stopRecording,
        ),
        const SizedBox(height: 16),
        const Text(
          'Recording... Tap to stop',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 24),
        const WaveformPlaceholder(isActive: true),
        const Spacer(),
      ],
    );
  }
}