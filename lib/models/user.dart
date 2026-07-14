/// User model - matches backend User entity
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role; // member | lecturer | admin
  final String? projectSkills;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = 'member',
    this.projectSkills,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'member',
      projectSkills: json['projectSkills'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'role': role,
        'projectSkills': projectSkills,
      };

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Auth tokens from login/register
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String accessTokenExpiresAt;
  final String refreshTokenExpiresAt;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpiresAt: json['accessTokenExpiresAt'] ?? '',
      refreshTokenExpiresAt: json['refreshTokenExpiresAt'] ?? '',
    );
  }
}
