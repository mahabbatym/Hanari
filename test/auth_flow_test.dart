import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanari/l10n/language_controller.dart';
import 'package:hanari/screens/app.dart';
import 'package:hanari/services/favorites_controller.dart';
import 'package:hanari/theme/app_theme.dart';

void main() {
  testWidgets('registration form reports localized required fields', (
    tester,
  ) async {
    final language = LanguageController();
    final favorites = FavoritesController();
    addTearDown(language.dispose);
    addTearDown(favorites.dispose);

    await tester.pumpWidget(
      LanguageScope(
        controller: language,
        child: FavoritesScope(
          controller: favorites,
          child: MaterialApp(
            theme: AppTheme.light,
            home: const AuthScreen(isRegistration: true),
          ),
        ),
      ),
    );

    final submit = find.widgetWithText(FilledButton, 'Тіркелу');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('Қош келдіңіз!'), findsOneWidget);
    expect(find.text('Аты'), findsOneWidget);
    expect(find.text('Email енгізіңіз'), findsOneWidget);
    expect(find.text('Құпиясөзді енгізіңіз'), findsOneWidget);
    expect(find.text('Құпиясөзді растаңыз'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'login can navigate to registration without losing language state',
    (tester) async {
      final language = LanguageController();
      final favorites = FavoritesController();
      addTearDown(language.dispose);
      addTearDown(favorites.dispose);

      await tester.pumpWidget(
        LanguageScope(
          controller: language,
          child: FavoritesScope(
            controller: favorites,
            child: MaterialApp(
              theme: AppTheme.light,
              home: const AuthScreen(isRegistration: false),
              routes: {
                '/register': (_) => const AuthScreen(isRegistration: true),
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Аккаунтыңыз жоқ па? Тіркелу'));
      await tester.pumpAndSettle();

      expect(find.text('Қош келдіңіз!'), findsOneWidget);
      expect(find.text('Аты'), findsOneWidget);
      expect(find.text('Саяхатты бастау үшін тіркеліңіз'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
