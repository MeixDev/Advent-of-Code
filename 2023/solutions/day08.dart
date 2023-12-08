import '../utils/index.dart';

enum MapDirection {
  left,
  right,
}

class DesertMap {
  final List<MapDirection> directions;
  final Map<String, MapInstruction> instructions;

  DesertMap({required this.directions, required this.instructions});
}

class MapInstruction {
  final String instructionName;
  final String left;
  final String right;

  MapInstruction({
    required this.instructionName,
    required this.left,
    required this.right,
  });
}

class Day08 extends GenericDay {
  Day08() : super(8);

  void parseLines(List<String> lines) {}

  @override
  DesertMap parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final directions = <MapDirection>[];
    final dirLine = lines[0].split('');
    for (final dir in dirLine) {
      if (dir == 'L') {
        directions.add(MapDirection.left);
      } else if (dir == 'R') {
        directions.add(MapDirection.right);
      }
    }
    final instructions = <String, MapInstruction>{};
    for (final line in lines.sublist(2, lines.length - 1)) {
      final split = line.split(' ');
      instructions[split[0]] = (MapInstruction(
        instructionName: split[0],
        left: split[2].substring(1, split[2].length - 1),
        right: split[3].substring(0, split[3].length - 2),
      ));
    }
    final map = DesertMap(directions: directions, instructions: instructions);
    return map;
  }

  @override
  int solvePart1() {
    final map = parseInput();
    String currentNode = "AAA";
    int directionIterator = 0;
    int steps = 0;
    while (currentNode != "ZZZ") {
      final direction = map.directions[directionIterator];
      final instruction = map.instructions[currentNode]!;
      if (direction == MapDirection.left) {
        currentNode = instruction.left;
      } else if (direction == MapDirection.right) {
        currentNode = instruction.right;
      }
      directionIterator++;
      if (directionIterator >= map.directions.length) {
        directionIterator = 0;
      }
      steps++;
    }
    return steps;
  }

  int lcm(int a, int b) {
    return (a * b) ~/ a.gcd(b);
  }

  int listLcm(List<int> list) {
    int result = list[0];
    for (int i = 1; i < list.length; i++) {
      result = lcm(result, list[i]);
    }
    return result;
  }

  @override
  int solvePart2() {
    final map = parseInput();
    List<String> currentNodes = [];
    for (final key in map.instructions.keys) {
      if (key.endsWith("A")) {
        currentNodes.add(key);
      }
    }
    List<int> stepsTaken = [];
    for (final node in currentNodes) {
      String currentNode = node;
      int directionIterator = 0;
      int steps = 0;
      while (!currentNode.endsWith("Z")) {
        final direction = map.directions[directionIterator];
        final instruction = map.instructions[currentNode]!;
        if (direction == MapDirection.left) {
          currentNode = instruction.left;
        } else if (direction == MapDirection.right) {
          currentNode = instruction.right;
        }
        directionIterator++;
        if (directionIterator >= map.directions.length) {
          directionIterator = 0;
        }
        steps++;
      }
      stepsTaken.add(steps);
    }
    return listLcm(stepsTaken);
  }
}
