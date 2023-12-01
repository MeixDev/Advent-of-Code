import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  List<int> parseLines(List<String> lines) {
    final List<int> numbers = [];
    for (final line in lines) {
      bool foundFirst = false;
      bool foundLast = false;
      int firstDigit = 48;
      int lastDigit = 48;
      line.runes.forEach((element) {
        if (element >= 48 && element <= 57) {
          if (!foundFirst) {
            firstDigit = element;
            foundFirst = true;
          } else {
            lastDigit = element;
            foundLast = true;
          }
        }
      });
      if (foundLast) {
        numbers.add((firstDigit - 48) * 10 + (lastDigit - 48));
      } else {
        numbers.add((firstDigit - 48) * 10 + (firstDigit - 48));
      }
    }
    return numbers;
  }

  static const Map<String, int> validValues = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
  };

  List<int> parseLinesPartTwo(List<String> lines) {
    final List<int> numbers = [];
    for (final line in lines) {
      bool foundFirst = false;
      bool foundLast = false;
      int firstValue = 0;
      int lastValue = 0;
      String subLine = line;
      while (subLine.isNotEmpty) {
        bool foundSomething = false;
        for (final key in validValues.keys) {
          if (subLine.startsWith(key)) {
            foundSomething = true;
            if (!foundFirst) {
              firstValue = validValues[key]!;
              foundFirst = true;
            } else {
              lastValue = validValues[key]!;
              foundLast = true;
            }
            subLine = subLine.replaceFirst(key, '');
            break;
          }
        }
        if (!foundSomething) {
          subLine = subLine.substring(1);
        }
      }
      if (foundLast) {
        numbers.add((firstValue) * 10 + (lastValue));
      } else {
        numbers.add((firstValue) * 10 + (firstValue));
      }
    }
    return numbers;
  }

  static const Map<String, String> replacements = {
    'one': 'one1one',
    'two': 'two2two',
    'three': 'three3three',
    'four': 'four4four',
    'five': 'five5five',
    'six': 'six6six',
    'seven': 'seven7seven',
    'eight': 'eight8eight',
    'nine': 'nine9nine',
  };

  List<int> parseLinesPartTwoAttemptTwo(List<String> lines) {
    final List<int> numbers = [];
    final List<String> modifiedLines = [];
    for (final line in lines) {
      String modifiedLine = line;
      for (final key in replacements.keys) {
        modifiedLine = modifiedLine.replaceAll(key, replacements[key]!);
      }
      modifiedLines.add(modifiedLine);
    }
    for (final line in modifiedLines) {
      bool foundFirst = false;
      bool foundLast = false;
      int firstDigit = 48;
      int lastDigit = 48;
      line.runes.forEach((element) {
        if (element >= 48 && element <= 57) {
          if (!foundFirst) {
            firstDigit = element;
            foundFirst = true;
          } else {
            lastDigit = element;
            foundLast = true;
          }
        }
      });
      if (foundLast) {
        numbers.add((firstDigit - 48) * 10 + (lastDigit - 48));
      } else {
        numbers.add((firstDigit - 48) * 10 + (firstDigit - 48));
      }
    }
    return numbers;
  }

  @override
  List<int> parseInput() {
    final inputUtil = InputUtil(1);
    final lines = inputUtil.getPerLine();
    final numbers = parseLines(lines);
    return numbers;
  }

  List<int> parseInputPartTwo() {
    final inputUtil = InputUtil(1);
    final lines = inputUtil.getPerLine();
    final numbers = parseLinesPartTwoAttemptTwo(lines);
    return numbers;
  }

  @override
  int solvePart1() {
    final numbers = parseInput();
    int sum = 0;
    for (final number in numbers) {
      sum += number;
    }
    return sum;
  }

  @override
  int solvePart2() {
    final numbers = parseInputPartTwo();
    int sum = 0;
    for (final number in numbers) {
      sum += number;
    }
    return sum;
  }
}
