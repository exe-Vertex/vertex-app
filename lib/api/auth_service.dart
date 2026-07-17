import '../models/user.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'mock_data.dart';

/// Auth service - handles login, register, refresh, logout
/// ====================================================
/// Khi chuyển server: chỉ cần set ApiConfig.useMockData = false
/// Tất cả API paths match backend: /api/auth/*
/// ====================================================
class AuthService {
  /// Login
  static Future<AuthTokens> login(String email, String password) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (email == 'test@test.com' && password == '123456') {
        return MockData.mockTokens;
      }
      // Accept any login for demo
      return MockData.mockTokens;
    }

    final response = await ApiClient.request(
      'POST',
      '/api/auth/login',
      body: {'email': email, 'password': password},
      isAuthPath: true,
    );
    return ApiClient.parseResponse(response, (json) => AuthTokens.fromJson(json));
  }

  /// Register
  static Future<AuthTokens> register(
      String name, String email, String password) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockData.mockTokens;
    }

    final response = await ApiClient.request(
      'POST',
      '/api/auth/register',
      body: {'name': name, 'email': email, 'password': password},
      isAuthPath: true,
    );
    return ApiClient.parseResponse(response, (json) => AuthTokens.fromJson(json));
  }

  /// External Login (Google/GitHub)
  static Future<AuthTokens> externalLogin(String provider, String token) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockData.mockTokens;
    }

    final response = await ApiClient.request(
      'POST',
      '/api/auth/external-login',
      body: {'provider': provider, 'token': token},
      isAuthPath: true,
    );
    return ApiClient.parseResponse(response, (json) => AuthTokens.fromJson(json));
  }

  /// Get current user
  static Future<User> getMe() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.currentUser;
    }

    final response = await ApiClient.request('GET', '/api/auth/me');
    return ApiClient.parseResponse(response, (json) => User.fromJson(json));
  }

  /// Logout
  static Future<void> logout() async {
    if (ApiConfig.useMockData) {
      await ApiClient.clearAuth();
      return;
    }

    final refreshToken = await ApiClient.getRefreshToken();
    if (refreshToken != null) {
      await ApiClient.request(
        'POST',
        '/api/auth/logout',
        body: {'refreshToken': refreshToken},
        isAuthPath: true,
      );
    }
    await ApiClient.clearAuth();
  }
}
