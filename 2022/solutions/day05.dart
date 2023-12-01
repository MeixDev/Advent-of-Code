import '../utils/index.dart';

class Cranes {
  final List<List<String>> rows;
  final List<CraneInstruction> instructions;

  const Cranes(this.rows, this.instructions);
}

class CraneInstruction {
  final int n;
  final int from;
  final int to;

  const CraneInstruction(this.n, this.from, this.to);
}

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  Cranes parseInput() {
    final inputUtil = InputUtil(5);
    final lines = inputUtil.getPerLine();
    final List<List<String>> rows = [
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
    ];
    final List<CraneInstruction> instructions = [];
    bool emptyLinePassed = false;
    for (final line in lines) {
      if (line.isEmpty) {
        emptyLinePassed = true;
        continue;
      }
      if (line[1] == "1") {
        continue;
      }
      if (!emptyLinePassed) {
        int row = 0;
        for (int index = 1; index < line.length; index += 4) {
          if (line[index] != " ") {
            rows[row].add(line[index]);
          }
          row += 1;
        }
      } else {
        final parts = line.split(" ");
        final n = int.parse(parts[1]);
        final from = int.parse(parts[3]);
        final to = int.parse(parts[5]);
        instructions.add(CraneInstruction(n, from, to));
      }
    }
    return Cranes(rows, instructions);
  }

  @override
  int solvePart1() {
    final cranes = parseInput();
    List<List<String>> rows = cranes.rows.toList();
    for (final instruction in cranes.instructions) {
      final n = instruction.n;
      final from = instruction.from - 1;
      final to = instruction.to - 1;
      final fromRow = rows[from];
      List<String> toRow = rows[to];
      final nFrom = fromRow.length;
      if (nFrom < n) {
        continue;
      }
      for (int i = n; i > 0; i--) {
        if (fromRow.isEmpty) {
          break;
        }
        final s = fromRow.removeAt(0);
        toRow.insert(0, s);
      }
      rows[from] = fromRow;
      rows[to] = toRow;
    }
    final result = rows.map((row) => row.first).join();
    print(result);
    return 0;
  }

  @override
  int solvePart2() {
    final cranes = parseInput();
    List<List<String>> rows = cranes.rows.toList();
    for (final instruction in cranes.instructions) {
      final n = instruction.n;
      final from = instruction.from - 1;
      final to = instruction.to - 1;
      final fromRow = rows[from];
      List<String> toRow = rows[to];
      final nFrom = fromRow.length;
      if (nFrom < n) {
        continue;
      }
      final List<String> tempList = [];
      for (int i = n; i > 0; i--) {
        if (fromRow.isEmpty) {
          break;
        }
        final s = fromRow.removeAt(0);
        tempList.insert(0, s);
      }
      for (final s in tempList) {
        toRow.insert(0, s);
      }
      rows[from] = fromRow;
      rows[to] = toRow;
    }
    final result = rows.map((row) => row.first).join();
    print(result);
    return 0;
  }
}
