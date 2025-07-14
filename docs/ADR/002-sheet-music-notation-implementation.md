---
status: "accepted"
date: 2025-07-10
decision-makers: ["Development Team"]
consulted: ["Music Education Experts", "Flutter Community"]
informed: ["All Contributors"]
---

# Implement Sheet Music Notation with simple_sheet_music Package

## Context and Problem Statement

The saxophone learning application needed to display visual sheet music notation for AI-generated practice exercises. Users required visual representation of scales, arpeggios, and interval training exercises to complement text-based descriptions. The implementation needed to integrate seamlessly with existing architecture while providing professional-quality notation display for effective music education.

## Decision Drivers

* Need for visual sheet music display to enhance learning effectiveness
* Requirement for Flutter-native solution with no external dependencies
* Integration with existing PracticeExercise model and AI-generated routines
* Backward compatibility with existing exercise data
* Comprehensive test coverage following TDD practices
* Performance considerations for mobile devices

## Considered Options

* Implement simple_sheet_music package for Flutter-native notation
* Use WebView-based solution with music notation JavaScript libraries
* Build custom notation rendering with CustomPainter
* Integrate third-party commercial notation SDKs

## Decision Outcome

Chosen option: "simple_sheet_music package implementation", because it provides Flutter-native notation rendering without external dependencies, integrates seamlessly with existing architecture through dependency injection, supports comprehensive musical notation generation, and maintains backward compatibility while delivering professional-quality sheet music display.

### Consequences

* Good, because provides Flutter-native solution with no WebView overhead
* Good, because integrates seamlessly with existing PracticeExercise model
* Good, because supports comprehensive musical notation generation (scales, arpeggios, intervals)
* Good, because maintains backward compatibility with existing exercise data
* Good, because enables responsive design adapting to different screen sizes
* Good, because provides comprehensive test coverage with TDD approach
* Good, because supports JSON serialization for Firestore persistence
* Neutral, because requires custom notation generation service implementation
* Bad, because has limitations compared to professional music notation software
* Bad, because requires maintenance of custom musical generation logic

### Confirmation

Implementation success validated through:
- 100% test coverage for musical domain models and generation services
- Widget tests demonstrating responsive notation display
- Integration tests with existing PracticeExercise model
- Storybook stories showing all notation types and edge cases
- Performance testing on various device sizes and orientations

## Pros and Cons of the Options

### simple_sheet_music Package

Flutter-native package for music notation rendering with comprehensive generation service.

* Good, because Flutter-native with no external dependencies or WebView overhead
* Good, because integrates seamlessly with existing Flutter architecture
* Good, because supports dependency injection pattern with get_it
* Good, because comprehensive musical notation generation (scales, arpeggios, intervals)
* Good, because JSON serialization support for Firestore persistence
* Good, because backward compatibility with existing exercise data
* Good, because responsive design adapting to different container sizes
* Good, because production-ready with treble clef support suitable for saxophone
* Neutral, because requires custom NotationGenerationService implementation
* Bad, because limited compared to professional music notation software features
* Bad, because requires ongoing maintenance of musical generation logic

### WebView-Based Solution

Integration with JavaScript music notation libraries through WebView.

* Good, because access to mature JavaScript music notation libraries
* Good, because professional-quality rendering capabilities
* Good, because extensive customization options
* Neutral, because requires JavaScript bridge development
* Bad, because WebView performance overhead on mobile devices
* Bad, because platform-specific rendering differences
* Bad, because increased application complexity with web-native bridge
* Bad, because dependency on web technologies in mobile application

### Custom Notation with CustomPainter

Build custom music notation rendering using Flutter's CustomPainter.

* Good, because complete control over rendering and appearance
* Good, because optimal performance with native Flutter rendering
* Good, because no external dependencies
* Neutral, because requires deep understanding of music notation standards
* Bad, because very high implementation complexity
* Bad, because significant development time for professional-quality output
* Bad, because requires expertise in both Flutter graphics and music theory
* Bad, because maintenance burden for custom rendering engine

### Commercial Notation SDKs

Integration with third-party commercial music notation solutions.

* Good, because professional-grade notation rendering
* Good, because comprehensive feature sets
* Good, because industry-standard quality
* Neutral, because may require platform-specific integration
* Bad, because licensing costs for commercial solutions
* Bad, because external dependencies and vendor lock-in
* Bad, because integration complexity with Flutter applications
* Bad, because overkill for saxophone learning application requirements

## More Information

### Implementation Phases

**Phase 1: Musical Domain Models & Data Enhancement (COMPLETED)**
- Created comprehensive musical domain models (MusicalNote, MusicalMeasure, SheetMusicData)
- Enhanced PracticeExercise model with optional sheetMusicData field
- Implemented full JSON serialization for Firestore persistence
- Achieved 100% test coverage for all domain models

**Phase 2: Music Notation Package Integration (COMPLETED)**
- Integrated simple_sheet_music package for Flutter-native rendering
- Created responsive NotationView widget with adaptive sizing
- Built ExerciseNotationCard widget for existing UI integration
- Implemented comprehensive error handling and fallback states

**Phase 3: Notation Generation Service (COMPLETED)**
- Implemented NotationGenerationService with dependency injection
- Created generators for scales (major, minor, chromatic), arpeggios, and intervals
- Added smart key handling supporting both letter names and flat keys
- Achieved 20/20 test coverage with comprehensive generation validation

**Phase 4: UI Integration & Testing (COMPLETED)**
- Integrated notation display into existing exercise workflow
- Created comprehensive Storybook stories for all notation components
- Implemented responsive design for various screen sizes
- Added interactive notation generator with live parameter controls

### Technical Architecture

**Data Flow:**
```
Exercise Description → NotationGenerationService → SheetMusicData → NotationView → simple_sheet_music Widget
```

**Service Integration:**
```dart
@lazySingleton
class NotationGenerationService {
  SheetMusicData generateScale(String key, String scaleType);
  SheetMusicData generateArpeggio(String key, String chordType);
  SheetMusicData generateInterval(String startNote, String intervalType);
}
```

### Musical Generation Capabilities

**Scale Generation:**
- Major, minor, and chromatic scales in all keys
- Proper accidental handling based on key signature context
- Support for both traditional (C, F) and flat (BB, EB) key naming

**Arpeggio Generation:**
- Major, minor, and dominant 7th chord arpeggios
- Proper voice leading and chord tone selection
- Integration with saxophone range and transposition

**Exercise Types:**
- Long tone exercises for breath control development
- Interval training (perfect 4ths, 5ths, octaves)
- Pattern recognition for automatic notation generation
- Backward compatibility with non-notated exercises

### Integration Points

**Existing Architecture:**
- Seamless integration with current PracticeExercise model
- Dependency injection using get_it container
- JSON serialization for Firestore persistence
- Provider pattern compatibility for state management

**User Experience:**
- Responsive notation display adapting to screen size
- Expandable notation view with show/hide functionality
- Loading states and graceful error handling
- Consistent design with existing UI patterns

This implementation provides comprehensive sheet music notation capability while maintaining architectural consistency and delivering professional-quality musical education features for saxophone learners.