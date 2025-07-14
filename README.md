# SaxBuddy - AI-Powered Saxophone Learning App

An intelligent Flutter application that provides personalized saxophone practice routines through AI-powered analysis of user performance.

## Overview

SaxBuddy helps self-taught saxophonists improve their skills through:
- **Guided Assessment**: 3-exercise baseline evaluation (scale + arpeggio + interval pattern)
- **AI-Powered Analysis**: Real-time pitch accuracy and timing detection
- **Personalized Practice Routines**: OpenAI-generated exercises targeting specific weaknesses
- **Smart Monetization**: 14-day free trial with subscription-based access

## Key Features

- ✅ **Firebase Authentication**: Secure user accounts with Google sign-in
- ✅ **Audio Recording & Analysis**: Real-time microphone-based performance analysis
- ✅ **AI Integration**: OpenAI GPT-4o-mini powered practice routine generation
- ✅ **Practice Routine Persistence**: Firestore-based routine storage and management
- ✅ **Sheet Music Notation**: Real sheet music rendering with simple_sheet_music package
- ✅ **Dependency Injection**: get_it + injectable for type-safe DI container
- ✅ **Responsive UI**: Adaptive layouts for phones and tablets
- ✅ **Comprehensive Testing**: 225+ tests passing (100% success rate)
- ✅ **Storybook Integration**: Complete component library with 18+ interactive stories
- ✅ **Production Ready**: Comprehensive logging, error handling, and monitoring

## Tech Stack

- **Frontend**: Flutter + Dart
- **Backend**: Firebase (Auth + Firestore)
- **AI**: OpenAI GPT-4o-mini via dart_openai package
- **Sheet Music**: simple_sheet_music package for notation rendering
- **Audio**: flutter_sound + custom pitch detection
- **State Management**: Provider pattern
- **Dependency Injection**: get_it + injectable
- **Testing**: Flutter Test + Mockito
- **UI Development**: Storybook for component development

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase account and project setup
- OpenAI API key

### Environment Setup

1. Clone the repository
2. Create a `.env` file in the root directory:
```bash
# Environment Configuration
ENVIRONMENT=development
LOG_LEVEL=DEBUG

# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Feature Flags
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
```

3. Install dependencies:
```bash
flutter pub get
```

4. Generate dependency injection configuration:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

5. Run the application:
```bash
flutter run
```

## Development

### Project Structure
```
lib/
├── features/           # Feature-based organization
│   ├── auth/          # Authentication
│   ├── assessment/    # Assessment exercises
│   ├── dashboard/     # Main dashboard
│   ├── landing/       # Landing page
│   ├── notation/      # Sheet music notation system
│   │   ├── services/  # SimpleSheetMusicService (JSON to Measure conversion)
│   │   └── widgets/   # NotationView, ExerciseNotationCard
│   ├── practice/      # Practice routines & models
│   │   ├── models/    # PracticeRoutine and PracticeExercise
│   │   ├── repositories/ # PracticeRoutineRepository
│   │   └── services/  # PracticeGenerationService
│   └── routines/      # Routine management UI
│       ├── providers/ # RoutinesProvider
│       ├── screens/   # Routine list and detail screens
│       └── widgets/   # Routine UI components
├── services/          # Core services
│   ├── openai_service.dart
│   ├── logger_service.dart
│   ├── audio_analysis_service.dart
│   └── firebase_storage_service.dart
├── injection.dart     # DI configuration
├── injection.config.dart  # Generated DI config
├── injection_module.dart  # DI module definitions
└── main.dart

stories/               # Storybook component library
├── notation/         # Notation component stories
│   ├── notation_view_stories.dart # 9 NotationView stories
│   └── exercise_notation_card_stories.dart # 9 ExerciseNotationCard stories
├── routines/         # Routine component stories
│   └── routines_stories.dart # 14 comprehensive stories
└── main.dart         # Storybook entry point

test/                  # Comprehensive test suite
├── features/         # Feature-specific tests
│   └── notation/     # NotationView and ExerciseNotationCard tests
├── services/         # Service layer tests
└── 225+ passing tests
```

### Dependency Injection Architecture

The app uses a comprehensive dependency injection system:

1. **get_it Container**: Type-safe service locator pattern
2. **injectable Annotations**: Automatic service registration
3. **Constructor Injection**: All services receive dependencies via constructors
4. **Mock-friendly Testing**: Easy to replace services with mocks in tests

#### DI Service Registration
```dart
// Service definitions with DI annotations
@singleton
class LoggerService { /* ... */ }

@singleton  
class OpenAIService {
  OpenAIService(this._logger);
}

@injectable
class UserRepository {
  UserRepository(this._firestore, this._logger);
}

@injectable
class PracticeRoutineRepository {
  PracticeRoutineRepository(this._firestore, this._logger);
}

@lazySingleton
class PracticeGenerationService {
  PracticeGenerationService(this._logger, this._openAI, this._dataset);
}

@lazySingleton
class SimpleSheetMusicService {
  // Converts JSON notation to List<Measure> for sheet music rendering
}
```

