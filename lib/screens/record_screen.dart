import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/widgets/avatar_icon.dart';
import 'package:selector/widgets/record_buttons.dart';
import 'package:selector/widgets/tracks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordScreen extends StatefulWidget {
  final Record record;
  const RecordScreen({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final Discogs discogs = GetIt.I.get<Discogs>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final isDouble = widget.record.isDouble;
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
                final recordInfo = snapshot.data?.info ?? widget.record.info;
                debugPrint('detail tag: ${Tags.cover(widget.record.uniqueId)}');
                // debugPrint(recordInfo.id.toString());
                // getImage(recordInfo).then((value) => setState(() {
                //       _imageProvider = value;
                //     }));
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverStickyHeader(
                      header: Container(
                        decoration: BoxDecoration(
                          color: themeData.scaffoldBackgroundColor,
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              Hero(
                                tag: Tags.cover(widget.record.uniqueId),
                                child: Image(
                                  image: recordInfo.imageProvider,
                                ),
                              ),
                              if (widget.record.status != RecordStatus.none)
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: AvatarIcon(
                                    image: widget.record.status ==
                                            RecordStatus.outside
                                        ? Image.asset(
                                            'assets/icons/icone en ecoute.png',
                                            height: iconSize,
                                            width: iconSize,
                                          )
                                        : widget.record.status ==
                                                RecordStatus.inside
                                            ? Image.asset(
                                                'assets/icons/icone mon selector.png',
                                                height: iconSize,
                                                width: iconSize,
                                              )
                                            : Image.asset(
                                                'assets/icons/icone sortie du selector.png',
                                                height: iconSize,
                                                width: iconSize,
                                              ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      recordInfo.title,
                                      style: themeData.textTheme.headline4,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isDouble)
                                    AvatarIcon(
                                      image: Image.asset(
                                        'assets/icons/icone multi vinyle.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                recordInfo.artist,
                                style: themeData.textTheme.subtitle1,
                              ),
                              Text(
                                "${recordInfo.year} - ${recordInfo.country}",
                                style: themeData.textTheme.bodyText1,
                              ),
                              Text(
                                recordInfo.format,
                                style: themeData.textTheme.bodyText1,
                              ),
                              Text(
                                recordInfo.label,
                                style: themeData.textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverStickyHeader(
                      header: RecordButtons(record: widget.record),
                      sliver: SliverToBoxAdapter(
                        child: recordInfo.tracks.isNotEmpty
                            ? Tracks(tracks: recordInfo.tracks)
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: JumpingText(locale.loadingTracks)),
                              ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
