import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  static const String _configuredUrl = String.fromEnvironment(
    'CUSTOMER_API_URL',
  );

  static String get baseUrl {
    if (_configuredUrl.isNotEmpty) return _configuredUrl;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3001/customers';
      default:
        return 'http://localhost:3001/customers';
    }
  }
}
