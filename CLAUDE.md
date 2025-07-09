# Saxophone Learning App - MVP Summary

## Motivation
Self-taught saxophonists lack structured feedback and personalized practice routines. Existing apps only provide basic pitch/timing feedback, but don't generate targeted practice plans based on detected weaknesses.

## Core Value Proposition
AI-powered practice routine generation based on real-time analysis of user's playing, targeting intermediate self-taught players who understand basic music theory.

## Key Features
- **Guided Assessment:** 3-exercise baseline (scale + arpeggio + interval pattern)
- **Real-time Analysis:** Pitch accuracy and timing detection via mobile microphone
- **AI-Generated Routines:** LLM creates personalized scale/arpeggio variations and interval training
- **Visual + Audio Output:** Sheet music notation with reference audio playback
- **Smart Monetization:** 14-day free trial with 3-5 routine limit, then subscription

## User Workflow
1. Open app → Complete 3-exercise guided assessment
2. App analyzes pitch/timing → Sends data to LLM API
3. Receive personalized practice routine with notation + audio
4. Practice with generated exercises
5. (Future iterations: Re-assess and adapt)

## Tech Stack
- **Mobile:** Flutter + Dart
- **Domain Design:** TypeScript interfaces → Dart classes
- **Backend:** Firebase (Auth + Firestore)
- **AI:** Direct LLM API calls (OpenAI/Claude)
- **Audio:** flutter_sound + pitch detection libraries
- **Payments:** RevenueCat for subscription management

## Development Phases
1. **User Accounts** - Firebase auth, trial tracking, subscription flow - See @docs/PHASE1
2. **Audio Recording/Analysis** - Basic pitch/timing detection prototype - See @docs/PHASE2
3. **LLM Integration** - AI routine generation with structured prompts - See @docs/PHASE3
4. **Notation + Audio** - Sheet music rendering with reference playback - See @docs/PHASE4

## Development Practices

1. Act as a pairing partner for the user. Seek consensus before proceeding
2. Strict Test-Driven Development (TDD)
  * RED - Write a failing test
  * GEEN - Implement with the least amount of code to make the test pass
  * BLUE - Refactor to cleanup/optimize the code


