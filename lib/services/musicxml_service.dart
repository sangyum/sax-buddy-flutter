import 'package:injectable/injectable.dart';
import 'package:sax_buddy/services/logger_service.dart';

@lazySingleton
class MusicXMLService {
  final LoggerService _logger;

  MusicXMLService(this._logger);

  /// Validate MusicXML structure
  bool isValidMusicXML(String? musicXML) {
    if (musicXML == null || musicXML.isEmpty) {
      return false;
    }

    try {
      // Basic validation - check for required MusicXML elements
      final hasRootElement = musicXML.contains('<score-partwise>') || 
                            musicXML.contains('<score-timewise>');
      final hasPartList = musicXML.contains('<part-list>');
      final hasPart = musicXML.contains('<part ');
      final hasMeasure = musicXML.contains('<measure ');

      return hasRootElement && hasPartList && hasPart && hasMeasure;
    } catch (e) {
      _logger.error('Error validating MusicXML: $e');
      return false;
    }
  }

  /// Clean and format MusicXML for display
  String? processMusicXML(String? musicXML) {
    if (musicXML == null || musicXML.isEmpty) {
      _logger.warning('No MusicXML provided for processing');
      return null;
    }

    try {
      // Remove any leading/trailing whitespace
      String cleaned = musicXML.trim();

      // Ensure proper XML declaration if missing
      if (!cleaned.startsWith('<?xml')) {
        cleaned = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n$cleaned';
      }

      // Validate the cleaned XML
      if (!isValidMusicXML(cleaned)) {
        _logger.warning('Invalid MusicXML structure detected');
        return null;
      }

      _logger.debug('MusicXML processed successfully');
      return cleaned;

    } catch (e) {
      _logger.error('Error processing MusicXML: $e');
      return null;
    }
  }

  /// Extract metadata from MusicXML
  Map<String, dynamic> extractMetadata(String? musicXML) {
    final metadata = <String, dynamic>{
      'title': null,
      'tempo': null,
      'keySignature': null,
      'timeSignature': null,
      'measureCount': 0,
    };

    if (musicXML == null || musicXML.isEmpty) {
      return metadata;
    }

    try {
      // Extract title from work-title or movement-title
      final titleMatch = RegExp(r'<work-title>(.*?)</work-title>').firstMatch(musicXML) ??
                        RegExp(r'<movement-title>(.*?)</movement-title>').firstMatch(musicXML);
      if (titleMatch != null) {
        metadata['title'] = titleMatch.group(1);
      }

      // Extract tempo from metronome marking
      final tempoMatch = RegExp(r'<per-minute>(\d+)</per-minute>').firstMatch(musicXML);
      if (tempoMatch != null) {
        metadata['tempo'] = int.tryParse(tempoMatch.group(1) ?? '');
      }

      // Extract key signature (fifths)
      final keyMatch = RegExp(r'<fifths>(-?\d+)</fifths>').firstMatch(musicXML);
      if (keyMatch != null) {
        final fifths = int.tryParse(keyMatch.group(1) ?? '0') ?? 0;
        metadata['keySignature'] = _fifthsToKeySignature(fifths);
      }

      // Extract time signature
      final beatsMatch = RegExp(r'<beats>(\d+)</beats>').firstMatch(musicXML);
      final beatTypeMatch = RegExp(r'<beat-type>(\d+)</beat-type>').firstMatch(musicXML);
      if (beatsMatch != null && beatTypeMatch != null) {
        metadata['timeSignature'] = '${beatsMatch.group(1)}/${beatTypeMatch.group(1)}';
      }

      // Count measures
      final measureMatches = RegExp(r'<measure ').allMatches(musicXML);
      metadata['measureCount'] = measureMatches.length;

      _logger.debug('Extracted metadata: $metadata');
      return metadata;

    } catch (e) {
      _logger.error('Error extracting metadata from MusicXML: $e');
      return metadata;
    }
  }

  /// Convert fifths value to key signature name
  String _fifthsToKeySignature(int fifths) {
    const keyMap = {
      -7: 'C♭ major',
      -6: 'G♭ major',
      -5: 'D♭ major',
      -4: 'A♭ major',
      -3: 'E♭ major',
      -2: 'B♭ major',
      -1: 'F major',
      0: 'C major',
      1: 'G major',
      2: 'D major',
      3: 'A major',
      4: 'E major',
      5: 'B major',
      6: 'F♯ major',
      7: 'C♯ major',
    };

    return keyMap[fifths] ?? 'Unknown';
  }

  /// Generate sample MusicXML for testing
  String generateSampleMusicXML({
    String title = 'Sample Exercise',
    int tempo = 120,
    String keySignature = 'C major',
  }) {
    final fifths = _keySignatureToFifths(keySignature);
    
    return '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>$title</work-title>
  </work>
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
      <part-abbreviation>Sax.</part-abbreviation>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
        <key>
          <fifths>$fifths</fifths>
        </key>
        <time>
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
        <clef>
          <sign>G</sign>
          <line>2</line>
        </clef>
      </attributes>
      <direction placement="above">
        <direction-type>
          <metronome>
            <beat-unit>quarter</beat-unit>
            <per-minute>$tempo</per-minute>
          </metronome>
        </direction-type>
      </direction>
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>E</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
    <measure number="2">
      <note>
        <pitch>
          <step>G</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>B</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>C</step>
          <octave>5</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
    <measure number="3">
      <note>
        <pitch>
          <step>B</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>G</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
    <measure number="4">
      <note>
        <pitch>
          <step>E</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>2</duration>
        <type>half</type>
      </note>
    </measure>
  </part>
</score-partwise>''';
  }

  /// Convert key signature name to fifths value
  int _keySignatureToFifths(String keySignature) {
    const keyMap = {
      'C♭ major': -7,
      'G♭ major': -6,
      'D♭ major': -5,
      'A♭ major': -4,
      'E♭ major': -3,
      'B♭ major': -2,
      'F major': -1,
      'C major': 0,
      'G major': 1,
      'D major': 2,
      'A major': 3,
      'E major': 4,
      'B major': 5,
      'F♯ major': 6,
      'C♯ major': 7,
    };

    return keyMap[keySignature] ?? 0;
  }

  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'service': 'MusicXMLService',
      'timestamp': DateTime.now().toIso8601String(),
      'ready': true,
    };
  }
}