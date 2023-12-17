import '../utils/index.dart';

class Instruction {
  final String full;
  final String label;
  final String op;
  final int? value;

  const Instruction(this.full, this.label, this.op, this.value);
}

class Day15 extends GenericDay {
  Day15() : super(15);

  void parseLines(List<String> lines) {}

  @override
  List<Instruction> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<Instruction> hashes = [];
    for (final line in lines) {
      final commaSeparated = line.split(',');
      for (final hash in commaSeparated) {
        final full = hash;
        final endLabel =
            hash.indexOf('=') == -1 ? hash.indexOf('-') : hash.indexOf('=');
        final label = hash.substring(0, endLabel);
        final op = hash.substring(endLabel, endLabel + 1);
        if (op == "=") {
          final value = int.parse(hash.substring(endLabel + 1));
          hashes.add(Instruction(full, label, op, value));
        } else {
          hashes.add(Instruction(full, label, op, null));
        }
      }
    }
    return hashes;
  }

  @override
  int solvePart1() {
    int score = 0;
    final hashes = parseInput();
    for (final instruction in hashes) {
      final hash = instruction.full;
      int subScore = 0;
      for (final runes in hash.runes) {
        subScore += runes;
        subScore *= 17;
        subScore %= 256;
      }
      // print(subScore);
      score += subScore;
    }
    return score;
  }

  @override
  int solvePart2() {
    int score = 0;
    final hashes = parseInput();
    final Map<int, List<Instruction>> map = {};
    for (final instruction in hashes) {
      final hash = instruction.label;
      int subScore = 0;
      for (final runes in hash.runes) {
        subScore += runes;
        subScore *= 17;
        subScore %= 256;
      }
      if (instruction.op == "=") {
        if (map.containsKey(subScore)) {
          if (map[subScore]!.firstWhereOrNull(
                  (element) => element.label == instruction.label) !=
              null) {
            map[subScore]![map[subScore]!.indexWhere(
                (element) => element.label == instruction.label)] = instruction;
          } else {
            map[subScore]!.add(instruction);
          }
        } else {
          map[subScore] = [instruction];
        }
      }
      if (instruction.op == '-') {
        if (map.containsKey(subScore)) {
          map[subScore]!
              .removeWhere((element) => element.label == instruction.label);
        }
      }
      // print("After \"${instruction.full}\":");
      // for (final entry in map.entries) {
      //   print("Box ${entry.key}: ${entry.value.map((e) => e.full).join(', ')}");
      // }
    }
    for (final mapEntry in map.entries) {
      final key = mapEntry.key;
      final value = mapEntry.value;
      if (value.length == 0) {
        continue;
      }
      for (int x = 0; x < value.length; x++) {
        final addedToScore = (key + 1) * (x + 1) * (value[x].value!);
        score += addedToScore;
      }
    }
    return score;
  }
}
