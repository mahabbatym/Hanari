class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.language = 'kk',
    this.createdAt,
  });

  final String userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final String language;
  final DateTime? createdAt;

  factory UserProfile.fromRow(
    Map<String, dynamic> row, {
    required String email,
  }) => UserProfile(
    userId: row['user_id'] as String,
    name: (row['name'] as String?)?.trim() ?? '',
    email: email,
    avatarUrl: row['avatar_url'] as String?,
    language: row['language'] as String? ?? 'kk',
    createdAt: DateTime.tryParse(row['created_at'] as String? ?? ''),
  );
}
