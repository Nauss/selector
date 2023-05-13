import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/parameters.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:selector/widgets/record_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart';

class RecordGrid extends StatelessWidget {
  final bluetooth = GetIt.I.get<Bluetooth>();
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
    final themeData = Theme.of(context);

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
              if (state == BlueToothState.offline ||
                  state == BlueToothState.bluetoothIsOff ||
                  state == BlueToothState.disconnected) {
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
                      "${stored.length}/$selectorCapacity",
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
