import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
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
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: getImage(recordInfo),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.6, 0.95],
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
                      recordInfo.artist,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
          fit: StackFit.expand,
        ),
      ),
    );
  }
}
