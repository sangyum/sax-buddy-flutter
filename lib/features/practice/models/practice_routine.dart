class PracticeRoutine {
  final String title;
  final String description;
  final List<String> targetAreas;
  final String difficulty;
  final String estimatedDuration;
  final List<PracticeExercise> exercises;

  const PracticeRoutine({
    required this.title,
    required this.description,
    required this.targetAreas,
    required this.difficulty,
    required this.estimatedDuration,
    required this.exercises,
  });

  factory PracticeRoutine.fromJson(Map<String, dynamic> json) {
    return PracticeRoutine(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetAreas: List<String>.from(json['targetAreas'] as List? ?? []),
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      estimatedDuration: json['estimatedDuration'] as String? ?? '20 minutes',
      exercises: (json['exercises'] as List? ?? [])
          .map((exercise) => PracticeExercise.fromJson(exercise as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'targetAreas': targetAreas,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'PracticeRoutine(title: $title, exercises: ${exercises.length})';
  }
}

class PracticeExercise {
  final String name;
  final String description;
  final String? tempo;
  final String? keySignature;
  final String? notes;
  final String estimatedDuration;

  const PracticeExercise({
    required this.name,
    required this.description,
    this.tempo,
    this.keySignature,
    this.notes,
    required this.estimatedDuration,
  });

  factory PracticeExercise.fromJson(Map<String, dynamic> json) {
    return PracticeExercise(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tempo: json['tempo'] as String?,
      keySignature: json['keySignature'] as String?,
      notes: json['notes'] as String?,
      estimatedDuration: json['estimatedDuration'] as String? ?? '10 minutes',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (tempo != null) 'tempo': tempo,
      if (keySignature != null) 'keySignature': keySignature,
      if (notes != null) 'notes': notes,
      'estimatedDuration': estimatedDuration,
    };
  }

  @override
  String toString() {
    return 'PracticeExercise(name: $name, duration: $estimatedDuration)';
  }
}