// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/presentation/dream_input_screen.dart';
import 'package:remind_ai/features/dreams/presentation/history_screen.dart';
import 'package:remind_ai/features/dreams/presentation/interpretation_result_screen.dart';
import 'package:remind_ai/features/home/presentation/home_screen.dart';
import 'package:remind_ai/router/fade_extension.dart';
import 'package:remind_ai/router/slide_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRoute {
  home,
  dreamInput,
  result,
  history;

  String get route => switch (this) {
    AppRoute.home => '/',
    AppRoute.dreamInput => '/dream-input',
    AppRoute.result => '/result',
    AppRoute.history => '/history',
  };

  String get name => toString().replaceAll('AppRoute.', '');
}

@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: AppRoute.home.route,
  routes: <GoRoute>[
    GoRoute(
      path: AppRoute.home.route,
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ).fade(),
    GoRoute(
      path: AppRoute.dreamInput.route,
      builder: (BuildContext context, GoRouterState state) =>
          const DreamInputScreen(),
    ).slide(),
    GoRoute(
      path: AppRoute.result.route,
      builder: (BuildContext context, GoRouterState state) =>
          InterpretationResultScreen(entry: state.extra! as DreamEntry),
    ).slide(),
    GoRoute(
      path: AppRoute.history.route,
      builder: (BuildContext context, GoRouterState state) =>
          const HistoryScreen(),
    ).slide(),
  ],
);
