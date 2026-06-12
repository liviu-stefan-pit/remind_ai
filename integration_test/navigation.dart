part of 'remind_ai_e2e_test.dart';

void navigationTests() {
  group('navigation', () {
    setUp(() async {
      await seedOnboardingComplete();
    });

    Future<void> pumpToHome(WidgetTester tester) async {
      await configureLargeTestSurface(tester);
      await pumpTestApp(tester);
      await pumpPastSplash(tester);
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));
    }

    testWidgets('settings, profile, and insights screens open from home',
        (tester) async {
      await pumpToHome(tester);

      await tapVisible(tester, find.byTooltip(AppStrings.settings));
      await pumpUntilFound(tester, find.text(AppStrings.settings));
      expect(find.text(AppStrings.appearance.toUpperCase()), findsOneWidget);

      await tapVisible(tester, find.text(AppStrings.themeLight));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(AppStrings.themeLight), findsWidgets);

      await tapVisible(tester, find.byTooltip('Back').first);
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      await tapVisible(tester, find.byTooltip(AppStrings.profile));
      await pumpUntilFound(tester, find.text(AppStrings.profile));
      expect(find.text(AppStrings.profile), findsOneWidget);

      await tapVisible(tester, find.byTooltip('Back').first);
      await pumpUntilFound(tester, find.text(AppStrings.homeTagline));

      await tapVisible(tester, find.byTooltip(AppStrings.insights));
      await pumpUntilFound(tester, find.text('Dream Insights'));
      expect(find.text('Dream Insights'), findsOneWidget);
    });

    testWidgets('Pro interpretation styles are locked on the Free tier',
        (tester) async {
      await pumpToHome(tester);

      await tapVisible(tester, find.text(AppStrings.interpretDream));
      await pumpUntilFound(tester, find.text(AppStrings.interpretationStyle));

      await tapVisible(tester, find.text(AppStrings.stylePsychologicalName));
      await pumpUntilFound(tester, find.text(AppStrings.proComingSoonStyle));

      expect(find.text(AppStrings.proComingSoonStyle), findsOneWidget);
      expect(find.text(AppStrings.styleStandardName), findsOneWidget);
    });
  });
}
