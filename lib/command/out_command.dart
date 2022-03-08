import 'dart:convert';

import 'package:ble_transmitter/utils/byte_tool.dart';

class StartCommand {
  List<int> begin = [0xAA, 0xBB];
  int length = 15;
  List<int> word = ByteTool.stringToListIntWithSize(utf8.encode('Download'), 8);
  List<int> type = ByteTool.stringToListIntWithSize(utf8.encode('wav'), 5);
  int count = 0;
  List<int> end = [0xCC, 0xDD];

  StartCommand(this.count, String fileExt) {
    type = ByteTool.stringToListIntWithSize(utf8.encode(fileExt), 5);
  }

  int get checkSum => ByteTool.checkSum(word + type + ByteTool.int32bytes(count, 2));

  get bytes => begin + ByteTool.int32bytes(length, 1) + word + type + ByteTool.int32bytes(count, 2) + ByteTool.int32bytes(checkSum, 1) + end;
}

class EndCommand {
  List<int> begin = [0xAA, 0xBB];
  int length = 8;
  List<int> word = ByteTool.stringToListIntWithSize(utf8.encode('End'), 8);
  List<int> end = [0xCC, 0xDD];

  EndCommand();

  int get checkSum => ByteTool.checkSum(word);

  get bytes => begin + ByteTool.int32bytes(length, 1) + word + ByteTool.int32bytes(checkSum, 1) + end;
}

class DataCommand {
  List<int> begin = [0xAA, 0xBB];
  List<int> end = [0xCC, 0xDD];
  int length = 255;
  List<int> raw;
  int counter = 0;

  DataCommand(this.raw, this.counter) {
    length = raw.length;
  }

  int get checkSum => ByteTool.checkSum(raw + ByteTool.int32bytes(counter, 2));

  get bytes => begin + ByteTool.int32bytes(length, 1) + raw + ByteTool.int32bytes(counter, 2) + ByteTool.int32bytes(checkSum, 1) + end;
}
