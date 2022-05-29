import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/gradient_text.dart';

class FermeMeuble extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final selector = GetIt.I.get<Selector>();
  late RecordStatus status;
  FermeMeuble();

  @override
  Future<bool> execute(Record record) async {
    status = record.status;
    return bluetooth.fermeMeuble(record.position);
  }

  @override
  Widget content(BuildContext context) {
    if (status == RecordStatus.inside) {
      return Image.asset("assets/gifs/insertion vinyle et fermeture.gif");
    } else {
      return Image.asset("assets/gifs/fermeture intercalaire vide.gif");
    }
  }

  @override
  Widget text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    if (status == RecordStatus.inside) {
      return GradientText(locale.selectorClosing);
    } else {
      return GradientText(locale.selectorClosingEmpty);
    }
  }
}
