import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/processor.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/double_switch.dart';
import 'package:selector/widgets/utils.dart';

class RecordButtons extends StatefulWidget {
  final Record record;

  const RecordButtons({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordButtons> createState() => _RecordButtonsState();
}

class _RecordButtonsState extends State<RecordButtons> {
  final selector = GetIt.I.get<Selector>();
  final processor = GetIt.I.get<Processor>();
  final bluetooth = GetIt.I.get<Bluetooth>();

  bool isDouble = false;

  @override
  void initState() {
    super.initState();
    isDouble = widget.record.isDouble;
  }

  void onTap(BuildContext context, Scenario scenario) {
    processor.start(scenario, widget.record);
    showSteps(context);
  }

  Widget getButton(BuildContext context, String type) {
    final locale = AppLocalizations.of(context)!;
    final ThemeData themeData = Theme.of(context);
    Color getDeleteColor(Set<MaterialState> states) {
      return themeData.colorScheme.error;
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
            onPressed: () => onTap(context,
                selector.addNextRemoved ? Scenario.addRemoved : Scenario.add),
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
    } else if (type == "takeOut") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onTap(context, Scenario.takeOut),
            child: Text(
              locale.takeOut,
            ),
          ),
        ),
      );
    } else if (type == "remove") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: widget.record.status == RecordStatus.outside
                ? () => onTap(context, Scenario.removeAlreadyOut)
                : () => onTap(context, Scenario.remove),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith(getDeleteColor),
            ),
            child: Text(
              locale.remove,
            ),
          ),
        ),
      );
    } else if (type == "removePermanently") {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onTap(context, Scenario.removePermanently),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith(getDeleteColor),
            ),
            child: Text(
              locale.removePermanently,
              textAlign: TextAlign.center,
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
    var isEditable = false;
    if (widget.record.status == RecordStatus.outside) {
      buttons.add(getButton(context, "store"));
      isEditable = true;
    }
    if (widget.record.status == RecordStatus.inside) {
      buttons.add(getButton(context, "listen"));
    }
    if (widget.record.status == RecordStatus.none) {
      buttons.add(getButton(context, "add"));
      isEditable = true;
    }
    if (widget.record.status == RecordStatus.removed) {
      buttons.add(getButton(context, "store"));
      buttons.add(getButton(context, "removePermanently"));
    } else if (widget.record.status == RecordStatus.inside) {
      buttons.add(getButton(context, "takeOut"));
    } else if (widget.record.status == RecordStatus.outside) {
      buttons.add(getButton(context, "remove"));
    }
    // Double picker switch
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buttons,
        ),
        DoubleSwitch(
            value: widget.record.isDouble,
            onChanged: isEditable
                ? (value) {
                    widget.record.isDouble = value;
                    setState(() {
                      isDouble = value;
                    });
                  }
                : null)
      ],
    );
  }
}
