import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:im_stepper/stepper.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/processor.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/selector.dart';

class RecordButtons extends StatelessWidget {
  final selector = GetIt.I.get<Selector>();
  final processor = GetIt.I.get<Processor>();
  final Record record;

  RecordButtons({Key? key, required this.record}) : super(key: key);

  void onTap(BuildContext context, Scenario scenario) {
    final ThemeData themeData = Theme.of(context);
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
            return Column(
              children: [
                IconStepper(
                  icons: processor.currentActions!
                      .map((action) => action.icon(context))
                      .toList(),
                  steppingEnabled: true,
                  activeStep: step,
                  enableStepTapping: false,
                  enableNextPreviousButtons: false,
                  activeStepColor: themeData.primaryColor,
                  activeStepBorderColor: Colors.transparent,
                  lineColor: themeData.accentColor,
                ),
                currentAction.image(context),
                currentAction.text(context),
              ],
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
      return OutlinedButton.icon(
        onPressed: () => onTap(context, Scenario.store),
        icon: const Icon(Icons.login),
        label: Text(
          locale.store,
        ),
      );
    } else if (type == "add") {
      return OutlinedButton.icon(
        onPressed: () => onTap(context, Scenario.add),
        icon: const Icon(Icons.login),
        label: Text(
          locale.add,
        ),
      );
    } else if (type == "listen") {
      return OutlinedButton.icon(
        onPressed: () => onTap(context, Scenario.listen),
        icon: const Icon(Icons.logout),
        label: Text(
          locale.listen,
        ),
      );
    } else if (type == "remove") {
      return OutlinedButton.icon(
        onPressed: () => onTap(context, Scenario.remove),
        icon: const Icon(Icons.delete_outline),
        label: Text(
          locale.remove,
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith(getDeleteColor),
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
