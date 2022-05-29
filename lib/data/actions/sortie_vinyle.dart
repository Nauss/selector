import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/gradient_text.dart';

class SortieVinyle extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final selector = GetIt.I.get<Selector>();
  late RecordStatus status;
  SortieVinyle();

  @override
  Future<bool> execute(Record record) async {
    selector.ensureRecordPosition(record);
    status = record.status;
    return bluetooth.sortieVinyle(record.position);
  }

  @override
  Widget content(BuildContext context) {
    if (status == RecordStatus.inside) {
      return Image.asset("assets/gifs/ouverture et retrait vinyle.gif");
    } else {
      return Image.asset("assets/gifs/ouverture intercalaire vide.gif");
    }
  }

  @override
  Widget text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    if (status == RecordStatus.inside) {
      return GradientText(locale.selectorOpeningVinyl);
    } else {
      return GradientText(locale.selectorOpeningEmpty);
    }
  }
}
