// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/features/auth/presentation/sign_in_screen.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/presentation/dream_input_screen.dart';
import 'package:remind_ai/features/dreams/presentation/history_screen.dart';
import 'package:remind_ai/features/dreams/presentation/interpretation_result_screen.dart';
import 'package:remind_ai/features/home/presentation/home_screen.dart';
import 'package:remind_ai/features/insights/presentation/insights_screen.dart';
import 'package:remind_ai/features/onboarding/presentation/onboarding_screen.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:remind_ai/features/profile/presentation/profile_screen.dart';
import 'package:remind_ai/features/settings/presentation/settings_screen.dart';
import 'package:remind_ai/features/splash/presentation/splash_screen.dart';
import 'package:remind_ai/router/shared_axis_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Routes that do not require the user to be authenticated.
const _kPublicRoutes = {'/', '/onboarding', '/sign-in'};

/// Wires Riverpod auth state changes into GoRouter's refresh mechanism.
class _RouterRefreshListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}

enum AppRoute {
  splash,
  onboarding,
  signIn,
  home,
  dreamInput,
  result,
  history,
  settings,
  profile,
  insights;

  String get route => switch (this) {
    AppRoute.splash => '/',
    AppRoute.onboarding => '/onboarding',
    AppRoute.signIn => '/sign-in',
    AppRoute.home => '/home',
    AppRoute.dreamInput => '/dream-input',
    AppRoute.result => '/result',
    AppRoute.history => '/history',
    AppRoute.settings => '/settings',
    AppRoute.profile => '/profile',
    AppRoute.insights => '/insights',
  };

  String get name => toString().replaceAll('AppRoute.', '');
}

@riverpod
GoRouter appRouter(Ref ref) {
  final notifier = _RouterRefreshListenable();

  ref.listen(authLogicProvider, (_, __) => notifier.refresh());
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoute.splash.route,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authLogicProvider);

      // While auth is resolving, don't redirect.
      if (authState.isLoading) return null;

      final isAuthenticated = authState.asData?.value != null;
      final isPublic = _kPublicRoutes.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublic) {
        return AppRoute.signIn.route;
      }
      if (isAuthenticated && state.matchedLocation == AppRoute.signIn.route) {
        return AppRoute.home.route;
      }
      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: AppRoute.splash.route,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.onboarding.route,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.signIn.route,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.home.route,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.dreamInput.route,
        builder: (BuildContext context, GoRouterState state) =>
            const DreamInputScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.result.route,
        builder: (BuildContext context, GoRouterState state) =>
            InterpretationResultScreen(entry: state.extra! as DreamEntry),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.history.route,
        builder: (BuildContext context, GoRouterState state) =>
            const HistoryScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.settings.route,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.profile.route,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
      ).sharedAxis(),
      GoRoute(
        path: AppRoute.insights.route,
        builder: (BuildContext context, GoRouterState state) =>
            const InsightsScreen(),
      ).sharedAxis(),
    ],
  );
}
