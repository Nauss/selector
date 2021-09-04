import 'package:rxdart/rxdart.dart';
import 'package:selector/data/debug.dart';
import 'package:selector/data/enums.dart';

class Bluetooth {
  BlueToothState state = BlueToothState.disconnected;
  late BehaviorSubject<BlueToothState> connectionSubject;

  Bluetooth() {
    connectionSubject = BehaviorSubject<BlueToothState>.seeded(state);
  }

  // Connection functions
  ValueStream<BlueToothState> get connectionStream => connectionSubject.stream;
  void connect() {
    fakeBluetooth().then((value) {
      state = BlueToothState.connected;
      connectionSubject.add(state);
    });
  }
}
