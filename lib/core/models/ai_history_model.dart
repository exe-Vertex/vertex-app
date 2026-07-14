class AiHistoryModel {
  final String id;
  final String userId;
  final String prompt;
  final String? planSummary;
  final DateTime createdAt;

  AiHistoryModel({
    required this.id,
    required this.userId,
    required this.prompt,
    this.planSummary,
    required this.createdAt,
  });

  factory AiHistoryModel.fromJson(Map<String, dynamic> json) {
    return AiHistoryModel(
      id: json['id'],
      userId: json['userId'],
      prompt: json['prompt'] ?? '',
      planSummary: json['planSummary'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
