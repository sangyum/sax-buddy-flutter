class ExerciseResult {
  final int exerciseId;
  final DateTime completedAt;
  final Duration actualDuration;
  final bool wasCompleted;
  final Map<String, dynamic>? analysisData;

  const ExerciseResult({
    required this.exerciseId,
    required this.completedAt,
    required this.actualDuration,
    required this.wasCompleted,
    this.analysisData,
  });

  ExerciseResult copyWith({
    int? exerciseId,
    DateTime? completedAt,
    Duration? actualDuration,
    bool? wasCompleted,
    Map<String, dynamic>? analysisData,
  }) {
    return ExerciseResult(
      exerciseId: exerciseId ?? this.exerciseId,
      completedAt: completedAt ?? this.completedAt,
      actualDuration: actualDuration ?? this.actualDuration,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      analysisData: analysisData ?? this.analysisData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseResult &&
        other.exerciseId == exerciseId &&
        other.completedAt == completedAt &&
        other.actualDuration == actualDuration &&
        other.wasCompleted == wasCompleted &&
        _mapEquals(other.analysisData, analysisData);
  }

  @override
  int get hashCode {
    return Object.hash(
      exerciseId,
      completedAt,
      actualDuration,
      wasCompleted,
      analysisData,
    );
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'ExerciseResult(exerciseId: $exerciseId, completed: $wasCompleted, duration: $actualDuration)';
  }
}