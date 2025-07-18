import 'exercise_result.dart';

enum SkillLevel {
  beginner,
  intermediate,
  advanced,
}

class AssessmentResult {
  final String sessionId;
  final DateTime completedAt;
  final List<ExerciseResult> exerciseResults;
  final SkillLevel skillLevel;
  final List<String> strengths;
  final List<String> weaknesses;
  final String? notes;

  const AssessmentResult({
    required this.sessionId,
    required this.completedAt,
    required this.exerciseResults,
    required this.skillLevel,
    required this.strengths,
    required this.weaknesses,
    this.notes,
  });

  AssessmentResult copyWith({
    String? sessionId,
    DateTime? completedAt,
    List<ExerciseResult>? exerciseResults,
    SkillLevel? skillLevel,
    List<String>? strengths,
    List<String>? weaknesses,
    String? notes,
  }) {
    return AssessmentResult(
      sessionId: sessionId ?? this.sessionId,
      completedAt: completedAt ?? this.completedAt,
      exerciseResults: exerciseResults ?? this.exerciseResults,
      skillLevel: skillLevel ?? this.skillLevel,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      notes: notes ?? this.notes,
    );
  }

  bool get allExercisesCompleted => 
      exerciseResults.length == 4 && 
      exerciseResults.every((result) => result.wasCompleted);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssessmentResult &&
        other.sessionId == sessionId &&
        other.completedAt == completedAt &&
        _listEquals(other.exerciseResults, exerciseResults) &&
        other.skillLevel == skillLevel &&
        _listEquals(other.strengths, strengths) &&
        _listEquals(other.weaknesses, weaknesses) &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      sessionId,
      completedAt,
      exerciseResults,
      skillLevel,
      strengths,
      weaknesses,
      notes,
    );
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'AssessmentResult(sessionId: $sessionId, skillLevel: $skillLevel, exercisesCompleted: ${exerciseResults.length}/4)';
  }
}