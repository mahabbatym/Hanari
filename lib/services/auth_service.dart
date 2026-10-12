import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

enum RegistrationStatus { signedIn, confirmationRequired }

class AuthService {
  bool get isConfigured => SupabaseConfig.isConfigured;

  GoTrueClient get _auth => Supabase.instance.client.auth;

  Future<void> signIn({required String email, required String password}) async {
    _ensureConfigured();
    await _auth.signInWithPassword(email: email.trim(), password: password);
  }

  Future<RegistrationStatus> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _ensureConfigured();
    final response = await _auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim()},
    );
    return response.session == null
        ? RegistrationStatus.confirmationRequired
        : RegistrationStatus.signedIn;
  }

  Future<void> signOut() async {
    _ensureConfigured();
    await _auth.signOut();
  }

  void _ensureConfigured() {
    if (!isConfigured) {
      throw StateError(
        'Supabase конфигурациясы жоқ. SUPABASE_URL және '
        'SUPABASE_PUBLISHABLE_KEY мәндерін іске қосу кезінде беріңіз.',
      );
    }
  }
}
