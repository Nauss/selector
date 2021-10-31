import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/record.dart';

class UserTakeAction extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  UserTakeAction();

  @override
  Future<void> execute(Record record) {
    return bluetooth.userTake();
  }

  @override
  Image image(BuildContext context) {
    return Image.asset("assets/platine.gif");
  }

  @override
  Icon icon(BuildContext context) {
    return const Icon(Icons.arrow_circle_up);
  }

  @override
  Text text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Text(locale.userTake);
  }
}
