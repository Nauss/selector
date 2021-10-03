import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';

class AddAction extends SelectorAction {
  final selector = GetIt.I.get<Selector>();
  final discogs = GetIt.I.get<Discogs>();
  AddAction();

  @override
  Future<void> execute(Record record) {
    selector.add(record);
    discogs.resultsSubject.add([]);
    return Future.delayed(const Duration(seconds: 1));
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
