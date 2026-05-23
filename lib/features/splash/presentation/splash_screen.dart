import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/rive/rive_widgets.dart';
import 'package:remind_ai/router/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final seen = ref.read(settingsLogicProvider).onboardingSeen;
    context.go(seen ? AppRoute.home.route : AppRoute.onboarding.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuietSky(
        child: Center(
          child: SplashIntroAnimation(size: 28),
        ),
      ),
    );
  }
}
