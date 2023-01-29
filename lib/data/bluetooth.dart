import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';

final customServiceUUID = Uuid.parse('0000FFE0-0000-1000-8000-00805F9B34FB');
final customCharacteristicUUID =
    Uuid.parse('0000FFE1-0000-1000-8000-00805F9B34FB');

class Bluetooth {
  BlueToothState _state = BlueToothState.disconnected;
  late BehaviorSubject<BlueToothState> connectionSubject;

  final _bluetooth = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  String? _deviceId;

  Bluetooth() {
    connectionSubject = BehaviorSubject<BlueToothState>.seeded(_state);
  }

  // Connection functions
  ValueStream<BlueToothState> get connectionStream => connectionSubject.stream;

  Future<void> connect() async {
    _state = BlueToothState.disconnected;
    connectionSubject.add(_state);

    bool permissionsOk = true;
    if (Platform.isAndroid) {
      final scan = await Permission.bluetoothScan.request();
      final connect = await Permission.bluetoothConnect.request();
      final location = await Permission.location.request();
      if (scan != PermissionStatus.granted ||
          connect != PermissionStatus.granted ||
          location != PermissionStatus.granted) {
        permissionsOk = false;
        debugPrint('permission failed: $scan, $connect, $location');
      }
    }

    if (!permissionsOk) {
      // @ todo show dialog
    }

    if (_scanSubscription != null) {
      _scanSubscription!.cancel();
    }

    _bluetooth.connectedDeviceStream.listen((state) {
      debugPrint('connectedDeviceStream $state');
      if (state.connectionState == DeviceConnectionState.connected) {
        _connectToDevice(state.deviceId, 5);
      }
    });

    _bluetooth.statusStream.listen((status) {
      debugPrint('statusStream $status');
      if (status == BleStatus.poweredOff) {
        _state = BlueToothState.bluetoothIsOff;
        connectionSubject.add(_state);
      }
    });

    // _bluetooth.characteristicValueStream.listen((value) {
    //   debugPrint('characteristicValueStream $value');
    // });

    if (_bluetooth.status == BleStatus.ready) {
      debugPrint('READY');
      // final status = await _bluetooth.connectedDeviceStream.first;
      // _deviceConnected(status.deviceId);
    }

    _scanSubscription = _bluetooth.scanForDevices(
      withServices: [customServiceUUID, customCharacteristicUUID],
      scanMode: ScanMode.lowLatency,
    ).listen(_scanResults, onError: (error) {
      _state = BlueToothState.disconnected;
      connectionSubject.add(_state);
      debugPrint("error: $error");
    });
  }

  Future<void> offline() async {
    _state = BlueToothState.offline;
    connectionSubject.add(_state);
  }

  get isOffline => _state == BlueToothState.offline;

  void _scanResults(DiscoveredDevice device) {
    debugPrint("_scanResults: $device, $_state");
    // if (_state == BlueToothState.connecting) return;
    if (device.name.startsWith('Selector')) {
      _state = BlueToothState.connecting;
      _connectToDevice(device.id, 5);
    }
  }

