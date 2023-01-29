import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/gradient_text.dart';

class AddAction extends SelectorAction {
  final selector = GetIt.I.get<Selector>();
  AddAction();

  @override
  Future<void> execute(Record record) {
    selector.add(record);
    return Future.value();
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
    return GradientText(locale.selectorUpdating);
  }
}

// Old add with addMore below
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:selector/data/actions/selector_action.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:selector/data/bluetooth.dart';
// import 'package:selector/data/discogs.dart';
// import 'package:selector/data/enums.dart';
// import 'package:selector/data/processor.dart';
// import 'package:selector/data/record.dart';
// import 'package:selector/data/selector.dart';
// import 'package:selector/screens/connection_screen.dart';
// import 'package:selector/screens/search_screen.dart';
// import 'package:selector/widgets/gradient_text.dart';

// class AddAction extends SelectorAction {
//   final selector = GetIt.I.get<Selector>();
//   final discogs = GetIt.I.get<Discogs>();
//   final bluetooth = GetIt.I.get<Bluetooth>();
//   final processor = GetIt.I.get<Processor>();
//   Record? record;
//   Completer<void>? completer;
//   AddAction();

//   @override
//   Future<void> execute(Record record) async {
//     this.record = record;
//     selector.add(record);
//     discogs.resultsSubject.add([]);
//     completer = Completer();
//     return completer!.future;
//   }

//   @override
//   Widget content(BuildContext context) {
//     // return AddButtons(
//     //   onFinish: onFinish,
//     //   onAdd: onAdd,
//     // );
//     return Image.asset("assets/gifs/insertion vinyle.gif");
//   }

//   @override
//   Widget text(BuildContext context) {
//     final locale = AppLocalizations.of(context)!;
//     return GradientText(locale.recordAdded);
//   }

//   void onFinish(BuildContext context) async {
//     completer?.complete();
//     if (!await bluetooth.checkConnection()) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) {
//             return const ConnectionScreen();
//           },
//         ),
//       );
//       return;
//     }
//     if (record == null) {
//       throw Exception("onFinish record is null, should not happen...");
//     }
//     processor.start(Scenario.close, record!);
//     // showSteps(context);
//   }

//   void onAdd(BuildContext context) async {
//     completer?.complete();
//     var navigator = Navigator.of(context);
//     // if (navigator.canPop()) {
//     //   navigator.pop();
//     // }
//     if (!await bluetooth.checkConnection()) {
//       navigator.push(
//         MaterialPageRoute(
//           builder: (context) {
//             return const ConnectionScreen();
//           },
//         ),
//       );
//       return;
//     }
//     navigator.push(
//       MaterialPageRoute(
//         builder: (context) => const SearchScreen(),
//       ),
//     );
//     // processor.start(Scenario.addMore, record!);
//     // showSteps(context);
//   }
// }
