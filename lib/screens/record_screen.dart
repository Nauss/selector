import 'package:flutter/material.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/utils.dart';
import 'package:selector/widgets/record_buttons.dart';
import 'package:selector/widgets/tracks.dart';

class RecordScreen extends StatefulWidget {
  final Record record;

  const RecordScreen({Key? key, required this.record}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState(record);
}

class _RecordScreenState extends State<RecordScreen> {
  Record record;
  _RecordScreenState(this.record);

  @override
  Widget build(BuildContext context) {
    RecordInfo recordInfo = record.info;
    if (!recordInfo.fullyLoaded) {
      Discogs.updateRecord(record).then((value) {
        setState(() {
          record = value;
        });
      });
    }
    final themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: getImage(recordInfo),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recordInfo.title,
                    style: themeData.primaryTextTheme.headline4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    recordInfo.artist,
                    style: themeData.primaryTextTheme.subtitle1,
                  ),
                  Text(
                    "${recordInfo.year} - ${recordInfo.country}",
                    style: themeData.primaryTextTheme.bodyText1,
                  ),
                  Text(
                    recordInfo.format,
                    style: themeData.primaryTextTheme.bodyText1,
                  ),
                  Text(
                    recordInfo.label,
                    style: themeData.primaryTextTheme.bodyText1,
                  ),
                ],
              ),
            ),
            RecordButtons(record: widget.record),
            Expanded(
              child: Tracks(tracks: recordInfo.tracks),
            ),
          ],
        ),
      ),
    );
  }
}
