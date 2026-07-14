import 'package:flutter/material.dart';
import '../services/workspace_service.dart';
import '../models/project_member_model.dart';

class WorkspaceModel {
  final String id;
  final String name;
  final String? slug;

  WorkspaceModel({required this.id, required this.name, this.slug});

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      slug: json['slug'],
    );
  }
}

class ProjectModel {
  final String id;
  final String workspaceId;
  final String name;

  ProjectModel({
    required this.id,
    required this.workspaceId,
    required this.name,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json, String orgId) {
    return ProjectModel(
      id: json['id'],
      workspaceId: orgId,
      name: json['name'] ?? 'Unknown Project',
    );
  }
}

class WorkspaceProvider extends ChangeNotifier {
  final WorkspaceService _workspaceService = WorkspaceService();

  List<WorkspaceModel> _workspaces = [];
  List<ProjectModel> _activeWorkspaceProjects = [];
  List<ProjectMemberModel> _activeProjectMembers = [];

  String? _activeWorkspaceId;
  String? _activeProjectId;

  bool _isLoading = false;
  String? _errorMessage;

  List<WorkspaceModel> get workspaces => _workspaces;
  List<ProjectModel> get activeWorkspaceProjects => _activeWorkspaceProjects;
  List<ProjectMemberModel> get activeProjectMembers => _activeProjectMembers;
  String? get activeProjectId => _activeProjectId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  WorkspaceModel? get activeWorkspace {
    if (_activeWorkspaceId == null) return null;
    return _workspaces.firstWhere(
      (ws) => ws.id == _activeWorkspaceId,
      orElse: () => _workspaces.first,
    );
  }

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orgsData = await _workspaceService.getMyWorkspaces();
      _workspaces = orgsData
          .map((json) => WorkspaceModel.fromJson(json))
          .toList();

      if (_workspaces.isNotEmpty) {
        _activeWorkspaceId = _workspaces.first.id;
        await _fetchProjectsForActiveWorkspace();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> switchWorkspace(String workspaceId) async {
    if (_activeWorkspaceId == workspaceId) return;

    _activeWorkspaceId = workspaceId;
    _activeProjectId = null;
    _activeWorkspaceProjects = []; // Clear old projects while loading
    _activeProjectMembers = [];

    _isLoading = true;
    notifyListeners();

    try {
      await _fetchProjectsForActiveWorkspace();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchProjectsForActiveWorkspace() async {
    if (_activeWorkspaceId == null) return;

    final projectsData = await _workspaceService.getWorkspaceProjects(
      _activeWorkspaceId!,
    );
    _activeWorkspaceProjects = projectsData
        .map((json) => ProjectModel.fromJson(json, _activeWorkspaceId!))
        .toList();

    if (_activeWorkspaceProjects.isNotEmpty) {
      _activeProjectId = _activeWorkspaceProjects.first.id;
      await _fetchMembersForActiveProject();
    }
  }

  Future<void> _fetchMembersForActiveProject() async {
    if (_activeWorkspaceId == null || _activeProjectId == null) return;

    try {
      final detailData = await _workspaceService.getProjectDetail(
        _activeWorkspaceId!,
        _activeProjectId!,
      );
      final membersList = detailData['members'] as List<dynamic>?;
      if (membersList != null) {
        _activeProjectMembers = membersList
            .map((json) => ProjectMemberModel.fromJson(json))
            .toList();
      } else {
        _activeProjectMembers = [];
      }
    } catch (e) {
      // Members fetch failed, just ignore for now or handle appropriately
      _activeProjectMembers = [];
    }
  }

  Future<void> selectProject(String projectId) async {
    if (_activeProjectId == projectId) return;

    _activeProjectId = projectId;
    _activeProjectMembers = [];
    _isLoading = true;
    notifyListeners();

    await _fetchMembersForActiveProject();

    _isLoading = false;
    notifyListeners();
  }
}
