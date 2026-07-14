import '../network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      if (response != null && response['accessToken'] != null) {
        await _apiClient.saveToken(
          response['accessToken'],
          response['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (e) {
      // Re-throw to be caught by the UI
      rethrow;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _apiClient.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _apiClient.post(
          '/auth/logout',
          body: {'refreshToken': refreshToken},
        );
      } catch (e) {
        // Ignore API error on logout, proceed to clear local tokens
      }
    }
    await _apiClient.clearToken();
  }

  Future<dynamic> getMe() async {
    return await _apiClient.get('/auth/me');
  }
}
