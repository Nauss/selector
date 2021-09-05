import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/widgets/record_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart';

class RecordGrid extends StatelessWidget {
  final RecordList? records;
  final bool isFiltered;
  const RecordGrid({Key? key, required this.records, this.isFiltered = false})
      : super(key: key);

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
            const SizedBox(
              width: 8,
            ),
            Text(text)
          ],
        ),
      ],
    );
  }

  Tuple3 sort(RecordList? records) {
    RecordList listening = [];
    RecordList stored = [];
    RecordList missing = [];
    if (records != null) {
      for (var record in records) {
        if (isFiltered) {
          missing.add(record);
        } else {
          switch (record.status) {
            case RecordStatus.inside:
              stored.add(record);
              break;
            case RecordStatus.outside:
              listening.add(record);
              break;
            case RecordStatus.missing:
              missing.add(record);
              break;
          }
        }
      }
    }

    return Tuple3(listening, stored, missing);
  }

  double _getTopMargin(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);
    return fsb != null ? fsb.style.height + fsb.style.margins.vertical : 0;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    final sorted = sort(records);
    RecordList listening = sorted.item1;
    RecordList stored = sorted.item2;
    RecordList missing = sorted.item3;

    final extraMargin = listening.length + stored.length == 0 ? 8 : 0;
    final padding = _getTopMargin(context) + extraMargin;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: padding,
          ),
        ),
        if (listening.isNotEmpty)
          getHeader(context, Icons.login, locale.listening),
        SliverGrid.count(
          crossAxisCount: 2,
          children: listening.map((e) => RecordTile(record: e)).toList(),
        ),
        if (stored.isNotEmpty)
          getHeader(context, Icons.logout, locale.mySelector),
        SliverGrid.count(
          crossAxisCount: 2,
          children: stored.map((e) => RecordTile(record: e)).toList(),
        ),
        if (missing.isNotEmpty)
          SliverGrid.count(
            crossAxisCount: 2,
            children: missing.map((e) => RecordTile(record: e)).toList(),
          ),
        SliverPadding(
          padding: EdgeInsets.only(
            top: padding,
          ),
        ),
      ],
    );
  }
}
