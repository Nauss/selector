import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/parameters.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/reconnection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/widgets/record_tile.dart';
import 'package:tuple/tuple.dart';

class RecordGrid extends StatelessWidget {
  final selector = GetIt.I.get<Selector>();
  final RecordList? records;
  final Parameters parameters;
  final List<RecordStatus> statusFilter;
  RecordGrid(
      {Key? key,
      required this.records,
      required this.parameters,
      this.statusFilter = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    final sorted = sort(records);
    RecordList listening = sorted.item1;
    RecordList stored = sorted.item2;
    RecordList removed = sorted.item3;
    RecordList none = sorted.item4;

    final extraMargin = listening.length + stored.length == 0 ? 8 : 0;
    final padding = _getTopMargin(context) + extraMargin + 4;
    final orientation = MediaQuery.of(context).orientation;
    var gridSize = parameters.gridViewType == GridViewType.normal ? 3 : 2;
    if (orientation == Orientation.landscape) {
      gridSize += 1;
    }
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: padding,
          ),
        ),
        SliverStickyHeader(
          header: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Reconnection(),
          ),
        ),
        if (listening.isNotEmpty &&
            (statusFilter.isEmpty ||
                statusFilter.contains(RecordStatus.outside)))
          SliverStickyHeader(
            header: listening.isNotEmpty
                ? getHeader(
                    context,
                    Image.asset(
                      'assets/icons/icone en ecoute.png',
                      width: 30,
                      height: 30,
                    ),
                    locale.listening,
                    "",
                  )
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: gridSize,
              children: listening.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (stored.isNotEmpty &&
            (statusFilter.isEmpty ||
                statusFilter.contains(RecordStatus.inside)))
          SliverStickyHeader(
            header: stored.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: listening.isEmpty ? 0 : 12),
                    child: getHeader(
                      context,
                      Image.asset(
                        'assets/icons/icone mon selector.png',
                        width: 30,
                        height: 30,
                      ),
                      locale.mySelector,
                      "${countTakenSpots(stored)}/$selectorCapacity",
                    ),
                  )
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: gridSize,
              children: stored.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (removed.isNotEmpty &&
            (statusFilter.isEmpty ||
                statusFilter.contains(RecordStatus.removed)))
          SliverStickyHeader(
            header: removed.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        top: listening.isEmpty && stored.isEmpty ? 0 : 12),
                    child: getHeader(
                      context,
                      Image.asset(
                        'assets/icons/icone sortie du selector.png',
                        width: 30,
                        height: 30,
                      ),
                      locale.outside,
                      "",
                    ),
                  )
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: gridSize,
              children: removed.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (none.isNotEmpty &&
            (statusFilter.isEmpty || statusFilter.contains(RecordStatus.none)))
          SliverGrid.count(
            crossAxisCount: gridSize,
            children: none.map((e) => RecordTile(record: e)).toList(),
          ),
        SliverPadding(
          padding: EdgeInsets.only(
            top: padding,
          ),
        ),
      ],
    );
  }

  Widget getHeader(
      BuildContext context, Widget icon, String text, String count) {
    final themeData = Theme.of(context);
    return Container(
      // height: 60.0,
      color: themeData.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          icon,
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 17),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              count,
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Tuple4 sort(RecordList? records) {
    final search = selector.selectorSearch;
    RecordList listening = [];
    RecordList stored = [];
    RecordList none = [];
    RecordList removed = [];
    if (records != null) {
      for (var record in records) {
        switch (record.status) {
          case RecordStatus.inside:
            if (search == null ||
                search.sortTypes.contains(SortType.mySelector)) {
              stored.add(record);
            }
            break;
          case RecordStatus.outside:
            if (search == null ||
                search.sortTypes.contains(SortType.listening)) {
              listening.add(record);
            }
            break;
          case RecordStatus.removed:
            if (search == null || search.sortTypes.contains(SortType.removed)) {
              removed.add(record);
            }
            break;
          case RecordStatus.none:
            none.add(record);
            break;
        }
      }
    }

    return Tuple4(listening, stored, removed, none);
  }

  double _getTopMargin(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);
    return fsb != null ? fsb.style.height + fsb.style.margins.vertical : 0;
  }
}

int countTakenSpots(List<Record> records) {
  int count = 0;
  for (var record in records) {
    count++;
    if (record.isDouble) {
      count++;
    }
  }
  return count;
}
