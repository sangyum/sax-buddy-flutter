# Landing Presentation - Component Diagram

## Overview
The landing presentation implements a responsive authentication entry point with adaptive layouts for different screen orientations and device types.

## Component Structure

```mermaid
graph TB
    subgraph "LandingPresentation"
        A[Scaffold] --> B[SafeArea]
        B --> C[LayoutBuilder]
        C --> D[Center]
        D --> E[SingleChildScrollView]
        E --> F[Container]
        
        F --> G{Layout Decision}
        G -->|Landscape & !Tablet| H[LandscapeLayout]
        G -->|Portrait or Tablet| I[PortraitLayout]
        
        subgraph "Responsive Logic"
            J[Screen Width Detection]
            K[Tablet Detection >600px]
            L[Orientation Detection]
            M[Content Width Calculation]
            N[Logo Size Calculation]
            O[Font Size Calculation]
        end
        
        subgraph "LandscapeLayout"
            H --> P[Row Layout]
            P --> Q[Left Column - Content]
            P --> R[Right Column - Actions]
        end
        
        subgraph "PortraitLayout" 
            I --> S[Column Layout]
            S --> T[Logo Section]
            T --> U[Content Section]
            U --> V[Actions Section]
        end
    end
    
    subgraph "External Dependencies"
        W[PortraitLayout Widget]
        H -.-> W
        X[LandscapeLayout Widget]
        I -.-> X
    end
    
    subgraph "Callbacks"
        Y[onSignIn: VoidCallback]
        H --> Y
        I --> Y
    end

    style A fill:#e1f5fe
    style G fill:#fff3e0
    style J fill:#f3e5f5
    style K fill:#f3e5f5
    style L fill:#f3e5f5
    style M fill:#f3e5f5
    style N fill:#f3e5f5
    style O fill:#f3e5f5
```

## Component Details

### Core Widget Structure
- **Scaffold**: Root container with background color `#FAFAFA`
- **SafeArea**: Ensures content respects device safe areas
- **LayoutBuilder**: Provides responsive constraints for adaptive layout
- **SingleChildScrollView**: Handles content overflow on smaller screens

### Responsive Logic
- **Device Detection**: Tablet threshold at 600px width
- **Orientation Detection**: Width vs height comparison
- **Content Width**: 60% of screen (400-600px) for tablets, full width for phones
- **Dynamic Sizing**: Logo (100px/140px), title (28px/36px), subtitle (16px/20px)

### Layout Variants
- **Portrait/Tablet**: Vertical column layout with centered content
- **Landscape Phone**: Horizontal row layout for space efficiency

### Data Flow
```
Props → Responsive Calculations → Layout Selection → Child Widget Rendering
```

### Dependencies
- `widgets/portrait_layout.dart`
- `widgets/landscape_layout.dart`
- Flutter Material Design components

### State Management
- **Stateless**: Pure presentation component
- **Props-driven**: All data passed via constructor
- **Callback-based**: User interactions handled via onSignIn callback