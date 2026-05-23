import 'package:flutter/material.dart';

/// Snappy motion tokens — all under 500 ms, single curve standard.
abstract final class AppMotion {
  static const instant = Duration(milliseconds: 120);
  static const quick = Duration(milliseconds: 200);
  static const standard = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 480);

  static const ease = Curves.easeOutCubic;
  static const easeIn = Curves.easeInCubic;
  static const easeInOut = Curves.easeInOutCubic;

  /// Returns zero duration when reduce-motion is enabled.
  static Duration adaptive(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
