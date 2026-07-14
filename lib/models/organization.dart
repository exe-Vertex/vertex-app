/// Organization summary
class OrgSummary {
  final String id;
  final String name;
  final String slug;
  final String plan;
  final int memberCount;
  final int maxMembers;
  final String createdAt;

  OrgSummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.plan,
    required this.memberCount,
    required this.maxMembers,
    required this.createdAt,
  });

  factory OrgSummary.fromJson(Map<String, dynamic> json) {
    return OrgSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      plan: json['plan'] ?? 'free',
      memberCount: json['memberCount'] ?? 0,
      maxMembers: json['maxMembers'] ?? 5,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
