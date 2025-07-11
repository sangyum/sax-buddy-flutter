# Assessment to Practice Routine Flow - Sequence Diagram

This diagram shows the complete interaction flow from initial assessment through AI-powered analysis to practice routine generation and persistence.

## System Components

- **User**: The saxophone player using the app
- **UI**: Flutter user interface components
- **AssessmentProvider**: Manages assessment state and audio recording
- **AudioAnalysisService**: Processes recorded audio for pitch/timing analysis  
- **AssessmentAnalyzer**: Creates structured dataset from assessment results
- **PracticeGenerationService**: Orchestrates practice routine generation
- **OpenAIService**: Interfaces with OpenAI GPT-4o-mini for routine generation
- **RoutinesProvider**: Manages practice routine state and persistence
- **PracticeRoutineRepository**: Handles Firestore CRUD operations
- **Firestore**: Cloud database for routine persistence

## Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant UI as Flutter UI
    participant AP as AssessmentProvider
    participant AAS as AudioAnalysisService
    participant AA as AssessmentAnalyzer
    participant PGS as PracticeGenerationService
    participant OAI as OpenAIService
    participant RP as RoutinesProvider
    participant PRR as PracticeRoutineRepository
    participant FS as Firestore

    Note over User, FS: Initial Assessment Phase
    
    User->>UI: Start Assessment
    UI->>AP: startAssessment()
    AP->>AP: Create AssessmentSession
    AP->>UI: Navigate to Exercise 1
    
    loop For Each Exercise (Scale, Arpeggio, Intervals)
        User->>UI: Begin Exercise
        UI->>AP: startRecording()
        AP->>AAS: initialize()
        AAS->>AP: Recording started
        AP->>UI: Show recording UI
        
        User->>User: Play saxophone exercise
        AAS->>AAS: Capture audio data
        AAS->>AAS: Analyze pitch/timing
        
        User->>UI: Stop recording
        UI->>AP: stopRecording()
        AP->>AAS: stopRecording()
        AAS->>AP: Return audio analysis
        AP->>AP: Store exercise results
        AP->>UI: Show exercise complete
        
        alt More exercises
            UI->>AP: nextExercise()
        else Assessment complete
            AP->>UI: Assessment completed
        end
    end
    
    Note over User, FS: AI Analysis & Routine Generation Phase
    
    User->>UI: Generate Practice Routines
    UI->>AP: Get completed session
    AP->>UI: Return AssessmentSession
    UI->>AA: createAssessmentDataset(session)
    
    AA->>AA: Analyze performance data
    AA->>AA: Identify strengths/weaknesses
    AA->>AA: Determine skill level
    AA->>UI: Return AssessmentDataset
    
    UI->>PGS: generatePracticePlans(dataset)
    PGS->>PGS: Validate dataset
    PGS->>OAI: generatePracticePlan(dataset)
    
    OAI->>OAI: Build structured prompt
    OAI->>OpenAI: API call to GPT-4o-mini
    OpenAI-->>OAI: JSON response with routines
    OAI->>OAI: Parse and validate response
    
    alt AI generation successful
        OAI->>PGS: Return generated routines
    else AI generation failed
        OAI->>PGS: Return fallback routines
    end
    
    PGS->>PGS: Adjust difficulty based on user level
    PGS->>UI: Return practice routines
    
    Note over User, FS: Practice Routine Persistence Phase
    
    UI->>RP: addRoutines(routines)
    RP->>RP: Add to in-memory cache
    RP->>UI: Immediate UI update
    
    par Background Persistence
        loop For each routine
            RP->>PRR: createRoutine(routine)
            PRR->>PRR: Add user context and timestamps
            PRR->>FS: Create document in practice_routines/{userId}/routines/{routineId}
            FS-->>PRR: Confirm creation
            PRR->>RP: Routine saved
        end
    end
    
    RP->>UI: All routines persisted
    UI->>User: Show generated routines
    
    Note over User, FS: User Session Management
    
    User->>UI: Return to dashboard later
    UI->>RP: setUserId(userId)
    RP->>PRR: getUserRoutines(userId)
    PRR->>FS: Query practice_routines/{userId}/routines
    FS-->>PRR: Return routine documents
    PRR->>RP: Return routine list
    RP->>RP: Load into memory cache
    RP->>UI: Routines available
    UI->>User: Show persisted routines
    
    Note over User, FS: Error Handling Scenarios
    
    alt Firestore unavailable
        PRR->>RP: Repository error
        RP->>RP: Continue with in-memory only
        RP->>UI: Warning: offline mode
    else OpenAI service unavailable
        OAI->>PGS: Service error
        PGS->>UI: Return fallback routines
        UI->>User: Show generated routines (offline)
    else Audio analysis fails
        AAS->>AP: Analysis error
        AP->>AP: Use mock data
        AP->>UI: Continue with estimated results
    end
```

## Key Interaction Points

### 1. Assessment Data Collection
- **Real-time Audio Analysis**: Live pitch and timing detection during exercises
- **Progressive Exercise Flow**: Scale → Arpeggio → Intervals with state management
- **Error Recovery**: Graceful handling of audio permission and recording failures

### 2. AI-Powered Analysis
- **Structured Data Processing**: Assessment results converted to standardized dataset
- **Intelligent Prompting**: Context-aware prompts sent to OpenAI for routine generation
- **Fallback Mechanisms**: Sample routines available when AI service is unavailable

### 3. Practice Routine Persistence
- **Dual Storage Strategy**: Immediate in-memory updates with background Firestore persistence
- **User-Scoped Data**: Hierarchical Firestore collection structure per user
- **Offline Resilience**: App continues working when database is unavailable

### 4. State Management Flow
- **Provider Pattern**: Reactive UI updates through ChangeNotifier providers
- **Dependency Injection**: Services injected through get_it container
- **Error Propagation**: Structured error handling with user-friendly messaging

## Data Flow Summary

1. **Assessment Input**: User performs saxophone exercises with real-time audio capture
2. **Analysis Processing**: Audio data analyzed for pitch accuracy and timing consistency  
3. **AI Generation**: Performance data sent to OpenAI for personalized routine creation
4. **Immediate Display**: Generated routines shown instantly in UI with in-memory caching
5. **Background Persistence**: Routines saved to Firestore for future sessions
6. **Session Recovery**: Persisted routines loaded automatically on app restart

## Technical Architecture Benefits

- **Scalable Design**: Repository pattern allows easy database switching
- **Offline Capability**: In-memory caching ensures app works without connectivity
- **Type Safety**: Dependency injection with compile-time service resolution
- **Error Resilience**: Multiple fallback layers for service failures
- **Performance**: Background persistence doesn't block UI interactions