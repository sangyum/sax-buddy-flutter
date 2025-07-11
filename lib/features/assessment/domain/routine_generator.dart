import 'package:injectable/injectable.dart';
import '../models/assessment_session.dart';
import '../../practice/models/practice_routine.dart';

@injectable
class RoutineGenerator {
  Future<List<PracticeRoutine>> generateSampleRoutines(
    AssessmentSession session,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      PracticeRoutine(
        title: 'Scale Fundamentals',
        description:
            'Practice basic scale patterns to improve finger coordination and pitch accuracy',
        targetAreas: ['scales', 'pitch accuracy', 'finger coordination'],
        difficulty: 'intermediate',
        estimatedDuration: '20 minutes',
        exercises: [
          PracticeExercise(
            name: 'C Major Scale',
            description: 'Practice C major scale at slow tempo',
            estimatedDuration: '10 minutes',
            tempo: '80 BPM',
            keySignature: 'C Major',
            notes: 'Focus on clean fingering and intonation',
          ),
          PracticeExercise(
            name: 'Chromatic Scale',
            description: 'Practice chromatic scale for finger dexterity',
            estimatedDuration: '10 minutes',
            tempo: '60 BPM',
            notes: 'Keep fingers close to keys',
          ),
        ],
      ),
      PracticeRoutine(
        title: 'Timing Development',
        description:
            'Improve rhythm and timing accuracy with metronome practice',
        targetAreas: ['timing', 'rhythm', 'metronome'],
        difficulty: 'intermediate',
        estimatedDuration: '15 minutes',
        exercises: [
          PracticeExercise(
            name: 'Metronome Practice',
            description: 'Practice long tones with metronome',
            estimatedDuration: '8 minutes',
            tempo: '60 BPM',
            notes: 'Focus on starting and stopping exactly with the beat',
          ),
          PracticeExercise(
            name: 'Rhythmic Patterns',
            description: 'Practice various rhythmic patterns',
            estimatedDuration: '7 minutes',
            tempo: '100 BPM',
            notes: 'Use different note values and patterns',
          ),
        ],
      ),
      PracticeRoutine(
        title: 'Breath Control',
        description: 'Exercises to improve breath control and support',
        targetAreas: ['breath control', 'tone quality', 'endurance'],
        difficulty: 'beginner',
        estimatedDuration: '12 minutes',
        exercises: [
          PracticeExercise(
            name: 'Long Tones',
            description: 'Hold sustained notes for breath development',
            estimatedDuration: '8 minutes',
            notes: 'Focus on steady air flow and tone quality',
          ),
          PracticeExercise(
            name: 'Breathing Exercises',
            description: 'Practice proper breathing technique',
            estimatedDuration: '4 minutes',
            notes: 'Use diaphragmatic breathing',
          ),
        ],
      ),
    ];
  }
}