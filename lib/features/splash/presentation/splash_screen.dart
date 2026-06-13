import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/rive/rive_widgets.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:remind_ai/router/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), _maybeNavigate);
  }

  void _maybeNavigate() {
    if (!mounted || _navigated) return;

    final firebaseReady = ref.read(firebaseReadyProvider);
    if (firebaseReady && ref.read(authLogicProvider).isLoading) {
      return;
    }

    _navigated = true;
    final seen = ref.read(settingsLogicProvider).onboardingSeen;

    if (!firebaseReady) {
      context.go(seen ? AppRoute.home.route : AppRoute.onboarding.route);
      return;
    }

    final isAuthenticated = ref.read(authLogicProvider).asData?.value != null;
    if (!isAuthenticated) {
      context.go(seen ? AppRoute.signIn.route : AppRoute.onboarding.route);
      return;
    }

    context.go(AppRoute.home.route);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authLogicProvider, (_, next) {
      if (!next.isLoading) _maybeNavigate();
    });

    return Scaffold(
      body: QuietSky(
        child: Center(
          child: SplashIntroAnimation(size: 28),
        ),
      ),
    );
  }
}
