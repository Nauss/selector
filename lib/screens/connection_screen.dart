import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/enums.dart';

import 'main_screen.dart';

const titleInset = 32.0;
const bottomInset = 16.0;

class ConnectionScreen extends StatelessWidget {
  final bluetooth = GetIt.I.get<Bluetooth>();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    // Connect to the bluetooth stream and push the main page when connected
    bluetooth.connectionStream
        .firstWhere((element) => element == BlueToothState.connected)
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          },
        ),
      );
    });
    // Connect to the bluetooth
    bluetooth.connect();
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
                  SizedBox(width: 8),
                  JumpingText(locale.connection),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
