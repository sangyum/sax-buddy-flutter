---
status: "accepted"
date: 2025-07-14
decision-makers: [Engineering Team]
consulted: [Product Team, Architecture Review]
informed: [Development Team]
---

# Keep Unified PracticeGenerationService Architecture

## Context and Problem Statement

After implementing the generic OpenAI service refactor and moving domain-specific logic to PracticeGenerationService, we evaluated whether to further split the service into separate `PracticeGenerationService` and `EtudeGenerationService` components. The current service handles both practice routine structure generation and etude/MusicXML generation within a single cohesive unit, but we questioned whether this violates single responsibility principle.

## Decision Drivers

* Adherence to Single Responsibility Principle
* Service maintainability and testability
* Performance optimization for parallel processing
* Code reusability across different features
* System complexity vs. benefit trade-offs
* Future extensibility requirements

## Considered Options

* Keep unified PracticeGenerationService (current architecture)
* Split into separate PracticeGenerationService and EtudeGenerationService
* Create a coordinating service with separate generation services

## Decision Outcome

Chosen option: "Keep unified PracticeGenerationService", because it maintains domain cohesion where etudes are generated specifically within practice routine context, provides optimal performance with current parallel processing implementation, and avoids premature optimization complexity without clear immediate benefits.

### Consequences

* Good, because maintains simple, cohesive architecture with proven performance
* Good, because etudes are generated with full routine context (difficulty, target areas, musical focus)
* Good, because single service manages entire workflow including progress callbacks efficiently
* Good, because avoids coordination overhead between multiple services
* Bad, because future feature expansion may require architectural changes
* Neutral, because decision can be easily revisited as requirements evolve

### Confirmation

Implementation adherence will be confirmed through:
- Service size monitoring (alert if grows beyond 500 lines)
- Performance metrics tracking for routine generation
- Code review verification that methods maintain clear separation of concerns
- Test coverage validation for both routine and etude generation logic

## Pros and Cons of the Options

### Keep unified PracticeGenerationService

Current implementation where single service handles both practice routine structure and etude generation.

* Good, because etudes generated with contextual information (difficulty, target areas, musical focus)
* Good, because efficient parallel processing with `Future.wait()` within routine context
* Good, because simplified coordination and single service manages entire workflow
* Good, because reduced system complexity with fewer DI configurations
* Neutral, because service is well-structured at ~400 lines with clear method separation
* Bad, because may violate strict interpretation of Single Responsibility Principle

### Split into separate PracticeGenerationService and EtudeGenerationService

Create two distinct services with separate responsibilities.

* Good, because adheres strictly to Single Responsibility Principle
* Good, because improved testability with focused service scopes
* Good, because potential for etude service reusability in other features
* Good, because enables parallel development on different concerns
* Bad, because increased system complexity requiring coordination layer
* Bad, because no immediate plans for etude generation outside routine context
* Bad, because progress callbacks and error handling become more complex
* Bad, because premature optimization without clear performance benefits

### Create coordinating service with separate generation services

Hybrid approach with PracticeCoordinatorService managing separate generation services.

* Good, because maintains separation of concerns
* Good, because allows independent service optimization
* Neutral, because provides flexibility for future requirements
* Bad, because significantly increased complexity with three services
* Bad, because coordination overhead outweighs benefits
* Bad, because adds abstraction layers without immediate value

## More Information

This decision aligns with the principle of starting simple and refactoring when complexity or requirements justify it. The current service demonstrates good performance (50-60% improvement in generation time) and maintains clear internal method separation. We will revisit this decision if we add standalone etude generation features, the service grows beyond manageable size, or multiple teams need to work independently on routine vs. musical notation logic.