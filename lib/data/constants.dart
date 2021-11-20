import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:selector/data/actions/close_empty_action.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/actions/add_action.dart';
import 'package:selector/data/actions/close_action.dart';
import 'package:selector/data/actions/listen_action.dart';
import 'package:selector/data/actions/open_action.dart';
import 'package:selector/data/actions/remove_action.dart';
import 'package:selector/data/actions/store_action.dart';
import 'package:selector/data/actions/user_take_action.dart';

import 'enums.dart';

const selectorCapacity = 120;
const similarityThreshold = 0.5;

class Globals {
  static Directory? images;
  static Future<void> init() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    images = Directory(p.join(documentsDir.path, "images"));
    if (!await images!.exists()) {
      await images!.create();
    }
  }
}

final Map<Scenario, List<SelectorAction>> scenarii = {
  Scenario.add: [OpenAction(), CloseAction(), AddAction()],
  Scenario.store: [OpenAction(), CloseAction(), StoreAction()],
  Scenario.listen: [
    OpenAction(),
    UserTakeAction(),
    CloseEmptyAction(),
    ListenAction()
  ],
  Scenario.remove: [
    OpenAction(),
    UserTakeAction(),
    CloseEmptyAction(),
    RemoveAction()
  ],
};

// Hero tags
class Tags {
  static cover(String id) => "cover$id";
}

// SVGs
class SVGs {
  static const double defaultSize = 24;
  static String listeningPath = 'assets/svgs/icône en écoute.svg';
  static String mySelectorPath = 'assets/svgs/icône mon selector.svg';
  static String storePath = 'assets/svgs/icone Ranger vinyle.svg';
  static String listenPath = 'assets/svgs/icone Sortir vinyle.svg';
  static String removePath = 'assets/svgs/icone Supprimer vinyle.svg';

  static SvgPicture listening({
    Color? color,
    double width = defaultSize,
    double height = defaultSize,
  }) =>
      SvgPicture.asset(
        listeningPath,
        color: color,
        width: width,
        height: height,
      );

  static SvgPicture mySelector({
    Color? color,
    double width = defaultSize,
    double height = defaultSize,
  }) =>
      SvgPicture.asset(
        mySelectorPath,
        color: color,
        width: width,
        height: height,
      );

  static SvgPicture store({
    Color? color,
    double width = defaultSize,
    double height = defaultSize,
  }) =>
      SvgPicture.asset(
        storePath,
        color: color,
        width: width,
        height: height,
      );

  static SvgPicture listen({
    Color? color,
    double width = defaultSize,
    double height = defaultSize,
  }) =>
      SvgPicture.asset(
        listenPath,
        color: color,
        width: width,
        height: height,
      );

  static SvgPicture remove({
    Color? color,
    double width = defaultSize,
    double height = defaultSize,
  }) =>
      SvgPicture.asset(
        removePath,
        color: color,
        width: width,
        height: height,
      );
}

// Arduino
class Arduino {
  static const done = 'ETAPE_FIN\r\n';
  static const take = 'PRENDRE_VINYL\r\n';
  static open(int position) => 'S$position';
  static close(int position) => 'R$position';
  static closeEmpty(int position) => 'A$position';
}
