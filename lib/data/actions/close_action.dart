import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';

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
  SvgPicture image(BuildContext context) {
    return SVGs.mySelector(width: 150, height: 150);
  }

  @override
  Icon icon(BuildContext context) {
    return const Icon(Icons.close);
  }

  @override
  Text text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Text(locale.selectorInsertAndClose(slot));
  }
}
