import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  parseInput() {
    final inputUtil = InputUtil(4);
    final lines = inputUtil.getPerLine();
    final assignments = lines.map((e) {
      final l = e.split(",");
      return Tuple2<String, String>(l[0], l[1]);
    }).toList();
    final parsedAssignments = assignments.map((e) {
      final l1 = e.item1.split("-");
      final tuple1 = Tuple2<int, int>(int.parse(l1[0]), int.parse(l1[1]));
      final l2 = e.item2.split("-");
      final tuple2 = Tuple2<int, int>(int.parse(l2[0]), int.parse(l2[1]));
      return Tuple2<Tuple2<int, int>, Tuple2<int, int>>(tuple1, tuple2);
    }).toList();
    return parsedAssignments;
  }

  @override
  int solvePart1() {
    final assignments = parseInput();
    int score = 0;
    for (final a in assignments) {
      if (a.item1.item1 >= a.item2.item1 &&
          a.item1.item1 <= a.item2.item2 &&
          a.item1.item2 >= a.item2.item1 &&
          a.item1.item2 <= a.item2.item2) {
        score += 1;
      } else if (a.item2.item1 >= a.item1.item1 &&
          a.item2.item1 <= a.item1.item2 &&
          a.item2.item2 >= a.item1.item1 &&
          a.item2.item2 <= a.item1.item2) {
        score += 1;
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final assignments = parseInput();
    int score = 0;
    for (final a in assignments) {
      if (a.item1.item1 >= a.item2.item1 && a.item1.item1 <= a.item2.item2 ||
          a.item1.item2 >= a.item2.item1 && a.item1.item2 <= a.item2.item2) {
        score += 1;
      } else if (a.item2.item1 >= a.item1.item1 &&
              a.item2.item1 <= a.item1.item2 ||
          a.item2.item2 >= a.item1.item1 && a.item2.item2 <= a.item1.item2) {
        score += 1;
      }
    }
    return score;
  }
}
