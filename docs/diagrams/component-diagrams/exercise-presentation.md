# Exercise Presentation - Component Diagram

## Overview
The exercise presentation manages the assessment flow with audio recording capabilities, exercise navigation, and real-time state updates.

## Component Structure

```mermaid
graph TB
    subgraph "ExercisePresentation"
        A[Scaffold] --> B[AppBar]
        A --> C[Body Content]
        
        subgraph "AppBar Structure"
            B --> D[Title: Assessment]
            B --> E[Back Button]
            E --> F[onExit Callback]
        end
        
        subgraph "Body Logic"
            C --> G{Exercise Available?}
            G -->|No| H[Center: No exercise available]
            G -->|Yes| I[Main Content Column]
        end
        
        subgraph "Main Content Structure"
            I --> K[ExerciseProgressIndicator]
            I --> M[Conditional Recording Indicator]
            I --> N[Expanded: ExerciseContent]
            I --> O[ExerciseNavigationButtons]
            
            M --> Q{isRecording?}
            Q -->|Yes| R[RecordingIndicator]
        end
        
        subgraph "Child Components"
            K --> S[Progress: currentExercise/totalExercises]
            N --> T[ExerciseContent Widget]
            O --> U[NavigationButtons Widget]
            R --> V[Recording Visual Feedback]
        end
    end
    
    subgraph "Data Dependencies"
        W[AssessmentExercise Model]
        X[ExerciseState Enum]
        Y[AudioRecordingService]
        Z[Exercise Navigation State]
        AA[Recording State]
        BB[Countdown State]
    end
    
    subgraph "Callback Dependencies"
        CC[onStartRecording]
        DD[onStopRecording]
        EE[onCancelCountdown]
        FF[onPreviousExercise]
        GG[onNextExercise]
        HH[onCompleteAssessment]
        II[onExit]
    end
    
    T --> W
    T --> X
    T --> Y
    T --> BB
    U --> Z
    U --> X
    
    style A fill:#e1f5fe
    style G fill:#fff3e0
    style Q fill:#fff3e0
    style K fill:#e8f5e8
    style N fill:#e8f5e8
    style O fill:#e8f5e8
```

## Component Details

### Core Structure
- **Scaffold**: Root container with light background (`#FAFAFA`)
- **AppBar**: Assessment header with navigation
- **Conditional Body**: Handles null exercise states gracefully

### AppBar Configuration
- **Background**: Primary brand color (`#2E5266`)
- **Title**: Centered "Assessment" text
- **Navigation**: Back button triggers exit callback

### Content Flow
1. **Progress Indicator**: Shows current exercise position (X of Y)
2. **Recording Indicator**: Visual feedback when audio recording active
3. **Exercise Content**: Main exercise display and interaction area
4. **Navigation Buttons**: Previous/Next/Complete controls

### State Dependencies
```dart
AssessmentExercise? currentExercise;    // Current exercise data
ExerciseState exerciseState;            // Exercise completion state
int currentExerciseNumber;              // Progress tracking
int totalExercises;                     // Total exercise count
bool isRecording;                       // Audio recording state
int? countdownValue;                    // Recording countdown
AudioRecordingService audioService;     // Audio service injection
bool canGoToPreviousExercise;           // Navigation state
bool canGoToNextExercise;               // Navigation state
```

### Callback Interface
```dart
VoidCallback onStartRecording;          // Start audio recording
VoidCallback onStopRecording;           // Stop audio recording
VoidCallback? onCancelCountdown;        // Cancel recording countdown
VoidCallback? onPreviousExercise;       // Navigate to previous
VoidCallback? onNextExercise;           // Navigate to next
VoidCallback onCompleteAssessment;      // Complete assessment flow
VoidCallback onExit;                    // Exit assessment
```

### Widget Dependencies
- `../widgets/exercise_progress_indicator.dart`
- `../widgets/exercise_content.dart`
- `../widgets/exercise_navigation_buttons.dart`
- `../widgets/recording_indicator.dart`
- `../models/assessment_exercise.dart`
- `../models/exercise_state.dart`
- `AudioRecordingService`

### Layout Behavior
- **Responsive**: Adapts to different screen sizes
- **Conditional Rendering**: Shows/hides recording indicator
- **Safe Layout**: Handles null exercise states
- **Padded Content**: Consistent 24px horizontal padding

### State Management
- **Stateless**: Pure presentation component
- **Props-driven**: All state passed from parent container
- **Event-driven**: User interactions handled via callbacks