#### Using Services in Code
```dart
// Get services from DI container
final logger = getIt<LoggerService>();
final authService = getIt<AuthService>();

// Provider initialization
ChangeNotifierProvider<AuthProvider>(
  create: (context) => getIt<AuthProvider>(),
)
```

#### Regenerating DI Configuration
```bash
# After adding/modifying services with @injectable annotations
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter packages pub run build_runner watch
```

### AI Integration Architecture

The app uses a sophisticated AI integration system:

1. **get_it DI Container**: Dependency injection for all AI services
2. **OpenAIService**: Direct API integration with structured prompts
3. **PracticeGenerationService**: High-level routine generation with DI
4. **Graceful Fallbacks**: Sample routines when AI generation fails

### Key AI Features

- **Personalized Analysis**: Converts assessment data to structured format
- **Adaptive Difficulty**: Routines adjust based on inferred skill level
- **Smart Prompting**: Structured prompts for consistent AI responses
- **Error Resilience**: Comprehensive error handling and fallback mechanisms

### Testing

Run the full test suite:
```bash
flutter test --coverage
```

Run specific test categories:
```bash
flutter test test/services/          # Service tests
flutter test test/features/auth/     # Authentication tests
flutter test test/features/assessment/ # Assessment tests
```

### Practice Routine Persistence

The app includes comprehensive practice routine persistence with Firestore:

#### Data Architecture
- **Firestore Collection**: `practice_routines/{userId}/routines/{routineId}`
- **User-Scoped Storage**: Each user has their own routine subcollection
- **Rich Metadata**: Creation timestamps, AI generation tracking, difficulty levels
- **Offline Support**: In-memory caching with background sync

#### Repository Pattern
```dart
// CRUD operations through PracticeRoutineRepository
final repository = getIt<PracticeRoutineRepository>();

// Create new routine
await repository.createRoutine(routine);

// Load user's routines
final routines = await repository.getUserRoutines(userId);

// Update existing routine
await repository.updateRoutine(routine);

// Delete routine
await repository.deleteRoutine(userId, routineId);
```

#### Provider Integration
```dart
// RoutinesProvider handles both memory and persistence
final provider = getIt<RoutinesProvider>();

// Set user context
provider.setUserId(currentUser.id);

// Load persisted routines
await provider.loadUserRoutines();

// Add routines (saves to Firestore automatically)
await provider.addRoutines(generatedRoutines);
```

### Sheet Music Notation System

The app includes a comprehensive sheet music notation system built on the `simple_sheet_music` Flutter package:

#### Architecture Overview
```
AI Generation → JSON Notation → SimpleSheetMusicService → List<Measure> → NotationView → Rendered Sheet Music
```

#### Core Components

**SimpleSheetMusicService**
- Converts AI-generated JSON notation to `simple_sheet_music` Measure objects
- Handles error cases gracefully with fallback mechanisms
- Registered as @lazySingleton for optimal performance

**NotationView Widget**
- Accepts `List<Measure>?` for clean separation of concerns
- Configurable display options (height, width, title, tempo)
- Responsive design with adaptive layouts
- Built-in loading, empty, and error states

**ExerciseNotationCard Widget**
- Interactive expandable card for exercise display
- Integrates with NotationView for sheet music rendering
- Shows exercise metadata (tempo, key signature, duration)
- Smooth expand/collapse animations

#### Musical Content Support
- **Scales**: Major and minor scales with proper key signatures
- **Arpeggios**: Triad patterns with accidentals and inversions
- **Complex Exercises**: Mixed note durations, syncopated rhythms, advanced patterns
- **Error Handling**: Invalid notation data handled gracefully

#### AI Integration
- LLM generates etudes with minimum 4 measures
- Structured JSON format compatible with simple_sheet_music
- Supports notes, accidentals, durations, clefs, and key signatures
- Fallback to sample routines when AI generation fails

#### Testing & Development
- 8 comprehensive unit tests for NotationView (100% passing)
- 18 Storybook stories for interactive development
- Error scenario testing with invalid notation data
- Responsive design validation across screen sizes

### Component Development

Use Storybook for isolated component development:
```bash
./scripts/run-storybook.sh
# or
flutter run -t stories/main.dart
```

#### Storybook Features
- **32+ Comprehensive Stories**: Cover all component variations across the app
- **Notation Components**: Interactive sheet music display with musical examples
- **Routine Components**: Complete routine management and display stories
- **Edge Case Testing**: Long titles, many exercises, invalid data, various states
- **Responsive Design**: Components tested across different screen sizes
- **Data Variations**: AI-generated vs manual, different musical content and difficulty levels
- **Interactive Development**: Live component editing and testing

