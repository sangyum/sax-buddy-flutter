# Saxophone Learning App - MVP Summary

## Motivation
Self-taught saxophonists lack structured feedback and personalized practice routines. Existing apps only provide basic pitch/timing feedback, but don't generate targeted practice plans based on detected weaknesses.

## Core Value Proposition
AI-powered practice routine generation based on real-time analysis of user's playing, targeting intermediate self-taught players who understand basic music theory.

## Key Features
- **Guided Assessment:** 3-exercise baseline (scale + arpeggio + interval pattern)
- **Real-time Analysis:** Pitch accuracy and timing detection via mobile microphone
- **AI-Generated Routines:** LLM creates personalized scale/arpeggio variations and interval training
- **Visual + Audio Output:** Sheet music notation with reference audio playback
- **Smart Monetization:** 14-day free trial with 3-5 routine limit, then subscription

## User Workflow
1. Open app → Complete 3-exercise guided assessment
2. App analyzes pitch/timing → Sends data to LLM API
3. Receive personalized practice routine with notation + audio
4. Practice with generated exercises
5. (Future iterations: Re-assess and adapt)

## Tech Stack
- **Mobile:** Flutter + Dart
- **Domain Design:** TypeScript interfaces → Dart classes
- **Backend:** Firebase (Auth + Firestore)
- **AI:** OpenAI GPT-4o-mini via dart_openai package
- **Audio:** flutter_sound + pitch detection libraries
- **Payments:** RevenueCat for subscription management
- **Dependency Injection:** get_it + injectable for DI container management

## Development Phases
1. **User Accounts** - Firebase auth, trial tracking, subscription flow - See @docs/PHASE1
2. **Audio Recording/Analysis** - Basic pitch/timing detection prototype - See @docs/PHASE2
3. **LLM Integration** - AI routine generation with structured prompts - See @docs/PHASE3 ✅ **COMPLETED**
4. **Practice Routine Persistence** - Firestore-based routine storage and management - ✅ **COMPLETED**
5. **Notation + Audio** - Sheet music rendering with reference playbook - ✅ **COMPLETED**

## Development Practices

1. Act as a pairing partner for the user. Seek consensus before proceeding
2. Strict Test-Driven Development (TDD)
  * RED - Write a failing test
  * GEEN - Implement with the least amount of code to make the test pass
  * BLUE - Refactor to cleanup/optimize the code

## Project Structure
- Organize UI by feature/screen. Each screen is mapped to a feature and should be placed under lib/features/<feature name>.
- Favor creating small widgets and compose them to build more complex widgets/screens
- Storybook stories are organized in stories/ directory for component development and testing

## Development Tools
- **Storybook**: Run `./scripts/run-storybook.sh` or `flutter run -t stories/main.dart` for component development
- **Testing**: Use `flutter test` to run unit tests (not `uv run`)

### Storybook Component Library
- **Comprehensive Coverage**: Stories for all major UI components including NotationView and ExerciseNotationCard
- **Routine Components**: Complete routine list and detail view stories
- **Notation Components**: Interactive sheet music display with various musical examples
- **Edge Case Testing**: Long titles, many exercises, various difficulty levels, invalid notation data
- **Data Variations**: AI-generated vs manual routines, different exercise types, musical scales and arpeggios
- **Responsive Design**: Stories test component behavior across screen sizes and states

## Dependency Injection Architecture ✅ **COMPLETED**

### DI Implementation
- **Framework**: get_it + injectable for type-safe dependency injection
- **Pattern**: Constructor injection with @injectable annotations
- **Testing**: Mock injection for comprehensive unit testing
- **Configuration**: Auto-generated with build_runner

### Key Services
- **LoggerService**: Structured logging with environment-specific configuration (@singleton)
- **OpenAIService**: AI integration with OpenAI GPT-4o-mini (@singleton)
- **AuthService**: Firebase Auth wrapper (@singleton)
- **UserRepository**: Firestore user data management (@injectable)
- **PracticeRoutineRepository**: Practice routine persistence with CRUD operations (@injectable)
- **AudioRecordingService**: Audio capture and processing (@injectable)
- **AudioAnalysisService**: Real-time audio analysis (@lazySingleton)
- **PracticeGenerationService**: AI-powered routine generation (@lazySingleton)
- **SimpleSheetMusicService**: JSON-to-Measure conversion for sheet music rendering (@lazySingleton)

