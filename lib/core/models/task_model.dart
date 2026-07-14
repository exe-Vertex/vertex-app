class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String? priority;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'] ?? 'Untitled Task',
      description: json['description'],
      status: json['status'] ?? 'Todo',
      priority: json['priority'],
    );
  }
}
