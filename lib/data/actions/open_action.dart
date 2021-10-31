import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';

class OpenAction extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  late String slot;
  OpenAction();

  @override
  Future<bool> execute(Record record) async {
    slot = record.position.toString();
    return bluetooth.open(record.position);
  }

  @override
  Image image(BuildContext context) {
    return Image.asset("assets/platine.gif");
  }

  @override
  Icon icon(BuildContext context) {
    return const Icon(Icons.open_in_new);
  }

  @override
  Text text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Text(locale.selectorOpening(slot));
  }
}
