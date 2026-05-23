import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_usage_service.g.dart';

const _kFreeUsageDateKey = 'freeUsageDate';
const _kFreeUsageCountKey = 'freeUsageCount';
const _kMaxDailyFreeUsage = 3;

@Riverpod(keepAlive: true)
FreeUsageService freeUsageService(Ref ref) {
  return FreeUsageService(Hive.box<String>('prefs'));
}

class FreeUsageService {
  const FreeUsageService(this._box);

  final Box<String> _box;

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int getTodayUsageCount() {
    final storedDate = _box.get(_kFreeUsageDateKey);
    if (storedDate != _todayKey()) return 0;
    return int.tryParse(_box.get(_kFreeUsageCountKey) ?? '0') ?? 0;
  }

  Future<void> recordFreeUsage() async {
    final today = _todayKey();
    final storedDate = _box.get(_kFreeUsageDateKey);
    final currentCount = storedDate == today
        ? (int.tryParse(_box.get(_kFreeUsageCountKey) ?? '0') ?? 0)
        : 0;
    await _box.put(_kFreeUsageDateKey, today);
    await _box.put(_kFreeUsageCountKey, (currentCount + 1).toString());
  }

  /// Returns true if the user has used fewer than [_kMaxDailyFreeUsage]
  /// requests today.
  bool canUseFreeRequest() => getTodayUsageCount() < _kMaxDailyFreeUsage;
}
