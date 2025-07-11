import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/routines/screens/routines_presentation.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

final List<Story> routinesStories = [
  Story(
    name: 'Routines/With Routines',
    description: 'RoutinesPresentation with sample practice routines',
    builder: (context) => RoutinesPresentation(
      routines: _mockRoutines,
      isLoading: false,
      error: null,
      onRefresh: () => debugPrint('Refresh tapped'),
      onRoutineTap: (routine) => debugPrint('Routine tapped: ${routine.title}'),
    ),
  ),
  Story(
    name: 'Routines/Loading State',
    description: 'RoutinesPresentation showing loading indicator',
    builder: (context) => RoutinesPresentation(
      routines: [],
      isLoading: true,
      error: null,
      onRefresh: () => debugPrint('Refresh tapped'),
      onRoutineTap: (routine) => debugPrint('Routine tapped: ${routine.title}'),
    ),
  ),
  Story(
    name: 'Routines/Empty State',
    description: 'RoutinesPresentation with no routines',
    builder: (context) => RoutinesPresentation(
      routines: [],
      isLoading: false,
      error: null,
      onRefresh: () => debugPrint('Refresh tapped'),
      onRoutineTap: (routine) => debugPrint('Routine tapped: ${routine.title}'),
    ),
  ),
  Story(
    name: 'Routines/Error State',
    description: 'RoutinesPresentation with error message',
    builder: (context) => RoutinesPresentation(
      routines: [],
      isLoading: false,
      error: 'Failed to load practice routines. Please check your internet connection.',
      onRefresh: () => debugPrint('Refresh tapped'),
      onRoutineTap: (routine) => debugPrint('Routine tapped: ${routine.title}'),
    ),
  ),
  Story(
    name: 'Routines/Single Routine',
    description: 'RoutinesPresentation with only one routine',
    builder: (context) => RoutinesPresentation(
      routines: [_mockRoutines.first],
      isLoading: false,
      error: null,
      onRefresh: () => debugPrint('Refresh tapped'),
      onRoutineTap: (routine) => debugPrint('Routine tapped: ${routine.title}'),
    ),
  ),
  Story(
    name: 'Routines/Many Routines',
    description: 'RoutinesPresentation with many routines for scrolling',
    builder: (context) => RoutinesPresentation(
      routines: _manyMockRoutines,
      isLoading: false,
      error: null,
      onRefresh: () => debugPrint('Refresh tapped'),
      onRoutineTap: (routine) => debugPrint('Routine tapped: ${routine.title}'),
    ),
  ),
];

final List<PracticeRoutine> _mockRoutines = [
  PracticeRoutine(
    title: 'Scale Fundamentals',
    description: 'Practice basic scale patterns to improve finger coordination and pitch accuracy',
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
    description: 'Improve rhythm and timing accuracy with metronome practice',
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

final List<PracticeRoutine> _manyMockRoutines = [
  ..._mockRoutines,
  PracticeRoutine(
    title: 'Jazz Improvisation',
    description: 'Learn the basics of jazz improvisation with blues scales',
    targetAreas: ['improvisation', 'jazz', 'blues scale'],
    difficulty: 'advanced',
    estimatedDuration: '25 minutes',
    exercises: [
      PracticeExercise(
        name: 'Blues Scale Practice',
        description: 'Practice blues scale in different keys',
        estimatedDuration: '12 minutes',
        tempo: '90 BPM',
        notes: 'Focus on swing rhythm',
      ),
      PracticeExercise(
        name: 'Call and Response',
        description: 'Practice improvising over backing tracks',
        estimatedDuration: '13 minutes',
        tempo: '120 BPM',
        notes: 'Listen and respond to musical phrases',
      ),
    ],
  ),
  PracticeRoutine(
    title: 'Altissimo Register',
    description: 'Develop control and technique in the altissimo register',
    targetAreas: ['altissimo', 'high notes', 'embouchure'],
    difficulty: 'advanced',
    estimatedDuration: '30 minutes',
    exercises: [
      PracticeExercise(
        name: 'Overtone Series',
        description: 'Practice overtone exercises for altissimo development',
        estimatedDuration: '15 minutes',
        notes: 'Focus on embouchure control and voicing',
      ),
      PracticeExercise(
        name: 'Altissimo Scales',
        description: 'Practice scales extending into altissimo range',
        estimatedDuration: '15 minutes',
        notes: 'Start slowly and build confidence',
      ),
    ],
  ),
  PracticeRoutine(
    title: 'Articulation Studies',
    description: 'Improve tonguing technique and articulation clarity',
    targetAreas: ['articulation', 'tonguing', 'staccato'],
    difficulty: 'intermediate',
    estimatedDuration: '18 minutes',
    exercises: [
      PracticeExercise(
        name: 'Single Tonguing',
        description: 'Practice single tonguing at various speeds',
        estimatedDuration: '10 minutes',
        tempo: '80-120 BPM',
        notes: 'Keep tongue light and consistent',
      ),
      PracticeExercise(
        name: 'Staccato Patterns',
        description: 'Practice various staccato articulation patterns',
        estimatedDuration: '8 minutes',
        tempo: '100 BPM',
        notes: 'Focus on clean starts and stops',
      ),
    ],
  ),
  PracticeRoutine(
    title: 'Intonation Training',
    description: 'Develop better pitch accuracy and intonation control',
    targetAreas: ['intonation', 'pitch accuracy', 'tuning'],
    difficulty: 'beginner',
    estimatedDuration: '16 minutes',
    exercises: [
      PracticeExercise(
        name: 'Tuning Exercises',
        description: 'Practice matching pitch with a tuner',
        estimatedDuration: '8 minutes',
        notes: 'Use electronic tuner for reference',
      ),
      PracticeExercise(
        name: 'Interval Recognition',
        description: 'Practice recognizing and playing intervals',
        estimatedDuration: '8 minutes',
        notes: 'Focus on perfect 4ths and 5ths first',
      ),
    ],
  ),
];