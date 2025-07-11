# Component Diagrams - SaxBuddy Flutter App

## Overview
This directory contains comprehensive component diagrams for all screen presentations in the SaxBuddy saxophone learning application. Each diagram illustrates the widget hierarchy, data flow, and component relationships within individual screens.

## Screen Presentations

### 1. [Landing Presentation](./landing-presentation.md)
**Responsive authentication entry point with adaptive layouts**

**Key Features:**
- Adaptive portrait/landscape layouts
- Tablet and phone responsive design
- Dynamic sizing based on screen dimensions
- Single sign-in callback for user authentication

**Widget Hierarchy:**
- Scaffold → SafeArea → LayoutBuilder → Responsive Layout Components

---

### 2. [Dashboard Presentation](./dashboard-presentation.md)
**Main user interface after authentication**

**Key Features:**
- Personalized welcome section with user data
- Subscription status display
- Quick navigation actions
- Recent activity overview

**Widget Hierarchy:**
- Scaffold → AppBar + SingleChildScrollView → Column of Feature Sections

---

### 3. [Exercise Presentation](./exercise-presentation.md)
**Assessment flow with audio recording capabilities**

**Key Features:**
- Real-time exercise progress tracking
- Audio recording with visual feedback
- Exercise navigation controls
- Conditional UI based on recording state

**Widget Hierarchy:**
- Scaffold → AppBar + Conditional Body → Progress + Content + Navigation

---

### 4. [Routines Presentation](./routines-presentation.md)
**Practice routines list with error handling and loading states**

**Key Features:**
- Conditional error banner display
- Loading state indicators
- Refresh functionality
- Routine selection handling

**Widget Hierarchy:**
- Scaffold → AppBar + Column → Error/Loading/Content Sections

---

### 5. [Routine Detail Presentation](./routine-detail-presentation.md)
**Detailed view of individual practice routines**

**Key Features:**
- Dynamic routine title in AppBar
- Comprehensive routine information display
- Exercise breakdown and instructions
- Scrollable content for longer routines

**Widget Hierarchy:**
- Scaffold → AppBar + SingleChildScrollView → Header + Exercise List

---

### 6. [Assessment Complete Presentation](./assessment-complete-presentation.md)
**Success screen after completing assessment exercises**

**Key Features:**
- Success animation and celebration UI
- Assessment results summary
- Action buttons for next steps
- Loading state during routine generation

**Widget Hierarchy:**
- Scaffold → SafeArea → Column → Animation + Content + Actions

---

## Architecture Patterns

### Common Design Patterns
1. **Stateless Presentations**: All screens are stateless widgets focused purely on UI rendering
2. **Props-driven Data**: All state and data passed via constructor parameters
3. **Callback-based Events**: User interactions handled through callback functions
4. **Conditional Rendering**: UI adapts based on state flags (loading, error, etc.)
5. **Responsive Design**: Layouts adapt to different screen sizes and orientations

### Widget Composition Strategy
- **Small, Focused Widgets**: Each screen composed of smaller, reusable components
- **Feature-based Organization**: Widgets organized by feature domain
- **Separation of Concerns**: Presentation logic separated from business logic
- **Consistent Styling**: Shared color scheme and design system

### Data Flow Architecture
```
Parent Container → Props → Presentation Widget → Child Widgets → User Events → Callbacks
```

### State Management Approach
- **Container-Presentation Pattern**: Business logic in container widgets, UI in presentation widgets
- **Dependency Injection**: Services injected via get_it container
- **Provider Pattern**: State management through ChangeNotifier providers
- **Immutable Data**: Props passed as immutable objects

## Technical Implementation

### Widget Dependencies
All presentations follow consistent dependency patterns:
- **Model Imports**: Feature-specific data models
- **Widget Imports**: Reusable UI components within feature
- **Service Imports**: Required for functionality (audio, etc.)

### Styling Conventions
- **Color Scheme**: Consistent brand colors (`#2E5266`, `#FAFAFA`, etc.)
- **Typography**: Standardized font weights and sizes
- **Spacing**: Consistent padding and margin values (16px, 24px, 32px)
- **Elevation**: Minimal shadows and flat design elements

### Responsive Behavior
- **Screen Size Detection**: LayoutBuilder for responsive calculations
- **Orientation Handling**: Different layouts for portrait/landscape
- **Device Type Adaptation**: Tablet vs phone specific UI adjustments
- **Content Overflow**: ScrollView widgets for content management

## Development Guidelines

### Component Creation
1. **Start with Presentation**: Create stateless presentation widget first
2. **Add Container**: Wrap with stateful container for business logic
3. **Inject Dependencies**: Use get_it for service dependencies
4. **Create Tests**: Comprehensive unit tests for all components
5. **Add Stories**: Storybook stories for component development

### Testing Strategy
- **Unit Tests**: Individual widget testing with mocks
- **Widget Tests**: Full screen rendering and interaction tests
- **Integration Tests**: End-to-end user flow validation
- **Visual Tests**: Storybook for visual regression testing

### Documentation Standards
- **Component Diagrams**: Mermaid diagrams for architecture visualization
- **Code Comments**: Inline documentation for complex logic
- **README Files**: Feature-level documentation and usage guides
- **API Documentation**: Generated from code annotations

## Related Documentation

- [System Architecture Diagrams](../README.md) - Complete system interaction flows
- [CLAUDE.md](../../../CLAUDE.md) - Project overview and development practices
- [README.md](../../../README.md) - Setup and development instructions
- [Storybook Guide](../../../stories/README.md) - Component development workflow