import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/processor.dart';

final customServiceUUID = Uuid.parse('0000FFE0-0000-1000-8000-00805F9B34FB');
final customCharacteristicUUID =
    Uuid.parse('0000FFE1-0000-1000-8000-00805F9B34FB');

class Bluetooth {
  final processor = GetIt.I.get<Processor>();
  BlueToothState _state = BlueToothState.disconnected;
  late BehaviorSubject<BlueToothState> connectionSubject;

  final _bluetooth = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  String? _deviceId;

  Bluetooth() {
    connectionSubject = BehaviorSubject<BlueToothState>.seeded(_state);

    _bluetooth.connectedDeviceStream.listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        _connectToDevice(state.deviceId, 5);
      }
    });

    _bluetooth.statusStream.listen((status) {
      if (status == BleStatus.poweredOff) {
        _state = BlueToothState.bluetoothIsOff;
        connectionSubject.add(_state);
      } else if (status == BleStatus.ready) {
        if (_scanSubscription == null) {
          if (_state != BlueToothState.disconnected) {
            _state = BlueToothState.disconnected;
            connectionSubject.add(_state);
          }
          startScan();
        }
      }
    });
  }

  // Connection functions
  ValueStream<BlueToothState> get connectionStream => connectionSubject.stream;

  Future<void> connect() async {
    if (_state != BlueToothState.disconnected) {
      _state = BlueToothState.disconnected;
      connectionSubject.add(_state);
    }

    bool permissionsOk = true;
    if (Platform.isAndroid) {
      final scan = await Permission.bluetoothScan.request();
      final connect = await Permission.bluetoothConnect.request();
      final location = await Permission.location.request();
      if (scan != PermissionStatus.granted ||
          connect != PermissionStatus.granted ||
          location != PermissionStatus.granted) {
        permissionsOk = false;
      }
    }

    if (!permissionsOk) {
      // @ todo show dialog
    }

    startScan();
  }

  Future<void> offline() async {
    _state = BlueToothState.offline;
    connectionSubject.add(_state);
  }

  get isOffline => _state == BlueToothState.offline;

  void _scanResults(DiscoveredDevice device) {
    if (device.name.startsWith('Selector')) {
      _state = BlueToothState.connecting;
      _connectToDevice(device.id, 5);
    }
  }

  void _connectToDevice(String deviceId, int timeout) {
    _bluetooth
        .connectToDevice(
      id: deviceId,
      connectionTimeout: Duration(seconds: timeout),
    )
        .listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        _deviceConnected(deviceId);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        if (_state != BlueToothState.disconnected) {
          _state = BlueToothState.disconnected;
          connectionSubject.add(_state);
        }
      }
      // Handle connection state updates
    }, onError: (error) {
      // Handle a possible error
      debugPrint("Connection failed: $error");
    });
  }

  Future<void> _deviceConnected(String deviceId) async {
    _deviceId = deviceId;
    await _getCharacteristic();

    await processor.hydrate();

    if (_state != BlueToothState.connected) {
      _state = BlueToothState.connected;
      connectionSubject.add(_state);
    }

    _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  Future<void> _getCharacteristic() async {
    List<Service> services = await _bluetooth.getDiscoveredServices(_deviceId!);
    for (var service in services) {
      if (service.id == (customServiceUUID)) {
        var characteristics = service.characteristics;
        for (var characteristic in characteristics) {
          if (characteristic.id == customCharacteristicUUID) {
            break;
          }
        }
      }
    }
  }

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
    return true;
  }

  // Actions
  Future<bool> sortieVinyle(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.sortieVinyle(position);

    return await sendMessage(message);
  }

  Future<bool> fermeMeuble(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.fermeMeuble(position);

    bool result = await sendMessage(message);
    result &= await sendMessage(Arduino.init(), waitForResponse: false);
    return result;
  }

  Future<bool> rentreVinyle() async {
    if (!await checkConnection()) {
      return false;
    }
    final message = Arduino.rentreVinyl();

    return await sendMessage(message);
  }

  Future<bool> ajoutVinyle(int position) async {
    if (!await checkConnection()) {
      return false;
    }

    final message = Arduino.ajoutVinyle(position);

    return await sendMessage(message);
  }

  Future<bool> off() async {
    if (!await checkConnection()) {
      return false;
    }
    final message = Arduino.off();

    return await sendMessage(message);
  }

  Future<bool> getStatus() async {
    if (!await checkConnection()) {
      return false;
    }

    return await sendMessage(Arduino.info());
  }

  Future<bool> sendMessage(String message,
      {bool waitForResponse = true}) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: customServiceUUID,
        characteristicId: customCharacteristicUUID,
        deviceId: _deviceId!);
    if (message.isNotEmpty) {
      try {
        await _bluetooth.writeCharacteristicWithResponse(characteristic,
            value: utf8.encode(message));
      } catch (e) {
        debugPrint('Error sending message: $e');
        return false;
      }
    }

    if (waitForResponse) {
      try {
        await _bluetooth
            .subscribeToCharacteristic(characteristic)
            .firstWhere((data) {
          final received = utf8.decode(data, allowMalformed: true);
          return received.startsWith(Arduino.done);
        });
        processor.stopHydrating();
      } catch (e) {
        // If hydrating > return true meaning the ETAPE_FIN was received
        if (processor.hydrating) {
          processor.stopHydrating();
          return true;
        }
        return false;
      }
    }
    return true;
  }

  Future<void> reset() async {
    _deviceId = "";
  }

  void startScan() {
    if (_scanSubscription != null) {
      _scanSubscription!.cancel();
    }
    _scanSubscription = _bluetooth.scanForDevices(
      withServices: [customServiceUUID, customCharacteristicUUID],
      scanMode: ScanMode.lowLatency,
    ).listen(_scanResults, onError: (error) {
      if (_state != BlueToothState.disconnected) {
        _state = BlueToothState.disconnected;
        connectionSubject.add(_state);
      }
    });
  }
}
