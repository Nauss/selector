import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/record.dart';
import 'package:selector/widgets/gradient_text.dart';

class RentreVinyle extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  RentreVinyle();

  @override
  Future<void> execute(Record record) {
    return bluetooth.rentreVinyle();
  }

  @override
  Widget content(BuildContext context) {
    return Image.asset(
      "assets/gifs/ouverture intercalaire vide.gif",
      width: 200,
    );
  }

  @override
  Widget text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return GradientText(locale.userInsert);
  }
}
