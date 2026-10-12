import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// HANARI's light and dark palettes follow the colors in ТТ_жоспар.docx.
class AppTheme {
  // Light palette: clean sakura surfaces with the approved pink accents.
  static const lightBackground = Color(0xFFFBF3F7);
  static const lightSurface = Color(0xFFF6E7EE);
  static const lightPrimary = Color(0xFFFD4875);
  static const lightAccent = Color(0xFFFE688E);
  static const lightSecondary = Color(0xFFD7A7B4);
  static const lightText = Color(0xFF2B2335);
  static const lightMutedText = Color(0xFF6E6270);
  static const lightOutline = Color(0xFFE9D5DF);

  // Dark palette: charcoal surfaces with restrained sakura accents.
  static const darkBackground = Color(0xFF0F0B0D);
  static const darkSurface = Color(0xFF1A1417);
  static const darkPrimary = Color(0xFFC6686F);
  static const darkAccent = Color(0xFFF3BEC1);
  static const darkSecondary = Color(0xFFD79D9B);
  static const darkText = Color(0xFFF8EEF0);
  static const darkMutedText = Color(0xFFC9B7BC);
  static const darkOutline = Color(0xFF3A2B31);

  static ThemeData get light => _create(
    brightness: Brightness.light,
    background: lightBackground,
    surface: lightSurface,
    primary: lightPrimary,
    accent: lightAccent,
    secondary: lightSecondary,
    text: lightText,
    mutedText: lightMutedText,
    outline: lightOutline,
  );

  static ThemeData get dark => _create(
    brightness: Brightness.dark,
    background: darkBackground,
    surface: darkSurface,
    primary: darkPrimary,
    accent: darkAccent,
    secondary: darkSecondary,
    text: darkText,
    mutedText: darkMutedText,
    outline: darkOutline,
  );

  static ThemeData _create({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color accent,
    required Color secondary,
    required Color text,
    required Color mutedText,
    required Color outline,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? darkBackground : lightText,
      primaryContainer: isDark ? const Color(0xFF611F17) : lightSurface,
      onPrimaryContainer: isDark ? darkText : lightText,
      secondary: secondary,
      onSecondary: isDark ? darkBackground : lightText,
      secondaryContainer: surface,
      onSecondaryContainer: text,
      error: isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A),
      onError: isDark ? const Color(0xFF690005) : Colors.white,
      surface: surface,
      onSurface: text,
      onSurfaceVariant: mutedText,
      outline: outline,
      outlineVariant: outline,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? lightSurface : darkSurface,
      onInverseSurface: isDark ? lightText : darkText,
      inversePrimary: isDark ? lightPrimary : darkAccent,
      tertiary: accent,
      onTertiary: isDark ? darkBackground : lightText,
      tertiaryContainer: surface,
      onTertiaryContainer: text,
      errorContainer: isDark
          ? const Color(0xFF93000A)
          : const Color(0xFFFFDAD6),
      onErrorContainer: isDark
          ? const Color(0xFFFFDAD6)
          : const Color(0xFF410002),
      surfaceTint: primary,
      surfaceContainerLowest: background,
      surfaceContainerLow: background,
      surfaceContainer: surface,
      surfaceContainerHigh: surface,
      surfaceContainerHighest: surface,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: outline,
      splashColor: accent.withValues(alpha: .10),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: text,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: text,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: text),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: text),
        bodySmall: TextStyle(fontSize: 12, height: 1.4, color: mutedText),
        labelLarge: TextStyle(fontWeight: FontWeight.w700, color: text),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 0 : 1,
        shadowColor: isDark
            ? Colors.transparent
            : lightOutline.withValues(alpha: .35),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: isDark ? BorderSide(color: outline) : BorderSide.none,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: accent.withValues(alpha: isDark ? .20 : .30),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? text : mutedText,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? background : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: mutedText),
        labelStyle: TextStyle(color: mutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(color: outline),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? darkSurface : darkText,
        contentTextStyle: TextStyle(color: isDark ? darkText : Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
    return base;
  }
}
