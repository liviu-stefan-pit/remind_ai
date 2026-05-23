// ignore_for_file: strict_raw_type, always_specify_types

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FadeTransitionPage extends CustomTransitionPage {
  FadeTransitionPage({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

extension GoRouteExtension on GoRoute {
  GoRoute fade() => GoRoute(
        path: path,
        pageBuilder: (context, state) => FadeTransitionPage(
          key: ValueKey<String>(path),
          child: builder!(context, state),
        ),
      );
}
