class ProjectMemberModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;

  ProjectMemberModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
  });

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) {
    return ProjectMemberModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Member',
      avatarUrl: json['avatarUrl'],
    );
  }
}
