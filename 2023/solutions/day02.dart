import '../utils/index.dart';

class CubesInBag {
  final int red;
  final int green;
  final int blue;
  final int gameId;

  CubesInBag(
      {required this.red,
      required this.green,
      required this.blue,
      required this.gameId});
}

class Day02 extends GenericDay {
  Day02() : super(2);

  List<CubesInBag> parseLines(List<String> lines) {
    final List<CubesInBag> bags = [];
    for (final line in lines) {
      int red = 0;
      int green = 0;
      int blue = 0;
      int gameId = 0;

      final split = line.split(' ');
      gameId = int.tryParse(split[1].substring(0, split[1].length - 1)) ?? -1;
      var subSplit = split.getRange(2, split.length).toList();
      while (subSplit.isNotEmpty) {
        final value = int.tryParse(subSplit.first) ?? -1;
        String color = subSplit.elementAt(1);
        // does color finish with a comma?
        if (color.endsWith(',') || color.endsWith(';')) {
          color = color.substring(0, color.length - 1);
        }
        if (color.startsWith('red')) {
          if (value > red) {
            red = value;
          }
        }
        if (color.startsWith('blue')) {
          if (value > blue) {
            blue = value;
          }
        }
        if (color.startsWith('green')) {
          if (value > green) {
            green = value;
          }
        }
        subSplit = subSplit.getRange(2, subSplit.length).toList();
      }
      bags.add(CubesInBag(red: red, green: green, blue: blue, gameId: gameId));
    }
    return bags;
  }

  @override
  List<CubesInBag> parseInput() {
    final inputUtil = InputUtil(day);
    final lines = inputUtil.getPerLine();
    final bags = parseLines(lines);
    return bags;
  }

  @override
  int solvePart1() {
    final bags = parseInput();
    int redMax = 12;
    int greenMax = 13;
    int blueMax = 14;
    int gameIdSum = 0;
    for (final bag in bags) {
      if (bag.red <= redMax) {
        if (bag.green <= greenMax) {
          if (bag.blue <= blueMax) {
            gameIdSum += bag.gameId;
          }
        }
      }
    }
    return gameIdSum;
  }

  @override
  int solvePart2() {
    final bags = parseInput();
    int fullPower = 0;
    for (final bag in bags) {
      final localPower = bag.red * bag.green * bag.blue;
      fullPower += localPower;
    }
    return fullPower;
  }
}
