import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/utils/dream_text_analyzer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insights_logic.g.dart';

/// Aggregated, derived view of the dream journal for the Pro dashboard.
class InsightsData {
  const InsightsData({
    required this.totalDreams,
    required this.topThemes,
    required this.styleBreakdown,
  });

  final int totalDreams;
  final List<KeywordCount> topThemes;
  final Map<DreamStyle, int> styleBreakdown;
}

@riverpod
InsightsData insights(Ref ref) {
  final dreams = ref.watch(dreamHistoryLogicProvider);

  final styleBreakdown = <DreamStyle, int>{};
  for (final dream in dreams) {
    styleBreakdown[dream.style] = (styleBreakdown[dream.style] ?? 0) + 1;
  }

  return InsightsData(
    totalDreams: dreams.length,
    topThemes: topKeywords(dreams.map((d) => d.dreamText)),
    styleBreakdown: styleBreakdown,
  );
}
