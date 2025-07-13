import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'dashboard/dashboard_stories.dart';
import 'assessment/assessment_stories.dart';
import 'assessment/real_time_waveform_stories.dart';
import 'notation/simple_sheet_music_stories.dart';
import 'routines/routines_stories.dart';
import 'notation/notation_view_stories.dart';
import 'notation/exercise_notation_card_stories.dart';

Future<void> main() async {
  // Initialize environment for storybook
  await dotenv.load(fileName: '.env');

  runApp(const StorybookApp());
}

class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      initialStory: 'Dashboard',
      stories: [
        ...dashboardStories,
        ...assessmentStories,
        ...realTimeWaveformStories,
        ...routinesStories,
        ...notationViewStories,
        ...exerciseNotationCardStories,
        ...sheetMusicStories,
      ],
      wrapperBuilder: (context, child) => MaterialApp(
        title: 'Sax Buddy Storybook',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E5266)),
          useMaterial3: true,
        ),
        home: Scaffold(body: Center(child: child)),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
