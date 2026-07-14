import '../network/api_client.dart';

class TaskService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getProjectTasks(String orgId, String projectId) async {
    final response = await _apiClient.get(
      '/orgs/$orgId/projects/$projectId/tasks',
    );
    return response as List<dynamic>;
  }

  Future<dynamic> createTask(
    String orgId,
    String projectId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.post(
      '/orgs/$orgId/projects/$projectId/tasks',
      body: data,
    );
  }

  Future<dynamic> updateTask(
    String orgId,
    String projectId,
    String taskId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.put(
      '/orgs/$orgId/projects/$projectId/tasks/$taskId',
      body: data,
    );
  }

  // --- Subtasks ---
  Future<List<dynamic>> getSubtasks(
    String orgId,
    String projectId,
    String taskId,
  ) async {
    final response = await _apiClient.get(
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/subtasks',
    );
    return response as List<dynamic>;
  }

  Future<dynamic> createSubtask(
    String orgId,
    String projectId,
    String taskId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.post(
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/subtasks',
      body: data,
    );
  }

  Future<dynamic> updateSubtask(
    String orgId,
    String projectId,
    String taskId,
    String subtaskId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.put(
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/subtasks/$subtaskId',
      body: data,
    );
  }

  // --- Comments ---
  Future<List<dynamic>> getComments(
    String orgId,
    String projectId,
    String taskId,
  ) async {
    final response = await _apiClient.get(
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/comments',
    );
    return response as List<dynamic>;
  }

  Future<dynamic> createComment(
    String orgId,
    String projectId,
    String taskId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.post(
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/comments',
      body: data,
    );
  }
}
