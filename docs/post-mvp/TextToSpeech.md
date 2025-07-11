# Text-to-Speech Implementation Plan for Exercise Instructions

## Overview
Implement OpenAI's text-to-speech API to read exercise instructions in a friendly voice when users land on the exercise screen during assessment, with intuitive voice controls integrated into the exercise card.

## Implementation Plan

### Phase 1: Create TextToSpeechService (TDD)
1. **Write failing test** for `TextToSpeechService`
   - Test TTS generation from exercise instructions
   - Test audio file caching and management
   - Test service initialization with OpenAI
   - Test error handling and fallbacks

2. **Implement TextToSpeechService** to make tests pass
   - Use OpenAI TTS API via existing `dart_openai` package
   - Generate friendly, conversational instruction audio
   - Cache audio files to avoid repeated API calls
   - Handle graceful fallbacks when TTS fails

3. **Add to dependency injection**
   - Register as `@lazySingleton` in DI container
   - Constructor inject `OpenAIService` and `LoggerService`

### Phase 2: Audio Playback Infrastructure
1. **Add audio playback dependency**
   - Add `audioplayers: ^6.0.0` to `pubspec.yaml`
   - Update DI configuration for audio services

2. **Create AudioPlayerService**
   - Manage audio playback state (play/pause/stop)
   - Handle audio resource cleanup
   - Provide playback progress tracking

### Phase 3: Voice Control UI Components
1. **Create VoiceInstructionWidget**
   - Playback controls (play/pause/replay/transcript)
   - Progress bar with time display
   - Loading states during TTS generation
   - Error handling with text fallback

2. **Update ExerciseCard widget**
   - Integrate VoiceInstructionWidget into exercise card
   - Maintain existing layout and design consistency
   - Add voice control section between instructions and exercise info

### Phase 4: Integration with Exercise Flow
1. **Update ExerciseSetup screen**
   - Add TTS auto-play trigger when exercise loads
   - Pass voice control callbacks to ExerciseCard
   - Handle voice control state management

2. **Enhanced ExercisePresentation**
   - Pass audio services down to child widgets
   - Manage TTS lifecycle with exercise state
   - Coordinate voice playback with recording workflow

### Phase 5: Optimization & Polish
1. **Performance optimizations**
   - Pre-generate TTS for all exercises on assessment start
   - Smart caching strategy with cache expiration
   - Background audio generation

2. **User experience enhancements**
   - User preference for auto-play on/off
   - Friendly instruction prompt engineering
   - Smooth transitions between exercise states

## Technical Implementation Details

### Services Architecture
```dart
@lazySingleton
class TextToSpeechService {
  Future<File> generateInstructionAudio(AssessmentExercise exercise);
  String _createFriendlyInstructions(AssessmentExercise exercise);
  Future<File?> getCachedAudio(String cacheKey);
}

@injectable
class AudioPlayerService {
  Future<void> play(String filePath);
  Future<void> pause();
  Future<void> stop();
  Stream<Duration> get positionStream;
}
```

### UI Components
```dart
class VoiceInstructionWidget extends StatefulWidget {
  final AssessmentExercise exercise;
  final VoidCallback? onTranscriptToggle;
}

// Updated ExerciseCard with voice controls
class ExerciseCard extends StatelessWidget {
  // ... existing properties
  final bool showVoiceControls;
  final VoiceControlCallbacks? voiceCallbacks;
}
```

### Integration Points
- **Auto-trigger**: Generate and play TTS when user lands on exercise
- **Exercise Card**: Embed voice controls in existing card design
- **State Management**: Coordinate with existing exercise state flow
- **Error Handling**: Graceful degradation to text-only mode

## Dependencies to Add
```yaml
dependencies:
  audioplayers: ^6.0.0  # Audio playback functionality
```

## OpenAI TTS Configuration
- **Model**: `tts-1` (standard quality, faster generation)
- **Voice**: `nova` (clear, friendly female voice)
- **Format**: MP3 for broad compatibility
- **Prompt Enhancement**: Convert technical instructions to conversational guidance

