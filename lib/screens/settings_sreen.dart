import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final bluetoothMessageController = TextEditingController(text: 'INIT');
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SettingsList(
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
              subtitle: TextField(
                controller: bluetoothMessageController,
                textCapitalization: TextCapitalization.characters,
              ),
              title: locale.bluetoothSettings,
              tiles: [
                SettingsTile(
                  title: 'Tail only 🙈',
                  trailing: OutlinedButton(
                      onPressed: () {
                        bluetooth.sendMessage(bluetoothMessageController.text);
                      },
                      child: const Text('Envoyer')),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
