import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_usage_service.g.dart';

const _kLastFreeUsageDateKey = 'lastFreeUsageDate';

@Riverpod(keepAlive: true)
FreeUsageService freeUsageService(Ref ref) {
  return FreeUsageService(Hive.box<String>('prefs'));
}

class FreeUsageService {
  const FreeUsageService(this._box);

  final Box<String> _box;

  DateTime? getLastFreeUsageDate() {
    final raw = _box.get(_kLastFreeUsageDateKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> recordFreeUsage() =>
      _box.put(_kLastFreeUsageDateKey, DateTime.now().toIso8601String());

  /// Returns true only if the user has never made a free request,
  /// or if their last free request was on a previous calendar day.
  bool canUseFreeRequest() {
    final last = getLastFreeUsageDate();
    if (last == null) return true;

    final today = DateTime.now();
    final lastDay = DateTime(last.year, last.month, last.day);
    final todayDay = DateTime(today.year, today.month, today.day);

    return lastDay.isBefore(todayDay);
  }
}
