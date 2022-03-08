import 'package:ble_transmitter/constant/constant.dart';
import 'package:ble_transmitter/manager/log_manager.dart';
import 'package:flutter/material.dart';

var connectState = ConnectState();
enum AppState{
  connected,
  disconnected,
  scanning,
}


class ConnectState extends ChangeNotifier {
  var _value = AppState.disconnected;

  get value => _value;

  set value(value) {
    _value = value;
    notifyListeners();
    switch(value){
      case AppState.connected:
        logManager.addEvent('CONNECTED');
        break;
      case AppState.scanning:
        logManager.addEvent('SCANNING');
        break;
      case AppState.disconnected:
        logManager.addEvent('DISCONNECTED');
        break;
      default:
        logManager.addEvent('UNKNOW');
    }

  }
}