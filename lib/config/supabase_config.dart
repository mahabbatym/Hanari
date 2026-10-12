abstract final class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://akuapxdzcenfmdqqxzfn.supabase.co',
  );
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'sb_publishable_MJR0SyGVCvnYiT_hg3wOuA_Cc4Fp9_f',
    ),
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
