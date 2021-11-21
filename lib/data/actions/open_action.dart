import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';

class OpenAction extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final selector = GetIt.I.get<Selector>();
  late String slot;
  OpenAction();

  @override
  Future<bool> execute(Record record) async {
    selector.ensureRecordPosition(record);
    slot = record.position.toString();
    return bluetooth.open(record.position);
  }

  @override
  SvgPicture image(BuildContext context) {
    return SVGs.mySelector(width: 150, height: 150);
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
