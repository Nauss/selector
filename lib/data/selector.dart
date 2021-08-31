import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record.dart';

import 'debug.dart';

class Selector {
  static const String BoxName = 'selector';

  RecordList records = [];
  late BehaviorSubject<RecordList> recordsSubject;
  late BehaviorSubject<Record> recordSubject;

  Selector() {
    recordsSubject = BehaviorSubject<RecordList>.seeded(records);
    recordSubject = BehaviorSubject<Record>();
  }

  Future<RecordList?> load() async {
    // Open the box
    var box = await Hive.openBox(BoxName);
    await createFakeHive();
    records = <Record>[];
    for (var i = 0; i < selectorCapacity; i++) {
      var record = box.get(i) as Record?;
      if (record != null) {
        records!.add(record);
      }
    }
    return records;
  }
}

// showmodalbottom sheet
