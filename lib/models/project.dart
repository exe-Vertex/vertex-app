import 'user.dart';

/// Project summary (list view)
class ProjectSummary {
  final String id;
  final String name;
  final String? description;
  final String deadline;
  final int taskCount;
  final int memberCount;
  final double progress;
  final String createdAt;

  ProjectSummary({
    required this.id,
    required this.name,
    this.description,
    required this.deadline,
    required this.taskCount,
    required this.memberCount,
    required this.progress,
    required this.createdAt,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      deadline: json['deadline'] ?? '',
      taskCount: json['taskCount'] ?? 0,
      memberCount: json['memberCount'] ?? 0,
      progress: (json['progress'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
    );
  }
}

/// Project member
class ProjectMember {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final String? projectSkills;

  ProjectMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.projectSkills,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'Member',
      projectSkills: json['projectSkills'],
    );
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Task model
class Task {
  final String id;
  final String title;
  final String? description;
  final String status; // todo | in-progress | ready-for-review | done
  final String priority; // low | medium | high
  final ProjectMember? assignee;
  final String startDate;
  final String endDate;
  final int position;
  final String? submissionLink;
  final String createdAt;
  final List<Subtask> subtasks;
  final int commentCount;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.assignee,
    required this.startDate,
    required this.endDate,
    this.position = 0,
    this.submissionLink,
    required this.createdAt,
    this.subtasks = const [],
    this.commentCount = 0,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'todo',
      priority: json['priority'] ?? 'medium',
      assignee: json['assignee'] != null
          ? ProjectMember.fromJson(json['assignee'])
          : null,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      position: json['position'] ?? 0,
      submissionLink: json['submissionLink'],
      createdAt: json['createdAt'] ?? '',
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((s) => Subtask.fromJson(s))
              .toList() ??
          [],
      commentCount: json['commentCount'] ?? 0,
    );
  }

  Task copyWith({String? status, String? priority}) {
    return Task(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignee: assignee,
      startDate: startDate,
      endDate: endDate,
      position: position,
      submissionLink: submissionLink,
      createdAt: createdAt,
      subtasks: subtasks,
      commentCount: commentCount,
    );
  }
}

/// Subtask
class Subtask {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;
  final int position;

  Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isCompleted,
    this.position = 0,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      position: json['position'] ?? 0,
    );
  }
}

/// Task comment
class TaskComment {
  final String id;
  final String taskId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final String createdAt;

  TaskComment({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
  });

  factory TaskComment.fromJson(Map<String, dynamic> json) {
    return TaskComment(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'],
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

/// Project detail (full data)
class ProjectDetail {
  final String id;
  final String name;
  final String? description;
  final String deadline;
  final double progress;
  final String createdAt;
  final List<Task> tasks;
  final List<ProjectMember> members;

  ProjectDetail({
    required this.id,
    required this.name,
    this.description,
    required this.deadline,
    required this.progress,
    required this.createdAt,
    required this.tasks,
    required this.members,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      deadline: json['deadline'] ?? '',
      progress: (json['progress'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((t) => Task.fromJson(t))
              .toList() ??
          [],
      members: (json['members'] as List<dynamic>?)
              ?.map((m) => ProjectMember.fromJson(m))
              .toList() ??
          [],
    );
  }

  int get todoCount => tasks.where((t) => t.status == 'todo').length;
  int get inProgressCount =>
      tasks.where((t) => t.status == 'in-progress').length;
  int get reviewCount =>
      tasks.where((t) => t.status == 'ready-for-review').length;
  int get doneCount => tasks.where((t) => t.status == 'done').length;
}
