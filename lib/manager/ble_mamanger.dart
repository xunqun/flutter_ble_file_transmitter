import 'package:ble_transmitter/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'connect_state.dart';

var bleManager = BleManager();
const SERVICE_UUID = "0000AA01-0000-1000-8000-00805F9B34FB";
const CHARACTERISTIC_UUID_RX = "0000BA02-0000-1000-8000-00805F9B34FB";
const CHARACTERISTIC_UUID_TX = "0000BA01-0000-1000-8000-00805F9B34FB";
const DESIRED_MTU = 512;

class BleManager extends ChangeNotifier {
  BluetoothDevice? _device;
  BluetoothService? _service;
  BluetoothCharacteristic? _charTx;
  BluetoothCharacteristic? _charRx;

  BleManager() {
    FlutterBlue.instance.scanResults.listen((results) {
      scanResults.list = results;
    });
  }

  set device(value) {
    _device = value;
    if (_device != null) {
      _device!.state.listen((event) {
        if (event == BluetoothDeviceState.connected) {
          _onConnected(value);
        }
        if(event == BluetoothDeviceState.disconnected){
          connectState.value = AppState.disconnected;
        }
      }, onError: (_) {
        _device = null;
      }, onDone: () {
        device = null;
      });
    }
  }

  scan() {
    FlutterBlue.instance.startScan(timeout: const Duration(seconds: 6));
    Future.delayed(const Duration(seconds: 6)).then((value) {
      FlutterBlue.instance.stopScan();
      if (connectState.value == AppState.scanning) {
        connectState.value = AppState.disconnected;
      }
    });
    connectState.value = AppState.scanning;
  }

  Future<List<int>> write(List<int> data) async {
    await _charRx!.write(data);
    return await _charTx!.read();
  }

  disconnect() {
    connectState.value = AppState.disconnected;
    _device?.disconnect();
  }

  void _onConnected(BluetoothDevice bluetoothDevice) async {
    await Future.delayed(const Duration(milliseconds: 600));
    await _device!.requestMtu(DESIRED_MTU);
    await Future.delayed(Duration(milliseconds: 600));
    var services = await _device!.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase() == SERVICE_UUID) {
        _service = service;
        _service!.characteristics.forEach((char) {
          if (char.uuid.toString().toUpperCase() == CHARACTERISTIC_UUID_RX) {
            _charRx = char;
            print('rx found');
          } else if (char.uuid.toString().toUpperCase() == CHARACTERISTIC_UUID_TX) {
            _charTx = char;
            print('tx found');
          }
        });
      }
      if (_charRx != null && _charTx != null) {
        connectState.value = AppState.connected;
      }
    });
  }
}

var scanResults = ScanResults();

class ScanResults extends ChangeNotifier {
  List<ScanResult> _results = [];

  get list => _results;

  set list(value) {
    _results = value;
    notifyListeners();
  }
}