### DI Setup
```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// lib/injection_module.dart
@module
abstract class InjectionModule {
  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  
  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}
```

### Usage in Code
```dart
// Service usage
final logger = getIt<LoggerService>();
final authService = getIt<AuthService>();

// Provider initialization
ChangeNotifierProvider<AuthProvider>(
  create: (context) => getIt<AuthProvider>(),
)
```

### Configuration Generation
```bash
# Regenerate DI configuration after adding/modifying services
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter packages pub run build_runner watch
```

### Testing
- **Mock Injection**: All services use constructor injection for easy mocking
- **Test Setup**: Each test file creates and injects mock dependencies
- **Coverage**: 200/200 tests passing (100% success rate)

## AI Integration Status ✅ **COMPLETED**

### OpenAI Service Implementation
- **Service Architecture**: Dependency injection pattern with get_it container
- **API Integration**: OpenAI GPT-4o-mini via dart_openai package
- **Environment Config**: API key loaded from `.env` file (`OPENAI_API_KEY`)
- **Error Handling**: Graceful fallback to sample routines if AI generation fails
- **Production Ready**: Comprehensive logging and error handling

### AI-Powered Features
- **Personalized Practice Routines**: Generated based on user's assessment performance
- **Adaptive Difficulty**: Routines adjust based on inferred skill level
- **Smart Fallbacks**: App continues working even if OpenAI service fails
- **Comprehensive Analysis**: Assessment data converted to structured format for AI processing

### Environment Setup
```bash
# Required in .env file
OPENAI_API_KEY=your_openai_api_key_here
```

### Usage
1. Complete assessment exercises
2. App analyzes performance and creates dataset
3. OpenAI generates personalized practice routines
4. User receives AI-powered recommendations
5. If AI fails, fallback routines are provided

## Practice Routine Persistence ✅ **COMPLETED**

### Firestore Data Architecture
- **Collection Structure**: `practice_routines/{userId}/routines/{routineId}`
- **Hierarchical Organization**: User-specific subcollections for efficient querying
- **Document Schema**: Complete practice routine data with metadata
- **Performance Optimization**: Offline persistence and caching enabled

### Repository Pattern Implementation
- **PracticeRoutineRepository**: Full CRUD operations with comprehensive error handling
- **Firestore Integration**: Native Cloud Firestore integration with structured queries
- **Performance Logging**: Detailed operation timing and metadata tracking
- **Error Handling**: Graceful fallbacks with `RepositoryException` wrapper

### Enhanced Data Model
```dart
class PracticeRoutine {
  final String id;              // Unique identifier
  final String userId;          // Owner reference
  final String title;           // Routine name
  final String description;     // Detailed description
  final List<String> targetAreas; // Practice focus areas
  final String difficulty;      // Beginner/Intermediate/Advanced
  final String estimatedDuration; // Expected practice time
  final List<PracticeExercise> exercises; // Exercise list
  final DateTime createdAt;     // Creation timestamp
  final DateTime updatedAt;     // Last modification
  final bool isAIGenerated;     // Generation source tracking
}
```

### Persistence Features
- **Automatic Saving**: Routines saved immediately after AI generation
- **User Context**: User ID automatically set on authentication
- **Background Sync**: Seamless sync between memory and Firestore
- **Offline Support**: In-memory caching for UI responsiveness
- **App Startup Loading**: User routines loaded automatically on dashboard access

### RoutinesProvider Enhancement
- **Dual Storage**: In-memory cache + Firestore persistence
- **Real-time Updates**: Immediate UI updates with background persistence
- **Error Recovery**: Graceful handling of network failures
- **User Management**: Automatic user context management and routine loading

### Repository Operations
```dart
// Create new routine
await repository.createRoutine(routine);

// Load user's routines
final routines = await repository.getUserRoutines(userId);

// Update existing routine
await repository.updateRoutine(routine);

// Delete routine
await repository.deleteRoutine(userId, routineId);
```

### Integration Points
- **Assessment Flow**: Generated routines automatically saved to user's collection
- **Dashboard**: Routines loaded on user authentication
- **Provider Pattern**: Seamless integration with existing state management
- **Testing**: Comprehensive test suite with 100% CRUD operation coverage

## Sheet Music Notation System ✅ **COMPLETED**

