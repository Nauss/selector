import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';

class Selector {
  static const String BoxName = 'selector';
  static const SelectorSearchKey = 'selectorSearch';
  static const NetworkSearchKey = 'networkSearch';

  RecordList records = [];
  late BehaviorSubject<RecordList> recordsSubject;
  Search? selectorSearch, networkSearch;
  late BehaviorSubject<Search> selectorSearchSubject, networkSearchSubject;

  Selector() {
    recordsSubject = BehaviorSubject<RecordList>();
    selectorSearchSubject = BehaviorSubject<Search>();
    networkSearchSubject = BehaviorSubject<Search>();
  }

  // Records functions
  ValueStream<RecordList> get recordsStream => recordsSubject.stream;
  void loadRecords() {
    // Get the box
    var box = Hive.box(Record.BoxName);
    records = <Record>[];
    for (var i = 0; i < selectorCapacity; i++) {
      var record = box.get(i) as Record?;
      if (record != null) {
        records.add(record);
      }
    }
    recordsSubject.add(records);
  }

  void remove(Record record) {
    // Get the box
    var box = Hive.box(Record.BoxName);
    box.delete(record.position);
    records.remove(record);
    recordsSubject.add(records);
  }

  void listen(Record record) {
    record.status = RecordStatus.outside;
    record.save();
    recordsSubject.add(records);
  }

  void store(Record record) {
    record.status = RecordStatus.inside;
    record.save();
    recordsSubject.add(records);
  }

  void add(Record record) {
    record.status = RecordStatus.inside;
    record.position = records.last.position + 1;
    // Get the box
    var box = Hive.box(Record.BoxName);
    box.put(record.position, record);
    records.add(record);
    recordsSubject.add(records);
  }

  // Search functions
  ValueStream<Search> get selectorSearchStream => selectorSearchSubject.stream;
  ValueStream<Search> get networkSearchStream => networkSearchSubject.stream;
  void loadSelectorSearch() {
    // Get the box
    var box = Hive.box(Selector.BoxName);
    selectorSearch = box.get(SelectorSearchKey) as Search?;
    if (selectorSearch == null) {
      selectorSearch = Search();
      box.put(SelectorSearchKey, selectorSearch);
    }
    selectorSearchSubject.add(selectorSearch!);
  }

  void loadNetworkSearch() {
    // Get the box
    var box = Hive.box(Selector.BoxName);
    networkSearch = box.get(NetworkSearchKey) as Search?;
    if (networkSearch == null) {
      networkSearch = Search();
      box.put(NetworkSearchKey, networkSearch);
    }
    networkSearchSubject.add(networkSearch!);
  }

  void filter(Search search) {}
}
