import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/parameters.dart';
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
  Parameters parameters = Parameters();
  bool _addNextRemoved = false;

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
    for (var key in box.keys) {
      var record = box.get(key) as Record?;
      if (record != null) {
        records.add(record);
      }
    }
    recordsSubject.add(records);
  }

  void remove(Record record, bool permanently) {
    if (permanently) {
      // Get the box
      var box = Hive.box(Record.boxName);
      box.delete(record.info.id);
      records.remove(record);
    } else {
      record.status = RecordStatus.removed;
      // Reset the position since we want to put it back to the closest possible position
      record.position = -1;
      record.save();
    }
    recordsSubject.add(records);
  }

  void listen(Record record) {
    record.status = RecordStatus.outside;
    // Reset the position since we want to put it back to the closest possible position
    record.position = -1;
    record.save();
    recordsSubject.add(records);
  }

  void store(Record record) {
    record.status = RecordStatus.inside;
    record.save();
    recordsSubject.add(records);
  }

  Future<void> add(Record record) async {
    if (_addNextRemoved) {
      _addNextRemoved = false;
      record.status = RecordStatus.removed;
    } else {
      record.status = RecordStatus.inside;
    }
    // Get the box
    var box = Hive.box(Record.boxName);
    await box.put(record.info.id, record);
    records.add(record);
    recordsSubject.add(records);
  }

  bool get addNextRemoved => _addNextRemoved = true;
  void setAddNextRemoved() => _addNextRemoved = true;

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

  Record? find(int id) {
    final index = records.indexWhere(
      (element) => element.info.id == id,
    );
    if (index >= 0) {
      return records[index];
    }
    return null;
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

  void toggleSortType(SortType type) {
    selectorSearch!.toggleSortType(type);
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
        // Find the first available position
        List<int> freeSpots = [for (var i = 1; i <= selectorCapacity; i++) i];
        for (final element in records) {
          freeSpots.remove(element.position);
          if (element.isDouble) {
            // Add one to the position if it's a double
            // Since the next position is already taken
            freeSpots.remove(element.position + 1);
          }
        }
        if (freeSpots.isEmpty) {
          // @Todo better handling of full Selector
          throw Exception("No free spots");
        }
        var position = freeSpots[0];
        if (record.isDouble) {
          var nextPosition = 1;
          while (freeSpots[nextPosition] - position != 1 || position.isEven) {
            position = freeSpots[nextPosition];
            nextPosition++;
          }
        }
        if (position > selectorCapacity) {
          // @Todo better handling of full Selector
          throw Exception("No free spots");
        }
        record.position = position;
      }
    }
  }

  int get selectorCount =>
      records.where((record) => record.status == RecordStatus.inside).length;
  int get listeningCount =>
      records.where((record) => record.status == RecordStatus.outside).length;
  int get removedCount =>
      records.where((record) => record.status == RecordStatus.removed).length;
}
