import '../utils/index.dart';

enum Ins {
  addx,
  noop,
}

class InstructionA {
  final Ins ins;
  final int value;

  InstructionA(this.ins, this.value);
  factory InstructionA.fromLine(String line) {
    final parts = line.split(" ");
    switch (parts[0]) {
      case "addx":
        return InstructionA(Ins.addx, int.parse(parts[1]));
      case "noop":
        return InstructionA(Ins.noop, 0);
      default:
        throw Exception("Unknown instruction");
    }
  }
}

class Day10 extends GenericDay {
  Day10() : super(10);
  @override
  List<InstructionA> parseInput() {
    final inputUtil = InputUtil(10);
    return inputUtil
        .getPerLine()
        .map((line) => InstructionA.fromLine(line))
        .toList();
  }

  List<int> cyclesToCheck = [20, 60, 100, 140, 180, 220];

  int checkCycle(int cycle, int x) {
    if (cyclesToCheck.contains(cycle)) {
      return cycle * x;
    }
    return 0;
  }

  @override
  int solvePart1() {
    final instructions = parseInput();
    int score = 0;
    int cycles = 0;
    int x = 1;
    for (final instruction in instructions) {
      switch (instruction.ins) {
        case Ins.addx:
          for (int i = 0; i < 2; i += 1) {
            cycles += 1;
            score += checkCycle(cycles, x);
            if (i == 1) {
              x += instruction.value;
            }
          }
          break;
        case Ins.noop:
          cycles += 1;
          score += checkCycle(cycles, x);
          break;
      }
    }
    return score;
  }

  void displayCycle(int cycle, int x, List<String> field) {
    String spritePos = "";
    for (int i = 0; i < 40; i += 1) {
      if (i == x || i == x - 1 || i == x + 1) {
        spritePos += "#";
      } else {
        spritePos += ".";
      }
    }
    print("Sprite position: $spritePos");
    print("");
    print("During cycle $cycle: CRT draws pixel in position ${cycle - 1}");
    if (spritePos[(cycle - 1) % 40].contains("#")) {
      field[cycle - 1] = "#";
    }
  }

  @override
  int solvePart2() {
    final instructions = parseInput();
    List<String> fieldList = List.filled(240, ".");
    int cycles = 0;
    int x = 1;
    for (final instruction in instructions) {
      switch (instruction.ins) {
        case Ins.addx:
          for (int i = 0; i < 2; i += 1) {
            if (i == 0) {
              print(
                  "Start cycle $cycles : begin executing addx ${instruction.value}");
            } else {
              print(
                  "Start cycle $cycles : finish executing addx ${instruction.value}");
            }
            cycles += 1;
            displayCycle(cycles, x, fieldList);
            if (i == 1) {
              x += instruction.value;
            }
          }
          break;
        case Ins.noop:
          cycles += 1;
          displayCycle(cycles, x, fieldList);
          break;
      }
    }
    print("Final field:");
    for (int y = 0; y < 6; y += 1) {
      String line = "";
      for (int x = 0; x < 40; x += 1) {
        line += fieldList[y * 40 + x];
      }
      print(line);
    }
    return 0;
  }
}
