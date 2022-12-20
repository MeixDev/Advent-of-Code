import '../utils/index.dart';

class EncryptedData {
  int value;
  int originalPosition;
  EncryptedData(this.value, this.originalPosition);

  @override
  String toString() {
    return value.toString();
  }
}

class Day20 extends GenericDay {
  Day20() : super(20);
  @override
  List<EncryptedData> parseInput() {
    final inputUtil = InputUtil(20);
    final lines = inputUtil.getPerLine();
    final List<EncryptedData> data = [];
    for (int i = 0; i < lines.length; i++) {
      data.add(EncryptedData(int.parse(lines[i]), i));
    }
    return data;
  }

  List<EncryptedData> parseInputP2() {
    final decryptionKey = 811589153;
    final inputUtil = InputUtil(20);
    final lines = inputUtil.getPerLine();
    final List<EncryptedData> data = [];
    for (int i = 0; i < lines.length; i++) {
      data.add(EncryptedData(int.parse(lines[i]) * decryptionKey, i));
    }
    return data;
  }

  @override
  int solvePart1() {
    final stopwatch = Stopwatch()..start();
    final data = parseInput();
    for (int i = 0; i < data.length; i++) {
      int indexOfValue =
          data.indexWhere((element) => element.originalPosition == i);
      final encryptedData = data[indexOfValue];
      int value = data[indexOfValue].value;
      value = value % (data.length - 1);
      if (value < 0) {
        for (int x = 0; x < value.abs(); x++) {
          if (indexOfValue == 0) {
            data.removeAt(indexOfValue);
            data.insert(data.length, encryptedData);
            indexOfValue = data.length - 1;
          }
          data.swap(indexOfValue, indexOfValue - 1);
          indexOfValue -= 1;
          if (indexOfValue == 0) {
            data.removeAt(indexOfValue);
            data.insert(data.length, encryptedData);
            indexOfValue = data.length - 1;
          }
        }
      } else {
        for (int x = 0; x < value.abs(); x++) {
          if (indexOfValue == data.length - 1) {
            data.removeAt(indexOfValue);
            data.insert(0, encryptedData);
            indexOfValue = 0;
          }
          data.swap(indexOfValue, indexOfValue + 1);
          indexOfValue += 1;
          if (indexOfValue == data.length - 1) {
            data.removeAt(indexOfValue);
            data.insert(0, encryptedData);
            indexOfValue = 0;
          }
        }
      }
    }
    final indexOfZero = data.indexWhere((element) => element.value == 0);
    int value1000 = data[(indexOfZero + 1000) % data.length].value;
    int value2000 = data[(indexOfZero + 2000) % data.length].value;
    int value3000 = data[(indexOfZero + 3000) % data.length].value;
    stopwatch.stop();
    print("Solved in ${stopwatch.elapsedMilliseconds}ms");
    return value1000 + value2000 + value3000;
  }

  @override
  int solvePart2() {
    final stopwatch = Stopwatch()..start();
    final data = parseInputP2();
    for (int round = 0; round < 10; round += 1) {
      for (int i = 0; i < data.length; i++) {
        int indexOfValue =
            data.indexWhere((element) => element.originalPosition == i);
        final encryptedData = data[indexOfValue];
        int value = data[indexOfValue].value;
        value = value % (data.length - 1);
        if (value < 0) {
          for (int x = 0; x < value.abs(); x++) {
            if (indexOfValue == 0) {
              data.removeAt(indexOfValue);
              data.insert(data.length, encryptedData);
              indexOfValue = data.length - 1;
            }
            data.swap(indexOfValue, indexOfValue - 1);
            indexOfValue -= 1;
            if (indexOfValue == 0) {
              data.removeAt(indexOfValue);
              data.insert(data.length, encryptedData);
              indexOfValue = data.length - 1;
            }
          }
        } else {
          for (int x = 0; x < value.abs(); x++) {
            if (indexOfValue == data.length - 1) {
              data.removeAt(indexOfValue);
              data.insert(0, encryptedData);
              indexOfValue = 0;
            }
            data.swap(indexOfValue, indexOfValue + 1);
            indexOfValue += 1;
            if (indexOfValue == data.length - 1) {
              data.removeAt(indexOfValue);
              data.insert(0, encryptedData);
              indexOfValue = 0;
            }
          }
        }
      }
    }
    final indexOfZero = data.indexWhere((element) => element.value == 0);
    int value1000 = data[(indexOfZero + 1000) % data.length].value;
    int value2000 = data[(indexOfZero + 2000) % data.length].value;
    int value3000 = data[(indexOfZero + 3000) % data.length].value;
    stopwatch.stop();
    print("Solved in ${stopwatch.elapsedMilliseconds}ms");
    return value1000 + value2000 + value3000;
  }
}
