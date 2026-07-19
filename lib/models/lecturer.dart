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
      id: json['Id'] ?? json['id'] ?? '',
      title: json['Title'] ?? json['title'] ?? '',
      description: json['Description'] ?? json['description'],
      status: json['Status'] ?? json['status'] ?? 'todo',
      priority: json['Priority'] ?? json['priority'] ?? 'medium',
      assigneeName: json['AssigneeName'] ?? json['assigneeName'],
      startDate: json['StartDate'] ?? json['startDate'] ?? '',
      endDate: json['EndDate'] ?? json['endDate'] ?? '',
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
      id: json['projectId'] ?? json['Id'] ?? json['id'] ?? '',
      name: json['projectName'] ?? json['Name'] ?? json['name'] ?? '',
      description: json['projectDescription'] ?? json['Description'] ?? json['description'] ?? '',
      organizationName: json['orgName'] ?? json['OrganizationName'] ?? json['organizationName'] ?? '',
      deadline: json['deadline'] ?? json['Deadline'] ?? '',
      memberCount: json['memberCount'] ?? json['MemberCount'] ?? 0,
      initials: ((json['memberInitials'] ?? json['Initials'] ?? json['initials']) as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      progress: json['progress'] ?? json['Progress'] ?? 0,
      reviewStatus: json['reviewStatus'] ?? json['ReviewStatus'] ?? 'on_track',
      totalTasks: json['tasksTotal'] ?? json['TotalTasks'] ?? json['totalTasks'] ?? 0,
      approvedTasks: json['tasksApproved'] ?? json['ApprovedTasks'] ?? json['approvedTasks'] ?? 0,
      inReviewTasks: json['tasksInReview'] ?? json['InReviewTasks'] ?? json['inReviewTasks'] ?? 0,
      inProgressTasks: json['tasksInProgress'] ?? json['InProgressTasks'] ?? json['inProgressTasks'] ?? 0,
      todoTasks: json['tasksTodo'] ?? json['TodoTasks'] ?? json['todoTasks'] ?? 0,
      reviewTasks: ((json['reviewTasks'] ?? json['ReviewTasks']) as List<dynamic>?)
              ?.map((e) => LecturerTask.fromJson(e as Map<String, dynamic>))
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
      id: json['Id'] ?? json['id'] ?? '',
      taskId: json['TaskId'] ?? json['taskId'] ?? '',
      userId: json['UserId'] ?? json['userId'] ?? '',
      userName: json['UserName'] ?? json['userName'] ?? 'Unknown',
      role: json['Role'] ?? json['role'] ?? 'student',
      content: json['Content'] ?? json['content'] ?? '',
      createdAt: json['CreatedAt'] ?? json['createdAt'] ?? '',
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
      id: json['projectId'] ?? json['Id'] ?? json['id'] ?? '',
      name: json['projectName'] ?? json['Name'] ?? json['name'] ?? '',
      description: json['projectDescription'] ?? json['Description'] ?? json['description'] ?? '',
      organizationName: json['orgName'] ?? json['OrganizationName'] ?? json['organizationName'] ?? '',
      deadline: json['deadline'] ?? json['Deadline'] ?? '',
      memberCount: json['memberCount'] ?? json['MemberCount'] ?? 0,
      memberNames: ((json['memberNames'] ?? json['MemberNames']) as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      progress: json['progress'] ?? json['Progress'] ?? 0,
      reviewStatus: json['reviewStatus'] ?? json['ReviewStatus'] ?? 'on_track',
      tasks: ((json['tasks'] ?? json['Tasks']) as List<dynamic>?)?.map((e) => LecturerTask.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      comments: ((json['comments'] ?? json['Comments']) as List<dynamic>?)?.map((e) => TaskCommentDto.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      contributions: json['contributions'] ?? json['Contributions'] ?? [],
    );
  }
}
