import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:selector/app.dart';
import 'package:selector/data/constants.dart';

// Adapters
import 'package:selector/data/track.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // enums
  Hive.registerAdapter(RecordStatusAdapter());
  Hive.registerAdapter(SideAdapter());
  Hive.registerAdapter(SortTypeAdapter());

  Hive.registerAdapter(RecordInfoAdapter());
  Hive.registerAdapter(RecordAdapter());
  Hive.registerAdapter(SearchAdapter());
  Hive.registerAdapter(TrackAdapter());

  Hive.deleteBoxFromDisk('records');
}

void main() async {
  await initHive();
  await Globals.init();
  runApp(SelectorApp());
}
