import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/parameters.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/search_screen.dart';
import 'package:selector/widgets/app_bar.dart';
import 'package:selector/widgets/pointing_arrow.dart';
import 'package:selector/widgets/selector_filter.dart';
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
  late Parameters parameters;

  @override
  void initState() {
    selector.loadSelectorSearch();
    selector.loadRecords();
    parameters = selector.parameters;

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
        body: SelectorAppBar(
          parameters: parameters,
        ),
        drawer: Drawer(
          child: StreamBuilder<Search>(
              stream: selector.selectorSearchStream,
              initialData: selector.selectorSearch,
              builder: (context, snapshot) {
                final search = snapshot.data;
                return ListView(
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
                          children: const [
                            BackButton(),
                            Text(
                              "Selector",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.addOne),
                          if (selector.records.isEmpty)
                            const PointingArrow(angle: pi, size: 40),
                        ],
                      ),
                      leading: Image.asset(
                          'assets/icons/icone ajout nouveau vinyle.png'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SearchScreen();
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    SwitchListTile(
                      // secondary: getSortTypeIcon(),
                      title: Text(locale.largeThumbnails),
                      value: parameters.gridViewType == GridViewType.large,
                      activeColor: themeData.primaryColor,
                      onChanged: (value) {
                        if (value == true) {
                          selector.parameters.gridViewType = GridViewType.large;
                        } else {
                          selector.parameters.gridViewType =
                              GridViewType.normal;
                        }
                        setState(() => parameters.gridViewType =
                            selector.parameters.gridViewType);
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    SelectorFilter(search: search, sortType: SortType.removed),
                    // SelectorFilter(
                    //     search: search, sortType: SortType.listening),
                    // SelectorFilter(
                    //     search: search, sortType: SortType.mySelector),
                    // ListTile(
                    //   title: Text(locale.addMultiple),
                    //   leading: Image.asset(
                    //       'assets/icons/icone ajout plusieurs nouveaux vinyles.png'),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) {
                    //           return const SearchScreen(
                    //             multiple: true,
                    //           );
                    //         },
                    //       ),
                    //     );
                    //   },
                    // ),
                    // ListTile(
                    //   title: Text(locale.advanced),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) {
                    //           return const SettingsScreen();
                    //         },
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                );
              }),
        ),
        // floatingActionButton: FloatingActionButton(
        //   mini: true,
        //   backgroundColor: themeData.primaryColor,
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const SearchScreen();
        //         },
        //       ),
        //     );
        //   },
        //   child: const Icon(
        //     Icons.add,
        //   ),
        // ),
      ),
    );
  }
}
