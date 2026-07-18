class LecturerTask {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? assigneeName;
  final String startDate;
  final String endDate;

  LecturerTask({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.assigneeName,
    required this.startDate,
    required this.endDate,
  });

  factory LecturerTask.fromJson(Map<String, dynamic> json) {
    return LecturerTask(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'todo',
      priority: json['priority'] ?? 'medium',
      assigneeName: json['assigneeName'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}

class LecturerGroup {
  final String id;
  final String name;
  final String description;
  final String organizationName;
  final String deadline;
  final int memberCount;
  final List<String> initials;
  final int progress;
  final String reviewStatus;
  final int totalTasks;
  final int approvedTasks;
  final int inReviewTasks;
  final int inProgressTasks;
  final int todoTasks;
  final List<LecturerTask> reviewTasks;

  LecturerGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.organizationName,
    required this.deadline,
    required this.memberCount,
    required this.initials,
    required this.progress,
    required this.reviewStatus,
    required this.totalTasks,
    required this.approvedTasks,
    required this.inReviewTasks,
    required this.inProgressTasks,
    required this.todoTasks,
    required this.reviewTasks,
  });

  factory LecturerGroup.fromJson(Map<String, dynamic> json) {
    return LecturerGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      organizationName: json['organizationName'] ?? '',
      deadline: json['deadline'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      initials: (json['initials'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      progress: json['progress'] ?? 0,
      reviewStatus: json['reviewStatus'] ?? 'on_track',
      totalTasks: json['totalTasks'] ?? 0,
      approvedTasks: json['approvedTasks'] ?? 0,
      inReviewTasks: json['inReviewTasks'] ?? 0,
      inProgressTasks: json['inProgressTasks'] ?? 0,
      todoTasks: json['todoTasks'] ?? 0,
      reviewTasks: (json['reviewTasks'] as List<dynamic>?)
              ?.map((e) => LecturerTask.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TaskCommentDto {
  final String id;
  final String taskId;
  final String userId;
  final String userName;
  final String role;
  final String content;
  final String createdAt;

  TaskCommentDto({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userName,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory TaskCommentDto.fromJson(Map<String, dynamic> json) {
    return TaskCommentDto(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Unknown',
      role: json['role'] ?? 'student',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class LecturerGroupDetail {
  final String id;
  final String name;
  final String description;
  final String organizationName;
  final String deadline;
  final int memberCount;
  final List<String> memberNames;
  final int progress;
  final String reviewStatus;
  final List<LecturerTask> tasks;
  final List<TaskCommentDto> comments;
  final List<dynamic> contributions;

  LecturerGroupDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.organizationName,
    required this.deadline,
    required this.memberCount,
    required this.memberNames,
    required this.progress,
    required this.reviewStatus,
    required this.tasks,
    required this.comments,
    required this.contributions,
  });

  factory LecturerGroupDetail.fromJson(Map<String, dynamic> json) {
    return LecturerGroupDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      organizationName: json['organizationName'] ?? '',
      deadline: json['deadline'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      memberNames: (json['memberNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      progress: json['progress'] ?? 0,
      reviewStatus: json['reviewStatus'] ?? 'on_track',
      tasks: (json['tasks'] as List<dynamic>?)?.map((e) => LecturerTask.fromJson(e)).toList() ?? [],
      comments: (json['comments'] as List<dynamic>?)?.map((e) => TaskCommentDto.fromJson(e)).toList() ?? [],
      contributions: json['contributions'] ?? [],
    );
  }
}
