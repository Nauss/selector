import 'package:hive/hive.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/hive_ids.dart';

part 'search.g.dart';

@HiveType(typeId: hiveSearchId)
class Search extends HiveObject {
  static const DisplayedHistoryLength = 5;
  static const StoredHistoryLength = 30;

  @HiveField(0)
  late List<String> history;
  @HiveField(1)
  late SortType sortType;

  Search() {
    history = [];
    sortType = SortType.artist;
  }

  List<String> getFilteredHistory(String? filter) {
    List<String> list;
    if (filter != null && filter.isNotEmpty) {
      list = history.reversed
          .where(
            (term) => term.startsWith(filter),
          )
          .toList();
    } else {
      list = history.reversed.toList();
    }
    return list.take(DisplayedHistoryLength).toList();
  }

  void addHistory(String term) {
    if (history.contains(term)) {
      history.removeWhere((t) => t == term);
      history.add(term);
    } else {
      history.add(term);
      if (history.length > StoredHistoryLength) {
        history.removeRange(0, history.length - StoredHistoryLength);
      }
    }
    save();
  }

  void deleteHistory(String term) {
    history.removeWhere((t) => t == term);
    save();
  }

  SortType get sort {
    return sortType;
  }

  set setSortType(SortType type) {
    sortType = type;
    save();
  }
}
