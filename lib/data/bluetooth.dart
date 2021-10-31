import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';

const customServiceUUID = '0000FFE0-0000-1000-8000-00805F9B34FB';
const customCharacteristicUUID = '0000FFE1-0000-1000-8000-00805F9B34FB';

class Bluetooth {
  BlueToothState state = BlueToothState.disconnected;
  late BehaviorSubject<BlueToothState> connectionSubject;

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<BluetoothDeviceState>? _stateSubscription;
  BluetoothDevice? _device;
  BluetoothCharacteristic? _uart;

  Bluetooth() {
    connectionSubject = BehaviorSubject<BlueToothState>.seeded(state);

    // Listen to scan results
    // _flutterBlue.scanResults.listen(_scanResults);
  }

  // Connection functions
  ValueStream<BlueToothState> get connectionStream => connectionSubject.stream;
  Future<void> connect() async {
    // Check the phone's bluetooth
    var isAvailable = await _flutterBlue.isAvailable;
    if (!isAvailable) {
      connectionSubject.add(BlueToothState.noBluetooth);
      return;
    }
    var isOn = await _flutterBlue.isOn;
    if (!isOn) {
      connectionSubject.add(BlueToothState.bluetoothIsOff);
      return;
    }

    // Check for existing connection
    final connected = await _flutterBlue.connectedDevices;
    if (connected.isNotEmpty) {
      // Already connected, nothing more todo
      state = BlueToothState.connecting;
      _deviceConnected(connected[0]);
      state = BlueToothState.connected;
      connectionSubject.add(state);
      return;
    }

    _flutterBlue
        .scan(timeout: const Duration(seconds: 10))
        .listen(_scanResults);
    // await _flutterBlue.startScan(timeout: const Duration(seconds: 10));
  }

  Future<void> _scanResults(ScanResult result) async {
    if (state == BlueToothState.connecting) return;
    if (result.device.name.startsWith('Selector')) {
      state = BlueToothState.connecting;
      var connected = await _connectToDevice(result.device, 5);
      int attempt = 0;
      while (!connected && attempt < 3) {
        connected = await _connectToDevice(result.device, 5);
        attempt += 1;
      }
      if (!connected) {
        return;
      }

      await _deviceConnected(result.device);

      state = BlueToothState.connected;
      connectionSubject.add(state);

      // Stop scanning
      await _flutterBlue.stopScan();
    }
  }

  Future<bool> _connectToDevice(BluetoothDevice device, int timeout) async {
    Future<bool> returnValue = Future.value(true);
    try {
      await device.connect().timeout(Duration(seconds: timeout), onTimeout: () {
        returnValue = Future.value(false);
        device.disconnect();
      });
    } catch (e) {
      returnValue = Future.value(false);
    }

    return returnValue;
  }

  Future<void> _deviceConnected(BluetoothDevice device) async {
    _device = device;
    await getCharacteristic();
    if (_stateSubscription == null) {
      _stateSubscription = _device!.state.listen(_stateListener);
    } else {
      _stateSubscription!.resume();
    }
  }

  Future<void> getCharacteristic() async {
    List<BluetoothService> services = await _device!.discoverServices();
    for (var service in services) {
      if (service.uuid == Guid(customServiceUUID)) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid == Guid(customCharacteristicUUID)) {
            _uart = c;
            break;
          }
        }
      }
    }
  }

  void _stateListener(BluetoothDeviceState event) {
    if (event == BluetoothDeviceState.disconnected) {
      reset();
      state = BlueToothState.disconnected;
      connectionSubject.add(state);
    }
  }

  bool _checkConnection() {
    return state == BlueToothState.connected;
  }

  // Actions
  Future<bool> open(int position) async {
    if (!_checkConnection()) {
      return false;
    }

    final message = Arduino.open(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> close(int position) async {
    if (!_checkConnection()) {
      return false;
    }

    final message = Arduino.close(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> userInsert() async {
    if (!_checkConnection()) {
      return false;
    }

    final message = Arduino.userInsert();

    await sendMessage(message);
    return true;
  }

  Future<bool> userTake() async {
    if (!_checkConnection()) {
      return false;
    }

    final message = Arduino.userTake();

    await sendMessage(message);
    return true;
  }

  Future<void> sendMessage(String message) async {
    await _uart!.write(utf8.encode(message));
    await _uart!.read();
    if (!_uart!.isNotifying) {
      await _uart!.setNotifyValue(true);
      await _uart!.read();
    }

    await _uart!.value.firstWhere((value) {
      final received = utf8.decode(value, allowMalformed: true);
      return received == Arduino.done;
    });
  }

  Future<void> reset() async {
    _stateSubscription?.pause();
    _device = null;
    _uart = null;
  }
}
