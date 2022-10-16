import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/search_screen.dart';
import 'package:selector/widgets/app_bar.dart';
import 'package:selector/widgets/selector_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: const SelectorAppBar(),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ClipRect(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor,
                    image: const DecorationImage(
                      image: AssetImage("assets/missing.png"),
                      fit: BoxFit.none,
                      alignment: Alignment(2.2, 1.5),
                      scale: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackButton(),
                      Text(
                        "Selector",
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: SVGs.listening(),
                title: Text(locale.listening),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: SVGs.mySelector(),
                title: Text(locale.mySelector),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: SVGs.remove(),
                title: Text(locale.removed),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              // divider
              const Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                title: Text(locale.addMultiple),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text(locale.removeAll),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
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
