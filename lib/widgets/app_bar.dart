import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:selector/data/parameters.dart';
import 'package:selector/data/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/widgets/empty_selector.dart';
import 'package:selector/widgets/record_grid.dart';
import 'package:selector/widgets/search_history.dart';

class SelectorAppBar extends StatefulWidget {
  final Parameters parameters;
  const SelectorAppBar({
    Key? key,
    required this.parameters,
  }) : super(key: key);

  @override
  State<SelectorAppBar> createState() => _SelectorAppBarState();
}

class _SelectorAppBarState extends State<SelectorAppBar> {
  final FloatingSearchBarController searchBarController =
      FloatingSearchBarController();
  final selector = GetIt.I.get<Selector>();
  List<String> filteredSearchHistory = [];

  @override
  void initState() {
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
      searchBarController.query = term;
      search?.addHistory(term);
      filteredSearchHistory = search?.getFilteredHistory(term) ?? [];
      selector.filter(term);
      searchBarController.close();
    });
  }

  void _handleDelete(Search? search, String term) {
    setState(() {
      searchBarController.query = term;
      search?.deleteHistory(term);
      filteredSearchHistory = search?.getFilteredHistory(term) ?? [];
      selector.filter(term);
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
                if (searchBarController.query.isNotEmpty) {
                  return Center(
                      child: Text(
                    locale.filterEmptyResult,
                    style: Theme.of(context).textTheme.titleLarge,
                  ));
                }
                return const EmptySelector();
              }
              return FloatingSearchBarScrollNotifier(
                child: RecordGrid(
                  records: records,
                  parameters: widget.parameters,
                ),
              );
            },
          ),
          automaticallyImplyBackButton: true,
          automaticallyImplyDrawerHamburger: true,
          controller: searchBarController,
          physics: const BouncingScrollPhysics(),
          clearQueryOnClose: false,
          transition: CircularFloatingSearchBarTransition(),
          title: Text(
            searchBarController.query.isEmpty
                ? locale.searchTitle
                : searchBarController.query,
            style: themeData.inputDecorationTheme.hintStyle,
          ),
          iconColor: themeData.primaryColor,
          hint: locale.searchHint,
          hintStyle: themeData.inputDecorationTheme.hintStyle,
          actions: [
            FloatingSearchBarAction.searchToClear(
              color: themeData.primaryTextTheme.labelSmall?.color,
            ),
            const SizedBox(
              width: 4,
              height: 4,
            ),
          ],
          onQueryChanged: (query) => _handleSearch(search, query),
          // onQueryChanged: (query) {
          //   setState(() {
          //     filteredSearchHistory = search?.getFilteredHistory(query) ?? [];
          //     selector.filter(query);
          //   });
          // },
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
