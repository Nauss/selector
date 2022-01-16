import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';
import 'package:selector/widgets/gradient_text.dart';

class CloseAction extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  late String slot;
  CloseAction();

  @override
  Future<bool> execute(Record record) {
    slot = record.position.toString();
    return bluetooth.close(record.position);
  }

  @override
  Widget image(BuildContext context) {
    return Image.asset("assets/gifs/fermeture intercalaire avec vinyle.gif");
  }

  @override
  Widget text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return GradientText(locale.selectorInsertAndClose(slot));
  }
}
