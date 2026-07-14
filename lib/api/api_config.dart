/// API configuration
/// ====================================================
/// Khi deploy: Đổi baseUrl sang URL server thật
/// Ví dụ: https://vertex-api.example.com
/// ====================================================
class ApiConfig {
  // ── LOCAL DEVELOPMENT ──
  // Đổi thành IP máy bạn nếu test trên thiết bị thật
  // Ví dụ: static const String baseUrl = 'http://192.168.1.x:7099';
  static const String baseUrl = 'https://localhost:7099';

  // ── PRODUCTION ──
  // static const String baseUrl = 'https://your-server.com';

  /// Có dùng mock data local không?
  /// Set = true để phát triển UI mà không cần backend
  /// Set = false khi kết nối với server thật
  static const bool useMockData = true;
}
