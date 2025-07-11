import 'package:flutter/material.dart';
import '../../injection.dart';
import '../../services/logger_service.dart';
import 'landing_container.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<LoggerService>();
    return LandingContainer(logger: logger);
  }
}