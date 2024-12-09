import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  List<int?> parseLines(List<String> lines) {
    final List<int?> files = [];
    final line = lines[0].split('');
    bool freeSpace = false;
    int id = 0;
    for (final char in line) {
      int value = int.parse(char);
      for (int i = 0; i < value; i++) {
        if (freeSpace) {
          files.add(null);
        } else {
          files.add(id);
        }
      }
      if (freeSpace) {
        id++;
      }
      freeSpace = !freeSpace;
    }
    return files;
  }

  @override
  List<int?> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  @override
  int solvePart1() {
    final files = parseInput();
    // final filesString =
    //     files.map((e) => e == null ? '.' : e.toString()).join('');
    // print(filesString);
    bool sorted = false;
    while (!sorted) {
      for (int i = files.length - 1; i > 0; i--) {
        if (files[i] == null) {
          continue;
        }
        final current = files[i]!;
        final firstEmptyIndex = files.indexWhere((element) => element == null);
        if (firstEmptyIndex > i) {
          sorted = true;
          break;
        }
        files[i] = null;
        files[firstEmptyIndex] = current;
      }
    }
    // final filesStringSorted =
    //     files.map((e) => e == null ? '.' : e.toString()).join('');
    // print(filesStringSorted);
    int checksum = 0;
    for (int i = 0; i < files.length; i++) {
      if (files[i] == null) {
        continue;
      }
      checksum += i * files[i]!;
    }
    return checksum;
  }

  @override
  int solvePart2() {
    final files = parseInput();
    // final filesString =
    //     files.map((e) => e == null ? '.' : e.toString()).join('');
    // print(filesString);
    for (int i = files.length - 1; i > 0; i--) {
      // final filesStringSorted =
      //     files.map((e) => e == null ? '.' : e.toString()).join('');
      // print(filesStringSorted);
      if (files[i] == null) {
        continue;
      }
      final current = files[i]!;
      int currentFileSize = 1;
      for (int j = i - 1; j >= 0; j--) {
        if (files[j] != current) {
          break;
        }
        currentFileSize++;
      }
      while (true) {
        final firstEmptyIndex = files.indexWhere((element) => element == null);
        if (firstEmptyIndex > i || firstEmptyIndex == -1) {
          i -= currentFileSize - 1;
          break;
        }
        final emptySpaceSize = files
            .sublist(firstEmptyIndex,
                files.indexWhere((element) => element != null, firstEmptyIndex))
            .length;
        if (emptySpaceSize < currentFileSize) {
          for (int j = 0; j < emptySpaceSize; j++) {
            files[firstEmptyIndex + j] = -1; //Making them not empty
          }
          continue;
        }
        for (int j = 0; j < currentFileSize; j++) {
          files[i - j] = null;
          files[firstEmptyIndex + j] = current;
        }
        i -= currentFileSize - 1;
        break;
      }
      //Revert all -1 to null
      for (int j = 0; j < i; j++) {
        if (files[j] == -1) {
          files[j] = null;
        }
      }
    }
    // final filesStringSorted =
    //     files.map((e) => e == null ? '.' : e.toString()).join('');
    // print(filesStringSorted);
    int checksum = 0;
    for (int i = 0; i < files.length; i++) {
      if (files[i] == null) {
        continue;
      }
      checksum += i * files[i]!;
    }
    return checksum;
  }
}
