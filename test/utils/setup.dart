import 'dart:io';

import 'package:hive/hive.dart';
import 'package:selector/data/debug.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/data/track.dart';

Future<void> initHive() async {
  var path = Directory.current.path;
  Hive.init('$path/test/hive_testing_path');

  // enums
  Hive.registerAdapter(RecordStatusAdapter());
  Hive.registerAdapter(SideAdapter());
  Hive.registerAdapter(SortTypeAdapter());

  Hive.registerAdapter(RecordInfoAdapter());
  Hive.registerAdapter(RecordAdapter());
  Hive.registerAdapter(SearchAdapter());
  Hive.registerAdapter(TrackAdapter());

  await Hive.openBox(Selector.boxName);
  await Hive.openBox(Record.boxName);

  await createFakeHive();
}
