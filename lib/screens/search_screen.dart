import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/data/utils.dart';
import 'package:selector/widgets/record_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/widgets/search_history.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final FloatingSearchBarController searchBarController =
      FloatingSearchBarController();
  final selector = GetIt.I.get<Selector>();
  final discogs = GetIt.I.get<Discogs>();
  List<String> filteredSearchHistory = [];

  @override
  void initState() {
    selector.loadNetworkSearch();

    filteredSearchHistory =
        selector.networkSearch?.getFilteredHistory(null) ?? [];
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  void handleScanPressed(
    BuildContext context,
  ) async {
    final themeData = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    String scanResult = "";
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        themeData.primaryColor.toHex(),
        locale.cancel,
        true,
        ScanMode.BARCODE,
      );
    } on Exception {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(locale.barcodeScanFailed),
      ));
    }
    if (scanResult != '-1') {
      setState(() {
        discogs.searchRecords(scanResult);
      });
    }
  }

  void _handleSearch(Search? search, String term) {
    discogs.searchRecords(term);
    search?.addHistory(term);
    searchBarController.query = term;
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
      child: PopScope(
        canPop: true,
        child: Scaffold(
          body: StreamBuilder<Search>(
              stream: selector.networkSearchStream,
              builder: (context, snapshot) {
                var search = snapshot.data;
                return FloatingSearchBar(
                  body: StreamBuilder<RecordList>(
                    stream: discogs.resultsStream,
                    builder: (context, snapshot) {
                      return RecordGrid(
                        records: snapshot.data,
                        parameters: selector.parameters,
                        statusFilter: const [RecordStatus.none],
                      );
                    },
                  ),
                  controller: searchBarController,
                  physics: const BouncingScrollPhysics(),
                  transition: CircularFloatingSearchBarTransition(),
                  // title: Text(
                  //   selectedTerm.isEmpty ? locale.searchDiscogs : selectedTerm,
                  //   style: themeData.inputDecorationTheme.hintStyle,
                  // ),
                  hint: locale.searchHint,
                  hintStyle: themeData.inputDecorationTheme.hintStyle,
                  iconColor: Colors.white,
                  actions: [
                    FloatingSearchBarAction.searchToClear(),
                    IconButton(
                      icon: const ImageIcon(
                        AssetImage(
                          'assets/barcode_scanner.png',
                        ),
                      ),
                      onPressed: () {
                        handleScanPressed(
                          context,
                        );
                      },
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
              }),
        ),
      ),
    );
  }
}
