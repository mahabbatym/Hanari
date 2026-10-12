import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanari/screens/app.dart';
import 'package:hanari/services/favorites_controller.dart';
import 'package:hanari/l10n/language_controller.dart';
import 'package:hanari/theme/app_theme.dart';
import 'package:hanari/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('main navigation shows icons without text labels', (
    tester,
  ) async {
    final language = LanguageController();
    final favorites = FavoritesController();
    final theme = ThemeController();
    addTearDown(language.dispose);
    addTearDown(favorites.dispose);
    addTearDown(theme.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: LanguageScope(
          controller: language,
          child: ThemeScope(
            controller: theme,
            child: FavoritesScope(
              controller: favorites,
              child: const MainShell(),
            ),
          ),
        ),
      ),
    );

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(
      navigationBar.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysHide,
    );
    expect(find.text('Home'), findsNothing);
    expect(find.text('Explore'), findsNothing);
    expect(find.text('Favorites'), findsNothing);
    expect(find.text('Profile'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home Explore button opens the usable Explore screen', (
    tester,
  ) async {
    final language = LanguageController();
    final favorites = FavoritesController();
    addTearDown(language.dispose);
    addTearDown(favorites.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: LanguageScope(
          controller: language,
          child: FavoritesScope(
            controller: favorites,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    final exploreButton = find.text('Зерттеуді бастау');
    expect(exploreButton, findsOneWidget);
    await tester.tap(exploreButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.text('Таным'), findsOneWidget);
    expect(find.text('Корея мәдениетінің бөлімін таңдаңыз.'), findsOneWidget);
    expect(find.text('Тарих'), findsOneWidget);
    expect(find.text('Дәстүр'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Тарих'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(CategoryScreen), findsOneWidget);
    expect(find.text('Ежелгі дәуірден бүгінге дейін'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Explore shows a friendly message when its section list is empty',
    (tester) async {
      final language = LanguageController();
      addTearDown(language.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: LanguageScope(
            controller: language,
            child: const ExploreScreen(sections: []),
          ),
        ),
      );

      expect(
        find.text('Бұл бөлімнің материалы әзірленіп жатыр.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Home remains free of layout overflows at iPhone width in all locales',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final language = LanguageController();
      final favorites = FavoritesController();
      addTearDown(language.dispose);
      addTearDown(favorites.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: LanguageScope(
            controller: language,
            child: FavoritesScope(
              controller: favorites,
              child: const HomeScreen(),
            ),
          ),
        ),
      );

      for (final locale in ['kk', 'ru', 'en', 'ko']) {
        language.languageCode = locale;
        language.notifyListeners();
        await tester.pump();
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'locale: $locale');
      }
    },
  );

  testWidgets('Saving a Home story updates its real continue-learning shelf', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final language = LanguageController();
    final favorites = FavoritesController();
    addTearDown(language.dispose);
    addTearDown(favorites.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: LanguageScope(
          controller: language,
          child: FavoritesScope(
            controller: favorites,
            child: const HomeScreen(),
          ),
        ),
      ),
    );

    final addFavorite = find.byTooltip('Таңдаулыға қосу');
    await tester.drag(find.byType(ListView).first, const Offset(0, -560));
    await tester.pump(const Duration(milliseconds: 250));
    expect(addFavorite, findsWidgets);
    await tester.tap(addFavorite.first);
    await tester.pump();
    expect(find.text('Сақталған материалдар: 1'), findsOneWidget);
    expect(find.byType(CultureEntryScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
