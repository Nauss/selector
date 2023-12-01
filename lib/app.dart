import 'package:flutter/material.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

class SelectorApp extends StatelessWidget {
  const SelectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Selector',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          error: Colors.red[800],
        ),
        primaryColor: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 16),
        ),
        fontFamily: 'Cooper Black',
      ),
      home: const ConnectionScreen(),
    );
  }
}
