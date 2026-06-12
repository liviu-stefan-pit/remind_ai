part of 'remind_ai_e2e_test.dart';

void dreamFlowTests() {
  group('dream flow', () {
    setUp(() async {
      await seedOnboardingComplete();
    });

    Future<void> openDreamInput(WidgetTester tester) async {
      await configureLargeTestSurface(tester);
      await pumpTestApp(tester);
      await pumpPastSplash(tester);
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      await tapVisible(tester, find.text(AppStrings.interpretDream));
      await pumpUntilFound(tester, find.text(AppStrings.describeDreamLabel));
    }

    testWidgets('submit dream shows fake interpretation and saves to history',
        (tester) async {
      await openDreamInput(tester);

      await tester.enterText(find.byType(TextFormField), sampleDreamText);
      await tester.pump(const Duration(milliseconds: 200));

      await submitDreamForm(tester);
      await pumpUntilFound(
        tester,
        find.textContaining(kFakeInterpretationMarker),
      );

      expect(find.textContaining(kFakeInterpretationMarker), findsOneWidget);
      expect(find.text(sampleDreamText), findsAtLeastNWidgets(1));

      await tapVisible(tester, find.byTooltip('Back').first);
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      await tapVisible(tester, find.byTooltip(AppStrings.dreamHistory));
      await pumpUntilFound(tester, find.text(sampleDreamText));

      expect(find.text(sampleDreamText), findsOneWidget);
    });

    testWidgets('failing Gemini client surfaces an error snackbar',
        (tester) async {
      await configureLargeTestSurface(tester);
      await pumpTestApp(
        tester,
        geminiClient: const FakeGeminiClient(shouldFail: true),
      );
      await pumpPastSplash(tester);
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      await tapVisible(tester, find.text(AppStrings.interpretDream));
      await pumpUntilFound(tester, find.byType(TextFormField));

      await tester.enterText(find.byType(TextFormField), sampleDreamText);
      await tester.pump(const Duration(milliseconds: 200));

      await submitDreamForm(tester);
      await pumpUntilFound(tester, find.text(AppStrings.unexpectedError));

      expect(find.text(AppStrings.unexpectedError), findsOneWidget);
      expect(find.textContaining(kFakeInterpretationMarker), findsNothing);
    });
  });
}