## UI Mockup

### Enhanced Exercise Card with Voice Controls
```
┌─────────────────────────────────┐
│          Exercise 2             │
│      C Major Arpeggio           │
│                                 │
│ Play C-E-G-C arpeggio, two     │
│ octaves, quarter notes at 70    │
│ BPM                             │
│                                 │
│ ┌─────────────────────────────┐ │ ← Voice Control Section
│ │  🔊 Listen to Instructions   │ │
│ │  ▶️  ⏸️  🔄  📄            │ │
│ │  [████████░░] 0:15 / 0:23   │ │
│ └─────────────────────────────┘ │
│                                 │
│ Duration: 45 sec | Tempo: 70    │
│ Focus: interval accuracy...     │
└─────────────────────────────────┘
```

### Voice Control Component Details

#### 1. Voice Control Header
- **Icon**: Speaker/audio icon (🔊)
- **Text**: "Listen to Instructions"
- **Purpose**: Clear indication of audio functionality

#### 2. Playback Controls Row
- **Play/Pause** (▶️/⏸️): Toggle audio playback
- **Replay** (🔄): Restart instruction audio
- **Transcript** (📄): Show/hide text transcript
- **Visual State**: Active button highlighted

#### 3. Progress Bar
- **Progress Bar**: Visual playback progress
- **Time Display**: Current time / Total duration format
- **Interactive**: Optional tap to seek functionality

#### 4. States
- **Loading**: "Generating voice instructions..." with loading bar
- **Playing**: Active progress with pause button
- **Paused**: Static progress with play button
- **Complete**: Full progress bar with replay option
- **Error**: "Instructions not available" with text-only fallback

## Visual Design Specifications

### Colors & Typography
- **Background**: Light gray (#FAFAFA) - matches current theme
- **Card Background**: White with subtle shadow
- **Primary Color**: #2E5266 (current theme)
- **Text**: #212121 (current)
- **Secondary Text**: #757575
- **Active Controls**: #2E5266
- **Inactive Controls**: #BDBDBD

### Spacing & Layout
- **Voice Control Section**: 
  - Padding: 12px all sides
  - Border radius: 8px
  - Background: #F5F5F5 (subtle)
- **Control Buttons**: 
  - Size: 40x40px
  - Spacing: 8px between buttons
- **Progress Bar**: 
  - Height: 4px
  - Margin: 8px vertical

## Accessibility Features
- **Screen Reader**: Full VoiceOver/TalkBack support
- **Large Text**: Respects system font scaling
- **High Contrast**: Sufficient color contrast ratios
- **Touch Targets**: Minimum 44x44px for all buttons

## User Experience Flow
1. **Landing**: Auto-generate and play instructions (if enabled)
2. **Control**: User can pause, replay, or view transcript
3. **Fallback**: Text instructions always available
4. **Preference**: Setting to disable auto-play
5. **Caching**: Subsequent visits play instantly

## Benefits
1. **Accessibility**: Better support for users with reading difficulties
2. **Hands-free**: Users can listen while preparing their instrument
3. **Professional Feel**: Enhanced app experience with voice guidance
4. **User Engagement**: More interactive and immersive learning experience

## Risk Mitigation
- **Graceful Degradation**: App works fully without TTS
- **Caching Strategy**: Offline capability with cached audio files
- **Non-blocking**: TTS generation doesn't delay core functionality
- **Error Handling**: Clear fallbacks to text instructions
- **Performance**: Background generation and smart caching

## Future Considerations
- **Voice Selection**: Multiple voice options if OpenAI expands offerings
- **Language Support**: Multi-language instruction support
- **Personalization**: User-customizable reading speed and tone
- **Advanced Features**: Interactive voice responses and adaptive instruction complexity

---

**Status**: Planning phase - not part of current MVP
**Priority**: Post-MVP enhancement
**Estimated Effort**: 2-3 weeks
**Dependencies**: Existing OpenAI integration, stable exercise flow