import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
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
  bool _isInBackground = false;
  StreamSubscription<BlueToothState>? _stream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
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
            Padding(
              padding: const EdgeInsets.only(
                top: titleInset,
                bottom: titleInset,
              ),
              child: Text(
                "Selector",
                style: GoogleFonts.openSans(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SVGs.mySelector(width: 200, height: 200),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: bottomInset,
                bottom: bottomInset,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bluetooth_searching,
                    color: themeData.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  JumpingText(locale.connection),
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
    }
    if (state == AppLifecycleState.resumed && _isInBackground) {
      _isInBackground = false;
      if (await bluetooth.checkPermissions()) {
        bluetooth.connect();
      }
    }
  }

  void _bluetoothConnectionListener(BlueToothState state) {
    if (state == BlueToothState.connected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        ),
      );
    } else if (state == BlueToothState.noBluetooth ||
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
    WidgetsBinding.instance?.removeObserver(this);
    _stream?.cancel();
    super.dispose();
  }
}
