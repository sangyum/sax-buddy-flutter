import '../models/assessment_exercise.dart';

class InitialExercises {
  static const List<AssessmentExercise> exercises = [
    AssessmentExercise(
      id: 1,
      title: 'C Major Scale',
      instructions: 'Play C Major scale, one octave, quarter notes at 80 BPM',
      duration: Duration(seconds: 45),
      tempo: 80,
      focusAreas: [
        'pitch accuracy',
        'finger coordination', 
        'timing consistency'
      ],
    ),
    AssessmentExercise(
      id: 2,
      title: 'C Major Arpeggio',
      instructions: 'Play C-E-G-C arpeggio, two octaves, quarter notes at 70 BPM',
      duration: Duration(seconds: 45),
      tempo: 70,
      focusAreas: [
        'interval accuracy',
        'large leap control',
        'technical facility'
      ],
    ),
    AssessmentExercise(
      id: 3,
      title: 'Octave Jumps',
      instructions: 'Play Low G to High G, Low A to High A, Low Bb to High Bb with quarter rest between jumps',
      duration: Duration(minutes: 1),
      focusAreas: [
        'range capability',
        'register transitions',
        'intonation consistency'
      ],
    ),
    AssessmentExercise(
      id: 4,
      title: 'Dynamic Control Scale',
      instructions: 'Play C Major scale with crescendo ascending, diminuendo descending',
      duration: Duration(minutes: 1),
      focusAreas: [
        'breath control',
        'dynamic range',
        'musical expression'
      ],
    ),
  ];

  static AssessmentExercise getExerciseById(int id) {
    return exercises.firstWhere(
      (exercise) => exercise.id == id,
      orElse: () => throw ArgumentError('Exercise with id $id not found'),
    );
  }

  static int get totalExercises => exercises.length;

  static Duration get totalEstimatedDuration {
    return exercises.fold(
      Duration.zero,
      (total, exercise) => total + exercise.duration,
    );
  }
}