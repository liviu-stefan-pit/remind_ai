import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fast snappy fade+scale transition (200 ms) — replaces the mushy
/// Material 3 shared-axis effect.
class SharedAxisTransitionPage extends CustomTransitionPage<void> {
  SharedAxisTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 160),
          transitionsBuilder: (context, animation, _, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final scale = Tween<double>(begin: 0.99, end: 1).animate(fade);
            return FadeTransition(
              opacity: fade,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
        );
}

extension GoRouteSharedAxisExtension on GoRoute {
  GoRoute sharedAxis() => GoRoute(
        path: path,
        pageBuilder: (context, state) => SharedAxisTransitionPage(
          key: ValueKey<String>(path),
          child: builder!(context, state),
        ),
      );
}
