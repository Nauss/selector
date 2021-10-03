import 'package:flutter/material.dart' hide Action;
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/debug.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';

class CloseAction extends SelectorAction {
  late String slot;
  CloseAction();

  @override
  Future<void> execute(Record record) {
    slot = record.position.toString();
    return fakeClose();
  }

  @override
  Image image(BuildContext context) {
    return Image.asset("assets/platine.gif");
  }

  @override
  Icon icon(BuildContext context) {
    return const Icon(Icons.close);
  }

  @override
  Text text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Text(locale.selectorClosing(slot));
  }
}
