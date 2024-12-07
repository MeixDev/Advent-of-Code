import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  void parseLines(List<String> lines) {}

  @override
  List<String> parseInput() {
    final lines = input.getPerLine();
    return lines;
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    final pattern = RegExp(r'[+-]?\d+');
    int sum = 0;
    for (final line in lines) {
      String progress = line;
      while (progress.isNotEmpty) {
        int idx = progress.indexOf("mul(");
        if (idx == -1) {
          break;
        }
        // print("Beginning mul( at $idx");
        progress = progress.substring(idx + 4);
        final matchN1Reg = pattern.firstMatch(progress);
        if (matchN1Reg == null) {
          // print("No n1 match, broke");
          continue;
        }
        final matchN1 = matchN1Reg.group(0)!;
        // pattern.allMatches(progress).map((m) => m.group(0)).join();
        final n1 = int.parse(matchN1);
        progress = progress.substring(n1.toString().length);
        if (progress[0] != ',') {
          // print("No comman after n1, broke");
          continue;
        }
        progress = progress.substring(1);
        final matchN2Reg = pattern.firstMatch(progress);
        if (matchN2Reg == null) {
          // print("No n2 match, broke");
          continue;
        }
        final matchN2 = matchN2Reg.group(0)!;
        final n2 = int.parse(matchN2);
        progress = progress.substring(n2.toString().length);
        if (progress[0] != ')') {
          // print("No closing bracket after n2, broke");
          continue;
        }
        // print("n1: $n1, n2: $n2");
        sum += n1 * n2;
      }
    }
    return sum;
  }

  @override
  int solvePart2() {
    final lines = parseInput();
    final pattern = RegExp(r'[+-]?\d+');
    int sum = 0;
    bool enabled = true;
    for (final line in lines) {
      String progress = line;
      while (progress.isNotEmpty) {
        int idx = progress.indexOf("mul(");
        if (idx == -1) {
          break;
        }
        String instructionsSubstring = progress.substring(0, idx);
        while (instructionsSubstring.isNotEmpty) {
          if (enabled) {
            int jdx = instructionsSubstring.indexOf("don't()");
            if (jdx == -1) break;
            // print("Found don't() at $jdx");
            enabled = false;
            instructionsSubstring = instructionsSubstring.substring(jdx + 7);
          } else {
            int jdx = instructionsSubstring.indexOf("do()");
            if (jdx == -1) break;
            // print("Found do() at $jdx");
            enabled = true;
            instructionsSubstring = instructionsSubstring.substring(jdx + 4);
          }
        }
        // print("Beginning mul( at $idx");
        progress = progress.substring(idx + 4);
        final matchN1Reg = pattern.firstMatch(progress);
        if (matchN1Reg == null) {
          // print("No n1 match, broke");
          continue;
        }
        final matchN1 = matchN1Reg.group(0)!;
        // pattern.allMatches(progress).map((m) => m.group(0)).join();
        final n1 = int.parse(matchN1);
        progress = progress.substring(n1.toString().length);
        if (progress[0] != ',') {
          // print("No comman after n1, broke");
          continue;
        }
        progress = progress.substring(1);
        final matchN2Reg = pattern.firstMatch(progress);
        if (matchN2Reg == null) {
          // print("No n2 match, broke");
          continue;
        }
        final matchN2 = matchN2Reg.group(0)!;
        final n2 = int.parse(matchN2);
        progress = progress.substring(n2.toString().length);
        if (progress[0] != ')') {
          // print("No closing bracket after n2, broke");
          continue;
        }
        // print("n1: $n1, n2: $n2, enabled: $enabled");
        if (enabled) {
          sum += n1 * n2;
        }
      }
    }
    return sum;
  }
}
