import 'musical_measure.dart';

/// Complete sheet music data including measures and metadata
class SheetMusicData {
  final List<MusicalMeasure> measures;
  final NotationMetadata metadata;

  const SheetMusicData({
    required this.measures,
    required this.metadata,
  });

  factory SheetMusicData.fromJson(Map<String, dynamic> json) {
    return SheetMusicData(
      measures: (json['measures'] as List? ?? [])
          .map((measureJson) => MusicalMeasure.fromJson(measureJson as Map<String, dynamic>))
          .toList(),
      metadata: NotationMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'measures': measures.map((measure) => measure.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }

  @override
  String toString() {
    return 'SheetMusicData(measures: ${measures.length}, title: ${metadata.title})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SheetMusicData &&
        _listEquals(other.measures, measures) &&
        other.metadata == metadata;
  }

  @override
  int get hashCode => Object.hash(measures, metadata);

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Metadata for sheet music notation display
class NotationMetadata {
  final Clef clef;
  final int tempo;
  final String title;
  final String? composer;

  const NotationMetadata({
    required this.clef,
    required this.tempo,
    required this.title,
    this.composer,
  });

  factory NotationMetadata.fromJson(Map<String, dynamic> json) {
    return NotationMetadata(
      clef: Clef.values.byName(json['clef'] as String),
      tempo: json['tempo'] as int,
      title: json['title'] as String,
      composer: json['composer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clef': clef.name,
      'tempo': tempo,
      'title': title,
      if (composer != null) 'composer': composer,
    };
  }

  @override
  String toString() {
    return 'NotationMetadata(title: $title, tempo: $tempo, clef: ${clef.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotationMetadata &&
        other.clef == clef &&
        other.tempo == tempo &&
        other.title == title &&
        other.composer == composer;
  }

  @override
  int get hashCode => Object.hash(clef, tempo, title, composer);
}

/// Musical clefs for notation display
enum Clef {
  treble,  // For saxophone and most melodic instruments
  bass,    // For low instruments
}