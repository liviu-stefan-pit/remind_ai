import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/config/access_tier/access_tier.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
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

/// Syncs the quota from Firestore on sign-in and exposes the remaining count
/// for the current user/tier. Rebuilds whenever auth or tier changes.
@riverpod
Future<int> quotaRemaining(Ref ref) async {
  final uid = ref.watch(authLogicProvider).asData?.value?.uid;
  final tier = ref.watch(accessTierLogicProvider).tier;
  final quota = ref.read(usageQuotaServiceProvider);
  if (uid != null) {
    await quota.syncFromServer(uid);
  }
  return quota.remainingToday(tier);
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
  bool canSubmit(AccessTier tier) => getTodayUsageCount() < dailyLimitFor(tier);

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

  // ---------------------------------------------------------------------------
  // Firestore-backed quota (source of truth — prevents incognito bypass)
  // ---------------------------------------------------------------------------

  DocumentReference<Map<String, dynamic>> _quotaDoc(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('quota')
          .doc(_todayKey());

  /// Fetches today's count from Firestore and seeds the local Hive cache so
  /// the UI stays accurate across sessions (e.g. after sign-in on a new
  /// device or incognito tab). Falls back silently on any error.
  Future<void> syncFromServer(String uid) async {
    try {
      final snap = await _quotaDoc(uid).get();
      final count = (snap.data()?['count'] as num?)?.toInt() ?? 0;
      final today = _todayKey();
      await _box.put(_kUsageDateKey, today);
      await _box.put(_kUsageCountKey, count.toString());
    } catch (_) {
      // Non-fatal: local Hive counter remains as-is.
    }
  }

  /// Checks the server-side quota for [uid].
  ///
  /// - [FirebaseException] with code `permission-denied` → deny immediately;
  ///   this means Firestore rules rejected the request and must not be bypassed.
  /// - Any other error (network offline, timeout) → fall back to local Hive
  ///   counter so a transient outage does not lock out a legitimate user.
  Future<bool> canSubmitFromServer(String uid, AccessTier tier) async {
    try {
      final snap = await _quotaDoc(uid).get();
      final count = (snap.data()?['count'] as num?)?.toInt() ?? 0;
      return count < dailyLimitFor(tier);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied' || e.code == 'unauthenticated') {
        // Rules denied access — treat as quota exhausted, never fall back.
        debugPrint('Quota: Firestore denied (${e.code}); blocking submission.');
        return false;
      }
      // Other Firebase errors (unavailable, deadline-exceeded) → offline fallback.
      debugPrint(
        'Quota: Firestore unavailable (${e.code}); using local counter.',
      );
      return canSubmit(tier);
    } catch (_) {
      // Non-Firestore network error → offline fallback.
      return canSubmit(tier);
    }
  }

  /// Atomically increments the server-side daily counter. Fire-and-forget;
  /// the local [recordUsage] call is the fast-path fallback.
  Future<void> recordUsageToServer(String uid) async {
    try {
      await _quotaDoc(
        uid,
      ).set({'count': FieldValue.increment(1)}, SetOptions(merge: true));
    } catch (_) {
      // Non-fatal: local counter already updated; server will reconcile on next
      // successful write.
    }
  }
}
