# Routines Presentation - Component Diagram

## Overview
The routines presentation displays a list of practice routines with error handling, loading states, and refresh capabilities.

## Component Structure

```mermaid
graph TB
    subgraph "RoutinesPresentation"
        A[Scaffold] --> B[AppBar]
        A --> C[Body: Column]
        
        subgraph "AppBar Structure"
            B --> D[Title: Practice Routines]
            B --> E[Leading: Back Button]
            B --> F[Actions: Refresh Button]
            E --> G[Navigator.pop]
            F --> H[onRefresh Callback]
        end
        
        subgraph "Body Content"
            C --> I[Conditional Error Banner]
            C --> J[Conditional Loading Indicator]
            C --> K[Expanded: RoutineList]
            
            I --> L{error != null?}
            L -->|Yes| M[ErrorBanner Widget]
            
            J --> N{isLoading?}
            N -->|Yes| O[LoadingIndicator Widget]
        end
        
        subgraph "RoutineList Content"
            K --> P[RoutineList Widget]
            P --> Q[routines: List<PracticeRoutine>]
            P --> R[onRoutineTap: Function]
            P --> S[onRefresh: VoidCallback]
        end
    end
    
    subgraph "Data Dependencies"
        T[List<PracticeRoutine> routines]
        U[bool isLoading]
        V[String? error]
        W[VoidCallback onRefresh]
        X[Function(PracticeRoutine) onRoutineTap]
    end
    
    subgraph "External Widgets"
        Y[ErrorBanner Widget]
        Z[LoadingIndicator Widget]
        AA[RoutineList Widget]
        M -.-> Y
        O -.-> Z
        P -.-> AA
    end
    
    subgraph "State Flow"
        BB[Loading State] --> CC[Data Loaded]
        CC --> DD[Display Routines]
        BB --> EE[Error State]
        EE --> FF[Display Error Banner]
        DD --> GG[User Interaction]
        GG --> HH[Refresh/Tap Actions]
    end
    
    style A fill:#e1f5fe
    style L fill:#fff3e0
    style N fill:#fff3e0
    style BB fill:#f3e5f5
    style EE fill:#ffebee
    style DD fill:#e8f5e8
```

## Component Details

### Core Structure
- **Scaffold**: Root container with light gray background (`#F8F9FA`)
- **AppBar**: Header with navigation and actions
- **Column Layout**: Vertical arrangement of conditional components

### AppBar Configuration
- **Background**: White with no elevation
- **Title**: "Practice Routines" with custom styling
- **Navigation**: Back button with dark gray color (`#212121`)
- **Actions**: Refresh button with brand color (`#2E5266`)

### Content States
1. **Error State**: Red error banner displayed at top
2. **Loading State**: Loading indicator shown during data fetch
3. **Content State**: RoutineList with practice routines
4. **Empty State**: Handled within RoutineList component

### Conditional Rendering Logic
```dart
if (error != null) ErrorBanner(error: error!)     // Error display
if (isLoading) LoadingIndicator()                 // Loading display
Expanded(child: RoutineList(...))                 // Always present
```

### Props Interface
```dart
final List<PracticeRoutine> routines;           // Practice routine data
final bool isLoading;                           // Loading state flag
final String? error;                            // Error message
final VoidCallback onRefresh;                   // Refresh action
final Function(PracticeRoutine) onRoutineTap;   // Routine selection
```

### Widget Dependencies
- `../widgets/error_banner.dart`
- `../widgets/loading_indicator.dart`
- `../widgets/routine_list.dart`
- `PracticeRoutine` model from practice feature

### User Interactions
- **Back Navigation**: AppBar back button → Navigator.pop()
- **Refresh Action**: AppBar refresh button → onRefresh callback
- **Routine Selection**: List item tap → onRoutineTap callback
- **Pull-to-Refresh**: RoutineList pull gesture → onRefresh callback

### Layout Behavior
- **Responsive**: Adapts to different screen sizes
- **Scrollable**: RoutineList handles content overflow
- **State-aware**: Shows appropriate UI based on loading/error states
- **Accessible**: Proper semantics and color contrast

### Data Flow
```
Parent Container → Props → Conditional Rendering → Child Widgets → User Actions → Callbacks
```

### State Management
- **Stateless**: Pure presentation component
- **Props-driven**: All state managed by parent container
- **Event-driven**: User interactions propagated via callbacks