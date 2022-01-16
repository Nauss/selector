import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/gradient_text.dart';

class OpenAction extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final selector = GetIt.I.get<Selector>();
  late String slot;
  late RecordStatus status;
  OpenAction();

  @override
  Future<bool> execute(Record record) async {
    selector.ensureRecordPosition(record);
    slot = record.position.toString();
    status = record.status;
    return bluetooth.open(record.position);
  }

  @override
  Widget image(BuildContext context) {
    if (status == RecordStatus.inside) {
      return Image.asset("assets/gifs/ouverture intercalaire avec vinyle.gif");
    } else {
      return Image.asset("assets/gifs/ouverture intercalaire vide.gif");
    }
  }

  @override
  Widget text(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return GradientText(locale.selectorOpening(slot));
  }
}
