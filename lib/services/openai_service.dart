import 'package:dart_openai/dart_openai.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class OpenAIService {
  final LoggerService _logger;
  bool _isInitialized = false;

  OpenAIService(this._logger);

  bool get isInitialized => _isInitialized;

  /// Initialize the OpenAI service with API key
  void initialize(String apiKey) {
    try {
      OpenAI.apiKey = apiKey;
      _isInitialized = true;
      _logger.debug('OpenAI service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize OpenAI service: $e');
      rethrow;
    }
  }


  /// Generic method to generate a response from OpenAI given a prompt
  Future<String> generateResponse(String prompt) async {
    if (!_isInitialized) {
      throw Exception('OpenAI service not initialized');
    }

    try {
      final response = await OpenAI.instance.chat.create(
        model: 'gpt-4o-mini',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                'You are an expert assistant. Provide helpful, accurate responses.',
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
          ),
        ],
        maxTokens: 2000,
        temperature: 0.7,
      );

      if (response.choices.isEmpty) {
        throw Exception('No response from OpenAI');
      }

      final content = response.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('Empty response from OpenAI');
      }

      _logger.debug('Generated response from OpenAI');
      return content.first.text ?? '';
    } catch (e) {
      _logger.error('OpenAI API request failed: $e');
      rethrow;
    }
  }

  /// Generate multiple responses in parallel for batch processing
  Future<List<String>> generateBatchResponses(List<String> prompts) async {
    if (!_isInitialized) {
      throw Exception('OpenAI service not initialized');
    }

    try {
      final futures = prompts.map((prompt) => generateResponse(prompt)).toList();
      return await Future.wait(futures);
    } catch (e) {
      _logger.error('Batch OpenAI requests failed: $e');
      rethrow;
    }
  }


  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'service': 'OpenAI',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
