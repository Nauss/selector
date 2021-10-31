import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/widgets/missing_bluetooth_dialog.dart';

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
              child: Image.asset(
                'assets/platine.gif',
              ),
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
      if (await FlutterBlue.instance.isOn) {
        bluetooth.connect();
      } else {
        bluetooth.connectionSubject.add(BlueToothState.bluetoothIsOff);
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
    } else if (state == BlueToothState.bluetoothIsOff) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const MissingBluetootheDialog(),
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
