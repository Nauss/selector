import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/screens/record_screen.dart';
import 'package:selector/data/processor.dart';
import 'package:selector/widgets/utils.dart';

class Reconnection extends StatelessWidget {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final processor = GetIt.I.get<Processor>();
  Reconnection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    return StreamBuilder(
      stream: bluetooth.connectionStream,
      builder: (context, snapshot) {
        BlueToothState state = snapshot.hasData
            ? snapshot.data as BlueToothState
            : BlueToothState.disconnected;
        return StreamBuilder(
          stream: processor.hydratingStream,
          builder: (context, snapshot) {
            bool hydrating = snapshot.hasData ? snapshot.data as bool : false;
            if (state == BlueToothState.connected) {
              if (hydrating) {
                Future.microtask(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RecordScreen(record: processor.record!);
                      },
                    ),
                  );
                  showSteps(context);
                });
              }
              return const SizedBox.shrink();
            }
            return ElevatedButton.icon(
              onPressed: () {
                // Back to the connection screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ConnectionScreen();
                    },
                  ),
                );
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.orange,
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  themeData.focusColor,
                ),
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(
                Icons.bluetooth_disabled,
                size: 20,
              ),
              label: Text(
                locale.waitForReconnect,
                style: const TextStyle(color: Colors.orange),
              ),
            );
          },
        );
      },
    );
  }
}
