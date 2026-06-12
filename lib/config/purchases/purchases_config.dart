/// RevenueCat configuration. All keys are public SDK keys (safe to ship) and
/// are supplied at build time via --dart-define so they are not hard-coded:
///
///   --dart-define=REVENUECAT_ANDROID_KEY=goog_xxx
///   --dart-define=REVENUECAT_WEB_KEY=rcb_xxx
///   --dart-define=REVENUECAT_WEB_PURCHASE_LINK=https://pay.rev.cat/xxxx
///
/// See PUBLISH_NEXT_STEPS.md ("RevenueCat Dashboard setup").
abstract final class PurchasesConfig {
  /// Google Play public SDK key (`goog_…`). Used on Android.
  static const String androidApiKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
  );

  /// Web Billing public SDK key (`rcb_…`). Used on Flutter Web, and as the
  /// Bearer token for the REST entitlement check on Windows.
  static const String webApiKey = String.fromEnvironment('REVENUECAT_WEB_KEY');

  /// RevenueCat Web Purchase Link opened in the browser on Windows (which has
  /// no native RevenueCat SDK). The Firebase UID is appended as `app_user_id`.
  static const String webPurchaseLink = String.fromEnvironment(
    'REVENUECAT_WEB_PURCHASE_LINK',
  );

  /// Entitlement identifier configured in the RevenueCat dashboard.
  static const String entitlementId = 'pro';

  static bool get hasAndroidKey => androidApiKey.isNotEmpty;
  static bool get hasWebKey => webApiKey.isNotEmpty;
  static bool get hasWebPurchaseLink => webPurchaseLink.isNotEmpty;

  /// Whether the Pro tier can currently be purchased on any platform. Stays
  /// false until RevenueCat keys are supplied at build time, so the Phase-1
  /// launch ships Free-only and surfaces Pro as "coming soon".
  static bool get proPurchasable =>
      hasAndroidKey || hasWebKey || hasWebPurchaseLink;
}
