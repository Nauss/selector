import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:selector/data/actions/action.dart';
import 'package:selector/data/actions/add_action.dart';
import 'package:selector/data/actions/close_action.dart';
import 'package:selector/data/actions/listen_action.dart';
import 'package:selector/data/actions/open_action.dart';
import 'package:selector/data/actions/remove_action.dart';
import 'package:selector/data/actions/store_action.dart';
import 'package:selector/data/actions/user_insert_action.dart';
import 'package:selector/data/actions/user_take_action.dart';

import 'enums.dart';

const selectorCapacity = 120;

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

final Map<Scenario, List<Action>> scenarii = {
  Scenario.add: [OpenAction(), UserInsertAction(), CloseAction(), AddAction()],
  Scenario.store: [
    OpenAction(),
    UserInsertAction(),
    CloseAction(),
    StoreAction()
  ],
  Scenario.listen: [
    OpenAction(),
    UserTakeAction(),
    CloseAction(),
    ListenAction()
  ],
  Scenario.remove: [
    OpenAction(),
    UserTakeAction(),
    CloseAction(),
    RemoveAction()
  ],
};
