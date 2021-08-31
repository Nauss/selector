import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main_screen.dart';

const titleInset = 32.0;
const bottomInset = 16.0;

class ConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
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
                  Text(locale.connection),
                  // Fake stuff, to replace with bluetooth connected
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainScreen();
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_right,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
