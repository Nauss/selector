import 'package:flutter/material.dart' hide Action;
import 'package:selector/data/actions/action.dart';
import 'package:selector/data/debug.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';

class UserInsertAction extends Action {
  const UserInsertAction();

  @override
  Future<void> execute(Record record) {
    return fakeUserInsert();
  }

  @override
  Image image(BuildContext context) {
    return Image.asset("assets/platine.gif");
  }

  @override
  Icon icon(BuildContext context) {
    return const Icon(Icons.arrow_circle_down);
  }

  @override
  Text text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Text(locale.userInsert);
  }
}
