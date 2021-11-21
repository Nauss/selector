import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';
import 'package:string_similarity/string_similarity.dart';

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
    ensureRecordPosition(record);
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
    final lowerQuery = query.toLowerCase();
    // First filter
    final filtered = records.where((record) {
      final lowerArtists = record.info.artist.toLowerCase().split(" ");
      final lowerTitles = record.info.title.toLowerCase().split(" ");
      // Check the start of each word
      var index = lowerArtists.indexWhere(
        (element) => element.contains(lowerQuery),
      );
      if (index != -1) {
        return true;
      }
      index = lowerTitles.indexWhere(
        (element) => element.contains(lowerQuery),
      );
      if (index != -1) {
        return true;
      }
      // Check similarity
      var bestMatch = lowerQuery.bestMatch(lowerArtists);
      var match = bestMatch.ratings.indexWhere(
        (element) => element.rating! > similarityThreshold,
      );
      if (match != -1) {
        return true;
      }
      bestMatch = lowerQuery.bestMatch(lowerTitles);
      match = bestMatch.ratings.indexWhere(
        (element) => element.rating! > similarityThreshold,
      );
      if (match != -1) {
        return true;
      }
      return false;
    });
    recordsSubject.add(filtered.toList());

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

  void ensureRecordPosition(Record record) {
    if (record.position == -1) {
      if (records.isEmpty) {
        record.position = 1;
      } else {
        record.position = records.last.position + 1;
      }
    }
  }
}
