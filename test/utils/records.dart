import 'package:selector/data/enums.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/track.dart';

final simpleInfo1 = RecordInfo(
  id: 1,
  artist: "Carlos",
  title: "Carlos",
  year: 2020,
  tracks: [],
  country: '',
  format: '',
  image: '',
  label: '',
);
final simpleInfo2 = RecordInfo(
  id: 2,
  artist: "Carlos",
  title: "Carlos",
  year: 2020,
  tracks: [],
  country: '',
  format: '',
  image: '',
  label: '',
);

final doubleInfo1 = RecordInfo(
  id: 100,
  artist: "Carlos",
  title: "Carlos",
  year: 2022,
  tracks: [Track(title: 'title', duration: 'duration', side: Side.C)],
  country: '',
  format: '',
  image: '',
  label: '',
);

final doubleInfo2 = RecordInfo(
  id: 200,
  artist: "Carlos",
  title: "Carlos",
  year: 2022,
  tracks: [Track(title: 'title', duration: 'duration', side: Side.C)],
  country: '',
  format: '',
  image: '',
  label: '',
);
