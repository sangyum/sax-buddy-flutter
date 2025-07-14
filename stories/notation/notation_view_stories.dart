import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';

final List<Story> notationViewStories = [
  Story(
    name: 'NotationView/C Major Scale',
    description: 'NotationView displaying a C major scale exercise',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          musicXML: _cMajorScaleMusicXML,
          tempo: 120,
          title: 'C Major Scale',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/D Major Arpeggio',
    description: 'NotationView showing a D major arpeggio with sharps',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          musicXML: _dMajorArpeggioMusicXML,
          tempo: 100,
          title: 'D Major Arpeggio',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Complex Exercise',
    description: 'NotationView with mixed note durations and accidentals',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          musicXML: _complexExerciseMusicXML,
          tempo: 140,
          title: 'Complex Exercise',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Loading State',
    description: 'NotationView in loading state',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const NotationView(
          isLoading: true,
          title: 'Loading Exercise',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Empty State',
    description: 'NotationView with no MusicXML data',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const NotationView(
          musicXML: null,
          title: 'Empty Exercise',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Small Height',
    description: 'NotationView with constrained height (300px)',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: NotationView(
          musicXML: _cMajorScaleMusicXML,
          tempo: 120,
          title: 'Constrained Height',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/F Major Scale',
    description: 'NotationView with one flat (F major scale)',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          musicXML: _fMajorScaleMusicXML,
          tempo: 110,
          title: 'F Major Scale',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Bb Major Scale',
    description: 'NotationView with two flats (Bb major scale)',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          musicXML: _bbMajorScaleMusicXML,
          tempo: 100,
          title: 'Bb Major Scale',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Long Title',
    description: 'NotationView with very long title to test text overflow',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          musicXML: _cMajorScaleMusicXML,
          tempo: 120,
          title: 'This is a Very Long Exercise Title That Should Test Text Overflow Behavior',
        ),
      );
    },
  ),
];

// Sample MusicXML data for stories

const String _cMajorScaleMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>C Major Scale</work-title>
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
      <direction placement="above">
        <direction-type>
          <metronome>
            <beat-unit>quarter</beat-unit>
            <per-minute>120</per-minute>
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
  </part>
</score-partwise>''';

const String _dMajorArpeggioMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>D Major Arpeggio</work-title>
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
          <fifths>2</fifths>
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
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <alter>1</alter>
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
          <step>D</step>
          <octave>5</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

const String _complexExerciseMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>Complex Exercise</work-title>
  </work>
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>2</divisions>
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
        <type>eighth</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <alter>1</alter>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>eighth</type>
        <accidental>sharp</accidental>
      </note>
      <note>
        <pitch>
          <step>E</step>
          <octave>4</octave>
        </pitch>
        <duration>2</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>4</duration>
        <type>half</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

const String _fMajorScaleMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>F Major Scale</work-title>
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
          <fifths>-1</fifths>
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
          <step>F</step>
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
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>B</step>
          <alter>-1</alter>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

const String _bbMajorScaleMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>Bb Major Scale</work-title>
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
          <fifths>-2</fifths>
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
          <step>B</step>
          <alter>-1</alter>
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
      <note>
        <pitch>
          <step>D</step>
          <octave>5</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>E</step>
          <alter>-1</alter>
          <octave>5</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
  </part>
</score-partwise>''';