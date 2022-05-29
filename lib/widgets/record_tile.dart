import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/utils.dart';
import 'package:selector/screens/record_screen.dart';

class RecordTile extends StatelessWidget {
  final Record record;

  const RecordTile({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecordInfo recordInfo = record.info;
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return RecordScreen(record: record);
              },
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: Tags.cover(record.uniqueId),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: getImage(recordInfo),
                  ),
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
                      '${recordInfo.artist} @${record.position}',
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
          ],
        ),
      ),
    );
  }
}
