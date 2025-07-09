## Phase 3: LLM Integration + Routine Generation (Updated with Dart OpenAI Package)

**Technical Implementation:**

### Dependencies
```yaml
dependencies:
  dart_openai: ^5.1.0
  flutter_dotenv: ^5.1.0
```

### Environment Setup
```dart
// .env file
OPENAI_API_KEY=your_openai_api_key_here
```

### Updated LLM Service
```dart
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LLMService {
  LLMService() {
    _initializeOpenAI();
  }
  
  void _initializeOpenAI() {
    OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;
    OpenAI.organization = dotenv.env['OPENAI_ORG_ID']; // Optional
  }
  
  Future<GeneratedRoutine> generatePracticeRoutine(AssessmentResult assessment) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-4-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                _getSystemPrompt(),
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                _buildPrompt(assessment),
              ),
            ],
          ),
        ],
        temperature: 0.7,
        maxTokens: 1500,
        responseFormat: OpenAIResponseFormat(
          type: OpenAIResponseFormatType.jsonObject,
        ),
      );
      
      final content = chatCompletion.choices.first.message.content?.first.text;
      if (content == null) {
        throw LLMException('No content received from OpenAI');
      }
      
      return _parseRoutineResponse(content);
      
    } on OpenAIException catch (e) {
      throw LLMException('OpenAI Error: ${e.message}');
    } catch (e) {
      throw LLMException('Failed to generate routine: $e');
    }
  }
  
  String _getSystemPrompt() {
    return '''
You are an expert saxophone instructor creating personalized practice routines. 
Analyze the user's performance data and generate targeted exercises.

RULES:
1. Generate 3-5 exercises focusing on detected weaknesses
2. Include mix of scales, arpeggios, and interval training
3. Respond ONLY with valid JSON in this exact format:

{
  "focus_area": "pitch_accuracy|timing|intonation|technique",
  "difficulty": "beginner|intermediate|advanced",
  "exercises": [
    {
      "type": "scale|arpeggio|interval|chromatic",
      "key_signature": "C|G|D|A|E|B|F#|Db|Ab|Eb|Bb|F",
      "notes": ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"],
      "rhythm": "quarter|eighth|dotted_quarter|mixed",
      "bpm": 80,
      "description": "Clear explanation of the exercise and focus points"
    }
  ]
}

Base difficulty on user's overall accuracy: <70% = beginner, 70-85% = intermediate, >85% = advanced.
''';
  }
  
  String _buildPrompt(AssessmentResult assessment) {
    final promptData = assessment.toPromptData();
    
    return '''
SAXOPHONE ASSESSMENT RESULTS:
${_formatAssessmentData(promptData)}

ANALYSIS:
- Overall accuracy: ${assessment.overallAccuracy.toStringAsFixed(1)}%
- Primary weaknesses: ${_identifyWeaknesses(assessment)}
- Recommended focus: ${_recommendFocus(assessment)}

Generate a personalized practice routine targeting these specific issues.
''';
  }
  
  String _formatAssessmentData(Map<String, dynamic> data) {
    // Format assessment data for better LLM understanding
    final buffer = StringBuffer();
    
    buffer.writeln('SCALE PERFORMANCE:');
    buffer.writeln('- Pitch accuracy: ${data['scale_performance']['pitch_accuracy']}%');
    buffer.writeln('- Timing accuracy: ${data['scale_performance']['timing_accuracy']}%');
    buffer.writeln('- Problem notes: ${data['scale_performance']['problem_notes']}');
    
    buffer.writeln('\nARPEGGIO PERFORMANCE:');
    buffer.writeln('- Pitch accuracy: ${data['arpeggio_performance']['pitch_accuracy']}%');
    buffer.writeln('- Interval accuracy: ${data['arpeggio_performance']['interval_accuracy']}%');
    
    buffer.writeln('\nINTERVAL PERFORMANCE:');
    buffer.writeln('- Pitch accuracy: ${data['interval_performance']['pitch_accuracy']}%');
    buffer.writeln('- Intonation issues: ${data['interval_performance']['intonation_issues']}');
    
    return buffer.toString();
  }
  
  List<String> _identifyWeaknesses(AssessmentResult assessment) {
    final weaknesses = <String>[];
    
    if (assessment.scaleAnalysis.pitchAccuracy < 80) {
      weaknesses.add('pitch_accuracy');
    }
    if (assessment.scaleAnalysis.timingAccuracy < 80) {
      weaknesses.add('timing_consistency');
    }
    if (assessment.intervalAnalysis.intervalAccuracy < 75) {
      weaknesses.add('intonation');
    }
    
    return weaknesses;
  }
  
  String _recommendFocus(AssessmentResult assessment) {
    final weaknesses = _identifyWeaknesses(assessment);
    
    if (weaknesses.contains('pitch_accuracy')) return 'pitch_accuracy';
    if (weaknesses.contains('timing_consistency')) return 'timing';
    if (weaknesses.contains('intonation')) return 'intonation';
    
    return 'technique'; // Default if no major weaknesses
  }
  
  GeneratedRoutine _parseRoutineResponse(String jsonResponse) {
    try {
      final data = jsonDecode(jsonResponse) as Map<String, dynamic>;
      
      final exercises = (data['exercises'] as List).map((exerciseData) {
        return Exercise(
          type: ExerciseType.values.firstWhere(
            (e) => e.toString().split('.').last == exerciseData['type']
          ),
          keySignature: exerciseData['key_signature'] as String,
          notes: List<String>.from(exerciseData['notes']),
          rhythm: exerciseData['rhythm'] as String,
          bpm: exerciseData['bpm'] as int,
          description: exerciseData['description'] as String,
        );
      }).toList();
      
      return GeneratedRoutine(
        id: _generateId(),
        exercises: exercises,
        focusArea: data['focus_area'] as String,
        difficulty: DifficultyLevel.values.firstWhere(
          (d) => d.toString().split('.').last == data['difficulty']
        ),
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw LLMException('Failed to parse routine response: $e');
    }
  }
  
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
```

### Enhanced Error Handling with OpenAI Package
```dart
import 'package:dart_openai/dart_openai.dart';

class LLMService {
  // ... previous code ...
  
  Future<GeneratedRoutine> generatePracticeRoutine(AssessmentResult assessment) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-4-turbo",
        messages: [
          // ... message setup ...
        ],
        temperature: 0.7,
        maxTokens: 1500,
      );
      
      return _parseRoutineResponse(
        chatCompletion.choices.first.message.content?.first.text ?? ''
      );
      
    } on OpenAIRateLimitException catch (e) {
      throw LLMException('Rate limit exceeded. Please try again later.');
    } on OpenAIServerException catch (e) {
      throw LLMException('OpenAI server error: ${e.message}');
    } on OpenAIException catch (e) {
      throw LLMException('OpenAI API error: ${e.message}');
    } catch (e) {
      throw LLMException('Unexpected error: $e');
    }
  }
}
```

### Initialization in Main App
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  runApp(MyApp());
}
```

**Key Advantages of dart_openai Package:**
- Type-safe API interactions
- Built-in error handling for different OpenAI error types
- Automatic request/response serialization
- Support for streaming responses (future enhancement)
- Better integration with Dart's async/await patterns

**Updated Dependencies:**
- `dart_openai: ^5.1.0`
- `flutter_dotenv: ^5.1.0`

**Deliverable:** Clean, type-safe LLM integration with proper error handling and structured response parsing.
