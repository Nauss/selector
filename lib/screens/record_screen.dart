import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/utils.dart';
import 'package:selector/widgets/record_buttons.dart';
import 'package:selector/widgets/tracks.dart';

class RecordScreen extends StatelessWidget {
  final Discogs discogs = GetIt.I.get<Discogs>();
  final Record record;
  RecordScreen({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recordInfo = record.info;
    discogs.loadDetails(record);

    final themeData = Theme.of(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          discogs.recordDetailSubject.add(null);
          return true;
        },
        child: Scaffold(
          body: StreamBuilder<Record?>(
              stream: discogs.recordDetailStream,
              builder: (context, snapshot) {
                final updatedInfo = snapshot.data?.info ?? recordInfo;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Center(
                        child: Stack(
                          children: [
                            Hero(
                              tag: Tags.cover(record.uniqueId),
                              child: Image(
                                image: getImage(updatedInfo),
                              ),
                            ),
                            if (record.status != RecordStatus.missing)
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor:
                                      themeData.dialogBackgroundColor,
                                  child: record.status == RecordStatus.outside
                                      ? SVGs.listening(
                                          color: themeData.primaryColor,
                                        )
                                      : SVGs.mySelector(
                                          color: themeData.primaryColor,
                                        ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            updatedInfo.title,
                            style: themeData.textTheme.headline4,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            updatedInfo.artist,
                            style: themeData.textTheme.subtitle1,
                          ),
                          Text(
                            "${updatedInfo.year} - ${updatedInfo.country}",
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(
                            updatedInfo.format,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(
                            updatedInfo.label,
                            style: themeData.textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    RecordButtons(record: record),
                    Flexible(
                      flex: 1,
                      child: Tracks(tracks: updatedInfo.tracks),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
