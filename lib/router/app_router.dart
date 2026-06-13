// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
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
  ref.listen(settingsLogicProvider, (_, __) => notifier.refresh());
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoute.splash.route,
    refreshListenable: notifier,
    redirect: (context, state) {
      final firebaseReady = ref.read(firebaseReadyProvider);
      if (!firebaseReady) return null;

      final authState = ref.read(authLogicProvider);
      final location = state.matchedLocation;
      final onboardingSeen = ref.read(settingsLogicProvider).onboardingSeen;

      // Fresh installs must complete onboarding before sign-in or any app route.
      if (!onboardingSeen) {
        final allowed = {AppRoute.splash.route, AppRoute.onboarding.route};
        if (!allowed.contains(location)) {
          return AppRoute.onboarding.route;
        }
      }

      // Hold on splash until Firebase auth resolves — avoids a flash of home /
      // history backed by stale local data on slow mobile networks. Stay on
      // sign-in during Google popup so we don't bounce through splash/onboarding.
      if (authState.isLoading) {
        if (location == AppRoute.splash.route ||
            location == AppRoute.signIn.route) {
          return null;
        }
        return AppRoute.splash.route;
      }

      final isAuthenticated = authState.asData?.value != null;
      final isPublic = _kPublicRoutes.contains(location);

      if (!isAuthenticated && !isPublic) {
        return AppRoute.signIn.route;
      }
      if (isAuthenticated && location == AppRoute.signIn.route) {
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
