part of 'remind_ai_e2e_test.dart';

void onboardingFlowTests() {
  group('onboarding flow', () {
    testWidgets('fresh install shows onboarding then home after completion',
        (tester) async {
      await configureLargeTestSurface(tester);
      await pumpTestApp(tester);
      await pumpPastSplash(tester);

      expect(find.text('Catch your dreams before they fade'), findsOneWidget);

      await tapVisible(tester, find.text('Skip'));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text(AppStrings.ageGateLabel), findsOneWidget);

      await tapVisible(tester, find.text(AppStrings.ageGateLabel));
      await tester.pump(const Duration(milliseconds: 200));

      await tapVisible(tester, find.text(AppStrings.onboardingBegin));
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      expect(find.text(AppStrings.homeTagline), findsOneWidget);
    });

    testWidgets('returning user skips onboarding after splash', (tester) async {
      await configureLargeTestSurface(tester);
      await seedOnboardingComplete();
      await pumpTestApp(tester);
      await pumpPastSplash(tester);

      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      expect(find.text('Catch your dreams before they fade'), findsNothing);
      expect(find.text(AppStrings.homeTagline), findsOneWidget);
    });
  });
}
