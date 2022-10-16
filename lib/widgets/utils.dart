import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/processor.dart';

Future<dynamic> showSteps(BuildContext context) {
  final processor = GetIt.I.get<Processor>();
  return showModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.33,
    ),
    barrierColor: const Color.fromARGB(100, 0, 0, 0),
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: StreamBuilder<Object>(
          stream: processor.stepStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final step = snapshot.data as int;
            if (step == -1) {
              Future.delayed(
                  const Duration(milliseconds: 10),
                  () => Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      ));
              return Container();
            }
            final currentAction = processor.currentAction;
            if (currentAction == null) {
              return Container();
            }
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: currentAction.content(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: currentAction.text(context),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
