import 'dart:math';

import 'package:ble_transmitter/command/out_command.dart';
import 'package:ble_transmitter/manager/ble_mamanger.dart';
import 'package:ble_transmitter/manager/log_manager.dart';
import 'package:ble_transmitter/manager/settings.dart';

var uploadManager = UploadManager();
class UploadManager {

  Future<bool> startTask(List<int> data, String fileExt) async {

    var startTime = DateTime.now();
    var segments = (data.length ~/ settings.dataLength);
    if (data.length % settings.dataLength > 0) {
      segments += 1;
    }
    var bytes = StartCommand(segments, fileExt).bytes;
    logManager.addSendRaw(bytes, msg: 'START COMMAND', desc: 'total chunks: $segments');
    var response = await bleManager.write(bytes);
    logManager.addReceiveRaw(response, msg: 'START ACK');
    for (int i = 0; i < segments; i++) {
      var start = settings.dataLength * i;
      var end = min(start + settings.dataLength - 1, data.length - 1);
      var dataSegment = data.sublist(start, end);
      bytes = DataCommand(dataSegment, i).bytes;
      logManager.addSendRaw(bytes, msg:'DATA COMMAND', desc: 'chunk $i');
      response = await bleManager.write(bytes);
      logManager.addReceiveRaw(response, msg: 'DATA ACK');
    }
    bytes = EndCommand().bytes;
    var ms = DateTime.now().difference(startTime).inMilliseconds;
    logManager.addSendRaw(bytes, msg: 'END COMMAND', desc: 'total cost $ms ms');
    response = await bleManager.write(bytes);
    logManager.addReceiveRaw(response, msg: 'END ACK');

    return true;
  }
}