  void _connectToDevice(String deviceId, int timeout) {
    _bluetooth
        .connectToDevice(
      id: deviceId,
      // servicesWithCharacteristicsToDiscover: {serviceId: [char1, char2]},
      connectionTimeout: Duration(seconds: timeout),
    )
        .listen((connectionState) {
      debugPrint("connectionState: $connectionState");
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        _deviceConnected(deviceId);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        _state = BlueToothState.disconnected;
        connectionSubject.add(_state);
      }
      // Handle connection state updates
    }, onError: (error) {
      // Handle a possible error
      debugPrint("Conenction failed: $error");
    });
  }

  Future<void> _deviceConnected(String deviceId) async {
    _deviceId = deviceId;
    await _getCharacteristic();
    // if (_stateSubscription == null) {
    //   _stateSubscription = _bluetooth.state.listen(_stateListener);
    // } else {
    //   _stateSubscription!.resume();
    // }

    _state = BlueToothState.connected;
    connectionSubject.add(_state);

    // Future.delayed(const Duration(milliseconds: 500), getStatus);
  }

  Future<void> _getCharacteristic() async {
    List<DiscoveredService> services =
        await _bluetooth.discoverServices(_deviceId!);
    for (var service in services) {
      if (service.serviceId == (customServiceUUID)) {
        var characteristics = service.characteristics;
        for (var characteristic in characteristics) {
          if (characteristic.characteristicId == customCharacteristicUUID) {
            debugPrint(
                "found: ${service.serviceId}${characteristic.characteristicId}");
            break;
          }
        }
      }
    }
  }

  // void _stateListener(BluetoothDeviceState event) {
  //   if (event == BluetoothDeviceState.disconnected) {
  //     reset();
  //     _state = BlueToothState.offline;
  //     connectionSubject.add(_state);
  //   }
  // }

  Future<bool> checkConnection() async {
    final permissionsOk = await checkPermissions();
    return permissionsOk && _state == BlueToothState.connected;
  }

  Future<bool> checkPermissions() async {
    final status = _bluetooth.status;
    // Check the phone's bluetooth
    // status == BleStatus.unknown ||
    if (status == BleStatus.unsupported || status == BleStatus.unauthorized) {
      connectionSubject.add(BlueToothState.noBluetooth);
      return false;
    }
    // Check the phone's location
    if (status == BleStatus.locationServicesDisabled) {
      connectionSubject.add(BlueToothState.noLocation);
      return false;
    }
    // Check bluetooth power
    if (status == BleStatus.poweredOff) {
      connectionSubject.add(BlueToothState.bluetoothIsOff);
      return false;
    }
    // var isOn = await _bluetooth.isOn;
    // if (!isOn) {
    //   // Try once more after some time (to allow auto-enable)
    //   await Future.delayed(const Duration(seconds: 2));
    //   isOn = await _bluetooth.isOn;
    //   if (!isOn) {
    //     connectionSubject.add(BlueToothState.bluetoothIsOff);
    //     return false;
    //   }
    // }
    return true;
  }

  // Actions
  Future<bool> sortieVinyle(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.sortieVinyle(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> fermeMeuble(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.fermeMeuble(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> rentreVinyle() async {
    if (!await checkConnection()) {
      return false;
    }
    final message = Arduino.rentreVinyl();

    await sendMessage(message);
    return true;
  }

  Future<bool> ajoutVinyle(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.ajoutVinyle(position);

    await sendMessage(message);
    return true;
  }

  Future<bool> getStatus() async {
    debugPrint('getStatus');
    if (!await checkConnection()) {
      debugPrint('No connection');
      return false;
    }

    await sendMessage(Arduino.info());
    return true;
  }

  Future<void> sendMessage(String message) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: customServiceUUID,
        characteristicId: customCharacteristicUUID,
        deviceId: _deviceId!);
    if (message.isNotEmpty) {
      debugPrint('Sending message: $message');

      try {
        await _bluetooth.writeCharacteristicWithResponse(characteristic,
            value: utf8.encode(message));
      } catch (e) {
        debugPrint('Error sending message: $e');
      }
      // _bluetooth.subscribeToCharacteristic(characteristic).listen((value) {
      //   debugPrint('Received message: ${utf8.decode(value)}');
      // });

      // await _characteristicId!.read();
      // if (!_characteristicId!.isNotifying) {
      //   await _characteristicId!.setNotifyValue(true);
      //   await _characteristicId!.read();
      // }
    }

    // final response = await _bluetooth.readCharacteristic(characteristic);
    // final received = utf8.decode(response, allowMalformed: true);
    // debugPrint('response: $received');
    await _bluetooth
        .subscribeToCharacteristic(characteristic)
        .firstWhere((data) {
      debugPrint('subscribeToCharacteristic Received: $data');
      final received = utf8.decode(data, allowMalformed: true);
      // if (received.startsWith(Arduino.status)) {
      //   final status = received.replaceAll(Arduino.status, '');
      //   debugPrint('$received status: $status');
      // }
      debugPrint('Received: $received');
      return received.startsWith(Arduino.done);
    });
    // await _bluetooth.characteristicValueStream.firstWhere((value) {
    //   final received =
    //       utf8.decode(value.result.dematerialize(), allowMalformed: true);
    //   // if (received.startsWith(Arduino.status)) {
    //   //   final status = received.replaceAll(Arduino.status, '');
    //   //   debugPrint('$received status: $status');
    //   // }
    //   debugPrint('Received: $received');
    //   return received.startsWith(Arduino.done);
    // });

    // String responseString = "";
    // // while (!responseString.startsWith(Arduino.done)) {
    // final response = await _bluetooth.readCharacteristic(characteristic);
    // responseString = utf8.decode(response, allowMalformed: true);
    // debugPrint('Received $responseString');
    // }

    // await _characteristicId!.value.firstWhere((value) {
    //   final received = utf8.decode(value, allowMalformed: true);
    //   // if (received.startsWith(Arduino.status)) {
    //   //   final status = received.replaceAll(Arduino.status, '');
    //   //   debugPrint('$received status: $status');
    //   // }
    //   return received.startsWith(Arduino.done);
    // });
    debugPrint('sendMessage done');
  }

  Future<void> reset() async {
    _deviceId = "";
  }
}
