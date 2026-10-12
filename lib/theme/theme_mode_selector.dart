import 'package:flutter/material.dart';

import '../l10n/language_controller.dart';
import 'theme_controller.dart';

/// Compact, localized Light / Dark / System selector for Profile settings.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);
    final strings = context.strings;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ThemeChoice(
          mode: ThemeMode.system,
          selected: controller.themeMode,
          label: strings.get('themeSystem'),
          icon: Icons.settings_brightness_rounded,
          onSelected: controller.setThemeMode,
        ),
        _ThemeChoice(
          mode: ThemeMode.light,
          selected: controller.themeMode,
          label: strings.get('themeLight'),
          icon: Icons.light_mode_rounded,
          iconOnly: true,
          onSelected: controller.setThemeMode,
        ),
        _ThemeChoice(
          mode: ThemeMode.dark,
          selected: controller.themeMode,
          label: strings.get('themeDark'),
          icon: Icons.dark_mode_rounded,
          iconOnly: true,
          onSelected: controller.setThemeMode,
        ),
      ],
    );
  }
}

class _ThemeChoice extends StatelessWidget {
  const _ThemeChoice({
    required this.mode,
    required this.selected,
    required this.label,
    required this.icon,
    this.iconOnly = false,
    required this.onSelected,
  });

  final ThemeMode mode;
  final ThemeMode selected;
  final String label;
  final IconData icon;
  final bool iconOnly;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    avatar: Icon(icon, size: 18),
    label: iconOnly ? const SizedBox.shrink() : Text(label),
    tooltip: iconOnly ? label : null,
    showCheckmark: false,
    selected: selected == mode,
    onSelected: (_) => onSelected(mode),
  );
}
