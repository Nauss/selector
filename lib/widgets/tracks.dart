import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/track.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tracks extends StatelessWidget {
  final TrackList tracks;
  const Tracks({Key? key, required this.tracks}) : super(key: key);

  Widget trackItem(Track track, int index) {
    final side = EnumToString.convertToString(track.side);
    return ListTile(
      leading: Text("$side${index + 1} - ${track.title}"),
      trailing: Text(track.duration),
      dense: true,
    );
  }

  Widget sideItem(Side side, BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return SizedBox(
      height: 30,
      child: ListTile(
        leading: Text(locale.oneSide(EnumToString.convertToString(side))),
        enabled: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    var list = tracks.where((track) => track.side == Side.A).map((track) {
      var item = trackItem(track, index);
      index += 1;
      return item;
    }).toList();
    list.insert(0, sideItem(Side.A, context));
    if (tracks.length > index) {
      list.add(sideItem(Side.B, context));
      list.addAll(tracks.where((track) => track.side == Side.B).map((track) {
        var item = trackItem(track, index);
        index += 1;
        return item;
      }));
    }
    if (tracks.length > index) {
      list.add(sideItem(Side.C, context));
      list.addAll(tracks.where((track) => track.side == Side.C).map((track) {
        var item = trackItem(track, index);
        index += 1;
        return item;
      }));
    }
    if (tracks.length > index) {
      list.add(sideItem(Side.D, context));
      list.addAll(tracks.where((track) => track.side == Side.D).map((track) {
        var item = trackItem(track, index);
        index += 1;
        return item;
      }));
    }
    if (list.length <= 1) return Container();
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return list[index];
      },
    );
  }
}
