import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';
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
/// On platforms with a native/web SDK (Android, Web) it configures the SDK,
/// listens for entitlement changes, and runs purchases directly. On Windows
/// (no SDK) it opens a browser purchase link and resolves entitlement through
/// the REST client instead.
class PurchasesService {
  PurchasesService(this._ref);

  final Ref _ref;
  bool _configured = false;

  bool get supportsSdk =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  String? get _apiKey {
    if (kIsWeb) {
      return PurchasesConfig.hasWebKey ? PurchasesConfig.webApiKey : null;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PurchasesConfig.hasAndroidKey ? PurchasesConfig.androidApiKey : null;
    }
    return null;
  }

  Future<void> configure() async {
    if (_configured || !supportsSdk) return;
    final key = _apiKey;
    if (key == null) return;
    try {
      await Purchases.configure(PurchasesConfiguration(key));
      Purchases.addCustomerInfoUpdateListener(_applyCustomerInfo);
      _configured = true;
      await _refreshFromSdk();
    } catch (error) {
      debugPrint('RevenueCat: configure failed ($error).');
    }
  }

  /// Aligns the RevenueCat identity with the signed-in Firebase user and
  /// refreshes the entitlement.
  Future<void> onSignIn(String firebaseUid) async {
    if (supportsSdk && _configured) {
      try {
        final result = await Purchases.logIn(firebaseUid);
        _applyCustomerInfo(result.customerInfo);
      } catch (error) {
        debugPrint('RevenueCat: logIn failed ($error).');
      }
    } else {
      // Windows / unconfigured: resolve via REST.
      await refreshViaRest(firebaseUid);
    }
  }

  Future<void> onSignOut() async {
    if (supportsSdk && _configured) {
      try {
        await Purchases.logOut();
      } catch (_) {
        // Anonymous logout can throw if already anonymous; ignore.
      }
    }
    _ref.read(accessTierLogicProvider.notifier).applyEntitlement(
      isActive: false,
    );
  }

  /// Starts the native/web purchase flow. Throws [PurchaseException] when the
  /// SDK is unavailable (use [webPurchaseUrl] on Windows instead).
  Future<void> purchasePro() async {
    if (!supportsSdk || !_configured) {
      throw const PurchaseException(
        'In-app purchase is not available on this platform.',
      );
    }
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      final package =
          current?.monthly ?? current?.availablePackages.firstOrNull;
      if (package == null) {
        throw const PurchaseException('No Pro offering is available.');
      }
      final result = await Purchases.purchasePackage(package);
      _applyCustomerInfo(result.customerInfo);
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return; // user backed out — not an error
      }
      throw PurchaseException('Purchase failed: ${e.message ?? code.name}');
    }
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

  Future<void> _refreshFromSdk() async {
    try {
      _applyCustomerInfo(await Purchases.getCustomerInfo());
    } catch (error) {
      debugPrint('RevenueCat: getCustomerInfo failed ($error).');
    }
  }

  void _applyCustomerInfo(CustomerInfo info) {
    final entitlement = info.entitlements.all[PurchasesConfig.entitlementId];
    final isActive = entitlement?.isActive ?? false;
    final rawExpiry = entitlement?.expirationDate;
    final expiry = rawExpiry != null ? DateTime.tryParse(rawExpiry) : null;
    _ref.read(accessTierLogicProvider.notifier).applyEntitlement(
      isActive: isActive,
      expiry: expiry,
    );
  }
}
