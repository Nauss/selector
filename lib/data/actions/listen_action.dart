import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/gradient_text.dart';

class ListenAction extends SelectorAction {
  final selector = GetIt.I.get<Selector>();
  final bluetooth = GetIt.I.get<Bluetooth>();
  ListenAction();

  @override
  Future<bool> execute(Record record) async {
    selector.listen(record);
    return true;
  }

  @override
  Widget content(BuildContext context) {
    return Image.asset(
      "assets/gifs/ouverture intercalaire vide.gif",
      width: 200,
    );
  }

  @override
  Widget text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return GradientText(locale.selectorUpdating);
  }
}
