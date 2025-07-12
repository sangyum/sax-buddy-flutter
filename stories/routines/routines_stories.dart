import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/routines/screens/routines_presentation.dart';
import 'package:sax_buddy/features/routines/screens/routine_detail_presentation.dart';
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
      error:
          'Failed to load practice routines. Please check your internet connection.',
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

  // Routine Detail Stories
  Story(
    name: 'Routine Detail/Beginner Routine',
    description: 'Routine detail view for a beginner-level practice routine',
    builder: (context) => RoutineDetailPresentation(
      routine: _mockRoutines[2], // Breath Control - beginner
    ),
  ),
  Story(
    name: 'Routine Detail/Intermediate Routine',
    description:
        'Routine detail view for an intermediate-level practice routine',
    builder: (context) => RoutineDetailPresentation(
      routine: _mockRoutines[0], // Scale Fundamentals - intermediate
    ),
  ),
  Story(
    name: 'Routine Detail/Advanced Routine',
    description: 'Routine detail view for an advanced-level practice routine',
    builder: (context) => RoutineDetailPresentation(
      routine: _manyMockRoutines[3], // Jazz Improvisation - advanced
    ),
  ),
  Story(
    name: 'Routine Detail/Single Exercise',
    description: 'Routine detail view with only one exercise',
    builder: (context) =>
        RoutineDetailPresentation(routine: _singleExerciseRoutine),
  ),
  Story(
    name: 'Routine Detail/Many Exercises',
    description: 'Routine detail view with many exercises for scrolling',
    builder: (context) =>
        RoutineDetailPresentation(routine: _manyExercisesRoutine),
  ),
  Story(
    name: 'Routine Detail/Long Title',
    description: 'Routine detail view with a very long title to test layout',
    builder: (context) => RoutineDetailPresentation(routine: _longTitleRoutine),
  ),
  Story(
    name: 'Routine Detail/AI Generated',
    description: 'Routine detail view for an AI-generated practice routine',
    builder: (context) =>
        RoutineDetailPresentation(routine: _aiGeneratedRoutine),
  ),
  Story(
    name: 'Routine Detail/No Tempo',
    description:
        'Routine detail view with exercises that have no tempo specified',
    builder: (context) => RoutineDetailPresentation(routine: _noTempoRoutine),
  ),
];

final Map<String, dynamic> _musicalNotation = {
  'clef': 'treble',
  'keySignature': 'cMajor',
  'tempo': 120,
  'measures': [
    {
      'notes': [
        {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c5', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c4', 'duration': 'half', 'accidental': null},
      ],
    },
  ],
};

