import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/features/assessment/widgets/assessment_action_buttons.dart';
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart';

void main() {
  group('AssessmentActionButtons', () {
    late AssessmentProvider assessmentProvider;

    setUp(() {
      dotenv.testLoad(fileInput: '''
ENVIRONMENT=test
DEVELOPMENT_MODEL_ID=test
PRODUCTION_MODEL_ID=test
''');
      assessmentProvider = AssessmentProvider();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<AssessmentProvider>.value(
        value: assessmentProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: AssessmentActionButtons(),
          ),
        ),
      );
    }

    testWidgets('renders both action buttons', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Generate Practice Routine'), findsOneWidget);
      expect(find.text('Return to Dashboard'), findsOneWidget);
    });

    testWidgets('generates practice routine button has correct styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);

      final elevatedButton = tester.widget<ElevatedButton>(button);
      expect(elevatedButton.style?.backgroundColor?.resolve({}), const Color(0xFF2E5266));
    });

    testWidgets('return to dashboard button has correct styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final button = find.byType(TextButton);
      expect(button, findsOneWidget);

      final textButton = tester.widget<TextButton>(button);
      final textWidget = textButton.child as Text;
      expect(textWidget.style?.color, const Color(0xFF2E5266));
    });

    testWidgets('tapping generate practice routine shows snackbar', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Generate Practice Routine'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Practice routine generation coming soon!'), findsOneWidget);
    });
  });
}