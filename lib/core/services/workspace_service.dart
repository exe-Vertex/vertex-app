import '../network/api_client.dart';

class WorkspaceService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getMyWorkspaces() async {
    final response = await _apiClient.get('/orgs');
    return response as List<dynamic>;
  }

  Future<List<dynamic>> getWorkspaceProjects(String orgId) async {
    final response = await _apiClient.get('/orgs/$orgId/projects');
    return response as List<dynamic>;
  }

  Future<dynamic> getProjectDetail(String orgId, String projectId) async {
    return await _apiClient.get('/orgs/$orgId/projects/$projectId');
  }
}
