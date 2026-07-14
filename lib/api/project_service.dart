import '../models/project.dart';
import '../models/organization.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'mock_data.dart';

/// Project & Organization service
/// ====================================================
/// API paths match backend exactly:
///   /api/orgs, /api/orgs/{orgId}/projects, etc.
/// ====================================================
class ProjectService {
  // ── Organizations ──

  static Future<List<OrgSummary>> listOrgs() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return MockData.organizations;
    }

    final response = await ApiClient.request('GET', '/api/orgs');
    return ApiClient.parseResponse(
      response,
      (json) =>
          (json as List).map((j) => OrgSummary.fromJson(j)).toList(),
    );
  }

  // ── Projects ──

  static Future<List<ProjectSummary>> listProjects(String orgId) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.projects;
    }

    final response =
        await ApiClient.request('GET', '/api/orgs/$orgId/projects');
    return ApiClient.parseResponse(
      response,
      (json) =>
          (json as List).map((j) => ProjectSummary.fromJson(j)).toList(),
    );
  }

  static Future<ProjectDetail> getProjectDetail(
      String orgId, String projectId) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return MockData.projectDetail;
    }

    final response = await ApiClient.request(
        'GET', '/api/orgs/$orgId/projects/$projectId');
    return ApiClient.parseResponse(
      response,
      (json) => ProjectDetail.fromJson(json),
    );
  }

  // ── Tasks ──

  static Future<Task> updateTaskStatus(
    String orgId,
    String projectId,
    String taskId,
    String newStatus,
  ) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      final task = MockData.tasks.firstWhere((t) => t.id == taskId);
      return task.copyWith(status: newStatus);
    }

    final response = await ApiClient.request(
      'PUT',
      '/api/orgs/$orgId/projects/$projectId/tasks/$taskId',
      body: {'status': newStatus},
    );
    return ApiClient.parseResponse(response, (json) => Task.fromJson(json));
  }

  // ── Comments ──

  static Future<List<TaskComment>> listComments(
    String orgId,
    String projectId,
    String taskId,
  ) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.comments
          .where((c) => c.taskId == taskId)
          .toList();
    }

    final response = await ApiClient.request(
      'GET',
      '/api/orgs/$orgId/projects/$projectId/tasks/$taskId/comments',
    );
    return ApiClient.parseResponse(
      response,
      (json) =>
          (json as List).map((j) => TaskComment.fromJson(j)).toList(),
    );
  }

  static Future<TaskComment> addComment(
    String orgId,
    String projectId,
    String taskId,
    String content,
  ) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return TaskComment(
        id: 'c${DateTime.now().millisecondsSinceEpoch}',
        taskId: taskId,
        userId: MockData.currentUser.id,
        userName: MockData.currentUser.name,
        content: content,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    final response = await ApiClient.request(
      'POST',
      '/api/orgs/$orgId/projects/$projectId/tasks/$taskId/comments',
      body: {'content': content},
    );
    return ApiClient.parseResponse(
        response, (json) => TaskComment.fromJson(json));
  }

  // ── Subtasks ──

  static Future<List<Subtask>> listSubtasks(
    String orgId,
    String projectId,
    String taskId,
  ) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      final task = MockData.tasks.firstWhere((t) => t.id == taskId,
          orElse: () => MockData.tasks.first);
      return task.subtasks;
    }

    final response = await ApiClient.request(
      'GET',
      '/api/orgs/$orgId/projects/$projectId/tasks/$taskId/subtasks',
    );
    return ApiClient.parseResponse(
      response,
      (json) =>
          (json as List).map((j) => Subtask.fromJson(j)).toList(),
    );
  }
}
