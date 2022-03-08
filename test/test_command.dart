import 'package:ble_transmitter/command/out_command.dart';
import 'package:ble_transmitter/utils/byte_tool.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:convert/convert.dart';

void main() {
  test('Counter value should be incremented', () {
    testCommand();
  });
}

testCommand(){

  var checksum = ByteTool.checkSum([0x00, 0x01]);
  print(checksum);
  var start = StartCommand(10);
  var result = hex.encode(start.bytes);
  print(result);
}