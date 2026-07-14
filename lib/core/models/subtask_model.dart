class SubtaskModel {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;
  final int position;

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isCompleted,
    required this.position,
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'],
      taskId: json['taskId'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      position: json['position'] ?? 0,
    );
  }
}
