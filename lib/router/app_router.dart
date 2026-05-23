// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/features/home/presentation/home_screen.dart';
import 'package:remind_ai/router/fade_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRoute {
  home;

  String get route => switch (this) {
    AppRoute.home => '/',
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
  ],
);
