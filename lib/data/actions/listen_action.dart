import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';

class ListenAction extends SelectorAction {
  final selector = GetIt.I.get<Selector>();
  final bluetooth = GetIt.I.get<Bluetooth>();
  ListenAction();

  @override
  Future<bool> execute(Record record) async {
    selector.listen(record);
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  SvgPicture image(BuildContext context) {
    return SVGs.mySelector(width: 150, height: 150);
  }

  @override
  Icon icon(BuildContext context) {
    return const Icon(Icons.account_balance_sharp);
  }

  @override
  Text text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Text(locale.selectorUpdating);
  }
}
