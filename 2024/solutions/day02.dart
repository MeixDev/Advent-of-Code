import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  List<List<int>> parseLines(List<String> lines) {
    final List<List<int>> parsedLines = [];
    for (final line in lines) {
      final numbers = line.split(' ');
      final parsedNumbers = numbers.map((e) => int.parse(e)).toList();
      parsedLines.add(parsedNumbers);
    }
    return parsedLines;
  }

  @override
  List<List<int>> parseInput() {
    final lines = input.getPerLine();
    final parsedLines = parseLines(lines);
    return parsedLines;
  }

  bool isValid(int current, int next) {
    if (current == next) {
      return false;
    }
    if (next > current + 3) {
      return false;
    }
    if (next < current - 3) {
      return false;
    }
    return true;
  }

  @override
  int solvePart1() {
    final List<List<int>> numbers = parseInput();
    int safe = 0;
    for (final line in numbers) {
      int index = 1;
      int current = line[0];
      int increasing = 0;
      while (index < line.length) {
        final int next = line[index];
        if (isValid(current, next)) {
          if (next > current) {
            if (increasing == 0) {
              increasing = 1;
            } else if (increasing == -1) {
              break;
            }
          }
          if (next < current) {
            if (increasing == 0) {
              increasing = -1;
            } else if (increasing == 1) {
              break;
            }
          }
          index++;
          current = next;
          continue;
        } else {
          break;
        }
      }
      print('Line: $line, Index: $index');
      if (index == line.length) {
        safe++;
      }
    }
    return safe;
  }

  bool testLine(List<int> line) {
    final differences = <int>[];
    for (int i = 1; i < line.length; i++) {
      differences.add(line[i] - line[i - 1]);
    }

    bool condition1 =
        differences.every((diff) => 1 <= diff.abs() && diff.abs() <= 3);
    bool condition2 = differences.every((diff) => diff > 0) ||
        differences.every((diff) => diff < 0);

    return condition1 && condition2;
  }

  // Good fucking lord, this is so much cleaner.
  @override
  int solvePart2() {
    final List<List<int>> numbers = parseInput();
    int safe = 0;
    for (final line in numbers) {
      final test = testLine(line);
      if (test) {
        safe++;
      } else {
        int index = 0;
        while (index < line.length) {
          final List<int> newList = List<int>.from(line);
          newList.removeAt(index);
          if (testLine(newList)) {
            safe++;
            break;
          }
          index++;
        }
      }
    }
    return safe;
  }
}
