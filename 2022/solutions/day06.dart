import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  String parseInput() {
    final inputUtil = InputUtil(6);
    return inputUtil.asString;
  }

  @override
  int solvePart1() {
    final s = parseInput();
    String c1 = "";
    String c2 = "";
    String c3 = "";
    for (int i = 0; i < s.length; i += 1) {
      c1 = s[i];
      if (s[i + 1] != c1) {
        c2 = s[i + 1];
        if (s[i + 2] != c1 && s[i + 2] != c2) {
          c3 = s[i + 2];
          if (s[i + 3] != c1 && s[i + 3] != c2 && s[i + 3] != c3) {
            return i + 4;
          }
        }
      }
    }
    return 0;
  }

  @override
  int solvePart2() {
    final s = parseInput();
    List<String> c = [];
    for (int i = 0; i < s.length; i += 1) {
      c.clear();
      c.add(s[i]);
      for (int j = i + 1; j < i + 14; j += 1) {
        if (!c.contains(s[j])) {
          c.add(s[j]);
        } else {
          break;
        }
        if (c.length == 14) {
          return j + 1;
        }
      }
    }
    return 0;
  }
}
