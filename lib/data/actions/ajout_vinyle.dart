import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/gradient_text.dart';

class AjoutVinyle extends SelectorAction {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final selector = GetIt.I.get<Selector>();
  final discogs = GetIt.I.get<Discogs>();
  late RecordStatus status;
  AjoutVinyle();

  @override
  Future<bool> execute(Record record) async {
    selector.ensureRecordPosition(record);
    status = record.status;
    selector.add(record);
    discogs.resultsSubject.add([]);
    return bluetooth.ajoutVinyle(record.position);
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
