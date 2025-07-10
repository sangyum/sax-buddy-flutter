import 'exercise_result.dart';

enum AssessmentSessionState {
  notStarted,
  inProgress,
  completed,
  cancelled,
}

class AssessmentSession {
  final String id;
  final DateTime startTime;
  final int currentExerciseIndex;
  final List<ExerciseResult> completedExercises;
  final AssessmentSessionState state;

  const AssessmentSession({
    required this.id,
    required this.startTime,
    required this.currentExerciseIndex,
    required this.completedExercises,
    required this.state,
  });

  AssessmentSession copyWith({
    String? id,
    DateTime? startTime,
    int? currentExerciseIndex,
    List<ExerciseResult>? completedExercises,
    AssessmentSessionState? state,
  }) {
    return AssessmentSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      completedExercises: completedExercises ?? this.completedExercises,
      state: state ?? this.state,
    );
  }

  bool get isCompleted => completedExercises.length == 4;
  bool get canProceedToNext => currentExerciseIndex < 3;
  bool get canGoToPrevious => currentExerciseIndex > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssessmentSession &&
        other.id == id &&
        other.startTime == startTime &&
        other.currentExerciseIndex == currentExerciseIndex &&
        _listEquals(other.completedExercises, completedExercises) &&
        other.state == state;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      startTime,
      currentExerciseIndex,
      completedExercises,
      state,
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
    return 'AssessmentSession(id: $id, currentIndex: $currentExerciseIndex, state: $state)';
  }
}