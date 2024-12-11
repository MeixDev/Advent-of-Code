import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  List<int> parseLines(List<String> lines) {
    final stones = <int>[];
    final line = lines.first;
    for (final stone in line.split(' ')) {
      stones.add(int.parse(stone));
    }
    return stones;
  }

  @override
  List<int> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  @override
  int solvePart1() {
    final stones = parseInput();
    num count = 0;
    for (final stone in stones) {
      final fastSolve = memoizeBlinkStone(blinkStone);
      final stoneCount = fastSolve(stone, 25);
      count += stoneCount;
    }
    return count.toInt();
  }

  memoizeBlinkStone(int Function(Function, int, int) f) {
    final cache = Map();
    m(m2, int stone, int remainingTimes) {
      final key = stone.toString() + "&" + remainingTimes.toString();
      if (cache.containsKey(key)) {
        return cache[key];
      }
      final result = f(m2, stone, remainingTimes);
      cache[key] = result;
      return result;
    }

    return (int stone, int remainingTimes) => m(m, stone, remainingTimes);
  }

  int blinkStone(blinkStoneDef, int stone, int remainingTimes) {
    if (remainingTimes == 0) {
      return 1;
    } else if (stone == 0) {
      return blinkStoneDef(blinkStoneDef, 1, remainingTimes - 1);
    }
    final stoneStr = stone.toString();
    final stoneLength = stoneStr.length;
    if (stoneLength % 2 == 0) {
      return (blinkStoneDef(
              blinkStoneDef,
              int.parse(stoneStr.substring(0, stoneLength ~/ 2)),
              remainingTimes - 1) +
          blinkStoneDef(
              blinkStoneDef,
              int.parse(stoneStr.substring(stoneLength ~/ 2)),
              remainingTimes - 1));
    }
    return blinkStoneDef(blinkStoneDef, stone * 2024, remainingTimes - 1);
  }

  @override
  int solvePart2() {
    final stones = parseInput();
    num count = 0;
    for (final stone in stones) {
      final fastSolve = memoizeBlinkStone(blinkStone);
      final stoneCount = fastSolve(stone, 75);
      count += stoneCount;
    }
    return count.toInt();
  }
}
