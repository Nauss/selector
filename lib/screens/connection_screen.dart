import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/feature_missing_dialog.dart';

import 'main_screen.dart';

const titleInset = 32.0;
const bottomInset = 16.0;

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with WidgetsBindingObserver {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final selector = GetIt.I.get<Selector>();
  bool _isInBackground = false;
  StreamSubscription<BlueToothState>? _stream;

  @override
  void initState() {
    selector.loadSelectorSearch();
    selector.loadRecords();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bluetooth.connect();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    // Connect to the bluetooth stream and push the main page when connected
    _stream = bluetooth.connectionStream.listen(_bluetoothConnectionListener);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: titleInset,
                bottom: titleInset,
              ),
              child: Text(
                "Selector",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Image.asset("assets/gifs/gif ouverture appli.gif"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: bottomInset,
                bottom: bottomInset,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  Icon(
                    Icons.bluetooth_searching,
                    color: themeData.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  JumpingText(locale.connection),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          bluetooth.offline();
                        },
                        icon: const Icon(Icons.skip_next),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _isInBackground = true;
      await bluetooth.offline();
    }
    if (state == AppLifecycleState.resumed && _isInBackground) {
      _isInBackground = false;
      await bluetooth.connect();
    }
  }

  void _bluetoothConnectionListener(BlueToothState state) {
    if (_isInBackground) {
      return;
    }
    if (state == BlueToothState.connected || state == BlueToothState.offline) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        ),
      );
    }
    // Only show the feature missing dialog if the platform is darwin
    else if (state == BlueToothState.noBluetooth ||
        state == BlueToothState.bluetoothIsOff ||
        state == BlueToothState.noLocation) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => FeatureMissingDialog(state: state),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stream?.cancel();
    super.dispose();
  }
}
