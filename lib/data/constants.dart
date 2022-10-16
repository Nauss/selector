import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:selector/data/actions/add_action.dart';
import 'package:selector/data/actions/ajout_vinyle.dart';
import 'package:selector/data/actions/ferme_meuble.dart';
import 'package:selector/data/actions/rentre_vinyle.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/actions/listen_action.dart';
import 'package:selector/data/actions/remove_action.dart';
import 'package:selector/data/actions/sortie_vinyle.dart';
import 'package:selector/data/actions/store_action.dart';

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
  Scenario.listen: [SortieVinyle(), FermeMeuble(), ListenAction()],
  Scenario.remove: [SortieVinyle(), FermeMeuble(), RemoveAction()],
  Scenario.store: [
    SortieVinyle(),
    RentreVinyle(),
    FermeMeuble(),
    StoreAction()
  ],
  Scenario.add: [SortieVinyle(), AjoutVinyle()],
  Scenario.addMore: [AjoutVinyle(), RentreVinyle(), AddAction()],
  Scenario.removeAlreadyOut: [RemoveAction()],
  Scenario.removePermanently: [RemoveAction(permanently: true)],
  Scenario.close: [FermeMeuble()],
};

// Hero tags
class Tags {
  static cover(String id) => "cover$id";
}

const iconSize = 15.0;
const primaryColor = Color(0xFF3399FF);

// SVGs
class SVGs {
  static const double defaultSize = 24;
  static String listeningPath = 'assets/svgs/icône en écoute.svg';
  static String mySelectorPath = 'assets/svgs/icône mon selector.svg';
  static String storePath = 'assets/svgs/icone Ranger vinyle.svg';
  static String listenPath = 'assets/svgs/icone Sortir vinyle.svg';
  static String removePath = 'assets/svgs/icone Supprimer vinyle.svg';
  static String multiplePath = 'assets/svgs/icone multi vinyle.svg';

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

  static SvgPicture multiple({
    Color? color,
    double width = defaultSize,
    double height = defaultSize,
  }) =>
      SvgPicture.asset(
        multiplePath,
        color: color,
        width: width,
        height: height,
      );
}

// Arduino
class Arduino {
  static const done = 'ETAPE_FIN';
  static init() => 'INIT';
  static info() => 'INFO';
  static sortieVinyle(int position) => 'SV$position';
  static rentreVinyl() => 'RV';
  static ajoutVinyle(int position) => 'AV$position';
  static fermeMeuble(int position) => 'FM$position';
}
