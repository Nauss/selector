import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/search.dart';
import 'package:selector/data/selector.dart';

class SelectorFilter extends StatelessWidget {
  final selector = GetIt.I.get<Selector>();
  SelectorFilter({
    Key? key,
    required this.search,
    required this.sortType,
  }) : super(key: key);
  final Search? search;
  final SortType sortType;

  Widget getSortTypeIcon() {
    switch (sortType) {
      case SortType.listening:
        return Image.asset('assets/icons/icone en ecoute.png');
      case SortType.mySelector:
        return Image.asset('assets/icons/icone mon selector.png');
      case SortType.removed:
        return Image.asset('assets/icons/icone sortie du selector.png');
      default:
        return Image.asset('assets/icons/icone en ecoute.png');
    }
  }

  Widget getText(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    switch (sortType) {
      case SortType.listening:
        return Text(locale.listening);
      case SortType.mySelector:
        return Text(locale.mySelector);
      case SortType.removed:
        return Text(locale.removed);
      default:
        return Text(locale.listening);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SwitchListTile(
      secondary: getSortTypeIcon(),
      title: getText(context),
      value: search?.sortTypes.contains(sortType) ?? true,
      activeColor: themeData.primaryColor,
      onChanged: (value) {
        selector.toggleSortType(sortType);
      },
    );
  }
}
