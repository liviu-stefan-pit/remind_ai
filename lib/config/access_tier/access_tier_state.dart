import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remind_ai/config/access_tier/access_tier.dart';

part 'access_tier_state.freezed.dart';

@freezed
abstract class AccessTierState with _$AccessTierState {
  const factory AccessTierState({
    @Default(AccessTier.free) AccessTier tier,
    // For subscriptions: when the current Pro entitlement lapses. Null for
    // free users (and treated as no known expiry).
    DateTime? expiry,
  }) = _AccessTierState;
}
