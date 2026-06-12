import 'package:hive_ce/hive.dart';
import 'package:remind_ai/config/access_tier/access_tier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usage_quota_service.g.dart';

const _kUsageDateKey = 'usageDate';
const _kUsageCountKey = 'usageCount';
const _kLastSubmitKey = 'lastSubmitMs';

/// Daily interpretation cap for free users.
const _kFreeDailyLimit = 3;

/// Daily interpretation cap for Pro users. Generous for real use, but bounded
/// so a compromised/scripted Pro session can't run up unbounded cost against
/// the more expensive Pro model.
const _kProDailyLimit = 20;

/// Minimum spacing between submissions. Blocks rapid-fire scripted taps.
const _kMinSubmitInterval = Duration(seconds: 15);

@Riverpod(keepAlive: true)
UsageQuotaService usageQuotaService(Ref ref) {
  return UsageQuotaService(Hive.box<String>('prefs'));
}

class UsageQuotaService {
  const UsageQuotaService(this._box);

  final Box<String> _box;

  static int dailyLimitFor(AccessTier tier) =>
      tier.isPro ? _kProDailyLimit : _kFreeDailyLimit;

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int getTodayUsageCount() {
    final storedDate = _box.get(_kUsageDateKey);
    if (storedDate != _todayKey()) return 0;
    return int.tryParse(_box.get(_kUsageCountKey) ?? '0') ?? 0;
  }

  /// Remaining interpretations for [tier] today (clamped at zero).
  int remainingToday(AccessTier tier) {
    final remaining = dailyLimitFor(tier) - getTodayUsageCount();
    return remaining < 0 ? 0 : remaining;
  }

  /// Whether the user still has daily quota left for their [tier].
  bool canSubmit(AccessTier tier) =>
      getTodayUsageCount() < dailyLimitFor(tier);

  /// Whether enough time has elapsed since the last submission. Guards against
  /// rapid-fire scripted requests regardless of tier.
  bool isThrottled() {
    final last = int.tryParse(_box.get(_kLastSubmitKey) ?? '');
    if (last == null) return false;
    final elapsed = DateTime.now().millisecondsSinceEpoch - last;
    return elapsed < _kMinSubmitInterval.inMilliseconds;
  }

  /// Records the submit timestamp used by [isThrottled]. Called at the start of
  /// a submission attempt so even failed/in-flight requests count toward the
  /// throttle window.
  Future<void> markSubmitAttempt() async {
    await _box.put(
      _kLastSubmitKey,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Increments the daily counter. Called only after a successful
  /// interpretation so failed requests never consume quota.
  Future<void> recordUsage() async {
    final today = _todayKey();
    final storedDate = _box.get(_kUsageDateKey);
    final currentCount = storedDate == today
        ? (int.tryParse(_box.get(_kUsageCountKey) ?? '0') ?? 0)
        : 0;
    await _box.put(_kUsageDateKey, today);
    await _box.put(_kUsageCountKey, (currentCount + 1).toString());
  }
}
