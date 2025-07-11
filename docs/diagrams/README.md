# SaxBuddy System Architecture Diagrams

This folder contains comprehensive sequence diagrams that illustrate the key interaction flows in the SaxBuddy saxophone learning application.

## Diagram Overview

### 1. [Assessment to Practice Flow](./assessment-to-practice-flow.md)
**Complete end-to-end user journey from initial assessment to practice routine persistence**

**Key Interactions:**
- User performs 3-exercise assessment (Scale, Arpeggio, Intervals)
- Real-time audio analysis and performance evaluation
- AI-powered practice routine generation via OpenAI GPT-4o-mini
- Automatic persistence to Firestore with user-scoped storage
- Error handling and fallback mechanisms

**Components Covered:**
- AssessmentProvider, AudioAnalysisService, AssessmentAnalyzer
- PracticeGenerationService, OpenAIService
- RoutinesProvider, PracticeRoutineRepository, Firestore

### 2. [Data Persistence Architecture](./data-persistence-architecture.md)
**Detailed view of the practice routine persistence system**

**Key Interactions:**
- Repository pattern implementation with CRUD operations
- Dual storage strategy (in-memory cache + Firestore)
- User authentication and routine loading
- Background synchronization and error recovery
- Comprehensive logging and performance monitoring

**Components Covered:**
- RoutinesProvider state management
- PracticeRoutineRepository data access layer
- Firestore database operations
- LoggerService performance tracking

### 3. [AI Routine Generation Flow](./ai-routine-generation-flow.md)
**In-depth look at AI integration and routine generation**

**Key Interactions:**
- Assessment data analysis and structured dataset creation
- OpenAI API integration with prompt engineering
- JSON response parsing and validation
- Difficulty adjustment based on skill level
- Comprehensive fallback routine generation

**Components Covered:**
- AssessmentAnalyzer data processing
- PracticeGenerationService orchestration
- OpenAIService API integration
- Error handling and fallback strategies

## Architecture Highlights

### 🎯 **User-Centric Design**
- **Immediate Feedback**: UI updates instantly while background operations continue
- **Offline Capability**: App continues working when services are unavailable
- **Error Recovery**: Graceful degradation with meaningful user feedback

### 🔧 **Technical Excellence**
- **Repository Pattern**: Clean separation of data access and business logic
- **Dependency Injection**: Type-safe service management with get_it + injectable
- **Comprehensive Logging**: Detailed performance metrics and error tracking
- **Test-Driven Development**: 210+ tests ensuring reliability

### 🚀 **Scalable Architecture**
- **Microservice Ready**: Loosely coupled components for easy service extraction
- **Cloud-Native**: Firebase integration with offline-first design
- **AI-Powered**: OpenAI integration with intelligent fallback mechanisms
- **Performance Optimized**: Background operations and efficient caching

### 🛡️ **Production Ready**
- **Error Handling**: Multiple fallback layers for service failures
- **Data Consistency**: ACID-like guarantees for practice routine storage
- **Security**: User-scoped data access with Firebase Auth integration
- **Monitoring**: Comprehensive observability for debugging and optimization

## Key Design Patterns

### Repository Pattern
```dart
@injectable
class PracticeRoutineRepository {
  // CRUD operations with comprehensive error handling
  Future<void> createRoutine(PracticeRoutine routine);
  Future<List<PracticeRoutine>> getUserRoutines(String userId);
  Future<void> updateRoutine(PracticeRoutine routine);
  Future<void> deleteRoutine(String userId, String routineId);
}
```

### Provider Pattern with Persistence
```dart
@injectable
class RoutinesProvider extends ChangeNotifier {
  // Dual storage: immediate UI updates + background persistence
  Future<void> addRoutines(List<PracticeRoutine> routines);
  Future<void> loadUserRoutines();
  Future<void> syncRoutines();
}
```

### Service Integration with Fallbacks
```dart
@lazySingleton
class PracticeGenerationService {
  // AI generation with comprehensive fallback strategy
  Future<List<PracticeRoutine>> generatePracticePlans(AssessmentDataset dataset);
}
```

## Data Flow Summary

1. **Assessment Phase**: User performs exercises → Audio analysis → Performance metrics
2. **AI Analysis**: Assessment data → OpenAI API → Personalized routine generation
3. **Persistence Phase**: Generated routines → In-memory cache → Background Firestore save
4. **User Experience**: Immediate UI feedback → Offline capability → Session recovery

## Error Handling Strategy

### Service Failures
- **OpenAI Unavailable**: Use professionally designed fallback routines
- **Firestore Offline**: Continue with in-memory storage and sync when available
- **Audio Analysis Error**: Use mock data with estimated performance metrics

### Data Consistency
- **Write Operations**: Always update UI immediately, persist in background
- **Read Operations**: Serve from cache when possible, fetch fresh when needed
- **Conflict Resolution**: Server data takes precedence during synchronization

### User Experience
- **Graceful Degradation**: App continues working during service outages
- **Clear Feedback**: User-friendly error messages without technical jargon
- **Recovery Mechanisms**: Automatic retry and manual sync capabilities

## Viewing the Diagrams

These diagrams use [Mermaid](https://mermaid.js.org/) syntax for sequence diagrams. You can view them:

1. **GitHub**: Diagrams render automatically in GitHub's Markdown viewer
2. **VS Code**: Install the "Mermaid Preview" extension
3. **Online**: Copy the Mermaid code to [mermaid.live](https://mermaid.live/)
4. **Documentation Sites**: Most support Mermaid rendering natively

## Related Documentation

- [CLAUDE.md](../../CLAUDE.md) - Complete project overview and architecture
- [README.md](../../README.md) - Setup instructions and development guide
- [PHASE3.md](../PHASE3.md) - AI integration implementation details
- [Assessment Documentation](../assessments/) - Assessment system specifications