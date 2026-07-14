import 'dart:convert';
import '../models/project.dart';
import 'api_client.dart';
import 'api_config.dart';

class LecturerService {
  /// Lấy danh sách các nhóm sinh viên (projects) mà giảng viên phụ trách
  static Future<List<ProjectSummary>> getGroups() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    }

    final response = await ApiClient.request('GET', '/api/lecturer/groups');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProjectSummary.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load student groups');
    }
  }

  /// Lấy chi tiết một nhóm hướng dẫn
  static Future<ProjectDetail> getGroupDetail(String projectId) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      throw Exception('Mock data not supported for group detail');
    }

    final response = await ApiClient.request('GET', '/api/lecturer/groups/$projectId');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return ProjectDetail.fromJson(json);
    } else {
      throw Exception('Failed to load group detail');
    }
  }

  /// Phê duyệt một Task
  static Future<void> approveTask(String taskId) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    final response = await ApiClient.request('POST', '/api/lecturer/tasks/$taskId/approve');
    if (response.statusCode >= 300) {
      throw Exception('Failed to approve task');
    }
  }

  /// Yêu cầu sửa đổi Task (từ chối)
  static Future<void> requestChanges(String taskId) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    final response = await ApiClient.request('POST', '/api/lecturer/tasks/$taskId/request-changes');
    if (response.statusCode >= 300) {
      throw Exception('Failed to request changes');
    }
  }

  /// Thêm nhận xét vào Task
  static Future<void> addComment(String taskId, String content) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    final response = await ApiClient.request(
      'POST', 
      '/api/lecturer/tasks/$taskId/comments',
      body: {'content': content},
    );
    if (response.statusCode >= 300) {
      throw Exception('Failed to add comment');
    }
  }
}
