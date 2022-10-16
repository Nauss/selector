import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:selector/data/hive_ids.dart';
import 'package:selector/data/track.dart';

part 'record_info.g.dart';

@HiveType(typeId: hiveRecordInfoId)
class RecordInfo extends HiveObject {
  @HiveField(0)
  final int id; // The discogs id
  @HiveField(1)
  String title;
  @HiveField(2)
  String artist;
  @HiveField(3)
  String image;
  @HiveField(4)
  String country;
  @HiveField(5)
  int year;
  @HiveField(6)
  // Vinyl 33T - Album (to construct from response: formats)
  String format;
  @HiveField(7)
  // Label ariola 33158-65 (to construct from response: labels)
  String label;
  @HiveField(8)
  TrackList tracks;

  bool fullyLoaded;
  bool imageLoaded;
  ImageProvider imageProvider;

  RecordInfo({
    required this.id,
    required this.title,
    required this.artist,
    required this.image,
    required this.country,
    required this.year,
    required this.format,
    required this.label,
    required this.tracks,
    this.fullyLoaded = true,
    this.imageLoaded = false,
    this.imageProvider = const AssetImage(
      'assets/missing.png',
    ),
  });
}
