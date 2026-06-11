import 'package:flutter_test/flutter_test.dart';
import 'package:remind_ai/utils/id_generator.dart';

void main() {
  test('generateId returns a timestamp-prefixed id with a random suffix', () {
    final id = generateId();
    final parts = id.split('-');
    expect(parts.length, 2);
    expect(int.tryParse(parts[0]), isNotNull); // millis prefix
    expect(parts[1].length, 8); // hex suffix
  });

  test('generateId is unique even within the same millisecond', () {
    final ids = List.generate(1000, (_) => generateId()).toSet();
    expect(ids.length, 1000);
  });
}
