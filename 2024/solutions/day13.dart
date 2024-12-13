import '../utils/index.dart';

class ClawMachine {
  final Position a;
  final Position b;

  final Position prize;

  ClawMachine(this.a, this.b, this.prize);
}

class Day13 extends GenericDay {
  Day13() : super(13);

  List<ClawMachine> parseLines(List<String> lines) {
    final clawMachines = <ClawMachine>[];

    for (int i = 0; i < lines.length; i++) {
      final lineA = lines[i];
      final lineB = lines[i + 1];
      final linePrize = lines[i + 2];
      i += 3; //Empty line
      final xA = int.parse(
          lineA.substring(lineA.indexOf('X+') + 1, lineA.indexOf(',')));
      final yA = int.parse(lineA.substring(lineA.indexOf('Y+') + 1));
      final xB = int.parse(
          lineB.substring(lineB.indexOf('X+') + 1, lineB.indexOf(',')));
      final yB = int.parse(lineB.substring(lineB.indexOf('Y+') + 1));
      final xPrize = int.parse(linePrize.substring(
          linePrize.indexOf('X=') + 2, linePrize.indexOf(',')));
      final yPrize =
          int.parse(linePrize.substring(linePrize.indexOf('Y=') + 2));
      clawMachines.add(ClawMachine(
          Position(xA, yA), Position(xB, yB), Position(xPrize, yPrize)));
    }
    return clawMachines;
  }

  @override
  List<ClawMachine> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  int solveEquation(Position a, Position b, Position prize) {
    final m = (prize.x * b.y - prize.y * b.x) ~/ (a.x * b.y - a.y * b.x);
    if (m * (a.x * b.y - a.y * b.x) != (prize.x * b.y - prize.y * b.x)) {
      return 0;
    }
    final n = (prize.y - a.y * m) ~/ b.y;
    if (n * b.y != (prize.y - a.y * m)) {
      return 0;
    }
    return 3 * m + n;
  }

  @override
  int solvePart1() {
    final clawMachines = parseInput();
    int sum = 0;
    for (final m in clawMachines) {
      int cost = solveEquation(m.a, m.b, m.prize);
      sum += cost;
    }
    return sum;
  }

  @override
  int solvePart2() {
    final clawMachines = parseInput();
    int sum = 0;
    for (final m in clawMachines) {
      final truePrize = Position(m.prize.x + 10000000000000, m.prize.y + 10000000000000);
      int cost = solveEquation(m.a, m.b, truePrize);
      sum += cost;
    }
    return sum;
  }
}
