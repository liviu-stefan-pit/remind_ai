import 'package:flutter_test/flutter_test.dart';
import 'package:remind_ai/utils/dream_text_analyzer.dart';

void main() {
  test('tallies meaningful keywords and ranks by frequency', () {
    final result = topKeywords([
      'I was flying over a vast ocean.',
      'Flying again, this time over a city ocean of lights.',
      'A calm ocean stretched forever.',
    ]);

    final byWord = {for (final k in result) k.keyword: k.count};
    expect(byWord['ocean'], 3);
    expect(byWord['flying'], 2);
    expect(result.first.keyword, 'ocean');
  });

  test('filters stop words and short words', () {
    final result = topKeywords(['the and was for it up to a an']);
    expect(result, isEmpty);
  });

  test('respects the limit', () {
    final result = topKeywords([
      'apple banana cherry mango grape lemon melon olive peach plum',
    ], limit: 3);
    expect(result.length, 3);
  });

  test('breaks frequency ties alphabetically and is case-insensitive', () {
    final result = topKeywords(['Zebra zebra Apple apple']);
    expect(result.map((k) => k.keyword).toList(), ['apple', 'zebra']);
  });

  test('returns empty for no input', () {
    expect(topKeywords(const <String>[]), isEmpty);
  });
}
