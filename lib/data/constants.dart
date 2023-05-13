import 'dart:io';

import 'package:flutter/material.dart';
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
  Scenario.listen: [
    SortieVinyle(),
    RemoveAction(),
    RentreVinyle(),
    StoreAction(),
    FermeMeuble()
  ],
  Scenario.takeOut: [SortieVinyle(), FermeMeuble(), ListenAction()],
  Scenario.remove: [SortieVinyle(), FermeMeuble(), RemoveAction()],
  Scenario.store: [
    SortieVinyle(),
    RentreVinyle(),
    StoreAction(),
    FermeMeuble()
  ],
  Scenario.add: [SortieVinyle(), RentreVinyle(), FermeMeuble(), AddAction()],
  Scenario.addRemoved: [AddAction()],
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

// Arduino
class Arduino {
  static const done = 'ETAPE_FIN';
  static init() => 'INIT';
  static info() => 'INFO';
  static sortieVinyle(int position) => 'SV$position';
  static rentreVinyl() => 'RV';
  static ajoutVinyle(int position) => 'AV$position';
  static fermeMeuble(int position) => 'FM$position';
  static off() => 'OFF';
}
