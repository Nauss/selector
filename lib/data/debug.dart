import 'dart:async';

import 'package:hive/hive.dart';

import 'record.dart';
import 'enums.dart';
import 'record_info.dart';
import 'track.dart';

var carlos = Record(
  position: 17,
  status: RecordStatus.outside,
  info: RecordInfo(
    id: 1,
    artist: 'Carlos',
    country: 'France',
    format: 'Vinyl 33T - Album',
    label: 'Ariola',
    title: 'Big Bisou',
    year: 1977,
    tracks: [
      Track(
        title: 'Big Bisous',
        duration: "3:30",
        side: Side.A,
      ),
      Track(
        title: 'Big Bisous Dub radio',
        duration: "3:50",
        side: Side.A,
      ),
    ],
    image:
        'https://img.discogs.com/2_Zt-K30TgRVm1A0c_plLe7ukgQ=/fit-in/592x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-738818-1354279839-4779.jpeg.jpg',
    fullyLoaded: true,
  ),
);
var israel = Record(
  position: 5,
  status: RecordStatus.outside,
  info: RecordInfo(
    id: 2,
    artist: 'Israel vibration',
    country: 'France',
    format: 'Vinyl 33T - Album',
    label: 'Ariola',
    title: 'The same song',
    year: 1977,
    tracks: [
      Track(
        title: 'Big Bisous',
        duration: "2:19",
        side: Side.A,
      ),
    ],
    image:
        'https://img.discogs.com/DtrjCvpFb-esRJYGPFaNsOFFVeQ=/fit-in/476x500/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-2034746-1303344108.jpeg.jpg',
    fullyLoaded: true,
  ),
);
var israel2 = Record(
  position: 6,
  status: RecordStatus.outside,
  info: RecordInfo(
    id: 3,
    artist: 'Israel vibration',
    country: 'France',
    format: 'Vinyl 33T - Album',
    label: 'Ariola',
    title: 'Jericho',
    year: 1977,
    tracks: [
      Track(
        title: 'Big Bisous',
        duration: "5:00",
        side: Side.A,
      ),
    ],
    image:
        'https://img.discogs.com/VL_DQtSrzZK3fJ25bdFcQCYg1Es=/fit-in/450x450/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1156231-1196708190.jpeg.jpg',
    fullyLoaded: true,
  ),
);
var dubamix = Record(
  position: 10,
  status: RecordStatus.inside,
  info: RecordInfo(
    id: 4,
    artist: 'Dubamix',
    country: 'France',
    format: 'Vinyl 33T - Album',
    label: 'Ariola',
    title: 'Camarades',
    year: 2021,
    tracks: [
      Track(
        title: 'Big Bisous',
        duration: "4:57",
        side: Side.A,
      ),
    ],
    image:
        'https://img.discogs.com/FJfxlytLS2BK1n28ELCgzvo7CiY=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-15378504-1590573595-6105.jpeg.jpg',
    fullyLoaded: true,
  ),
);
var rancid = Record(
  position: 15,
  status: RecordStatus.inside,
  info: RecordInfo(
    id: 5,
    artist: 'Rancid',
    country: 'France',
    format: 'Vinyl 33T - Album',
    label: 'Ariola',
    title: 'Trouble maker',
    year: 2021,
    tracks: [
      Track(
        title: 'Big Bisous',
        duration: "2:10",
        side: Side.A,
      ),
    ],
    image:
        'https://img.discogs.com/cygoM8mpqcYrTjOEMLgT9rmAW74=/fit-in/600x532/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-10410895-1558899184-7721.jpeg.jpg',
    fullyLoaded: true,
  ),
);
var danakil = Record(
  position: 35,
  status: RecordStatus.inside,
  info: RecordInfo(
    id: 566,
    artist: 'Danakil',
    country: 'France',
    format: 'Vinyl 33T - Album',
    label: 'Ariola',
    title: 'Danakil Meets OnDubGround',
    year: 2021,
    tracks: [
      Track(
        title: 'Ecosysdub',
        duration: "2:10",
        side: Side.A,
      ),
    ],
    image:
        'https://img.discogs.com/A9svAHZNQGlraxNpBmDOKidicTQ=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-11153397-1511350803-8677.jpeg.jpg',
    fullyLoaded: true,
  ),
);

var fakeList = [israel, carlos, dubamix, israel2, rancid, danakil];

Future<void> createFakeHive() async {
  var box = Hive.box(Record.boxName);
  if (box.isEmpty) {
    for (var record in fakeList) {
      await record.store();
    }
  }
}

Future<void> fakeBluetooth() async {
  await Future.delayed(const Duration(seconds: 5));
}

Future<void> fakeOpen() async {
  await Future.delayed(const Duration(seconds: 5));
}

Future<void> fakeClose() async {
  await Future.delayed(const Duration(seconds: 5));
}

Future<void> fakeUserInsert() async {
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> fakeUserTake() async {
  await Future.delayed(const Duration(seconds: 2));
}
