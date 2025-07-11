# Dependency Injection Migration Plan

## Overview
Standardize on get_it + injectable for consistent constructor injection across the Flutter codebase.

## Package Selection: get_it + injectable

### Why This Combination?
- **Industry Standard**: Most widely adopted Flutter DI solution in 2024
- **Constructor Injection**: Full support for proper constructor injection
- **Code Generation**: Eliminates boilerplate with annotation-based registration
- **Hot Reload**: Seamless integration with Flutter's hot reload
- **No Interface Extraction**: Keep concrete classes for simplicity

## Required Dependencies

```yaml
dependencies:
  get_it: ^7.6.7
  injectable: ^2.3.2

dev_dependencies:
  injectable_generator: ^2.4.1
  build_runner: ^2.4.7
```

## Migration Timeline: 1-2 Days (Aggressive)

### Day 1: Foundation & Core Services (4-6 hours)

1. **Package Setup** (15 min)
   - Add dependencies to pubspec.yaml
   - Run `flutter pub get`

2. **Create DI Configuration** (30 min)
   - Create `lib/injection.dart`
   - Set up GetIt configuration

3. **Service Annotation** (1 hour)
   - Annotate all services with `@injectable`/`@singleton`/`@lazySingleton`

4. **Generate DI Code** (15 min)
   - Run `flutter packages pub run build_runner build`

5. **Initialize GetIt** (30 min)
   - Update main.dart to initialize GetIt before app startup

6. **Replace ServiceLocator** (1 hour)
   - Replace all `ServiceLocator.instance.get<>()` with `GetIt.instance<>()`
   - Remove ServiceLocator class entirely

7. **Update Service Constructors** (1-2 hours)
   - Remove all default parameter patterns
   - Make all dependencies required in constructors

### Day 2: Provider Integration & Testing (2-4 hours)

1. **Provider Updates** (1-2 hours)
   - Update all providers to use constructor injection
   - Modify main.dart provider setup to use GetIt

2. **Fix Compilation** (30 min)
   - Resolve breaking changes from constructor updates

3. **Test Migration** (1 hour)
   - Update ALL tests to use direct constructor injection
   - Create mock instances directly in tests (NOT GetIt)

4. **Validation** (30 min)
   - Run full test suite
   - Fix any remaining issues

## Implementation Strategy

### Service Annotation Patterns

```dart
// Singleton services (app lifecycle)
@singleton
class LoggerService { ... }

@singleton
class OpenAIService { 
  final LoggerService _logger;
  OpenAIService(this._logger);
}

// Lazy singleton services (on-demand)
@lazySingleton
class PracticeGenerationService { ... }

@lazySingleton
class AudioAnalysisService { ... }

// Factory services (new instance each time)
@injectable
class AudioRecordingService { ... }

@injectable
class FirebaseStorageService { ... }
```

### Provider Pattern (Production)

```dart
// In main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => GetIt.instance<AuthProvider>(),
    ),
    ChangeNotifierProvider<AssessmentProvider>(
      create: (context) => GetIt.instance<AssessmentProvider>(),
    ),
    ChangeNotifierProvider<RoutinesProvider>(
      create: (context) => GetIt.instance<RoutinesProvider>(),
    ),
  ],
)
```

### Constructor Injection (Updated Services)

```dart
// BEFORE (Mixed Patterns)
class AssessmentProvider {
  AssessmentProvider({
    AudioRecordingService? audioService,
    AudioAnalysisService? analysisService,
  }) : _audioService = audioService ?? AudioRecordingService(),
       _analysisService = analysisService ?? AudioAnalysisService();
}

// AFTER (Pure Constructor Injection)
@injectable
class AssessmentProvider extends ChangeNotifier {
  final AudioRecordingService _audioService;
  final AudioAnalysisService _analysisService;
  final FirebaseStorageService _storageService;
  
  AssessmentProvider(
    this._audioService,
    this._analysisService,
    this._storageService,
  );
}
```

