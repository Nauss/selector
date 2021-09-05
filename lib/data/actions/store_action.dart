import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';

class StoreAction extends Action {
  final selector = GetIt.I.get<Selector>();
  StoreAction();

  @override
  Future<void> execute(Record record) {
    selector.store(record);
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Image image(BuildContext context) {
    return Image.asset("assets/platine.gif");
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
