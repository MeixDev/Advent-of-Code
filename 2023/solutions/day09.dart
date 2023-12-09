import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  void parseLines(List<String> lines) {}

  @override
  List<List<int>> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final historyValues = <List<int>>[];
    for (final line in lines) {
      final split = line.split(' ');
      final values = <int>[];
      for (final value in split) {
        values.add(int.parse(value));
      }
      historyValues.add(values);
    }
    return historyValues;
  }

  @override
  int solvePart1() {
    final historyValues = parseInput();
    int score = 0;
    for (final values in historyValues) {
      final preamble = [values];
      int x = 0;
      while (x < preamble.length) {
        final differences = <int>[];
        final list = preamble[x];
        int y = 0;
        while (y < list.length - 1) {
          differences.add(list[y + 1] - list[y]);
          y++;
        }
        if (differences.any((element) => element != 0)) {
          preamble.add(differences);
        } else {
          preamble.add(differences);
          break;
        }
        x++;
      }
      final remontada = preamble.reversed.toList();
      x = 0;
      while (x < remontada.length) {
        if (x == 0) {
          remontada[x].add(0);
          x++;
          continue;
        }
        final previousListAddition = remontada[x - 1].last;
        remontada[x].add(remontada[x].last + previousListAddition);
        x++;
      }
      score += remontada.last.last;
    }
    return score;
  }

  @override
  int solvePart2() {
    final historyValues = parseInput();
    int score = 0;
    for (final values in historyValues) {
      final preamble = [values];
      int x = 0;
      while (x < preamble.length) {
        final differences = <int>[];
        final list = preamble[x];
        int y = 0;
        while (y < list.length - 1) {
          differences.add(list[y + 1] - list[y]);
          y++;
        }
        if (differences.any((element) => element != 0)) {
          preamble.add(differences);
        } else {
          preamble.add(differences);
          break;
        }
        x++;
      }
      final remontada = preamble.reversed.toList();
      x = 0;
      while (x < remontada.length) {
        if (x == 0) {
          remontada[x].insert(0, 0);
          x++;
          continue;
        }
        final previousListAddition = remontada[x - 1].first;
        remontada[x].insert(0, remontada[x].first - previousListAddition);
        x++;
      }
      score += remontada.last.first;
    }
    return score;
  }
}
