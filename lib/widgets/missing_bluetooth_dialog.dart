import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissingBluetootheDialog extends StatelessWidget {
  const MissingBluetootheDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      title: Row(
        children: [
          Text(locale.bluetoothSettings),
          Expanded(child: Container()),
          Icon(
            Icons.bluetooth_disabled,
            color: themeData.errorColor,
          ),
        ],
      ),
      content: Column(
        children: [
          Text(locale.bluetoothRequired),
          const Text(''),
          Text(locale.bluetoothNextActivate),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () async {
            await AppSettings.openBluetoothSettings();
            Navigator.of(context).pop();
          },
          child: Text(locale.next),
        )
      ],
    );
  }
}
