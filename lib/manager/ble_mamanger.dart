import 'package:ble_transmitter/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'connect_state.dart';

var bleManager = BleManager();
const SERVICE_UUID = "00001800-0000-1000-8000-00805f9b34fb";
const CHARACTERISTIC_UUID_RX = "00002a00-0000-1000-8000-00805f9b34fb";
const CHARACTERISTIC_UUID_TX = "00002a01-0000-1000-8000-00805f9b34fb";
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
          _device!.requestMtu(DESIRED_MTU);
          findProperties(_device!);
        }
      }, onError: (_) {
        _device = null;
      }, onDone: (){
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

  Future<List<int>> write(List<int> data) async{
    await _charRx?.write(data);
    return await _charTx?.read() ?? [];
  }

  disconnect(){
    connectState.value = AppState.disconnected;
    _device?.disconnect();
  }

  void findProperties(BluetoothDevice bluetoothDevice) {
    _device!.discoverServices().then((services) {
      services.forEach((service) {
        if(service.uuid.toString() == SERVICE_UUID){
          _service = service;
          _service!.characteristics.forEach((char) {
            if(char.uuid.toString() == CHARACTERISTIC_UUID_RX){
              _charRx = char;
              print('rx found');
            }else if(char.uuid.toString() == CHARACTERISTIC_UUID_TX){
              _charTx = char;
              print('tx found');
            }
          });
        }
      });
    }
    );
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
