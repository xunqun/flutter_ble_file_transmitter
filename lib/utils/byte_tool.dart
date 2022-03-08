import 'dart:typed_data';

class ByteTool{
  static List<int> stringToListIntWithSize(List<int> bytes, int size) {
    List<int> result = List.filled(size, 0x20);
    for (int i = 0; i < bytes.length; i++) {
      result[i] = bytes[i];
    }
    return result;
  }

  static int checkSum(List<int> array) {
    var result = array[0];
    for (int i = 1; i < array.length; i++) {
      result = result ^ array[i];
    }
    return result;
  }

  static Uint8List int32bytes(int value, int length) =>
      Uint8List(4)..buffer.asByteData().setInt32(0, value)..sublist(4-length);
}