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
4. **Notation + Audio** - Sheet music rendering with reference playback - See @docs/PHASE4

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
- **AudioRecordingService**: Audio capture and processing (@injectable)
- **AudioAnalysisService**: Real-time audio analysis (@lazySingleton)
- **PracticeGenerationService**: AI-powered routine generation (@lazySingleton)

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