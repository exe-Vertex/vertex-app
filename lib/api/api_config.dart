import 'package:flutter/foundation.dart';

/// API configuration
/// ====================================================
/// Khi deploy: Đổi baseUrl sang URL server thật
/// Ví dụ: https://vertex-api.example.com
/// ====================================================
class ApiConfig {
  // Đổi isProduction = true để kết nối server thật, false để test local
  static const bool isProduction = true;

  static String get baseUrl {
    if (isProduction) {
      return 'https://vertex.io.vn';
    }
    
    // LOCAL DEVELOPMENT
    if (kIsWeb) {
      return 'http://localhost:5093'; 
    }
    return 'http://10.0.2.2:5093'; 
  }

  /// Có dùng mock data local không?
  /// Set = true để phát triển UI mà không cần backend
  /// Set = false khi kết nối với server thật
  static const bool useMockData = false;
}
