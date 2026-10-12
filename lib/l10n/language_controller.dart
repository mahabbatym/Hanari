import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import 'app_strings.dart';

class LanguageController extends ChangeNotifier {
  String languageCode = 'kk';
  static const _preferenceKey = 'hanari_language';

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final preferredCode = preferences.getString(_preferenceKey);
    languageCode = AppStrings.languageNames.containsKey(preferredCode)
        ? preferredCode!
        : 'kk';

    if (SupabaseConfig.isConfigured &&
        Supabase.instance.client.auth.currentUser != null) {
      try {
        final user = Supabase.instance.client.auth.currentUser!;
        final row = await Supabase.instance.client
            .from('profiles')
            .select('language')
            .eq('user_id', user.id)
            .maybeSingle();
        final savedCode = row?['language'] as String?;
        if (AppStrings.languageNames.containsKey(savedCode)) {
          languageCode = savedCode!;
          await preferences.setString(_preferenceKey, languageCode);
        }
      } catch (_) {
        // Keep the device preference if the profile is temporarily unavailable.
      }
    }
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (!AppStrings.languageNames.containsKey(code)) return;
    languageCode = code;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, code);

    if (SupabaseConfig.isConfigured) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client
            .from('profiles')
            .update({'language': code})
            .eq('user_id', user.id);
      }
    }
  }
}

class LanguageScope extends InheritedNotifier<LanguageController> {
  const LanguageScope({
    super.key,
    required LanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static LanguageController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    assert(scope != null, 'LanguageScope is missing above this context.');
    return scope!.notifier!;
  }
}

extension AppStringsContext on BuildContext {
  AppStrings get strings => AppStrings(LanguageScope.of(this).languageCode);
}

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LanguageScope.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: controller.languageCode,
        icon: const Icon(Icons.language_rounded),
        borderRadius: BorderRadius.circular(16),
        items: AppStrings.languageNames.entries
            .map(
              (entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: (code) async {
          if (code == null) return;
          try {
            await controller.setLanguage(code);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.strings.get('languageSaved'))),
              );
            }
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.strings.get('languageSaveError')),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
