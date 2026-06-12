/// A keyword and how many times it appeared across analyzed dreams.
class KeywordCount {
  const KeywordCount(this.keyword, this.count);

  final String keyword;
  final int count;
}

/// Common English words filtered out so only meaningful dream themes surface.
const _stopWords = <String>{
  'the', 'and', 'was', 'were', 'are', 'for', 'with', 'that', 'this', 'they',
  'them', 'then', 'than', 'have', 'has', 'had', 'his', 'her', 'hers', 'him',
  'she', 'you', 'your', 'yours', 'our', 'ours', 'their', 'theirs', 'its',
  'but', 'not', 'all', 'any', 'can', 'could', 'would', 'should', 'did',
  'does', 'doing', 'done', 'from', 'into', 'onto', 'out', 'off', 'over',
  'under', 'about', 'after', 'before', 'again', 'just', 'like', 'very',
  'really', 'some', 'such', 'only', 'own', 'too', 'also', 'because', 'been',
  'being', 'there', 'here', 'where', 'when', 'what', 'which', 'who', 'whom',
  'how', 'why', 'will', 'shall', 'may', 'might', 'must', 'one', 'two', 'get',
  'got', 'now', 'see', 'saw', 'seen', 'feel', 'felt', 'went', 'goes', 'going',
  'come', 'came', 'said', 'say', 'says', 'tell', 'told', 'know', 'knew',
  'think', 'thought', 'around', 'while', 'still', 'back', 'down',
  'dream', 'dreamt', 'dreamed', 'dreaming', 'night', 'last',
};

/// Tallies the most frequent meaningful words across [texts].
///
/// Words are lowercased, tokenized on non-letters, stripped of stray
/// apostrophes, then filtered by [minLength] and a stop-word list. Ties are
/// broken alphabetically so the result is deterministic.
List<KeywordCount> topKeywords(
  Iterable<String> texts, {
  int limit = 8,
  int minLength = 3,
}) {
  final counts = <String, int>{};
  for (final text in texts) {
    for (final word in _tokenize(text)) {
      if (word.length < minLength) continue;
      if (_stopWords.contains(word)) continue;
      counts[word] = (counts[word] ?? 0) + 1;
    }
  }

  final entries = counts.entries.toList()
    ..sort((a, b) {
      final byCount = b.value.compareTo(a.value);
      return byCount != 0 ? byCount : a.key.compareTo(b.key);
    });

  return [
    for (final entry in entries.take(limit)) KeywordCount(entry.key, entry.value),
  ];
}

Iterable<String> _tokenize(String text) {
  return text
      .toLowerCase()
      .split(RegExp("[^a-z']+"))
      .map((word) => word.replaceAll(RegExp("^'+|'+\$"), ''))
      .where((word) => word.isNotEmpty);
}
