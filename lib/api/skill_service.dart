import 'dart:convert';
import 'api_client.dart';
import 'api_config.dart';

class SkillService {
  /// Lấy danh sách kỹ năng của User hiện tại
  static Future<List<String>> getSkills() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return ['Flutter', 'Dart', 'Figma'];
    }

    final response = await ApiClient.request('GET', '/api/auth/skills');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load skills');
    }
  }

  /// Cập nhật danh sách kỹ năng
  static Future<void> updateSkills(List<String> skills) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    final response = await ApiClient.request(
      'POST', 
      '/api/auth/skills',
      body: skills, // ApiClient.request will jsonEncode this list
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update skills');
    }
  }
}
