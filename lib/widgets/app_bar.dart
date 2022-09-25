import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/settings_sreen.dart';
import 'package:selector/widgets/empty_selector.dart';
import 'package:selector/widgets/record_grid.dart';
import 'package:selector/widgets/search_history.dart';

class SelectorAppBar extends StatefulWidget {
  const SelectorAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectorAppBar> createState() => _SelectorAppBarState();
}

class _SelectorAppBarState extends State<SelectorAppBar> {
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

  void _handleDelete(Search? search, String term) {
    setState(() {
      search?.deleteHistory(term);
      filteredSearchHistory =
          search?.getFilteredHistory(searchBarController.query) ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    return StreamBuilder<Search>(
      stream: selector.selectorSearchStream,
      builder: (context, snapshot) {
        var search = snapshot.data;
        return FloatingSearchBar(
          body: StreamBuilder<RecordList>(
            stream: selector.recordsStream,
            builder: (context, snapshot) {
              RecordList? records = snapshot.data;
              if (records == null || records.isEmpty) {
                if (selectedTerm.isNotEmpty) {
                  return Center(
                      child: Text(
                    locale.filterEmptyResult,
                    style: Theme.of(context).textTheme.headline6,
                  ));
                }
                return const EmptySelector();
              }
              return FloatingSearchBarScrollNotifier(
                  child: RecordGrid(
                records: records,
                isFiltered: selectedTerm.isNotEmpty,
              ));
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
          actions: [
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
            ),
            const SizedBox(
              width: 4,
              height: 4,
            ),
            FloatingSearchBarAction(
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
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
                  Icons.menu,
                ),
              ),
            ),
          ],
          onQueryChanged: (query) {
            setState(() {
              filteredSearchHistory = search?.getFilteredHistory(query) ?? [];
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
    );
  }
}
