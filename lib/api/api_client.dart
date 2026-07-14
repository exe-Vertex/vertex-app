import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

/// HTTP client wrapper - mirrors web FE http.ts logic
/// Handles: Authorization headers, token refresh, error handling
class ApiClient {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static bool _isRefreshing = false;

  /// Get stored access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'vertex.accessToken');
  }

  /// Get stored refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'vertex.refreshToken');
  }

  /// Save auth tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'vertex.accessToken', value: accessToken);
    await _storage.write(key: 'vertex.refreshToken', value: refreshToken);
  }

  /// Clear all auth data
  static Future<void> clearAuth() async {
    await _storage.deleteAll();
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Make authenticated API request
  /// Handles 401 → auto refresh token → retry
  static Future<http.Response> request(
    String method,
    String path, {
    dynamic body,
    Map<String, String>? extraHeaders,
    bool isAuthPath = false,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      ...?extraHeaders,
    };

    // Add auth header if not an auth path
    if (!isAuthPath) {
      final token = await getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    // Make request
    http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(url,
            headers: headers, body: body != null ? jsonEncode(body) : null);
        break;
      case 'PUT':
        response = await http.put(url,
            headers: headers, body: body != null ? jsonEncode(body) : null);
        break;
      case 'PATCH':
        response = await http.patch(url,
            headers: headers, body: body != null ? jsonEncode(body) : null);
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    // Handle 401 - try refresh token
    if (response.statusCode == 401 && !isAuthPath && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await getRefreshToken();
        if (refreshToken != null) {
          final refreshResponse = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          );

          if (refreshResponse.statusCode == 200) {
            final tokens = jsonDecode(refreshResponse.body);
            await saveTokens(
              accessToken: tokens['accessToken'],
              refreshToken: tokens['refreshToken'],
            );

            // Retry original request with new token
            headers['Authorization'] = 'Bearer ${tokens['accessToken']}';
            switch (method.toUpperCase()) {
              case 'GET':
                response = await http.get(url, headers: headers);
                break;
              case 'POST':
                response = await http.post(url,
                    headers: headers,
                    body: body != null ? jsonEncode(body) : null);
                break;
              case 'PUT':
                response = await http.put(url,
                    headers: headers,
                    body: body != null ? jsonEncode(body) : null);
                break;
              case 'PATCH':
                response = await http.patch(url,
                    headers: headers,
                    body: body != null ? jsonEncode(body) : null);
                break;
              case 'DELETE':
                response = await http.delete(url, headers: headers);
                break;
            }
          } else {
            await clearAuth();
            throw AuthException('Phiên đăng nhập đã hết hạn');
          }
        }
      } finally {
        _isRefreshing = false;
      }
    }

    return response;
  }

  /// Parse response and throw on error
  static T parseResponse<T>(
      http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204 || response.body.isEmpty) {
        return fromJson(null);
      }
      return fromJson(jsonDecode(response.body));
    }

    String message = 'Request failed with status ${response.statusCode}';
    try {
      final data = jsonDecode(response.body);
      if (data['message'] != null) message = data['message'];
      if (data['error'] != null) message = data['error'];
    } catch (_) {}

    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
