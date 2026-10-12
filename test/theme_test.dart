import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanari/theme/app_theme.dart';
import 'package:hanari/theme/theme_controller.dart';
import 'package:hanari/theme/theme_mode_selector.dart';
import 'package:hanari/l10n/language_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'HANARI themes use the specified Material 3 light and dark palettes',
    () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.light.colorScheme.brightness, Brightness.light);
      expect(AppTheme.light.scaffoldBackgroundColor, AppTheme.lightBackground);
      expect(AppTheme.light.colorScheme.surface, AppTheme.lightSurface);
      expect(AppTheme.light.colorScheme.primary, AppTheme.lightPrimary);

      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
      expect(AppTheme.dark.scaffoldBackgroundColor, AppTheme.darkBackground);
      expect(AppTheme.dark.colorScheme.surface, AppTheme.darkSurface);
      expect(AppTheme.dark.colorScheme.primary, AppTheme.darkPrimary);
    },
  );

  test('theme choice persists between controller instances', () async {
    SharedPreferences.setMockInitialValues({});
    final first = ThemeController();
    await first.load();
    expect(first.themeMode, ThemeMode.system);
    await first.setThemeMode(ThemeMode.dark);
    first.dispose();

    final restored = ThemeController();
    await restored.load();
    expect(restored.themeMode, ThemeMode.dark);
    await restored.setThemeMode(ThemeMode.light);
    restored.dispose();

    final systemChoice = ThemeController();
    await systemChoice.load();
    await systemChoice.setThemeMode(ThemeMode.system);
    systemChoice.dispose();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('hanari_theme_mode'), 'system');
  });

  testWidgets('System theme follows iOS or Android appearance changes', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: Builder(
          builder: (context) =>
              Scaffold(body: Text(Theme.of(context).brightness.name)),
        ),
      ),
    );
    expect(find.text('light'), findsOneWidget);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(find.text('dark'), findsOneWidget);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  });

  testWidgets('Profile selector changes the live theme and supports System', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final themes = ThemeController();
    await themes.load();
    final language = LanguageController();
    language.languageCode = 'en';

    await tester.pumpWidget(
      LanguageScope(
        controller: language,
        child: ThemeScope(
          controller: themes,
          child: AnimatedBuilder(
            animation: themes,
            builder: (context, _) => MaterialApp(
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themes.themeMode,
              home: Scaffold(
                body: Column(
                  children: [
                    const ThemeModeSelector(),
                    Builder(
                      builder: (context) =>
                          Text(Theme.of(context).brightness.name),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('light'), findsOneWidget);
    expect(find.text('Light'), findsNothing);
    expect(find.text('Dark'), findsNothing);
    expect(find.text('System'), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    await tester.tap(find.byTooltip('Dark'));
    await tester.pumpAndSettle();
    expect(find.text('dark'), findsOneWidget);

    await tester.tap(find.byTooltip('Light'));
    await tester.pumpAndSettle();
    expect(find.text('light'), findsOneWidget);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(find.text('dark'), findsOneWidget);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    themes.dispose();
    language.dispose();
  });
}
