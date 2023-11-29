import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/actions/selector_action.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/selector.dart';

class Processor {
  final selector = GetIt.I.get<Selector>();
  static const String boxName = 'processor';
  Record? _record; // The record being processed
  List<SelectorAction>? currentActions;
  Scenario? scenario;
  int step = -1;
  late BehaviorSubject<int> stepSubject;
  bool hydrating = false;
  late BehaviorSubject<bool> hydratingSubject;

  Processor() {
    stepSubject = BehaviorSubject<int>.seeded(step);
    hydratingSubject = BehaviorSubject<bool>.seeded(hydrating);
  }

  ValueStream<int> get stepStream => stepSubject.stream;
  ValueStream<bool> get hydratingStream => hydratingSubject.stream;

  SelectorAction? get currentAction =>
      step != -1 && currentActions != null ? currentActions![step] : null;

  void start(Scenario scenario, Record record) {
    _record = record;
    this.scenario = scenario;
    currentActions = scenarii[scenario];
    step = 0;
    stepSubject.add(step);
    execute(currentActions![step]);
  }

  void execute(SelectorAction action) {
    action.execute(_record!).then((executeResult) => done(executeResult));
  }

  void done(bool executeResult) async {
    if (!executeResult) {
      await save();
      currentActions = null;
      step = -1;
      stepSubject.add(step);
      return;
    }
    step += 1;
    stepSubject.add(step);
    if (currentActions != null && step < currentActions!.length) {
      execute(currentActions![step]);
    } else {
      currentActions = null;
      step = -1;
      stepSubject.add(step);

      stopHydrating();
    }
  }

  Future<void> save() async {
    var box = await Hive.openBox(boxName);
    if (step != -1 && scenario != null && record != null) {
      await box.put('step', step);
      await box.put('scenario', scenario!.index);
      await box.put('record', _record!.info.id);
    }
  }

  Future<void> hydrate() async {
    final box = await Hive.openBox(boxName);
    step = box.get('step', defaultValue: -1);
    if (step != -1) {
      scenario = Scenario.values[box.get('scenario') as int];
      hydrating = true;
      int recordId = box.get('record') as int;
      _record = selector.find(recordId);
      currentActions = scenarii[scenario!];
      stepSubject.add(step);
      execute(currentActions![step]);
      hydratingSubject.add(hydrating);
    }
  }

  // Utility functions
  int get currentStep => step;
  Record? get record => _record;
  void stopHydrating() {
    if (hydrating) {
      hydrating = false;
      // Clear the box
      var box = Hive.box(boxName);
      box.clear();
    }
  }
}
