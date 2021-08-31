import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:selector/data/discogs.dart';
import 'package:selector/data/record.dart';
import 'package:selector/widgets/empty_search.dart';
import 'package:selector/widgets/record_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends SearchDelegate<String> {
  SearchScreen(BuildContext context)
      : super(searchFieldLabel: AppLocalizations.of(context)!.searchDiscogs);

  void handleScanPressed(
    BuildContext context,
  ) async {
    final themeData = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    String scanResult = "";
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        themeData.primaryColor.toString(),
        locale.cancel,
        true,
        ScanMode.BARCODE,
      );
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(locale.barcodeScanFailed),
      ));
    }
    if (scanResult != '-1') {
      query = scanResult;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: ImageIcon(
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
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: () {
            query = "";
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // if (query.isNotEmpty) {
    //   return FutureBuilder(
    //     future: Discogs.getRecords(query),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return EmptySearch();
    //       }
    //       return RecordGrid(records: snapshot.data as RecordList);
    //     },
    //   );
    // }

    return EmptySearch();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: Discogs.getRecords(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return EmptySearch();
        }
        return RecordGrid(records: snapshot.data as RecordList);
      },
    );
  }
}
