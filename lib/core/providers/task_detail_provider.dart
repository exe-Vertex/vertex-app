import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/subtask_model.dart';
import '../models/comment_model.dart';

class TaskDetailProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  final String orgId;
  final String projectId;
  final String taskId;

  List<SubtaskModel> subtasks = [];
  List<CommentModel> comments = [];
  bool isLoading = false;
  String? errorMessage;

  TaskDetailProvider({
    required this.orgId,
    required this.projectId,
    required this.taskId,
  }) {
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final subtasksData = await _taskService.getSubtasks(
        orgId,
        projectId,
        taskId,
      );
      final commentsData = await _taskService.getComments(
        orgId,
        projectId,
        taskId,
      );

      subtasks = subtasksData.map((e) => SubtaskModel.fromJson(e)).toList();
      comments = commentsData.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSubtask(String title) async {
    try {
      final data = await _taskService.createSubtask(orgId, projectId, taskId, {
        'title': title,
      });
      subtasks.add(SubtaskModel.fromJson(data));
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleSubtask(String subtaskId, bool isCompleted) async {
    final index = subtasks.indexWhere((s) => s.id == subtaskId);
    if (index == -1) return;

    // Optimistic UI
    final oldSubtask = subtasks[index];
    subtasks[index] = SubtaskModel(
      id: oldSubtask.id,
      taskId: oldSubtask.taskId,
      title: oldSubtask.title,
      isCompleted: isCompleted,
      position: oldSubtask.position,
    );
    notifyListeners();

    try {
      await _taskService.updateSubtask(orgId, projectId, taskId, subtaskId, {
        'isCompleted': isCompleted,
      });
    } catch (e) {
      // Revert
      subtasks[index] = oldSubtask;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addComment(String content) async {
    try {
      final data = await _taskService.createComment(orgId, projectId, taskId, {
        'content': content,
      });
      comments.insert(0, CommentModel.fromJson(data)); // Prepend to top
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
