import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordButtons extends StatelessWidget {
  final Record record;

  const RecordButtons({Key? key, required this.record}) : super(key: key);

  Widget getButton(BuildContext context, String type) {
    final locale = AppLocalizations.of(context)!;
    if (type == "store" || type == "add")
      return ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.login),
        label: Text(
          type == "store" ? locale.store : locale.add,
        ),
      );
    else if (type == "listen")
      return ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout),
        label: Text(
          locale.listen,
        ),
      );
    else if (type == "remove")
      return ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.delete_outline),
        label: Text(
          locale.remove,
        ),
      );
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.help_outline),
      label: Text("??"),
    );
  }

  @override
  Widget build(BuildContext context) {
    var buttons = <Widget>[];
    if (record.status == RecordStatus.outside) {
      buttons.add(getButton(context, "store"));
    }
    if (record.status == RecordStatus.inside) {
      buttons.add(getButton(context, "listen"));
    }
    if (record.status == RecordStatus.missing) {
      buttons.add(getButton(context, "add"));
    } else {
      buttons.add(getButton(context, "remove"));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons,
    );
  }
}
