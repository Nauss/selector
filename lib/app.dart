import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
        ),
        dark: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blue,
            inputDecorationTheme:
                InputDecorationTheme(hintStyle: TextStyle(fontSize: 16))),
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              title: 'Selector',
              theme: theme,
              darkTheme: darkTheme,
              home: ConnectionScreen(),
            ));
  }
}
