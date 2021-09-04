import 'package:rxdart/rxdart.dart';
import 'package:selector/data/actions/action.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';

class Processor {
  Record? _record; // The record being processed
  List<Action>? currentActions;
  int step = -1;
  late BehaviorSubject<int> stepSubject;

  Processor() {
    stepSubject = BehaviorSubject<int>.seeded(step);
  }

  ValueStream<int> get stepStream => stepSubject.stream;

  Action? get currentAction =>
      step != -1 && currentActions != null ? currentActions![step] : null;

  void start(Scenario scenario, Record record) {
    _record = record;
    currentActions = scenarii[scenario];
    step = 0;
    stepSubject.add(step);
    execute(currentActions![step]);
  }

  void execute(Action action) {
    action.execute(_record!).then((_) => done());
  }

  void done() {
    step += 1;
    stepSubject.add(step);
    if (currentActions != null && step < currentActions!.length) {
      execute(currentActions![step]);
    } else {
      currentActions = null;
      step = -1;
      stepSubject.add(step);
    }
  }

  // Utility functions
}
