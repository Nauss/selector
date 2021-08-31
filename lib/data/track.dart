import 'package:hive/hive.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/hive_ids.dart';

part 'track.g.dart';

@HiveType(typeId: hiveTrackId)
class Track extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String duration;
  @HiveField(2)
  final Side side;

  Track({
    required this.title,
    required this.duration,
    required this.side,
  });
}

typedef TrackList = List<Track>;
