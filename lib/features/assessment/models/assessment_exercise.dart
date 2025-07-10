class AssessmentExercise {
  final int id;
  final String title;
  final String instructions;
  final Duration duration;
  final int? tempo;
  final List<String> focusAreas;

  const AssessmentExercise({
    required this.id,
    required this.title,
    required this.instructions,
    required this.duration,
    this.tempo,
    required this.focusAreas,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssessmentExercise &&
        other.id == id &&
        other.title == title &&
        other.instructions == instructions &&
        other.duration == duration &&
        other.tempo == tempo &&
        _listEquals(other.focusAreas, focusAreas);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      instructions,
      duration,
      tempo,
      focusAreas,
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
    return 'AssessmentExercise(id: $id, title: $title, duration: $duration, tempo: $tempo)';
  }
}