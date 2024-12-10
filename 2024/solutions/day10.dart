import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  Field<int> parseLines(List<String> lines) {
    final Field<int> field = Field(List.generate(
        lines.length, (_) => List.filled(lines[0].length - 1, 0)));
    for (var y = 0; y < field.height; y++) {
      for (var x = 0; x < field.width; x++) {
        final slope = lines[y][x];
        field.setValueAt(x, y, int.parse(slope));
      }
    }
    // print(field);
    return field;
  }

  @override
  Field<int> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  Set<Position> exploreSummit(
      Position point, Field<int> field, int nextToFind) {
    final adjacent = field.adjacent(point.x, point.y);
    final summitsFound = <Position>{};
    for (final adj in adjacent) {
      if (field.getValueAt(adj.x, adj.y) == 9 && nextToFind == 9) {
        summitsFound.add(Position(adj.x, adj.y));
      } else if (field.getValueAt(adj.x, adj.y) == nextToFind) {
        summitsFound.addAll(exploreSummit(adj, field, nextToFind + 1));
      }
    }
    return summitsFound;
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final entryPoints = <Position>[];
    field.forEach((x, y) {
      if (field.getValueAt(x, y) == 0) {
        entryPoints.add(Position(x, y));
      }
    });
    // print(entryPoints);
    int sum = 0;
    for (final entryPoint in entryPoints) {
      final summitPositions = exploreSummit(entryPoint, field, 1);
      // print(summitPositions.length);
      sum += summitPositions.length;
    }
    return sum;
  }

  List<Tuple2<Position, Set<Position>>> exploreSummitP2(
      Position point, Field<int> field, int nextToFind, Set<Position> visited) {
    final adjacent = field.adjacent(point.x, point.y);
    final summitsFound =
        List<Tuple2<Position, Set<Position>>>.empty(growable: true);
    for (final adj in adjacent) {
      final newVisited = visited.toSet()..add(Position(adj.x, adj.y));
      if (field.getValueAt(adj.x, adj.y) == 9 && nextToFind == 9) {
        summitsFound.add(Tuple2(Position(adj.x, adj.y), visited));
      } else if (field.getValueAt(adj.x, adj.y) == nextToFind) {
        summitsFound
            .addAll(exploreSummitP2(adj, field, nextToFind + 1, newVisited));
      }
    }
    return summitsFound;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final entryPoints = <Position>[];
    field.forEach((x, y) {
      if (field.getValueAt(x, y) == 0) {
        entryPoints.add(Position(x, y));
      }
    });
    // print(entryPoints);
    int sum = 0;
    for (final entryPoint in entryPoints) {
      final summitPositions =
          exploreSummitP2(entryPoint, field, 1, <Position>{});
      // print(summitPositions.length);
      sum += summitPositions.length;
    }
    return sum;
  }
}
