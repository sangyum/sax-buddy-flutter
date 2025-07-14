---
status: "accepted"
date: 2025-07-11
decision-makers: ["Development Team"]
consulted: ["Music Education Experts", "OpenAI API Documentation"]
informed: ["All Contributors"]
---

# Migrate to OpenSheetMusicDisplay (OSMD) with MusicXML for Music Notation

## Context and Problem Statement

The current `simple_sheet_music` package has significant limitations impacting the saxophone learning experience. It lacks critical musical notation features like time signatures, bar lines, repeat marks, dynamics, and articulations. The package also has unpredictable sizing behavior making legibility inconsistent. Users need professional-quality sheet music notation with complete musical symbols for effective practice.

## Decision Drivers

* Need for complete musical notation support (time signatures, dynamics, articulations)
* Requirement for professional-quality, publication-grade rendering
* Predictable and controllable sheet music sizing and legibility
* Integration with AI-generated practice routines
* Future scalability to native implementations
* Industry standard format compatibility

## Considered Options

* Continue with current `simple_sheet_music` package
* Migrate to OpenSheetMusicDisplay (OSMD) with MusicXML generation
* Implement VexFlow + WebView solution
* Build native platform solutions (SeeScore SDK, alphaTab)

## Decision Outcome

Chosen option: "OpenSheetMusicDisplay (OSMD) with MusicXML generation", because it provides professional-quality rendering, uses industry-standard MusicXML format, leverages OpenAI's proven MusicXML generation capabilities, and establishes a clear migration path to native implementations while delivering immediate improvement over current limitations.

### Consequences

* Good, because provides complete notation support (time signatures, repeats, dynamics, articulations)
* Good, because uses industry-standard MusicXML format compatible with all major music software
* Good, because OpenAI GPT-4o-mini can generate MusicXML directly with high accuracy
* Good, because establishes clear migration path to native solutions without AI retraining
* Good, because provides professional, publication-grade rendering quality
* Good, because offers predictable and controllable sheet music rendering
* Bad, because introduces WebView dependency and associated performance overhead
* Bad, because requires significant changes to current AI generation and rendering pipeline
* Bad, because WebView solution may have platform-specific rendering differences

### Confirmation

Implementation will be validated through:
- Comprehensive testing of MusicXML generation quality and accuracy
- Performance benchmarks comparing WebView rendering with current solution
- User testing to verify improved notation legibility and completeness
- Integration testing with existing AI-generated practice routines
- Storybook stories demonstrating all notation features

## Pros and Cons of the Options

### OpenSheetMusicDisplay (OSMD) with MusicXML

Professional music notation rendering using industry-standard MusicXML format in WebView.

* Good, because provides complete musical notation support including time signatures, dynamics, articulations
* Good, because uses MusicXML industry standard format ensuring compatibility
* Good, because OpenAI can generate MusicXML directly with proven accuracy
* Good, because offers professional, publication-grade rendering quality
* Good, because provides predictable sizing and legibility control
* Good, because establishes clear migration path to native solutions
* Good, because VexFlow-based rendering engine is mature and well-tested
* Neutral, because requires WebView integration with JavaScript bridge
* Bad, because introduces WebView performance overhead
* Bad, because requires significant changes to existing generation pipeline

### simple_sheet_music (Current)

Flutter-native package for basic music notation rendering.

* Good, because already implemented and integrated
* Good, because Flutter-native with no WebView dependency
* Good, because lightweight with minimal performance overhead
* Neutral, because provides basic note and rest rendering
* Bad, because missing critical features (time signatures, bar lines, repeat marks)
* Bad, because lacks dynamics and articulation support
* Bad, because has unpredictable sizing behavior affecting legibility
* Bad, because limited control over rendering appearance
* Bad, because not suitable for professional music education application

### VexFlow + WebView

Direct VexFlow integration with custom JavaScript bridge.

* Good, because mature notation library with 10+ years of development
* Good, because full notation support with extensive customization options
* Good, because cross-platform compatibility
* Neutral, because requires custom JSON to VexFlow API conversion
* Bad, because requires custom JavaScript integration and bridge development
* Bad, because uses non-standard format requiring custom conversion logic
* Bad, because medium complexity implementation with custom API learning curve

### Native Platform Solutions

Native iOS/Android implementations using commercial SDKs like SeeScore.

* Good, because provides best performance with native platform integration
* Good, because offers complete control over rendering and user experience
* Good, because enables advanced features like interactive notation and real-time highlighting
* Good, because provides offline rendering capabilities
* Neutral, because requires platform-specific development expertise
* Bad, because high implementation complexity requiring platform channels
* Bad, because commercial licensing costs for premium SDKs
* Bad, because significantly longer development timeline
* Bad, because requires maintenance of platform-specific codebases

## More Information

### Implementation Strategy

**Phase 1: OSMD Integration (MVP)**
- Add `webview_flutter` dependency and create OSMD HTML template
- Update OpenAI service to generate MusicXML instead of custom JSON
- Replace NotationView widget with WebView-based implementation
- Implement two-prompt AI strategy: separate routine generation from MusicXML generation
- Update tests and Storybook stories for MusicXML format

**Phase 2: Future Native Migration**
- Research and evaluate native SDK options (SeeScore, alphaTab)
- Implement platform channels for native rendering
- Maintain MusicXML format compatibility (no AI retraining required)
- Gradual migration starting with iOS, then Android

### AI Generation Architecture

**Two-Prompt Strategy:**
1. **Prompt 1**: Generate practice routines (pedagogical focus) with exercise metadata
2. **Prompt 2**: Generate MusicXML per exercise (musical notation focus)

Benefits:
- Better reliability with specialized prompts
- Parallel processing of multiple etudes
- Selective regeneration of failed notations
- Improved error handling and recovery

### Technical Architecture

**Current Data Flow:**
```
AI Generation → Custom JSON → SimpleSheetMusicService → List<Measure> → simple_sheet_music Widget
```

**New Data Flow (OSMD):**
```
AI Generation → MusicXML → WebView with OSMD → Professional Notation Rendering
```

**Future Data Flow (Native):**
```
AI Generation → MusicXML → Platform Channel → Native SDK → High-Performance Rendering
```

### Implementation Timeline

- **Estimated Time**: 2-3 development days for Phase 1 implementation
- **Risk Level**: Low-Medium with established technology integration
- **Testing**: Can run in parallel with existing system for validation

This decision provides immediate resolution of current notation limitations while establishing a clear evolution path for future native implementation, balancing technical debt reduction with feature completeness and scalability.