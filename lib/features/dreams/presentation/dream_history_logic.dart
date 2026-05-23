import 'package:remind_ai/features/dreams/data/datasources/dream_local_datasource.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_history_logic.g.dart';

@riverpod
class DreamHistoryLogic extends _$DreamHistoryLogic {
  @override
  List<DreamEntry> build() {
    final entries = ref.read(dreamLocalDatasourceProvider).getAll();
    return [...entries]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> delete(String id) async {
    await ref.read(dreamLocalDatasourceProvider).delete(id);
    state = state.where((e) => e.id != id).toList();
  }
}
