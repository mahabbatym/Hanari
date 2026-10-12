import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';

class ProfileRepository {
  Future<UserProfile?> currentProfile() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) return null;

    final row = await client
        .from('profiles')
        .select('user_id, name, avatar_url, language, created_at')
        .eq('user_id', user.id)
        .maybeSingle();

    if (row == null) return null;
    return UserProfile.fromRow(row, email: user.email ?? '');
  }

  Future<ProfileUpdateResult> updateCurrentProfile({
    required String name,
    required String email,
    required String? avatarUrl,
  }) async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) throw StateError('No authenticated user.');

    final cleanName = name.trim();
    final cleanEmail = email.trim();
    final emailChanged = cleanEmail.toLowerCase() != user.email?.toLowerCase();

    await client
        .from('profiles')
        .update({
          'name': cleanName,
          'avatar_url': avatarUrl?.trim().isEmpty == true
              ? null
              : avatarUrl?.trim(),
        })
        .eq('user_id', user.id);

    final response = await client.auth.updateUser(
      UserAttributes(
        email: emailChanged ? cleanEmail : null,
        data: {'name': cleanName},
      ),
    );
    final pendingEmail = response.user?.newEmail;
    return ProfileUpdateResult(
      emailConfirmationPending:
          emailChanged &&
          pendingEmail?.toLowerCase() == cleanEmail.toLowerCase(),
    );
  }
}

class ProfileUpdateResult {
  const ProfileUpdateResult({required this.emailConfirmationPending});

  final bool emailConfirmationPending;
}
