// Practice routine models for saxophone learning app
// Now using MusicXML with OSMD for notation rendering

class PracticeRoutine {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> targetAreas;
  final String difficulty;
  final String estimatedDuration;
  final List<PracticeExercise> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAIGenerated;

  const PracticeRoutine({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.targetAreas,
    required this.difficulty,
    required this.estimatedDuration,
    required this.exercises,
    required this.createdAt,
    required this.updatedAt,
    required this.isAIGenerated,
  });

  factory PracticeRoutine.fromJson(Map<String, dynamic> json) {
    return PracticeRoutine(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetAreas: List<String>.from(json['targetAreas'] as List? ?? []),
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      estimatedDuration: json['estimatedDuration'] as String? ?? '20 minutes',
      exercises: (json['exercises'] as List? ?? [])
          .map(
            (exercise) =>
                PracticeExercise.fromJson(exercise as Map<String, dynamic>),
          )
          .toList(),
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      isAIGenerated: json['isAIGenerated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'targetAreas': targetAreas,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isAIGenerated': isAIGenerated,
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
  final String? musicalConcept;
  String? musicXML;

  PracticeExercise({
    required this.name,
    required this.description,
    this.tempo,
    this.keySignature,
    this.notes,
    required this.estimatedDuration,
    this.musicalConcept,
    this.musicXML,
  });

  factory PracticeExercise.fromJson(Map<String, dynamic> json) {
    return PracticeExercise(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tempo: json['tempo'] as String?,
      keySignature: json['keySignature'] as String?,
      notes: json['notes'] as String?,
      estimatedDuration: json['estimatedDuration'] as String? ?? '10 minutes',
      musicalConcept: json['musicalConcept'] as String?,
      musicXML: json['musicXML'] as String?,
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
      if (musicalConcept != null) 'musicalConcept': musicalConcept,
      if (musicXML != null) 'musicXML': musicXML,
    };
  }

  @override
  String toString() {
    return 'PracticeExercise(name: $name, duration: $estimatedDuration)';
  }
}

class PracticeExerciseException implements Exception {
  final String message;
  const PracticeExerciseException(this.message);
  @override
  String toString() => 'PracticeExerciseException: $message';
}