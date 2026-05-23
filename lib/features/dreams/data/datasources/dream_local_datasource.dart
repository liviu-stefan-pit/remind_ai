import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_local_datasource.g.dart';

@Riverpod(keepAlive: true)
DreamLocalDatasource dreamLocalDatasource(Ref ref) {
  return DreamLocalDatasource(Hive.box<DreamEntry>('dreams'));
}

class DreamLocalDatasource {
  const DreamLocalDatasource(this._box);

  final Box<DreamEntry> _box;

  List<DreamEntry> getAll() => _box.values.toList();

  Option<DreamEntry> getById(String id) => Option.fromNullable(_box.get(id));

  Future<void> save(DreamEntry entry) => _box.put(entry.id, entry);

  Future<void> update(DreamEntry entry) => _box.put(entry.id, entry);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteAll() => _box.clear();
}
