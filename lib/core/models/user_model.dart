class UserProfile {
  final String id;
  final String fullName;
  final String customId;
  final String role;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.customId,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      customId: json['custom_id'] ?? '',
      role: json['role'] ?? 'student',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'custom_id': customId,
      'role': role,
    };
  }
}
