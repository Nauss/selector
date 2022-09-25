import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/screens/record_screen.dart';

import '../data/discogs.dart';
import 'avatar_icon.dart';

class RecordTile extends StatefulWidget {
  final Record record;
  const RecordTile({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordTile> createState() => _RecordTileState();
}

class _RecordTileState extends State<RecordTile> {
  final Discogs discogs = GetIt.I.get<Discogs>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecordInfo recordInfo = widget.record.info;
    discogs.loadImage(widget.record);
    final themeData = Theme.of(context);
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    final isDouble = widget.record.isDouble;
    return Card(
      child: Hero(
        tag: Tags.cover(widget.record.uniqueId),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    debugPrint(
                        'tile tag: ${Tags.cover(widget.record.uniqueId)}');
                    discogs.loadDetails(widget.record);
                    return RecordScreen(record: widget.record);
                  },
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: recordInfo.imageProvider,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      stops: const [0.2, 1],
                      colors: [
                        Colors.transparent,
                        isDark ? Colors.black : Colors.white,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${recordInfo.artist} @${widget.record.position}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        Text(
                          recordInfo.title,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isDouble)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: AvatarIcon(
                      svg: SVGs.multiple(
                        color: themeData.primaryColor,
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
