import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/processor.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/connection_screen.dart';

class RecordButtons extends StatelessWidget {
  final selector = GetIt.I.get<Selector>();
  final processor = GetIt.I.get<Processor>();
  final bluetooth = GetIt.I.get<Bluetooth>();
  final Record record;

  RecordButtons({Key? key, required this.record}) : super(key: key);

  void onTap(BuildContext context, Scenario scenario) {
    if (bluetooth.state != BlueToothState.connected) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const ConnectionScreen();
          },
        ),
      );
      return;
    }
    processor.start(scenario, record);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StreamBuilder<Object>(
          stream: processor.stepStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final step = snapshot.data as int;
            if (step == -1) {
              Future.delayed(const Duration(milliseconds: 10),
                  () => Navigator.popUntil(context, (route) => route.isFirst));
              return Container();
            }
            final currentAction = processor.currentAction;
            if (currentAction == null) {
              return Container();
            }
            return Center(
              child: Column(
                children: [
                  currentAction.image(context),
                  currentAction.text(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget getButton(BuildContext context, String type) {
    final locale = AppLocalizations.of(context)!;
    final ThemeData themeData = Theme.of(context);
    Color getDeleteColor(Set<MaterialState> states) {
      return themeData.errorColor;
    }

    if (type == "store") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onTap(context, Scenario.store),
            child: Text(
              locale.store,
            ),
          ),
        ),
      );
    } else if (type == "add") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onTap(context, Scenario.add),
            child: Text(
              locale.add,
            ),
          ),
        ),
      );
    } else if (type == "listen") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onTap(context, Scenario.listen),
            child: Text(
              locale.listen,
            ),
          ),
        ),
      );
    } else if (type == "remove") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onTap(context, Scenario.remove),
            child: Text(
              locale.remove,
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith(getDeleteColor),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var buttons = <Widget>[];
    if (record.status == RecordStatus.outside) {
      buttons.add(getButton(context, "store"));
    }
    if (record.status == RecordStatus.inside) {
      buttons.add(getButton(context, "listen"));
    }
    if (record.status == RecordStatus.missing) {
      buttons.add(getButton(context, "add"));
    } else {
      buttons.add(getButton(context, "remove"));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons,
    );
  }
}
