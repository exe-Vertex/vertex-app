import 'package:flutter/foundation.dart';

/// API configuration
/// ====================================================
/// Khi deploy: Đổi baseUrl sang URL server thật
/// Ví dụ: https://vertex-api.example.com
/// ====================================================
class ApiConfig {
  // ── LOCAL DEVELOPMENT ──
  // Đổi thành IP máy bạn nếu test trên thiết bị thật
  // Ví dụ: static const String baseUrl = 'http://192.168.1.x:7099';
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5093'; // or 7099 for HTTPS
    }
    return 'http://10.0.2.2:5093'; // Android Emulator
  }

  // ── PRODUCTION ──
  // static const String baseUrl = 'https://your-server.com';

  /// Có dùng mock data local không?
  /// Set = true để phát triển UI mà không cần backend
  /// Set = false khi kết nối với server thật
  static const bool useMockData = false;
}
