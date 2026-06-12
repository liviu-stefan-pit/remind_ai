import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/config/purchases/purchases_config.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/core/network/revenuecat_rest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchases_service.g.dart';

@Riverpod(keepAlive: true)
PurchasesService purchasesService(Ref ref) {
  final service = PurchasesService(ref);
  unawaited(service.configure());
  return service;
}

/// Bridges RevenueCat to [AccessTierLogic].
///
/// Phase 1 ships without the RevenueCat Flutter SDK on web — its web plugin
/// injects inline scripts that break under a strict CSP before Pro is enabled.
/// Entitlement checks fall back to the REST client (Windows / future web Pro).
/// Re-add `purchases_flutter` to pubspec when enabling native/web checkout.
class PurchasesService {
  PurchasesService(this._ref);

  final Ref _ref;

  /// Native/web SDK checkout is disabled until `purchases_flutter` is wired back.
  bool get supportsSdk => false;

  Future<void> configure() async {}

  /// Aligns the RevenueCat identity with the signed-in Firebase user and
  /// refreshes the entitlement.
  Future<void> onSignIn(String firebaseUid) async {
    if (_hasRestKey) {
      await refreshViaRest(firebaseUid);
    }
  }

  Future<void> onSignOut() async {
    _ref.read(accessTierLogicProvider.notifier).applyEntitlement(
      isActive: false,
    );
  }

  /// Starts the native/web purchase flow. Throws [PurchaseException] when the
  /// SDK is unavailable (use [webPurchaseUrl] on Windows instead).
  Future<void> purchasePro() async {
    throw const PurchaseException(
      'In-app purchase is not available in this build.',
    );
  }

  /// The browser checkout URL used on Windows, with the Firebase UID attached
  /// so the resulting subscription is keyed to the same account.
  String? webPurchaseUrl(String firebaseUid) {
    if (!PurchasesConfig.hasWebPurchaseLink) return null;
    final base = Uri.parse(PurchasesConfig.webPurchaseLink);
    return base.replace(
      queryParameters: {...base.queryParameters, 'app_user_id': firebaseUid},
    ).toString();
  }

  /// URL where the user can manage or cancel their subscription.
  Future<String?> managementUrl(String firebaseUid) async {
    if (!_hasRestKey) return null;
    try {
      final status = await _ref
          .read(revenueCatRestClientProvider)
          .fetchEntitlement(firebaseUid);
      return status.managementUrl;
    } on Object {
      return null;
    }
  }

  /// REST entitlement check (Windows + fallback). Returns whether Pro is active.
  Future<bool> refreshViaRest(String firebaseUid) async {
    final status = await _ref
        .read(revenueCatRestClientProvider)
        .fetchEntitlement(firebaseUid);
    _ref.read(accessTierLogicProvider.notifier).applyEntitlement(
      isActive: status.isActive,
      expiry: status.expiry,
    );
    return status.isActive;
  }

  bool get _hasRestKey =>
      PurchasesConfig.hasWebKey || PurchasesConfig.hasAndroidKey;
}
