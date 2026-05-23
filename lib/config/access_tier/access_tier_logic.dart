import 'package:remind_ai/config/access_tier/access_tier.dart';
import 'package:remind_ai/config/access_tier/access_tier_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_tier_logic.g.dart';

@Riverpod(keepAlive: true)
class AccessTierLogic extends _$AccessTierLogic {
  @override
  AccessTierState build() => const AccessTierState();

  void setTier(AccessTier tier) => state = state.copyWith(tier: tier);

  void toggle() => state = state.copyWith(
    tier: state.tier.isPro ? AccessTier.free : AccessTier.pro,
  );
}
