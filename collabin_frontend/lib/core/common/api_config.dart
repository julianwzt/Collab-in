import 'package:flutter/foundation.dart';

/// Konfigurasi alamat backend Spring Boot.
///
/// Prioritas:
///  1. `--dart-define=API_BASE_URL=...` (wajib untuk HP fisik & production)
///  2. Default per platform untuk pengembangan lokal:
///     - Web                 → http://localhost:8082
///     - Android emulator    → http://10.0.2.2:8082
///     - iOS simulator/lain  → http://127.0.0.1:8082
///
/// Contoh:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8082   // HP fisik (IP laptop)
///   flutter build apk --dart-define=API_BASE_URL=https://api.contoh.com
class ApiConfig {
  ApiConfig._();

  static const String _fromEnvironment = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_fromEnvironment.isNotEmpty) {
      return _fromEnvironment.replaceAll(RegExp(r'/+$'), '');
    }
    if (kIsWeb) return 'http://localhost:8082';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8082';
      default:
        return 'http://127.0.0.1:8082';
    }
  }
}
