import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/search_screen.dart';
import 'package:selector/screens/settings_sreen.dart';
import 'package:selector/widgets/empty_selector.dart';
import 'package:selector/widgets/record_grid.dart';
import 'package:selector/widgets/search_history.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final FloatingSearchBarController searchBarController =
      FloatingSearchBarController();
  final selector = GetIt.I.get<Selector>();
  List<String> filteredSearchHistory = [];
  String selectedTerm = "";

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
    selector.filter(term);
    searchBarController.close();
  }

  void _handleClear() {
    if (searchBarController.isClosed) {
      selector.filter("");
      setState(() {
        selectedTerm = "";
      });
    }
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
              body: StreamBuilder<RecordList>(
                stream: selector.recordsStream,
                builder: (context, snapshot) {
                  RecordList? records = snapshot.data;
                  if (records == null || records.isEmpty) {
                    return const EmptySelector();
                  }
                  return RecordGrid(
                    records: records,
                    isFiltered: selectedTerm.isNotEmpty,
                  );
                },
              ),
              controller: searchBarController,
              physics: const BouncingScrollPhysics(),
              clearQueryOnClose: false,
              transition: CircularFloatingSearchBarTransition(),
              title: Text(
                selectedTerm.isEmpty ? locale.searchTitle : selectedTerm,
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
                          return const SettingsScreen();
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
                _SearchIconButton(
                  isEmpty:
                      searchBarController.query.isEmpty && selectedTerm.isEmpty,
                  onClear: _handleClear,
                ),
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
                  return const SearchScreen();
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

class _SearchIconButton extends StatelessWidget {
  final bool isEmpty;
  final Function onClear;
  const _SearchIconButton({
    Key? key,
    required this.isEmpty,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FloatingSearchAppBarState bar = FloatingSearchAppBar.of(context)!;
    return FloatingSearchBarAction(
      showIfOpened: true,
      showIfClosed: true,
      builder: (context, animation) {
        return ValueListenableBuilder<String>(
          valueListenable: bar.queryNotifer,
          builder: (context, query, _) {
            return SearchToClear(
              isEmpty: isEmpty,
              // size: size,
              // color: color ?? bar.style.iconColor,
              // duration: duration * 0.5,
              onTap: () {
                if (!isEmpty) {
                  bar.clear();
                  onClear();
                } else {
                  bar.isOpen =
                      !bar.isOpen || (!bar.hasFocus && bar.isAlwaysOpened);
                }
              },
            );
          },
        );
      },
    );
  }
}
