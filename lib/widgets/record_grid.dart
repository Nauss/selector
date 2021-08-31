import 'package:flutter/material.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/widgets/record_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordGrid extends StatelessWidget {
  final RecordList? records;
  RecordGrid({Key? key, required this.records}) : super(key: key);

  Widget getHeader(BuildContext context, IconData icon, String text) {
    final themeData = Theme.of(context);
    return SliverGrid.count(
      crossAxisCount: 1,
      childAspectRatio: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: themeData.primaryColor,
            ),
            SizedBox(
              width: 8,
            ),
            Text(text)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    var listening = records != null
        ? records!
            .where(
              (record) => record.status == RecordStatus.outside,
            )
            .toList()
        : [];
    var stored = records != null
        ? records!
            .where(
              (record) => record.status == RecordStatus.inside,
            )
            .toList()
        : [];
    return CustomScrollView(
      slivers: [
        if (listening.length != 0)
          getHeader(context, Icons.login, locale.listening),
        SliverGrid.count(
          crossAxisCount: 2,
          children: listening.map((e) => RecordTile(record: e)).toList(),
        ),
        if (stored.length != 0)
          getHeader(context, Icons.logout, locale.mySelector),
        SliverGrid.count(
          crossAxisCount: 2,
          children: stored.map((e) => RecordTile(record: e)).toList(),
        ),
        if (records != null &&
            listening.length + stored.length < records!.length)
          SliverGrid.count(
            crossAxisCount: 2,
            children: records!.map((e) => RecordTile(record: e)).toList(),
          ),
      ],
    );
  }
}
