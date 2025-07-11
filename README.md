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
- ✅ **Dependency Injection**: get_it + injectable for type-safe DI container
- ✅ **Responsive UI**: Adaptive layouts for phones and tablets
- ✅ **Comprehensive Testing**: 210+ tests passing (100% success rate)
- ✅ **Storybook Integration**: Complete component library for UI development
- ✅ **Production Ready**: Comprehensive logging, error handling, and monitoring

## Tech Stack

- **Frontend**: Flutter + Dart
- **Backend**: Firebase (Auth + Firestore)
- **AI**: OpenAI GPT-4o-mini via dart_openai package
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
├── routines/         # Routine component stories
│   └── routines_stories.dart # 14 comprehensive stories
└── main.dart         # Storybook entry point

test/                  # Comprehensive test suite
├── features/         # Feature-specific tests
├── services/         # Service layer tests
└── 210+ passing tests
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

### Component Development

Use Storybook for isolated component development:
```bash
./scripts/run-storybook.sh
# or
flutter run -t stories/main.dart
```

#### Storybook Features
- **14 Comprehensive Stories**: Cover all routine component variations
- **Edge Case Testing**: Long titles, many exercises, various data states
- **Responsive Design**: Components tested across different screen sizes
- **Data Variations**: AI-generated vs manual, different difficulty levels
- **Interactive Development**: Live component editing and testing

#### Available Story Categories
- **Routine Lists**: Empty state, loading, error handling, different routine counts
- **Routine Details**: Beginner/intermediate/advanced, single/many exercises
- **Edge Cases**: Long titles, missing tempo, AI-generated indicators
- **UI States**: Loading states, error handling, responsive layouts

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

## Architecture Decisions

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