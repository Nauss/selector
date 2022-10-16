import 'package:hive/hive.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/hive_ids.dart';

part 'search.g.dart';

@HiveType(typeId: hiveSearchId)
class Search extends HiveObject {
  static const displayedHistoryLength = 5;
  static const storedHistoryLength = 30;

  @HiveField(0)
  List<String> history = [];
  @HiveField(1)
  List<SortType> sortTypes = [SortType.listening, SortType.mySelector];

  Search();

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
    return list.take(displayedHistoryLength).toList();
  }

  void addHistory(String term) {
    if (term.isEmpty) {
      return;
    }
    if (history.contains(term)) {
      history.removeWhere((t) => t == term);
      history.add(term);
    } else {
      history.add(term);
      if (history.length > storedHistoryLength) {
        history.removeRange(0, history.length - storedHistoryLength);
      }
    }
    save();
  }

  void deleteHistory(String term) {
    history.removeWhere((t) => t == term);
    save();
  }

  void toggleSortType(SortType type) {
    if (sortTypes.contains(type)) {
      sortTypes.remove(type);
    } else {
      sortTypes.add(type);
    }
    save();
  }
}
