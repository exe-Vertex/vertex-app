class CommentModel {
  final String id;
  final String taskId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      taskId: json['taskId'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Unknown',
      userAvatar: json['userAvatar'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
