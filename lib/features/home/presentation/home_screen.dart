import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(AppStrings.appName),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: AppStrings.dreamHistory,
          onPressed: () => context.push(AppRoute.history.route),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.auto_stories_outlined,
              size: 72,
              color: context.colorScheme.primary,
            ),
            const Gap(24),
            Text(
              AppStrings.homeTagline,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            Text(
              AppStrings.homeBody,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              AppStrings.homeCtaHint,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(80),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => context.push(AppRoute.dreamInput.route),
      icon: const Icon(Icons.auto_stories),
      label: const Text(AppStrings.interpretDream),
    ),
  );
}
