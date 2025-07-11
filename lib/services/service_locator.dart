import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/services/openai_service.dart';
import 'package:sax_buddy/features/practice/services/practice_generation_service.dart';
import 'package:sax_buddy/services/logger_service.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  static ServiceLocator get instance => _instance;
  
  ServiceLocator._internal();
  
  final Map<Type, dynamic> _services = {};
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;
  
  /// Initialize all services
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final logger = LoggerService.instance;
    logger.info('Initializing service locator');
    
    try {
      // Initialize OpenAI service
      final openAIService = OpenAIService();
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      
      if (apiKey != null && apiKey.isNotEmpty) {
        openAIService.initialize(apiKey);
        _services[OpenAIService] = openAIService;
        logger.debug('OpenAI service registered');
      } else {
        logger.warning('OpenAI API key not found in environment variables');
      }
      
      // Initialize Practice Generation service
      final practiceService = PracticeGenerationService();
      if (apiKey != null && apiKey.isNotEmpty) {
        practiceService.initialize(apiKey);
        _services[PracticeGenerationService] = practiceService;
        logger.debug('Practice generation service registered');
      } else {
        logger.warning('Cannot initialize practice generation service without OpenAI API key');
      }
      
      _isInitialized = true;
      logger.info('Service locator initialized successfully');
      
    } catch (e) {
      logger.error('Failed to initialize service locator: $e');
      rethrow;
    }
  }
  
  /// Get a service instance
  T get<T>() {
    if (!_isInitialized) {
      throw Exception('Service locator not initialized. Call initialize() first.');
    }
    
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T not found. Make sure it is registered.');
    }
    
    return service as T;
  }
  
  /// Register a service instance
  void register<T>(T service) {
    _services[T] = service;
  }
  
  /// Check if a service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }
  
  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'registeredServices': _services.keys.map((type) => type.toString()).toList(),
      'openAIServiceStatus': isRegistered<OpenAIService>() 
          ? get<OpenAIService>().getStatus()
          : {'status': 'not_registered'},
      'practiceServiceStatus': isRegistered<PracticeGenerationService>() 
          ? get<PracticeGenerationService>().getStatus()
          : {'status': 'not_registered'},
    };
  }
  
  /// Clear all services (useful for testing)
  void clear() {
    _services.clear();
    _isInitialized = false;
  }
}