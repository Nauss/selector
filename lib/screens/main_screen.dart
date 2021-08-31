import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';
import 'package:selector/screens/search_screen.dart';
import 'package:selector/screens/settings_sreen.dart';
import 'package:selector/widgets/record_grid.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FloatingSearchBarController searchBarController =
      FloatingSearchBarController();
  late final Search search;
  List<String> filteredSearchHistory = [];
  String? selectedTerm;
  RecordList? records;

  @override
  void initState() {
    Search.load().then((value) {
      setState(() {
        search = value;
        filteredSearchHistory = search.getFilteredHistory(null);
      });
    });
    Record.load().then((value) {
      setState(() {
        records = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    final fsb = FloatingSearchBar.of(context);
    return SafeArea(
      child: Scaffold(
        body: FloatingSearchBar(
          automaticallyImplyBackButton: false,
          body: FloatingSearchBarScrollNotifier(
            child: Padding(
              padding: EdgeInsets.only(
                top: fsb != null
                    ? fsb.style.height + fsb.style.margins.vertical
                    : 50,
              ),
              child: RecordGrid(records: records),
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
          actions: [
            FloatingSearchBarAction.searchToClear(),
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
            )
          ],
          onQueryChanged: (query) {
            setState(() {
              filteredSearchHistory = search.getFilteredHistory(query);
            });
          },
          onSubmitted: (query) {
            setState(() {
              search.addHistory(query);
              selectedTerm = query;
            });
            searchBarController.close();
          },
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Card(
                child: Builder(
                  builder: (context) {
                    if (filteredSearchHistory.isEmpty &&
                        searchBarController.query.isEmpty) {
                      return Container();
                    } else if (filteredSearchHistory.isEmpty) {
                      return ListTile(
                        title: Text(searchBarController.query),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          setState(() {
                            selectedTerm = searchBarController.query;
                            search.addHistory(selectedTerm!);
                          });
                          searchBarController.close();
                        },
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filteredSearchHistory
                            .map(
                              (term) => ListTile(
                                title: Text(
                                  term,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: const Icon(Icons.history),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      search.deleteHistory(term);
                                      filteredSearchHistory =
                                          search.getFilteredHistory(
                                              searchBarController.query);
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    // putSearchTermFirst(term);
                                    selectedTerm = term;
                                  });
                                  searchBarController.close();
                                },
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            showSearch(context: context, delegate: SearchScreen(context));
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
