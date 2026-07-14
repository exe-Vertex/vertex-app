import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  String? _currentOrgId;
  String? _currentProjectId;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateContext(String? orgId, String? projectId) {
    if (_currentOrgId != orgId || _currentProjectId != projectId) {
      _currentOrgId = orgId;
      _currentProjectId = projectId;
      _fetchTasks();
    }
  }

  Future<void> _fetchTasks() async {
    if (_currentOrgId == null || _currentProjectId == null) {
      _tasks = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tasksData = await _taskService.getProjectTasks(
        _currentOrgId!,
        _currentProjectId!,
      );
      _tasks = tasksData.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(
    String title,
    String? description,
    String status,
  ) async {
    if (_currentOrgId == null || _currentProjectId == null) return;
    try {
      final now = DateTime.now().toUtc();
      final endDate = now.add(
        const Duration(days: 7),
      ); // default deadline 1 week

      final newTaskJson = await _taskService.createTask(
        _currentOrgId!,
        _currentProjectId!,
        {
          'title': title,
          'description': description,
          'status': status,
          'priority': 'Medium', // Required by C# backend
          'startDate': now.toIso8601String(), // Required by C# backend
          'endDate': endDate.toIso8601String(), // Required by C# backend
        },
      );
      final newTask = TaskModel.fromJson(newTaskJson);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    if (_currentOrgId == null || _currentProjectId == null) return;

    // Optimistic UI update
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final oldTask = _tasks[index];
      _tasks[index] = TaskModel(
        id: oldTask.id,
        title: oldTask.title,
        description: oldTask.description,
        status: newStatus,
        priority: oldTask.priority,
      );
      notifyListeners();
    }

    try {
      await _taskService.updateTask(
        _currentOrgId!,
        _currentProjectId!,
        taskId,
        {'status': newStatus},
      );
    } catch (e) {
      // Revert if API fails
      _errorMessage = e.toString();
      _fetchTasks(); // simple revert by refetching
    }
  }
}