#### Available Story Categories
- **Notation System**: 
  - 9 NotationView stories (scales, arpeggios, complex exercises, loading states)
  - 9 ExerciseNotationCard stories (interactive states, error handling, UI variations)
- **Routine Management**: 
  - 14 comprehensive stories covering routine lists and details
- **Edge Cases**: Long titles, missing data, invalid notation, AI-generated indicators
- **UI States**: Loading states, error handling, responsive layouts, musical content display

### Development Workflow

1. **Assessment Flow**: Complete 3-exercise assessment
2. **AI Analysis**: Performance data sent to OpenAI for analysis
3. **Routine Generation**: Personalized practice routines generated
4. **Automatic Persistence**: Routines saved to user's Firestore collection
5. **Practice Session**: User follows AI-generated recommendations
6. **Progress Tracking**: Performance improvement over time
7. **Routine Management**: Users can view, organize, and delete saved routines

## Working with Emulators

### List Available Emulators
```bash
flutter emulators
```

### Start Emulator
```bash
# iOS
flutter emulators --launch apple_ios_simulator

# Android
flutter emulators --launch Pixel_Tablet_API_34
```

### List Running Devices
```bash
flutter devices
```

### Run App in Emulator
```bash
# iOS
flutter run -d 5B845F58-3E3A-4686-838B-253109163D6A

# Android
flutter run -d emulator-5554
```

## Production Deployment

### Environment Variables
Ensure the following environment variables are set:
- `OPENAI_API_KEY`: Your OpenAI API key
- `FIREBASE_PROJECT_ID`: Firebase project identifier
- `ENVIRONMENT`: Set to "production" for live deployment

### Build Commands
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
```

## API Integration

### OpenAI Configuration
The app uses OpenAI's GPT-4o-mini model for generating practice routines:
- **Model**: gpt-4o-mini (cost-effective, fast responses)
- **Temperature**: 0.7 (balanced creativity/consistency)
- **Max Tokens**: 2000 (adequate for routine generation)
- **Structured Prompts**: Ensures consistent JSON responses

### Firebase Services
- **Authentication**: Google sign-in integration
- **Firestore**: User data, assessment history, and practice routine persistence
- **Cloud Storage**: Audio file storage for assessments
- **Analytics**: User behavior tracking (optional)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Performance Optimizations

### Incremental Practice Routine Generation
- **50-60% Performance Improvement**: Reduced generation time from 40-60s to 15-20s
- **Parallel Processing**: Uses `Future.wait()` for concurrent etude generation within routines
- **Real-time Progress**: Users see routines as they complete with progress callbacks
- **Smart Batching**: Maintains personalized AI content while optimizing API calls
- **Incremental UI Updates**: `onRoutineCompleted` callbacks for responsive user experience

### Generic LLM Architecture
- **Clean Separation**: OpenAI service handles pure API communication
- **Domain Logic**: Practice-specific prompts and parsing moved to PracticeGenerationService
- **Generic Methods**: `generateResponse()` and `generateBatchResponses()` for reusability
- **Testability**: Easier mocking and testing with clear service boundaries

## Architecture Decisions

### ADR-001: Incremental Practice Routine Generation
**Decision**: Implement parallel processing with progress callbacks rather than backend migration
- **Performance**: 50-60% improvement with client-side optimization
- **User Experience**: Real-time progress updates instead of long wait times
- **Complexity**: Avoids backend infrastructure while maintaining personalized content
- **Implementation**: `Future.wait()` for etude batching per routine

### ADR-002: Unified PracticeGenerationService Architecture  
**Decision**: Keep unified service handling both routine structure and etude generation
- **Domain Cohesion**: Etudes generated with routine context (difficulty, target areas)
- **Performance**: Efficient parallel processing within single service
- **Simplicity**: Avoids premature optimization and service coordination overhead
- **Future Flexibility**: Can split if requirements justify increased complexity

### Why OpenAI over Other LLMs?
- **Reliability**: Consistent API availability and performance
- **Quality**: High-quality music education content generation
- **Developer Experience**: Excellent Dart package support
- **Cost-Effective**: GPT-4o-mini provides good value for our use case

### Why get_it + injectable DI Pattern?
- **Type Safety**: Compile-time service resolution with type checking
- **Testability**: Easy to mock services for comprehensive unit testing
- **Maintainability**: Clear dependency graphs and automatic registration
- **Performance**: Efficient singleton and lazy initialization patterns
- **Flexibility**: Easy to swap implementations without major refactoring
- **Production Ready**: Graceful degradation when services are unavailable

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@saxbuddy.com or create an issue in this repository.