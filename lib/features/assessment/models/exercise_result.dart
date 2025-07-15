class ExerciseResult {
  final int exerciseId;
  final DateTime completedAt;
  final Duration actualDuration;
  final bool wasCompleted;
  final Map<String, dynamic>? analysisData;
  final String? audioRecordingUrl;

  const ExerciseResult({
    required this.exerciseId,
    required this.completedAt,
    required this.actualDuration,
    required this.wasCompleted,
    this.analysisData,
    this.audioRecordingUrl,
  });

  ExerciseResult copyWith({
    int? exerciseId,
    DateTime? completedAt,
    Duration? actualDuration,
    bool? wasCompleted,
    Map<String, dynamic>? analysisData,
    String? audioRecordingUrl,
  }) {
    return ExerciseResult(
      exerciseId: exerciseId ?? this.exerciseId,
      completedAt: completedAt ?? this.completedAt,
      actualDuration: actualDuration ?? this.actualDuration,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      analysisData: analysisData ?? this.analysisData,
      audioRecordingUrl: audioRecordingUrl ?? this.audioRecordingUrl,
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
        _mapEquals(other.analysisData, analysisData) &&
        other.audioRecordingUrl == audioRecordingUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      exerciseId,
      completedAt,
      actualDuration,
      wasCompleted,
      analysisData,
      audioRecordingUrl,
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

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'completedAt': completedAt.toIso8601String(),
      'actualDuration': actualDuration.inMilliseconds,
      'wasCompleted': wasCompleted,
      'analysisData': analysisData,
      if (audioRecordingUrl != null) 'audioRecordingUrl': audioRecordingUrl,
    };
  }

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      exerciseId: json['exerciseId'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      actualDuration: Duration(milliseconds: json['actualDuration'] as int),
      wasCompleted: json['wasCompleted'] as bool,
      analysisData: json['analysisData'] as Map<String, dynamic>?,
      audioRecordingUrl: json['audioRecordingUrl'] as String?,
    );
  }

  @override
  String toString() {
    return 'ExerciseResult(exerciseId: $exerciseId, completed: $wasCompleted, duration: $actualDuration)';
  }
}