import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';

const customServiceUUID = '0000FFE0-0000-1000-8000-00805F9B34FB';
const customCharacteristicUUID = '0000FFE1-0000-1000-8000-00805F9B34FB';

class Bluetooth {
  BlueToothState _state = BlueToothState.disconnected;
  late BehaviorSubject<BlueToothState> connectionSubject;

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<BluetoothDeviceState>? _stateSubscription;
  StreamSubscription<ScanResult>? _scanSubscription;
  BluetoothDevice? _device;
  BluetoothCharacteristic? _uart;

  Bluetooth() {
    connectionSubject = BehaviorSubject<BlueToothState>.seeded(_state);
  }

  // Connection functions
  ValueStream<BlueToothState> get connectionStream => connectionSubject.stream;
  Future<void> connect() async {
    _state = BlueToothState.disconnected;
    connectionSubject.add(_state);

    if (!(await checkPermissions())) {
      return;
    }

    if (_scanSubscription != null) {
      _scanSubscription!.cancel();
    }
    await _flutterBlue.stopScan();

    // Check for existing connection
    final connected = await _flutterBlue.connectedDevices;
    if (connected.isNotEmpty) {
      // Already connected, look for the correct device
      final selectorIndex = connected.indexWhere(
        (element) => element.name.startsWith('Selector'),
      );
      if (selectorIndex != -1) {
        // Selector found, connect to it
        BluetoothDevice selectorDevice = connected[selectorIndex];
        _state = BlueToothState.connecting;
        connectionSubject.add(_state);
        await _deviceConnected(selectorDevice);
        _state = BlueToothState.connected;
        connectionSubject.add(_state);
        return;
      }
    }
    _scanSubscription = _flutterBlue.scan().listen(_scanResults);
  }

  Future<void> offline() async {
    await _flutterBlue.stopScan();
    _state = BlueToothState.offline;
    connectionSubject.add(_state);
  }

  get isOffline => _state == BlueToothState.offline;

  Future<void> _scanResults(ScanResult result) async {
    if (_state == BlueToothState.connecting) return;
    if (result.device.name.startsWith('Selector')) {
      _state = BlueToothState.connecting;
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

      _state = BlueToothState.connected;
      connectionSubject.add(_state);

      // Stop scanning
      await _flutterBlue.stopScan();
    }
  }

  Future<bool> _connectToDevice(BluetoothDevice device, int timeout) async {
    Future<bool> returnValue = Future.value(true);
    try {
      await device.connect().timeout(Duration(seconds: timeout),
          onTimeout: () async {
        returnValue = Future.value(false);
        await device.disconnect();
      });
    } catch (e) {
      await device.disconnect();
      returnValue = Future.value(false);
    }

    return returnValue;
  }

  Future<void> _deviceConnected(BluetoothDevice device) async {
    _device = device;
    await _getCharacteristic();
    if (_stateSubscription == null) {
      _stateSubscription = _device!.state.listen(_stateListener);
    } else {
      _stateSubscription!.resume();
    }
  }

  Future<void> _getCharacteristic() async {
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
      _state = BlueToothState.offline;
      connectionSubject.add(_state);
    }
  }

  Future<bool> checkConnection() async {
    final permissionsOk = await checkPermissions();
    return permissionsOk && _state == BlueToothState.connected;
  }

  Future<bool> checkPermissions() async {
    // Check the phone's location
    if (!await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      connectionSubject.add(BlueToothState.noLocation);
      return false;
    }
    // Check the phone's bluetooth
    var isAvailable = await _flutterBlue.isAvailable;
    if (!isAvailable) {
      connectionSubject.add(BlueToothState.noBluetooth);
      return false;
    }
    var isOn = await _flutterBlue.isOn;
    if (!isOn) {
      // Try once more after some time (to allow auto-enable)
      await Future.delayed(const Duration(seconds: 2));
      isOn = await _flutterBlue.isOn;
      if (!isOn) {
        connectionSubject.add(BlueToothState.bluetoothIsOff);
        return false;
      }
    }
    return true;
  }

  // Actions
  Future<bool> open(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.open(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> close(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.close(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> userTake() async {
    if (!await checkConnection()) {
      return false;
    }

    await sendMessage("");
    return true;
  }

  Future<bool> closeEmpty(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.closeEmpty(position);

    await sendMessage(message);
    return true;
  }

  Future<void> sendMessage(String message) async {
    if (message.isNotEmpty) {
      await _uart!.write(utf8.encode(message));
      await _uart!.read();
      if (!_uart!.isNotifying) {
        await _uart!.setNotifyValue(true);
        await _uart!.read();
      }
    }

    await _uart!.value.firstWhere((value) {
      final received = utf8.decode(value, allowMalformed: true);
      return received.startsWith(Arduino.take) ||
          received.startsWith(Arduino.done);
    });
  }

  Future<void> reset() async {
    _stateSubscription?.pause();
    _device = null;
    _uart = null;
  }
}
