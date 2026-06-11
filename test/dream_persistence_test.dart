import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/features/dreams/data/datasources/dream_local_datasource.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/hive/hive_registrar.g.dart';

void main() {
  late Directory tempDir;
  late Box<DreamEntry> box;
  late DreamLocalDatasource datasource;

  DreamEntry sample(String id) => DreamEntry(
        id: id,
        dreamText: 'I was flying over a city of glass.',
        style: DreamStyle.standard,
        createdAt: DateTime(2026, 1, 2, 3, 4),
        interpretationText: 'Flight often reflects a desire for freedom.',
      );

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('remind_ai_test');
    Hive.init(tempDir.path);
    // registerAdapters registers all app adapters; guard against re-register.
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapters();
    }
    box = await Hive.openBox<DreamEntry>('dreams_test');
    datasource = DreamLocalDatasource(box);
  });

  tearDown(() async {
    await box.close();
    await Hive.deleteBoxFromDisk('dreams_test');
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('save then getById round-trips all fields', () async {
    final entry = sample('a1');
    await datasource.save(entry);

    final loaded = datasource.getById('a1');
    expect(loaded.isSome(), isTrue);
    loaded.match(() => fail('expected an entry'), (e) {
      expect(e.id, 'a1');
      expect(e.dreamText, entry.dreamText);
      expect(e.style, DreamStyle.standard);
      expect(e.createdAt, entry.createdAt);
      expect(e.interpretationText, entry.interpretationText);
      expect(e.isSynced, isFalse); // default preserved
    });
  });

  test('getAll returns every saved entry', () async {
    await datasource.save(sample('a1'));
    await datasource.save(sample('a2'));
    expect(datasource.getAll().length, 2);
  });

  test('delete removes a single entry', () async {
    await datasource.save(sample('a1'));
    await datasource.save(sample('a2'));
    await datasource.delete('a1');

    expect(datasource.getById('a1').isNone(), isTrue);
    expect(datasource.getById('a2').isSome(), isTrue);
    expect(datasource.getAll().length, 1);
  });

  test('deleteAll (clear history) empties the box', () async {
    await datasource.save(sample('a1'));
    await datasource.save(sample('a2'));
    await datasource.deleteAll();
    expect(datasource.getAll(), isEmpty);
  });

  test('data survives a box close and reopen (restart simulation)', () async {
    await datasource.save(sample('persist'));
    await box.close();

    final reopened = await Hive.openBox<DreamEntry>('dreams_test');
    final reloaded = DreamLocalDatasource(reopened).getById('persist');
    expect(reloaded.isSome(), isTrue);
    box = reopened; // so tearDown closes the live handle
  });
}
