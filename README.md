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
- ✅ **Responsive UI**: Adaptive layouts for phones and tablets
- ✅ **Comprehensive Testing**: 195/207 tests passing (94% success rate)
- ✅ **Production Ready**: Comprehensive logging, error handling, and monitoring

## Tech Stack

- **Frontend**: Flutter + Dart
- **Backend**: Firebase (Auth + Firestore)
- **AI**: OpenAI GPT-4o-mini via dart_openai package
- **Audio**: flutter_sound + custom pitch detection
- **State Management**: Provider pattern
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

4. Run the application:
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
│   ├── practice/      # Practice routines
│   └── routines/      # Routine management
├── services/          # Core services
│   ├── openai_service.dart
│   ├── service_locator.dart
│   └── logger_service.dart
└── main.dart

stories/               # Storybook components
test/                  # Test files
```

### AI Integration Architecture

The app uses a sophisticated AI integration system:

1. **ServiceLocator Pattern**: Dependency injection for AI services
2. **OpenAIService**: Direct API integration with structured prompts
3. **PracticeGenerationService**: High-level routine generation
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

### Component Development

Use Storybook for isolated component development:
```bash
./scripts/run-storybook.sh
# or
flutter run -t stories/main.dart
```

### Development Workflow

1. **Assessment Flow**: Complete 3-exercise assessment
2. **AI Analysis**: Performance data sent to OpenAI for analysis
3. **Routine Generation**: Personalized practice routines generated
4. **Practice Session**: User follows AI-generated recommendations
5. **Progress Tracking**: Performance improvement over time

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
- **Firestore**: User data and assessment history
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

### Why ServiceLocator Pattern?
- **Testability**: Easy to mock AI services for testing
- **Flexibility**: Can switch AI providers without major refactoring
- **Error Isolation**: AI service failures don't crash the app
- **Production Ready**: Graceful degradation when services are unavailable

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@saxbuddy.com or create an issue in this repository.