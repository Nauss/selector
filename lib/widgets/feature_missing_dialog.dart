import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/enums.dart';

class FeatureMissingDialog extends StatelessWidget {
  final BlueToothState state;
  const FeatureMissingDialog({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    String title, text, next;
    IconData icon;
    if (state == BlueToothState.noLocation) {
      icon = Icons.location_disabled;
      title = locale.locationSettings;
      text = locale.locationRequired;
      next = locale.locationNextActivate;
    } else {
      icon = Icons.bluetooth_disabled;
      title = locale.bluetoothSettings;
      text = locale.bluetoothRequired;
      next = locale.bluetoothNextActivate;
    }
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      title: Row(
        children: [
          Text(title),
          Expanded(child: Container()),
          Icon(
            icon,
            color: themeData.errorColor,
          ),
        ],
      ),
      content: Column(
        children: [
          Text(text),
          const Text(''),
          Text(next),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () async {
            if (state == BlueToothState.noLocation) {
              await AppSettings.openLocationSettings();
            } else {
              await AppSettings.openBluetoothSettings();
            }
            Navigator.of(context).pop();
          },
          child: Text(locale.next),
        )
      ],
    );
  }
}
