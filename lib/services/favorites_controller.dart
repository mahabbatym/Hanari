import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class FavoritesController extends ChangeNotifier {
  static const _keyPrefix = 'hanari_favorites_';

  String? _userId;
  final Set<String> _entryIds = <String>{};

  Set<String> get entryIds => Set.unmodifiable(_entryIds);
  bool contains(String id) => _entryIds.contains(id);

  Future<void> loadForCurrentUser() async {
    _userId = SupabaseConfig.isConfigured
        ? Supabase.instance.client.auth.currentUser?.id
        : null;
    final preferences = await SharedPreferences.getInstance();
    _entryIds
      ..clear()
      ..addAll(preferences.getStringList(_storageKey) ?? const <String>[]);
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    if (!_entryIds.add(id)) _entryIds.remove(id);
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_storageKey, _entryIds.toList());
  }

  String get _storageKey => '$_keyPrefix${_userId ?? 'guest'}';
}

class FavoritesScope extends InheritedNotifier<FavoritesController> {
  const FavoritesScope({
    super.key,
    required FavoritesController controller,
    required super.child,
  }) : super(notifier: controller);

  static FavoritesController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FavoritesScope>();
    assert(scope != null, 'FavoritesScope is missing above this context.');
    return scope!.notifier!;
  }
}

extension FavoritesContext on BuildContext {
  FavoritesController get favorites => FavoritesScope.of(this);
}
