import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/selector.dart';

class RecordButtons extends StatelessWidget {
  final selector = GetIt.I.get<Selector>();
  final Record record;

  RecordButtons({Key? key, required this.record}) : super(key: key);

  Widget getButton(BuildContext context, String type) {
    final locale = AppLocalizations.of(context)!;
    final ThemeData themeData = Theme.of(context);
    Color getDeleteColor(Set<MaterialState> states) {
      return themeData.errorColor;
    }

    if (type == "store")
      return OutlinedButton.icon(
        onPressed: () {
          selector.store(record);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.login),
        label: Text(
          locale.store,
        ),
      );
    else if (type == "add")
      return OutlinedButton.icon(
        onPressed: () {
          selector.add(record);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.login),
        label: Text(
          locale.add,
        ),
      );
    else if (type == "listen")
      return OutlinedButton.icon(
        onPressed: () {
          selector.listen(record);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.logout),
        label: Text(
          locale.listen,
        ),
      );
    else if (type == "remove")
      return OutlinedButton.icon(
        onPressed: () {
          selector.removeRecord(record);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_outline),
        label: Text(
          locale.remove,
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith(getDeleteColor),
        ),
      );
    return Container();
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
