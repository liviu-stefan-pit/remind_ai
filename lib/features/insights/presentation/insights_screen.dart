import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/glass/liquid_panel.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/insights/presentation/insights_logic.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';
import 'package:remind_ai/utils/dream_text_analyzer.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  static const _title = 'Dream Insights';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(accessTierLogicProvider).tier.isPro;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text(_title)),
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: isPro
                  ? _InsightsBody()
                  : const _LockedTeaser(),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightsBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(insightsProvider);
    final aurora = context.auroraTheme;

    if (data.totalDreams < 3) {
      return Padding(
        padding: context.contentPadding,
        child: Center(
          child: Text(
            'Log at least 3 dreams to see which words show up most often.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(color: aurora.textDim),
          ),
        ),
      );
    }

    return ListView(
      padding: context.contentPadding.add(
        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      ),
      children: [
        _SectionLabel('Top recurring themes'),
        LiquidPanel(
          enableHoverGlow: false,
          child: SizedBox(
            height: 240,
            child: data.topThemes.isEmpty
                ? Center(
                    child: Text(
                      'No themes yet.',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: aurora.textDim),
                    ),
                  )
                : _ThemesBarChart(themes: data.topThemes),
          ),
        ),
        const Gap(AppSpacing.lg),
        _SectionLabel('Style usage'),
        LiquidPanel(
          enableHoverGlow: false,
          child: SizedBox(
            height: 240,
            child: _StylePieChart(breakdown: data.styleBreakdown),
          ),
        ),
        const Gap(AppSpacing.xl),
      ],
    );
  }
}

class _ThemesBarChart extends StatelessWidget {
  const _ThemesBarChart({required this.themes});

  final List<KeywordCount> themes;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    final maxCount =
        themes.map((t) => t.count).fold<int>(0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxCount + 1).toDouble(),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= themes.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      themes[index].keyword,
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: aurora.textDim),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < themes.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: themes[i].count.toDouble(),
                  color: aurora.accent,
                  width: 14,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StylePieChart extends StatelessWidget {
  const _StylePieChart({required this.breakdown});

  final Map<DreamStyle, int> breakdown;

  static String _label(DreamStyle s) => switch (s) {
    DreamStyle.standard => 'Standard',
    DreamStyle.psychological => 'Psychological',
    DreamStyle.mythic => 'Mythic',
    DreamStyle.creative => 'Creative',
  };

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    final palette = <Color>[
      aurora.accent,
      aurora.accentSoft,
      const Color(0xFF7C9CF5),
      const Color(0xFFB388F5),
    ];

    final entries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value.toDouble(),
                    color: palette[i % palette.length],
                    radius: 56,
                    title: total == 0
                        ? ''
                        : '${((entries[i].value / total) * 100).round()}%',
                    titleStyle: context.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF1A1305),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Gap(AppSpacing.md),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < entries.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: palette[i % palette.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      '${_label(entries[i].key)} (${entries[i].value})',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LockedTeaser extends StatelessWidget {
  const _LockedTeaser();

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return Padding(
      padding: context.contentPadding,
      child: Center(
        child: LiquidPanel(
          enableHoverGlow: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insights_rounded, size: 40, color: aurora.accent),
              const Gap(AppSpacing.md),
              Text(
                'Insights is a Pro feature',
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.sm),
              Text(
                'See which words and styles show up most in your journal and how '
                'you interpret them. Upgrade to unlock your personal dashboard.',
                style:
                    context.textTheme.bodyMedium?.copyWith(color: aurora.textDim),
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.lg),
              GlassButton(
                onPressed: () => context.push(AppRoute.profile.route),
                child: const Text('See Pro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.sectionLabel(aurora.textDim),
      ),
    );
  }
}
