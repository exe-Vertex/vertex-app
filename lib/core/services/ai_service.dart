import '../network/api_client.dart';

class AiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getHistory() async {
    final response = await _apiClient.get('/ai/history');
    return response as List<dynamic>;
  }

  Future<dynamic> chat(String prompt, String? orgId) async {
    final body = <String, dynamic>{'prompt': prompt};
    if (orgId != null) {
      body['orgId'] = orgId;
    }
    return await _apiClient.post('/ai/chat', body: body);
  }
}
