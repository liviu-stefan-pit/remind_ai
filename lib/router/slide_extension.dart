// ignore_for_file: strict_raw_type, always_specify_types

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideTransitionPage extends CustomTransitionPage {
  SlideTransitionPage({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

extension GoRouteSlideExtension on GoRoute {
  GoRoute slide() => GoRoute(
        path: path,
        pageBuilder: (context, state) => SlideTransitionPage(
          key: ValueKey<String>(path),
          child: builder!(context, state),
        ),
      );
}
