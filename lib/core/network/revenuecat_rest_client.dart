import 'package:dio/dio.dart';
import 'package:remind_ai/config/purchases/purchases_config.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'revenuecat_rest_client.g.dart';

/// Resolved entitlement state for a RevenueCat subscriber.
typedef EntitlementStatus = ({
  bool isActive,
  DateTime? expiry,
  String? managementUrl,
});

@Riverpod(keepAlive: true)
RevenueCatRestClient revenueCatRestClient(Ref ref) {
  return RevenueCatRestClient(Dio());
}

/// Reads a subscriber's `pro` entitlement straight from the RevenueCat REST
/// API. Used on Windows (no native SDK) and as a fallback elsewhere. The Web
/// Billing public key is a safe Bearer token for this read-only endpoint.
class RevenueCatRestClient {
  const RevenueCatRestClient(this._dio);

  final Dio _dio;

  Future<EntitlementStatus> fetchEntitlement(String appUserId) async {
    if (!PurchasesConfig.hasWebKey) {
      return (isActive: false, expiry: null, managementUrl: null);
    }
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        'https://api.revenuecat.com/v1/subscribers/$appUserId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${PurchasesConfig.webApiKey}',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final subscriber = resp.data?['subscriber'] as Map<String, dynamic>?;
      final managementUrl = subscriber?['management_url'] as String?;
      final entitlements =
          subscriber?['entitlements'] as Map<String, dynamic>?;
      final pro =
          entitlements?[PurchasesConfig.entitlementId] as Map<String, dynamic>?;
      if (pro == null) {
        return (isActive: false, expiry: null, managementUrl: managementUrl);
      }

      final expiresRaw = pro['expires_date'] as String?;
      final expiry = expiresRaw != null ? DateTime.tryParse(expiresRaw) : null;
      // A null expiry means a non-expiring (lifetime) grant; treat as active.
      final isActive = expiry == null || expiry.isAfter(DateTime.now());
      return (
        isActive: isActive,
        expiry: expiry,
        managementUrl: managementUrl,
      );
    } on DioException catch (e) {
      // Unknown subscriber → not subscribed yet, not an error.
      if (e.response?.statusCode == 404) {
        return (isActive: false, expiry: null, managementUrl: null);
      }
      throw NetworkException(
        'RevenueCat entitlement lookup failed.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
