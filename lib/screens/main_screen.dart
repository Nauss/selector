import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/search_screen.dart';
import 'package:selector/screens/settings_sreen.dart';
import 'package:selector/widgets/record_grid.dart';
import 'package:selector/widgets/search_history.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FloatingSearchBarController searchBarController =
      FloatingSearchBarController();
  final selector = GetIt.I.get<Selector>();
  List<String> filteredSearchHistory = [];
  String? selectedTerm;

  @override
  void initState() {
    selector.loadSelectorSearch();
    selector.loadRecords();

    filteredSearchHistory =
        selector.selectorSearch?.getFilteredHistory(null) ?? [];
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  void _handleSearch(Search? search, String term) {
    setState(() {
      search?.addHistory(term);
      selectedTerm = term;
      filteredSearchHistory =
          search?.getFilteredHistory(searchBarController.query) ?? [];
    });
    searchBarController.close();
  }

  void _handleDelete(Search? search, String term) {
    setState(() {
      search?.deleteHistory(term);
      filteredSearchHistory =
          search?.getFilteredHistory(searchBarController.query) ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<Search>(
          stream: selector.selectorSearchStream,
          builder: (context, snapshot) {
            var search = snapshot.data;
            return FloatingSearchBar(
              automaticallyImplyBackButton: false,
              body: FloatingSearchBarScrollNotifier(
                child: StreamBuilder<RecordList>(
                  stream: selector.recordsStream,
                  builder: (context, snapshot) {
                    RecordList? records = snapshot.data;
                    records = snapshot.data;
                    return RecordGrid(records: records);
                  },
                ),
              ),
              controller: searchBarController,
              transition: CircularFloatingSearchBarTransition(),
              title: Text(
                selectedTerm ?? locale.searchTitle,
                style: themeData.inputDecorationTheme.hintStyle,
              ),
              hint: locale.searchHint,
              hintStyle: themeData.inputDecorationTheme.hintStyle,
              leadingActions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SettingsScreen();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                  ),
                ),
              ],
              actions: [
                FloatingSearchBarAction.searchToClear(),
              ],
              onQueryChanged: (query) {
                setState(() {
                  filteredSearchHistory =
                      search?.getFilteredHistory(query) ?? [];
                });
              },
              onSubmitted: (query) => _handleSearch(search, query),
              builder: (context, transition) {
                return SearchHistory(
                  history: filteredSearchHistory,
                  onDelete: (term) => _handleDelete(search, term),
                  onSearch: (term) => _handleSearch(search, term),
                  query: searchBarController.query,
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: themeData.primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SearchScreen();
                },
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
