---
status: "accepted"
date: 2025-07-14
decision-makers: ["sangyum", "Claude Code"]
consulted: []
informed: []
---

# Incremental Practice Routine Generation with Batched Etude Processing

## Context and Problem Statement

The current practice routine generation system processes OpenAI API calls sequentially, creating significant performance bottlenecks and poor user experience. Users must wait 40-60 seconds with only a loading spinner while the system generates practice routines and individual exercise etudes. With 4 routines containing 3 exercises each, this results in 13 sequential API calls (1 for routines + 12 for individual exercise etudes), leading to unacceptable wait times that compromise the app's value proposition of providing immediate, personalized feedback.

## Decision Drivers

* **Performance**: Current 40-60 second wait times are unacceptable for mobile user experience
* **User Experience**: Need incremental feedback and progress indicators during generation
* **Maintainability**: Prefer simple architectural changes over complex backend infrastructure 
* **Scope Constraints**: Firebase Functions backend migration should be deferred to Post-MVP phase
* **Personalization**: Must maintain AI-generated content quality without fallback routines

## Considered Options

* **Option 1**: Full Firebase Functions backend with streaming delivery
* **Option 2**: One etude per routine instead of per exercise
* **Option 3**: Batched parallel processing per routine with incremental UI updates
* **Option 4**: Complete sequential processing optimization

## Decision Outcome

Chosen option: "**Batched parallel processing per routine with incremental UI updates**", because it provides significant performance improvements (50-60% faster) while maintaining the current architecture and avoiding complex backend infrastructure changes. This solution enables incremental user feedback as each routine completes while keeping the personalized one-etude-per-exercise design.

### Consequences

* Good, because reduces total generation time from 40-60s to 15-20s
* Good, because enables incremental UI updates as each routine batch completes
* Good, because maintains existing data model and architectural patterns
* Good, because provides immediate user feedback and progress indicators
* Good, because allows users to interact with completed routines while others generate
* Bad, because still requires multiple API calls (though now batched)
* Bad, because doesn't achieve the full performance potential of backend processing
* Neutral, because defers more complex optimizations to future iterations

### Confirmation

Implementation success will be confirmed through:
- Performance testing showing 50-60% improvement in generation times
- User experience testing validating incremental feedback effectiveness
- Code review ensuring proper error handling within batched processing
- Unit tests verifying parallel processing logic and progress callbacks

## Pros and Cons of the Options

### Full Firebase Functions backend with streaming delivery

Complete migration to server-side processing with real-time Firestore updates for maximum performance and user experience.

* Good, because provides 80-90% performance improvement
* Good, because enables true streaming delivery with real-time updates
* Good, because improves security by moving API keys to server
* Good, because enables advanced features like caching and retry logic
* Bad, because requires significant infrastructure changes and complexity
* Bad, because extends development timeline beyond current sprint capacity
* Bad, because introduces new failure modes and monitoring requirements

### One etude per routine instead of per exercise

Generate a single comprehensive etude per routine that incorporates all exercise concepts.

* Good, because reduces API calls from 12 to 4 for etude generation
* Good, because provides significant performance improvement
* Good, because enables parallel processing of routine etudes
* Bad, because changes the fundamental content model and user experience
* Bad, because reduces granular exercise-specific musical content
* Bad, because requires extensive UI and data model changes

### Batched parallel processing per routine with incremental UI updates

Process exercises within each routine in parallel batches, providing UI updates as each routine completes.

* Good, because provides 50-60% performance improvement with minimal architectural changes
* Good, because enables incremental user feedback and progress indicators
* Good, because maintains existing data model and exercise-specific content
* Good, because allows immediate interaction with completed routines
* Good, because preserves personalized one-etude-per-exercise design
* Neutral, because provides good but not optimal performance gains
* Bad, because still requires multiple API call batches (though parallelized)

### Complete sequential processing optimization

Optimize the current sequential approach without architectural changes.

* Good, because requires minimal code changes
* Good, because maintains existing architecture completely
* Bad, because provides limited performance improvements
* Bad, because doesn't address the fundamental sequential bottleneck
* Bad, because fails to provide incremental user feedback

## More Information

This decision represents a balanced approach that delivers significant performance improvements while maintaining development velocity and architectural simplicity. The implementation will:

1. Modify `OpenAIService.generatePracticePlan()` to use `Future.wait()` for parallel processing within each routine
2. Add progress callbacks to enable incremental UI updates
3. Update assessment completion flow to display routines as they complete
4. Maintain existing error handling and fallback mechanisms

The Firebase Functions backend migration (Option 1) remains planned for Post-MVP phase and will build upon this foundation to deliver the full performance and user experience vision.

Performance targets:
- Current: 40-60 seconds total wait time
- After implementation: 15-20 seconds with incremental feedback
- Future (Post-MVP): 5-10 seconds with streaming delivery

This decision should be re-evaluated after Post-MVP planning to determine the timeline for full backend migration.