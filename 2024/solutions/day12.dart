import 'dart:collection';

import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  Field<String> parseLines(List<String> lines) {
    final field = Field<String>(List<List<String>>.generate(
        lines.length, (index) => List<String>.filled(lines[0].length - 1, '')));
    for (int y = 0; y < lines.length; y++) {
      for (int x = 0; x < lines[0].length - 1; x++) {
        field.setValueAt(x, y, lines[y][x]);
      }
    }
    return field;
  }

  @override
  Field<String> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  (int, int) findSpace(Field<String> field, Position current, String letter,
      Set<Position> visited) {
    final adjacent = field.adjacent(current.x, current.y);
    int area = 0;
    int perimeter = 0;
    perimeter += 4 -
        adjacent
            .where((pos) => field.getValueAt(pos.x, pos.y) == letter)
            .length;
    for (final pos in adjacent) {
      if (field.getValueAt(pos.x, pos.y) == letter) {
        if (visited.contains(pos)) {
          continue;
        }
        visited.add(pos);
        area += 1;
        final (additionalArea, additionalPerimeter) =
            findSpace(field, pos, letter, visited);
        area += additionalArea;
        perimeter += additionalPerimeter;
      }
    }
    return (area, perimeter);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    // print(field);
    int sum = 0;
    for (int y = 0; y < field.height; y++) {
      for (int x = 0; x < field.width; x++) {
        if (field.getValueAt(x, y) == '#') {
          continue;
        }
        final letter = field.getValueAt(x, y);
        final visited = <Position>{};
        visited.add(Position(x, y));
        int area = 1;
        int perimeter = 0;
        final (additionalArea, additionalPerimeter) =
            findSpace(field, Position(x, y), letter, visited);
        area += additionalArea;
        perimeter += additionalPerimeter;
        // print('Letter: $letter, Area: $area, Perimeter: $perimeter');
        for (final position in visited) {
          field.setValueAt(position.x, position.y, '#');
        }
        sum += area * perimeter;
      }
    }
    return sum;
  }

  final walls = <Tuple2<String, Tuple2<int, int>>, List<int>>{};

  int findSpaceP2(Field<String> field, Position current, String letter,
      Set<Position> visited) {
    // final adjacent = field.adjacent(current.x, current.y);
    final adjacent = [
      Position(current.x + 1, current.y),
      Position(current.x - 1, current.y),
      Position(current.x, current.y + 1),
      Position(current.x, current.y - 1),
    ];
    int area = 0;
    for (final pos in adjacent) {
      if (!field.isOnField(pos) || field.getValueAt(pos.x, pos.y) != letter) {
        if (pos.x == current.x) {
          if (walls[Tuple2('y', Tuple2(pos.y, current.y))] == null) {
            walls[Tuple2('y', Tuple2(pos.y, current.y))] = <int>[];
          }
          walls[Tuple2('y', Tuple2(pos.y, current.y))]!.add(pos.x);
        } else {
          if (walls[Tuple2('x', Tuple2(pos.x, current.x))] == null) {
            walls[Tuple2('x', Tuple2(pos.x, current.x))] = <int>[];
          }
          walls[Tuple2('x', Tuple2(pos.x, current.x))]!.add(pos.y);
        }
        continue;
      }
      if (visited.contains(pos)) {
        continue;
      }
      visited.add(pos);
      area += 1;
      final additionalArea = findSpaceP2(field, pos, letter, visited);
      area += additionalArea;
    }
    return area;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    // print(field);
    int sum = 0;
    for (int y = 0; y < field.height; y++) {
      for (int x = 0; x < field.width; x++) {
        if (field.getValueAt(x, y) == '#') {
          continue;
        }
        final letter = field.getValueAt(x, y);
        final visited = <Position>{};
        visited.add(Position(x, y));
        int area = 1;
        int sides = 0;
        final additionalArea =
            findSpaceP2(field, Position(x, y), letter, visited);
        area += additionalArea;
        for (final wall in walls.entries) {
          final values = wall.value;
          values.sort((a, b) => a - b);
          int prev =  -2;
          for (final value in values) {
            if (value > prev + 1) {
              sides += 1;
            }
            prev = value;
          }
        }
        walls.clear();
        // print('Letter: $letter, Area: $area, Sides: $sides');
        for (final position in visited) {
          field.setValueAt(position.x, position.y, '#');
        }
        sum += area * sides;
      }
    }
    return sum;
  }
}
