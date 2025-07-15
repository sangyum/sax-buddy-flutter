---
status: "accepted"
date: 2025-01-14
decision-makers: ["Development Team"]
consulted: ["Product Owner", "UX Team"]
informed: ["Stakeholders"]
---

# Assessment Persistence Implementation with Current Routine Set Management

## Context and Problem Statement

The current assessment system allows users to evaluate their saxophone skills but does not persist the results, audio recordings, or assessment history. This prevents continuous learning and progress tracking. Additionally, the system lacks a clear concept of "current routines" - when multiple practice routines are generated from an assessment, users need to understand which routines are active versus historical.

The current implementation generates 2-5 practice routines per assessment, but there's no mechanism to:
1. Persist assessment results with audio recordings
2. Track assessment history and progress over time
3. Manage "current routine sets" vs historical routine sets
4. Provide clear ubiquitous language around assessment concepts

## Decision Drivers

* Need for persistent user progress tracking
* Requirement to store audio recordings for assessment history
* Clear distinction between current and historical practice routines
* Simplified ubiquitous language (removing "initial" vs "on-demand" assessment)
* Scalable architecture following existing repository patterns
* Comprehensive audio recording audit trail
* Support for multiple routine generation per assessment

## Considered Options

* **Option 1**: Store assessments in User model as embedded documents
* **Option 2**: Create separate AssessmentRepository with subcollection architecture
* **Option 3**: Extend existing PracticeRoutineRepository to handle assessment data
* **Option 4**: Create combined AssessmentRoutineRepository for unified management

## Decision Outcome

Chosen option: "**Option 2**: Create separate AssessmentRepository with subcollection architecture", because it provides the best separation of concerns, follows established patterns, and supports scalable assessment history management.

### Consequences

* Good, because maintains clean separation between assessment and routine domains
* Good, because follows established repository patterns (PracticeRoutineRepository)
* Good, because supports unlimited assessment history with subcollection architecture
* Good, because enables proper audio recording lifecycle management
* Good, because provides foundation for future assessment analytics
* Bad, because adds complexity with additional repository layer
* Bad, because requires careful coordination between assessment and routine persistence

### Confirmation

Implementation will be validated through:
1. Comprehensive test suite following TDD practices
2. Integration testing of assessment flow with persistence
3. Performance testing of subcollection queries
4. Code review ensuring architecture consistency
5. User acceptance testing of current routine set management

## Pros and Cons of the Options

### Option 1: Store assessments in User model as embedded documents

* Good, because simple single-document approach
* Good, because minimal additional complexity
* Bad, because limited scalability for assessment history
* Bad, because violates single responsibility principle
* Bad, because difficult to query assessment data independently

### Option 2: Create separate AssessmentRepository with subcollection architecture

* Good, because follows established repository patterns
* Good, because scalable subcollection design for assessment history
* Good, because proper separation of concerns
* Good, because supports complex assessment queries
* Good, because enables independent assessment data management
* Neutral, because adds additional repository layer
* Bad, because requires coordination between repositories

### Option 3: Extend existing PracticeRoutineRepository to handle assessment data

* Good, because unified data management
* Good, because reduced repository complexity
* Bad, because violates single responsibility principle
* Bad, because couples assessment and routine domains
* Bad, because complicates routine queries with assessment data

### Option 4: Create combined AssessmentRoutineRepository for unified management

* Good, because unified assessment and routine management
* Good, because simplified coordination
* Bad, because violates separation of concerns
* Bad, because creates overly complex repository
* Bad, because difficult to maintain and test

## Implementation Details

### Data Structure
- **User Model**: Extended with `currentAssessment`, `lastAssessmentDate`, `assessmentCount`
- **Assessment Subcollection**: `assessments/{userId}/results/{assessmentId}`
- **Audio Storage**: Firebase Storage URLs stored in assessment documents
- **Current Routine Set**: Multiple routines linked by `assessmentId` with `isCurrent` flag

### Ubiquitous Language
- **Assessment**: Any skill evaluation (no "initial" vs "on-demand" distinction)
- **Current Routine Set**: Latest generated set of routines based on most recent assessment
- **Assessment History**: All past assessments with full audio recording links
- **Routine Set**: Multiple practice routines generated from a single assessment

### Technical Approach
- JSON serialization for all assessment models
- Repository pattern following PracticeRoutineRepository
- Audio recording URL persistence in ExerciseResult
- Dependency injection integration
- TDD implementation with comprehensive test coverage

## More Information

This decision builds upon the existing architecture established in:
- ADR-001: Dependency Injection Standardization
- ADR-004: Incremental Practice Routine Generation
- ADR-005: Unified Practice Generation Service

The implementation will maintain backward compatibility and follow established patterns for error handling, logging, and performance monitoring. Future enhancements may include assessment analytics, progress visualization, and advanced querying capabilities.