import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

class SelectorApp extends StatelessWidget {
  const SelectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themeData.primaryColor,
    ));
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: themeData.primaryColor,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 16),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: themeData.primaryColor,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 16),
        ),
      ),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Selector',
        theme: theme,
        darkTheme: darkTheme,
        home: const ConnectionScreen(),
      ),
    );
  }
}
