---
status: "accepted"
date: 2025-07-11
decision-makers: ["Development Team"]
consulted: ["Flutter Community Best Practices"]
informed: ["All Contributors"]
---

# Standardize Dependency Injection with get_it + injectable

## Context and Problem Statement

The Flutter codebase currently uses mixed dependency injection patterns with ServiceLocator and optional constructor parameters with default values. This creates inconsistency, makes testing difficult, and leads to poor separation of concerns. Services are sometimes instantiated with default constructors, sometimes through ServiceLocator, creating a fragmented architecture that is hard to maintain and test.

## Decision Drivers

* Need for consistent dependency injection pattern across the entire codebase
* Requirement for better testability with easy mock injection
* Desire to eliminate boilerplate code through code generation
* Need for proper constructor injection to improve code clarity
* Performance considerations with singleton management
* Integration with Flutter's hot reload capability

## Considered Options

* Continue with current mixed ServiceLocator + default parameter pattern
* Adopt get_it + injectable for standardized dependency injection
* Use provider package for dependency injection
* Implement custom dependency injection solution

## Decision Outcome

Chosen option: "get_it + injectable", because it is the industry standard Flutter DI solution, provides full constructor injection support, eliminates boilerplate through code generation, integrates seamlessly with Flutter's hot reload, and offers clear lifecycle management with singleton patterns.

### Consequences

* Good, because provides consistent DI pattern across entire codebase
* Good, because enables better testability with easy mock injection
* Good, because reduces boilerplate through annotation-based code generation
* Good, because enforces explicit dependency declarations in constructors
* Good, because improves performance with proper singleton management
* Bad, because requires breaking changes to all service constructors
* Bad, because requires updating all test files to use constructor injection
* Bad, because introduces build-time code generation dependency

### Confirmation

Implementation compliance will be confirmed through:
- Code review ensuring all services use @injectable/@singleton/@lazySingleton annotations
- Test suite validation that all tests use direct constructor injection (not GetIt)
- Build process verification that generated DI code compiles successfully
- Runtime verification that all services are properly registered and injectable

## Pros and Cons of the Options

### get_it + injectable

Industry standard Flutter dependency injection solution combining service locator pattern with code generation.

* Good, because most widely adopted Flutter DI solution in 2024
* Good, because full support for constructor injection patterns
* Good, because eliminates registration boilerplate with annotations
* Good, because seamless integration with Flutter's hot reload
* Good, because clear lifecycle management (@singleton, @lazySingleton, @injectable)
* Good, because no need for interface extraction - works with concrete classes
* Neutral, because requires build-time code generation
* Bad, because breaking changes required for all service constructors
* Bad, because adds build_runner dependency for code generation

### ServiceLocator (Current)

Custom service locator implementation with manual registration.

* Good, because already implemented and working
* Good, because no additional dependencies required
* Neutral, because provides basic service location functionality
* Bad, because mixed with optional constructor parameters creates inconsistency
* Bad, because manual registration prone to errors
* Bad, because difficult to test with proper mock injection
* Bad, because no lifecycle management for services
* Bad, because not following Flutter community best practices

### Provider Package

Flutter state management solution that can be used for dependency injection.

* Good, because already integrated in the app for state management
* Good, because officially supported by Flutter team
* Neutral, because works well for widget-level dependency injection
* Bad, because not designed primarily for service-level dependency injection
* Bad, because would require significant architectural changes
* Bad, because less suitable for singleton service management
* Bad, because would create confusion between state management and DI

### Custom DI Solution

Build custom dependency injection framework specific to the project.

* Good, because could be tailored to specific project needs
* Good, because no external dependencies
* Neutral, because would provide learning opportunity
* Bad, because significant development and maintenance overhead
* Bad, because would not benefit from community testing and improvements
* Bad, because likely to have bugs and missing features compared to mature solutions
* Bad, because would not follow industry standards

## More Information

### Implementation Timeline
- **Day 1**: Foundation setup, service annotation, and core migration (4-6 hours)
- **Day 2**: Provider integration, testing updates, and validation (2-4 hours)

### Key Services to Migrate
- **Core Services**: LoggerService, OpenAIService, AuthService (@singleton)
- **Business Services**: PracticeGenerationService, AudioAnalysisService (@lazySingleton)
- **Utility Services**: AudioRecordingService, FirebaseStorageService (@injectable)
- **Providers**: AuthProvider, AssessmentProvider, RoutinesProvider (@injectable)

### Testing Strategy
All tests will use direct constructor injection with mocks, avoiding GetIt container in test environment for better isolation and performance.

### Files to Create/Update
- **New**: `lib/injection.dart`, `lib/injection.config.dart`
- **Updated**: `pubspec.yaml`, `lib/main.dart`, all service files, all provider files, all test files
- **Removed**: `lib/services/service_locator.dart`

This decision supports the long-term maintainability and testability of the codebase while following Flutter community best practices.