import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final selector = GetIt.I.get<Selector>();
  final bluetooth = GetIt.I.get<Bluetooth>();
  final bluetoothMessageController = TextEditingController(text: 'INIT');
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SettingsList(
          sections: [
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
            SettingsSection(
              title: locale.dataBase,
              tiles: [
                SettingsTile(
                  title: locale.clearDatabase,
                  trailing: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          themeData.errorColor),
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(locale.clearDatabase),
                        content: Text(locale.clearDatabaseWarning),
                        actions: [
                          ElevatedButton(
                            child: Text(locale.cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  themeData.errorColor),
                            ),
                            onPressed: () {
                              Hive.deleteBoxFromDisk(Record.boxName).then(
                                (value) => Hive.openBox(Record.boxName).then(
                                  (value) {
                                    selector.loadRecords();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                            child: Text(locale.clear),
                          ),
                        ],
                      ),
                    ),
                    child: Text(locale.clear),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
