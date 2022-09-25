import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/screens/search_screen.dart';
import 'package:selector/widgets/app_bar.dart';

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
    final themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: const SelectorAppBar(),
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
