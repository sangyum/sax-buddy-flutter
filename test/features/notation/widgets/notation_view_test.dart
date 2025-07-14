import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';

void main() {
  group('NotationView', () {

    const sampleMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>Test Exercise</work-title>
  </work>
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
        <key>
          <fifths>0</fifths>
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
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

    testWidgets('should create notation view widget with MusicXML', (WidgetTester tester) async {
      // Test that the widget can be created with proper parameters
      const widget = NotationView(
        musicXML: sampleMusicXML,
        tempo: 120,
        title: 'Test Exercise',
      );
      
      expect(widget.musicXML, equals(sampleMusicXML));
      expect(widget.tempo, equals(120));
      expect(widget.title, equals('Test Exercise'));
      expect(widget.isLoading, isFalse);
    });

    testWidgets('should create notation view in loading state', (WidgetTester tester) async {
      // Test that the widget can be created in loading state
      const widget = NotationView(
        isLoading: true,
        title: 'Loading Exercise',
      );
      
      expect(widget.isLoading, isTrue);
      expect(widget.title, equals('Loading Exercise'));
      expect(widget.musicXML, isNull);
    });

    testWidgets('should handle null MusicXML', (WidgetTester tester) async {
      // Test that the widget can handle null MusicXML
      const widget = NotationView(
        musicXML: null,
        title: 'Empty Exercise',
      );
      
      expect(widget.musicXML, isNull);
      expect(widget.title, equals('Empty Exercise'));
      expect(widget.isLoading, isFalse);
    });

    testWidgets('should handle empty MusicXML', (WidgetTester tester) async {
      // Test that the widget can handle empty MusicXML
      const widget = NotationView(
        musicXML: '',
        title: 'Empty Exercise',
      );
      
      expect(widget.musicXML, equals(''));
      expect(widget.title, equals('Empty Exercise'));
      expect(widget.isLoading, isFalse);
    });

    testWidgets('should create different widgets with different properties', (WidgetTester tester) async {
      // Test that different widgets have different properties
      const widget1 = NotationView(
        musicXML: sampleMusicXML,
        title: 'Exercise 1',
      );
      
      const newMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>Updated Exercise</work-title>
  </work>
</score-partwise>''';
      
      const widget2 = NotationView(
        musicXML: newMusicXML,
        title: 'Exercise 2',
      );
      
      expect(widget1.musicXML, equals(sampleMusicXML));
      expect(widget1.title, equals('Exercise 1'));
      expect(widget2.musicXML, equals(newMusicXML));
      expect(widget2.title, equals('Exercise 2'));
      expect(widget1.musicXML, isNot(equals(widget2.musicXML)));
    });
  });
}