## Testing Strategy (No GetIt in Tests)

### Direct Constructor Injection for Tests

```dart
// Test setup - inject mocks directly
test('should complete assessment successfully', () {
  // Arrange
  final mockAudioService = MockAudioRecordingService();
  final mockAnalysisService = MockAudioAnalysisService();
  final mockStorageService = MockFirebaseStorageService();
  
  final provider = AssessmentProvider(
    mockAudioService,
    mockAnalysisService,
    mockStorageService,
  );
  
  // Act & Assert
  // Test with direct mock injection
});
```

### Benefits of Constructor-Only Testing

1. **No DI container complexity** in tests
2. **Explicit mock injection** - clear what's being mocked
3. **Faster test execution** - no container initialization
4. **Better test isolation** - each test controls its dependencies
5. **Cleaner test setup** - direct constructor calls

## Breaking Changes (Acceptable)

1. **Remove optional dependencies** from all service constructors
2. **Remove ServiceLocator** class entirely
3. **Update all Provider instantiation** in main.dart to use GetIt
4. **Change all service access patterns** throughout codebase
5. **Update all test setup** to use direct constructor injection

## Services to Update

### Core Services
- `LoggerService` ’ `@singleton`
- `OpenAIService` ’ `@singleton`
- `AuthService` ’ `@singleton`

### Business Services
- `PracticeGenerationService` ’ `@lazySingleton`
- `AudioAnalysisService` ’ `@lazySingleton`

### Utility Services
- `AudioRecordingService` ’ `@injectable`
- `FirebaseStorageService` ’ `@injectable`

### Providers
- `AuthProvider` ’ `@injectable`
- `AssessmentProvider` ’ `@injectable`
- `RoutinesProvider` ’ `@injectable`

## Implementation Steps

### Hour 1: Package Setup
- Add get_it + injectable dependencies
- Create injection.dart configuration
- Initialize GetIt in main.dart

### Hour 2-3: Service Annotation
- Annotate all services with appropriate lifecycle
- Remove default constructor parameters
- Generate DI code with build_runner

### Hour 4-5: ServiceLocator Replacement
- Replace ServiceLocator with GetIt in production code
- Update AssessmentCompleteContainer
- Update all service access points

### Hour 6-7: Provider Integration
- Update all providers to use constructor injection
- Fix main.dart provider setup with GetIt
- Resolve compilation errors

### Hour 8: Testing & Cleanup
- Update ALL tests to use constructor injection (not GetIt)
- Create mock instances directly in tests
- Run tests and fix any remaining issues

## Expected Benefits

### Immediate Benefits
- **Consistent DI pattern** across entire codebase
- **Better testability** with easy mock injection
- **Reduced boilerplate** through code generation
- **Cleaner constructors** with explicit dependencies

### Long-term Benefits
- **Easier maintenance** with centralized dependency configuration
- **Better performance** with proper singleton management
- **Enhanced debugging** with clear dependency graph
- **Improved code quality** with enforced dependency patterns

## Final Result

- **Production**: Clean DI with GetIt
- **Tests**: Simple constructor injection with mocks
- **No mixed patterns** anywhere in codebase
- **Maximum testability** with explicit mock injection
- **Consistent architecture** across all services

## Files to Create/Update

### New Files
- `lib/injection.dart` - DI configuration
- `lib/injection.config.dart` - Generated DI code

### Updated Files
- `pubspec.yaml` - Add dependencies
- `lib/main.dart` - Initialize GetIt, update providers
- All service files - Add annotations, update constructors
- All provider files - Update to use constructor injection
- All test files - Update to use direct constructor injection
- Remove `lib/services/service_locator.dart`

This plan provides a complete roadmap for standardizing dependency injection across the Flutter codebase in 1-2 days with an aggressive, breaking-change-acceptable approach.