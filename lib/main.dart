import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:selector/app.dart';
import 'package:selector/data/bluetooth.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/debug.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/processor.dart';
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
  await Hive.openBox(Selector.boxName);
  await Hive.openBox(Record.boxName);

  // Debug add data
  await createFakeHive();
}

void initGetIt() {
  GetIt.I.registerSingleton<Selector>(Selector());
  GetIt.I.registerSingleton<Discogs>(Discogs());
  GetIt.I.registerSingleton<Bluetooth>(Bluetooth());
  GetIt.I.registerSingleton<Processor>(Processor());
}

void main() async {
  await dotenv.load(fileName: ".env");

  await Globals.init();
  initGetIt();
  await initHive();

  runApp(const SelectorApp());
}
