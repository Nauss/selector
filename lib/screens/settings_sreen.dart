import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return SettingsList(
      sections: [
        SettingsSection(
          title: locale.uiSettings,
          tiles: [
            SettingsTile.switchTile(
              title: locale.darkMode,
              subtitle: isDark ? locale.dark : locale.light,
              switchValue: isDark,
              onToggle: (bool value) {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
            ),
          ],
        ),
        SettingsSection(
          title: locale.bluetoothSettings,
          tiles: const [],
        ),
      ],
    );
  }
}
