import 'dart:math';

/// Generates a collision-resistant, sortable identifier for local entities.
///
/// Format: `<millisecondsSinceEpoch>-<8 random hex chars>`. The timestamp
/// prefix keeps IDs roughly time-ordered (useful for debugging and stable
/// keys), while the random suffix prevents the silent overwrites that a plain
/// millisecond timestamp causes when two entries are created in the same ms.
String generateId() {
  final millis = DateTime.now().millisecondsSinceEpoch;
  final random = Random.secure();
  final suffix = List<String>.generate(
    8,
    (_) => random.nextInt(16).toRadixString(16),
  ).join();
  return '$millis-$suffix';
}
