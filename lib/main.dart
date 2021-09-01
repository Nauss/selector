import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:selector/app.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/debug.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/selector.dart';

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

  // await Hive.deleteBoxFromDisk('records');
  // await Hive.deleteBoxFromDisk('selector');

  // Open the boxes
  await Hive.openBox(Selector.BoxName);
  await Hive.openBox(Record.BoxName);

  // Debug add data
  await createFakeHive();
}

void initGetIt() {
  GetIt.I.registerSingleton<Selector>(Selector());
  GetIt.I.registerSingleton<Discogs>(Discogs());
}

void main() async {
  await initHive();
  await Globals.init();
  initGetIt();
  runApp(SelectorApp());
}
