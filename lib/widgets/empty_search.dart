import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptySearch extends StatelessWidget {
  final String? query;
  const EmptySearch({Key? key, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final ThemeData themeData = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                query ?? locale.selectRecordStore,
                style: themeData.textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