final List<PracticeRoutine> _mockRoutines = [
  PracticeRoutine(
    id: 'random-id1',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Chromatic Scale',
        description: 'Practice chromatic scale for finger dexterity',
        estimatedDuration: '10 minutes',
        tempo: '60 BPM',
        notes: 'Keep fingers close to keys',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
  PracticeRoutine(
    id: 'random-id2',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Rhythmic Patterns',
        description: 'Practice various rhythmic patterns',
        estimatedDuration: '7 minutes',
        tempo: '100 BPM',
        notes: 'Use different note values and patterns',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
  PracticeRoutine(
    id: 'random-id3',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Breathing Exercises',
        description: 'Practice proper breathing technique',
        estimatedDuration: '4 minutes',
        notes: 'Use diaphragmatic breathing',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
];

final List<PracticeRoutine> _manyMockRoutines = [
  ..._mockRoutines,
  PracticeRoutine(
    id: 'random-id4',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Call and Response',
        description: 'Practice improvising over backing tracks',
        estimatedDuration: '13 minutes',
        tempo: '120 BPM',
        notes: 'Listen and respond to musical phrases',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
  PracticeRoutine(
    id: 'random-id5',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Altissimo Scales',
        description: 'Practice scales extending into altissimo range',
        estimatedDuration: '15 minutes',
        notes: 'Start slowly and build confidence',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
  PracticeRoutine(
    id: 'random-id6',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Staccato Patterns',
        description: 'Practice various staccato articulation patterns',
        estimatedDuration: '8 minutes',
        tempo: '100 BPM',
        notes: 'Focus on clean starts and stops',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
  PracticeRoutine(
    id: 'random-id7',
    userId: "user_id",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isAIGenerated: false,
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
        musicalNotation: _musicalNotation,
      ),
      PracticeExercise(
        name: 'Interval Recognition',
        description: 'Practice recognizing and playing intervals',
        estimatedDuration: '8 minutes',
        notes: 'Focus on perfect 4ths and 5ths first',
        musicalNotation: _musicalNotation,
      ),
    ],
  ),
];

// Additional mock routines for routine detail stories
final PracticeRoutine _singleExerciseRoutine = PracticeRoutine(
  id: 'single-exercise',
  userId: 'user_id',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isAIGenerated: false,
  title: 'Quick Warm-up',
  description: 'A simple warm-up routine with just one exercise',
  targetAreas: ['warm-up', 'breathing'],
  difficulty: 'beginner',
  estimatedDuration: '5 minutes',
  exercises: [
    PracticeExercise(
      name: 'Breathing Exercise',
      description: 'Deep breathing to prepare for practice',
      estimatedDuration: '5 minutes',
      notes: 'Take slow, deep breaths and focus on diaphragmatic breathing',
      musicalNotation: _musicalNotation,
    ),
  ],
);

final PracticeRoutine _manyExercisesRoutine = PracticeRoutine(
  id: 'many-exercises',
  userId: 'user_id',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isAIGenerated: false,
  title: 'Comprehensive Practice Session',
  description:
      'A complete practice routine covering all aspects of saxophone technique',
  targetAreas: [
    'scales',
    'articulation',
    'timing',
    'intonation',
    'tone quality',
  ],
  difficulty: 'intermediate',
  estimatedDuration: '45 minutes',
  exercises: [
    PracticeExercise(
      name: 'Warm-up Long Tones',
      description: 'Start with sustained notes to warm up',
      estimatedDuration: '5 minutes',
      notes: 'Focus on steady air flow and consistent tone',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Chromatic Scale',
      description: 'Full range chromatic scale',
      estimatedDuration: '5 minutes',
      tempo: '60 BPM',
      notes: 'Keep fingers close to keys',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Major Scales',
      description: 'Practice major scales in all keys',
      estimatedDuration: '10 minutes',
      tempo: '80 BPM',
      keySignature: 'All Major Keys',
      notes: 'Focus on clean fingering and intonation',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Arpeggios',
      description: 'Major and minor arpeggios',
      estimatedDuration: '8 minutes',
      tempo: '90 BPM',
      notes: 'Practice both major and minor arpeggios',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Articulation Studies',
      description: 'Various tonguing patterns',
      estimatedDuration: '7 minutes',
      tempo: '100 BPM',
      notes: 'Practice staccato, legato, and accent patterns',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Interval Training',
      description: 'Perfect 4ths, 5ths, and octaves',
      estimatedDuration: '5 minutes',
      notes: 'Focus on intonation and pitch accuracy',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Cool Down',
      description: 'Slow, expressive playing to end practice',
      estimatedDuration: '5 minutes',
      notes: 'Play something musical and expressive',
      musicalNotation: _musicalNotation,
    ),
  ],
);

final PracticeRoutine _longTitleRoutine = PracticeRoutine(
  id: 'long-title',
  userId: 'user_id',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isAIGenerated: false,
  title:
      'Advanced Contemporary Saxophone Techniques with Extended Range and Complex Rhythmic Patterns',
  description:
      'This is an extremely comprehensive routine designed for advanced players who want to push their technical boundaries and explore contemporary saxophone literature',
  targetAreas: [
    'extended techniques',
    'contemporary music',
    'complex rhythms',
    'multiphonics',
  ],
  difficulty: 'advanced',
  estimatedDuration: '60 minutes',
  exercises: [
    PracticeExercise(
      name: 'Multiphonic Exercises',
      description:
          'Practice producing multiple notes simultaneously using special fingerings and embouchure techniques',
      estimatedDuration: '20 minutes',
      notes:
          'Start with simple two-note multiphonics and gradually work toward more complex combinations',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Extended Techniques',
      description:
          'Explore growling, flutter tonguing, and other contemporary effects',
      estimatedDuration: '15 minutes',
      notes: 'Practice each technique slowly and with control',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Complex Rhythmic Patterns in Mixed Meters',
      description:
          'Work on challenging rhythmic patterns that change meters frequently',
      estimatedDuration: '25 minutes',
      tempo: '120 BPM',
      notes: 'Use a metronome and count carefully through meter changes',
      musicalNotation: _musicalNotation,
    ),
  ],
);

final PracticeRoutine _aiGeneratedRoutine = PracticeRoutine(
  id: 'ai-generated',
  userId: 'user_id',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isAIGenerated: true,
  title: 'AI-Personalized Practice Plan',
  description:
      'This routine was generated based on your recent assessment performance and focuses on your specific areas for improvement',
  targetAreas: ['pitch accuracy', 'timing consistency', 'breath control'],
  difficulty: 'intermediate',
  estimatedDuration: '22 minutes',
  exercises: [
    PracticeExercise(
      name: 'Targeted Pitch Training',
      description: 'Focus on notes where pitch accuracy needs improvement',
      estimatedDuration: '8 minutes',
      notes: 'AI identified these specific pitches for focused practice',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Metronome Synchronization',
      description: 'Timing exercises based on assessment analysis',
      estimatedDuration: '7 minutes',
      tempo: '85 BPM',
      notes: 'AI detected timing inconsistencies at this tempo range',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Adaptive Breathing Exercises',
      description: 'Customized breathing patterns for improved breath support',
      estimatedDuration: '7 minutes',
      notes:
          'AI-generated breathing routine based on your lung capacity analysis',
      musicalNotation: _musicalNotation,
    ),
  ],
);

final PracticeRoutine _noTempoRoutine = PracticeRoutine(
  id: 'no-tempo',
  userId: 'user_id',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isAIGenerated: false,
  title: 'Free-Form Expression',
  description:
      'A practice routine focused on musical expression without strict tempo constraints',
  targetAreas: ['expression', 'creativity', 'musicality'],
  difficulty: 'intermediate',
  estimatedDuration: '18 minutes',
  exercises: [
    PracticeExercise(
      name: 'Expressive Long Tones',
      description: 'Play long tones with dynamic changes and vibrato',
      estimatedDuration: '6 minutes',
      notes: 'Focus on creating beautiful, expressive sounds',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Free Improvisation',
      description: 'Improvise freely without constraints',
      estimatedDuration: '8 minutes',
      notes: 'Let your creativity flow without worrying about mistakes',
      musicalNotation: _musicalNotation,
    ),
    PracticeExercise(
      name: 'Ballad Playing',
      description: 'Play a slow ballad with personal interpretation',
      estimatedDuration: '4 minutes',
      notes: 'Focus on phrasing and emotional expression',
      musicalNotation: _musicalNotation,
    ),
  ],
);