### Architecture Overview
- **Package Integration**: Uses `simple_sheet_music` Flutter package for rendering actual sheet music
- **AI-Generated Content**: LLM generates etudes with 4+ measures in structured JSON format
- **Service Layer**: SimpleSheetMusicService converts JSON notation to Measure objects
- **Component Separation**: NotationView receives List<Measure> for clean widget architecture

### Core Components

#### SimpleSheetMusicService
- **JSON Conversion**: Transforms AI-generated JSON into simple_sheet_music Measure objects
- **Error Handling**: Graceful fallbacks for invalid notation data
- **Type Safety**: Proper conversion with comprehensive error checking
- **Dependency Injection**: Registered as @lazySingleton for performance

#### NotationView Widget
- **Interface**: Accepts `List<Measure>?` instead of raw JSON for better separation of concerns
- **Display Options**: Configurable height, width, title, and tempo parameters
- **State Management**: Loading, empty, and error states with appropriate UI feedback
- **Responsive Design**: Adaptive layout that hides title/tempo for small heights

#### ExerciseNotationCard Widget
- **Interactive Display**: Expandable card showing exercise details with optional notation
- **JSON Processing**: Handles conversion from exercise's musical notation to List<Measure>
- **Visual Design**: Duration badges, tempo/key signature display, and smooth animations
- **Error Recovery**: Graceful handling of conversion errors with fallback states

### Data Flow
```
AI Generation → JSON Notation → SimpleSheetMusicService → List<Measure> → NotationView → SimpleSheetMusic Widget
```

### LLM Integration
- **Structured Prompts**: AI generates etudes with minimum 4 measures
- **JSON Schema**: Standardized format compatible with simple_sheet_music package
- **Musical Elements**: Supports notes, accidentals, durations, clefs, and key signatures
- **Fallback Handling**: Sample routines provided when AI generation fails

### Testing & Development
- **Unit Tests**: Comprehensive test suite for NotationView widget (8/8 passing)
- **Storybook Stories**: 
  - 9 NotationView stories covering various scenarios, sizes, and musical examples
  - 9 ExerciseNotationCard stories testing states, interactions, and error handling
- **Component Library**: Interactive development environment for rapid iteration

### Musical Content Support
- **Scales**: Major and minor scales with proper key signatures
- **Arpeggios**: Triad patterns with accidentals and various inversions
- **Complex Exercises**: Mixed note durations, syncopated rhythms, and advanced patterns
- **Error Handling**: Invalid notation data handled gracefully with user feedback

### Performance Optimizations
- **Widget Efficiency**: NotationView uses direct Measure objects to avoid repeated JSON parsing
- **Lazy Loading**: SimpleSheetMusicService registered as singleton for reuse
- **Memory Management**: Efficient handling of large musical notation datasets
- **Responsive Rendering**: Adaptive UI based on available screen space

## Performance Optimization & Architecture Decisions ✅ **COMPLETED**

### Generic LLM Service Architecture
- **OpenAI Service Refactor**: Moved from domain-specific to generic LLM interface (See ADR-001)
- **Separation of Concerns**: Domain logic moved to PracticeGenerationService
- **Generic Methods**: `generateResponse(String prompt)` and `generateBatchResponses(List<String> prompts)`
- **Clean Architecture**: LLM service now purely handles API communication without domain coupling

### Incremental Practice Routine Generation
- **Performance Improvement**: 50-60% faster generation (40-60s → 15-20s)
- **Parallel Processing**: `Future.wait()` for etude generation within each routine
- **Progress Callbacks**: Real-time UI updates with `onRoutineCompleted` callbacks
- **Incremental Delivery**: Users see routines as they complete rather than waiting for full batch
- **Smart Batching**: Parallel etude generation per routine while maintaining personalized content

### Unified Service Architecture Decision
- **PracticeGenerationService**: Handles both routine structure and etude generation (See ADR-002)
- **Domain Cohesion**: Etudes generated with routine context (difficulty, target areas, musical focus)
- **Performance Benefits**: Efficient parallel processing within unified service
- **Simplified Coordination**: Single service manages entire workflow with progress tracking
- **Future Flexibility**: Architecture allows splitting if requirements justify complexity

### Architecture Decision Records
- **ADR-001**: Incremental Practice Routine Generation with Parallel Processing
- **ADR-002**: Unified PracticeGenerationService Architecture
- **Documentation**: `/docs/adr/` contains detailed technical decisions and rationale