import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/screens/connection_screen.dart';
import 'package:selector/widgets/record_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart';

class RecordGrid extends StatelessWidget {
  final bluetooth = GetIt.I.get<Bluetooth>();
  final RecordList? records;
  final bool isFiltered;
  RecordGrid({Key? key, required this.records, this.isFiltered = false})
      : super(key: key);

  Widget getHeader(BuildContext context, SvgPicture icon, String text) {
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
    final themeData = Theme.of(context);

    final sorted = sort(records);
    RecordList listening = sorted.item1;
    RecordList stored = sorted.item2;
    RecordList missing = sorted.item3;

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
        if (listening.isNotEmpty)
          SliverStickyHeader(
            header: listening.isNotEmpty
                ? getHeader(
                    context,
                    SVGs.listening(
                      color: themeData.primaryColor,
                    ),
                    locale.listening,
                  )
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: listening.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (stored.isNotEmpty)
          SliverStickyHeader(
            header: stored.isNotEmpty
                ? getHeader(
                    context,
                    SVGs.mySelector(
                      color: themeData.primaryColor,
                    ),
                    locale.mySelector)
                : null,
            sliver: SliverGrid.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: stored.map((e) => RecordTile(record: e)).toList(),
            ),
          ),
        if (missing.isNotEmpty)
          SliverGrid.count(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
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
