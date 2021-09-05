import 'package:flutter/material.dart' hide Action;
import 'package:selector/data/actions/action.dart';
import 'package:selector/data/debug.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';

class UserTakeAction extends Action {
  const UserTakeAction();

  @override
  Future<void> execute(Record record) {
    return fakeUserTake();
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
