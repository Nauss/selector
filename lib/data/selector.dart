import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';
import 'package:fuzzy/fuzzy.dart';

class Selector {
  static const String boxName = 'selector';
  static const selectorSearchKey = 'selectorSearch';
  static const networkSearchKey = 'networkSearch';

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
    var box = Hive.box(Record.boxName);
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
    var box = Hive.box(Record.boxName);
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
    var box = Hive.box(Record.boxName);
    box.put(record.position, record);
    records.add(record);
    recordsSubject.add(records);
  }

  void filter(String query) {
    if (selectorSearch == null || records.length < 2 || query.isEmpty) {
      recordsSubject.add(records);
      return;
    }
    // First filter
    final fuse = Fuzzy(
      records,
      options: FuzzyOptions<Record>(
        keys: [
          WeightedKey(
            name: 'artist',
            getter: (Record record) => record.info.artist,
            weight: 5,
          )
        ],
      ),
    );
    final result = fuse.search(query).map((e) => e.item).toList();

    // result.map((r) => r.info.artist).forEach(print);
    recordsSubject.add(result);
    // Then order
  }

  // Search functions
  ValueStream<Search> get selectorSearchStream => selectorSearchSubject.stream;
  ValueStream<Search> get networkSearchStream => networkSearchSubject.stream;
  void loadSelectorSearch() {
    // Get the box
    var box = Hive.box(Selector.boxName);
    selectorSearch = box.get(selectorSearchKey) as Search?;
    if (selectorSearch == null) {
      selectorSearch = Search();
      box.put(selectorSearchKey, selectorSearch);
    }
    selectorSearchSubject.add(selectorSearch!);
  }

  void loadNetworkSearch() {
    // Get the box
    var box = Hive.box(Selector.boxName);
    networkSearch = box.get(networkSearchKey) as Search?;
    if (networkSearch == null) {
      networkSearch = Search();
      box.put(networkSearchKey, networkSearch);
    }
    networkSearchSubject.add(networkSearch!);
  }
}
