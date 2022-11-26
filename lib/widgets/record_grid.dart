import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:selector/widgets/record_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart';

class RecordGrid extends StatelessWidget {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final search = GetIt.I.get<Selector>().selectorSearch;
  final RecordList? records;
  final List<RecordStatus> statusFilter;
  RecordGrid({Key? key, required this.records, this.statusFilter = const []})
      : super(key: key);

  Widget getHeader(BuildContext context, Image icon, String text) {
    final themeData = Theme.of(context);
    return Container(
      // height: 60.0,
      color: themeData.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(4.0),
      // alignment: Alignment.centerLeft,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          )
        ],
      ),
    );
  }

  Tuple4 sort(RecordList? records) {
    RecordList listening = [];
    RecordList stored = [];
    RecordList none = [];
    RecordList removed = [];
    if (records != null) {
      for (var record in records) {
        switch (record.status) {
          case RecordStatus.inside:
            if (search == null ||
                search!.sortTypes.contains(SortType.mySelector)) {
              stored.add(record);
            }
            break;
          case RecordStatus.outside:
            if (search == null ||
                search!.sortTypes.contains(SortType.listening)) {
              listening.add(record);
            }
            break;
          case RecordStatus.removed:
            if (search == null ||
                search!.sortTypes.contains(SortType.removed)) {
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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    final sorted = sort(records);
    RecordList listening = sorted.item1;
    RecordList stored = sorted.item2;
    RecordList removed = sorted.item3;
    RecordList none = sorted.item4;

    final extraMargin = listening.length + stored.length == 0 ? 8 : 0;
    final padding = _getTopMargin(context) + extraMargin + 4;
    final orientation = MediaQuery.of(context).orientation;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: padding,
          ),
        ),
        StreamBuilder(
            stream: bluetooth.connectionStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 0,
                  ),
                );
              }
              BlueToothState state = snapshot.data as BlueToothState;
              if (state == BlueToothState.offline) {
                return SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Back to the connection screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ConnectionScreen();
                              },
                            ),
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            themeData.focusColor,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(
                          Icons.bluetooth_disabled,
                          size: 20,
                        ),
                        label: Text(
                          locale.reconnect,
                          style: const TextStyle(color: Colors.orange),
                        ),
                      )
                    ],
                  ),
                );
              }
              return SliverToBoxAdapter(
                child: Container(
                  height: 0,
                ),
              );
            }),
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
                  )
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: listening.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (stored.isNotEmpty &&
            (statusFilter.isEmpty ||
                statusFilter.contains(RecordStatus.inside)))
          SliverStickyHeader(
            header: stored.isNotEmpty
                ? getHeader(
                    context,
                    Image.asset(
                      'assets/icons/icone mon selector.png',
                      width: 30,
                      height: 30,
                    ),
                    locale.mySelector)
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: stored.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (removed.isNotEmpty &&
            (statusFilter.isEmpty ||
                statusFilter.contains(RecordStatus.removed)))
          SliverStickyHeader(
            header: removed.isNotEmpty
                ? getHeader(
                    context,
                    Image.asset(
                      'assets/icons/icone sortie du selector.png',
                      width: 30,
                      height: 30,
                    ),
                    locale.removed)
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: removed.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (none.isNotEmpty &&
            (statusFilter.isEmpty || statusFilter.contains(RecordStatus.none)))
          SliverGrid.count(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
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
}
