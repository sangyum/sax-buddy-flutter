# Sheet Music Notation Implementation Plan

## Phase 1: Musical Domain Models & Data Enhancement
**Goal**: Extend the existing PracticeExercise model to support musical notation data

1. **Create musical domain models** in `lib/features/notation/domain/`:
   - `MusicalNote` - pitch, octave, accidental, duration
   - `MusicalMeasure` - notes, time signature, key signature
   - `SheetMusicData` - sequence of measures with metadata
   - `NotationMetadata` - clef (treble for sax), tempo markings

2. **Extend PracticeExercise model** to include:
   - `sheetMusicData`: SheetMusicData? - actual note sequences
   - Keep existing fields (tempo, keySignature, notes) for backward compatibility

## Phase 2: Music Notation Package Integration
**Goal**: Integrate a Flutter sheet music rendering solution

1. **Evaluate and integrate `simple_sheet_music` package**:
   - Add dependency to pubspec.yaml
   - Create proof-of-concept notation display
   - Test with basic saxophone exercises (scales, arpeggios)

2. **Create notation display widgets**:
   - `NotationView` - displays sheet music from SheetMusicData
   - `ExerciseNotationCard` - integrates with existing exercise UI
   - Handle loading states and fallbacks for exercises without notation

## Phase 3: Notation Generation Service
**Goal**: Convert text-based exercise descriptions to actual musical notation

1. **Create NotationGenerationService** with dependency injection:
   - Scale generator: "C Major scale" → note sequence (C-D-E-F-G-A-B-C)
   - Arpeggio generator: "C Major arpeggio" → chord tones (C-E-G-C)
   - Pattern generator: Handle interval training and chromatic exercises
   - Leverage existing tempo/keySignature fields from PracticeExercise

2. **Integrate with existing AI system**:
   - Update OpenAI prompts to request specific note sequences
   - Enhance PracticeGenerationService to populate notation data
   - Add fallback generation for non-AI exercises

## Phase 4: UI Integration & Testing
**Goal**: Seamlessly integrate notation display into existing routine workflow

1. **Update existing screens**:
   - Routine detail screen: Add notation display below exercise descriptions
   - Exercise cards: Show notation preview with expand option
   - Maintain existing UI patterns and design consistency

2. **Comprehensive testing**:
   - Unit tests for notation generation service
   - Widget tests for notation display components
   - Integration tests for end-to-end exercise flow
   - Test with all exercise types (scales, arpeggios, long tones, etc.)

## Technical Benefits
- **Incremental approach**: Builds on existing architecture without breaking changes
- **Backward compatibility**: Existing exercises continue working without notation
- **Performance conscious**: Notation data only loaded when needed
- **TDD aligned**: Each phase includes comprehensive test coverage
- **Flutter native**: Uses established Flutter patterns and dependency injection

## Implementation Priority
1. Start with most common exercise types: major scales, arpeggios, chromatic scales
2. Add advanced exercises: intervals, complex rhythms, extended techniques
3. Future: PDF export, audio-notation sync, interactive notation features

This plan transforms text-based practice descriptions into visual sheet music while maintaining the existing app architecture and user experience.

## Implementation Status

### ✅ Phase 1: Musical Domain Models & Data Enhancement (COMPLETED)
**Musical Domain Models Created:**
- `MusicalNote` - Represents musical notes with pitch, octave, accidental, and duration
- `MusicalMeasure` - Contains notes with time and key signatures
- `SheetMusicData` - Complete sheet music with measures and metadata
- `NotationMetadata` - Clef, tempo, title, and composer information

**PracticeExercise Model Enhanced:**
- Added optional `sheetMusicData` field to PracticeExercise
- Maintains backward compatibility with existing exercises
- Full JSON serialization support for persistence

**Test Coverage:**
- 100% test coverage for all musical domain models
- Comprehensive JSON serialization/deserialization tests
- Backward compatibility tests for existing exercise data

### ✅ Phase 2: Music Notation Package Integration (COMPLETED)
**Package Integration:**
- Added `simple_sheet_music: ^1.0.1` dependency for Flutter-native notation rendering
- Created responsive `NotationView` widget for displaying sheet music
- Built `ExerciseNotationCard` widget integrating notation with existing exercise UI

**Notation Display Features:**
- Responsive design adapting to different container sizes
- Loading states and graceful fallbacks for missing notation data
- Expandable notation view with show/hide functionality
- Displays exercise metadata (title, tempo, measure count)

**Widget Architecture:**
- `NotationView` - Core sheet music display component
- `ExerciseNotationCard` - Enhanced exercise card with notation toggle
- Fully tested with comprehensive widget tests

**Integration with Existing UI:**
- Seamless integration with current exercise display patterns
- Maintains existing design consistency and user experience
- Ready for integration into routine detail screens

### ✅ Phase 3: Notation Generation Service (COMPLETED)
**NotationGenerationService Implementation:**
- Created comprehensive `NotationGenerationService` with dependency injection (@lazySingleton)
- Implemented scale generators (major, minor, chromatic) for all common keys
- Built arpeggio generators (major, minor, dominant 7th chords)
- Added long tone and interval training exercise generators
- Comprehensive error handling and input validation

**Musical Generation Features:**
- **Scale Generation**: Major, minor, and chromatic scales in all keys
- **Arpeggio Generation**: Major, minor, and 7th chord arpeggios
- **Long Tone Exercises**: Sustained note sequences for breath control
- **Interval Training**: Perfect 4ths, 5ths, and octaves
- **Smart Key Handling**: Supports both letter names (C, F) and flat keys (BB, EB)
- **Accidental Logic**: Prefers sharps or flats based on key signature context

**Integration Capabilities:**
- Seamless integration with existing `PracticeExercise` model
- JSON serialization for Firestore persistence
- Pattern recognition for automatic notation generation from exercise names
- Backward compatibility with exercises that don't have notation

**Test Coverage:**
- 20/20 tests passing for NotationGenerationService
- 4/4 integration tests demonstrating real-world usage
- Comprehensive coverage of scale, arpeggio, and interval generation
- Error handling validation for invalid inputs

**Storybook Integration:**
- Interactive notation generator story with live controls
- Demonstrates all generation types with real-time updates
- Parameter controls for key, scale type, chord type, and tempo

### ⏳ Phase 4: UI Integration & Testing (PENDING)
**Planned Features:**
- Integration with routine detail screens
- Storybook stories for notation components
- End-to-end testing with generated routines
- Performance optimization for large notation datasets

## Research Findings

### Flutter Sheet Music Libraries
- **simple_sheet_music** (Recommended): Production-ready Flutter package with treble clef support
- **music_notes**: Comprehensive music theory + basic rendering capabilities
- **VexFlow**: Web-based solution via WebView integration
- **CustomPainter**: Full control approach for saxophone-specific notation

### Current Exercise Types Requiring Notation
Based on existing practice routines:
- Major/minor scales in all keys
- Chromatic scales
- Arpeggios (major/minor)
- Interval training (4ths, 5ths, octaves)
- Long tones (sustained notes)
- Articulation patterns
- Rhythmic exercises
- Blues scales
- Breathing exercises (non-notated)