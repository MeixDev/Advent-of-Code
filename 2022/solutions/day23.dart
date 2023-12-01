import 'dart:math';
import '../utils/index.dart';

enum Dir {
  N,
  NE,
  E,
  SE,
  S,
  SW,
  W,
  NW;

  List<Dir> adjacent() {
    switch (this) {
      case N:
        return [NW, NE];
      case E:
        return [NE, SE];
      case S:
        return [SE, SW];
      case W:
        return [SW, NW];
      default:
        throw Exception("Not a cardinal direction");
    }
  }
}

extension MoveBy on Position {
  Position moveBy(Dir dir) {
    switch (dir) {
      case Dir.N:
        return Position(x, y - 1);
      case Dir.NE:
        return Position(x + 1, y - 1);
      case Dir.E:
        return Position(x + 1, y);
      case Dir.SE:
        return Position(x + 1, y + 1);
      case Dir.S:
        return Position(x, y + 1);
      case Dir.SW:
        return Position(x - 1, y + 1);
      case Dir.W:
        return Position(x - 1, y);
      case Dir.NW:
        return Position(x - 1, y - 1);
    }
  }

  List<Position> inDirection(Dir dir) {
    final adjacentPos = dir.adjacent();
    return [
      moveBy(adjacentPos[0]),
      moveBy(dir),
      moveBy(adjacentPos[1]),
    ];
  }
}

class Day23 extends GenericDay {
  Day23() : super(23);

  @override
  parseInput() {
    final inputUtil = InputUtil(23);
    final List<Position> positions = [];
    final lines = inputUtil.getPerLine();
    for (int y = 0; y < lines.length; y++) {
      for (int x = 0; x < lines[y].length; x++) {
        switch (lines[y][x]) {
          case "#":
            positions.add(Position(x, y));
            break;
          case ".":
            continue;
          default:
            throw Exception("Unknown character ${lines[y][x]}");
        }
      }
    }
    return positions;
  }

  static const ROUNDS = 10;

  static const ALL_DIRECTIONS = [
    Dir.N,
    Dir.NE,
    Dir.E,
    Dir.SE,
    Dir.S,
    Dir.SW,
    Dir.W,
    Dir.NW,
  ];

  List<Position> algorithm(List<Position> pos) {
    List<Position> positions = List.from(pos);
    List<Dir> directions = [
      Dir.N,
      Dir.S,
      Dir.W,
      Dir.E,
    ];
    for (int round = 0; round < ROUNDS; round++) {
      Map<Position, Position> proposed = {};
      Map<Position, int> endpoints = {};
      for (final p in positions) {
        if (ALL_DIRECTIONS
            .any((element) => positions.contains(p.moveBy(element)))) {
          for (final dir in directions) {
            if (p
                .inDirection(dir)
                .any((element) => positions.contains(element))) {
              continue;
            }
            final endpoint = p.moveBy(dir);
            proposed[p] = endpoint;
            if (endpoints.containsKey(endpoint)) {
              endpoints[endpoint] = endpoints[endpoint]! + 1;
            } else {
              endpoints[endpoint] = 1;
            }
            break;
          }
        }
      }
      for (final entry in proposed.entries) {
        if (endpoints[entry.value]! == 1) {
          positions.remove(entry.key);
          positions.add(entry.value);
        }
      }
      final firstDirection = directions.removeAt(0);
      directions.add(firstDirection);
    }
    return positions;
  }

  int algorithmP2(List<Position> pos) {
    List<Position> positions = List.from(pos);
    List<Dir> directions = [
      Dir.N,
      Dir.S,
      Dir.W,
      Dir.E,
    ];
    for (int round = 0; true; round++) {
      Map<Position, Position> proposed = {};
      Map<Position, int> endpoints = {};
      for (final p in positions) {
        if (ALL_DIRECTIONS
            .any((element) => positions.contains(p.moveBy(element)))) {
          for (final dir in directions) {
            if (p
                .inDirection(dir)
                .any((element) => positions.contains(element))) {
              continue;
            }
            final endpoint = p.moveBy(dir);
            proposed[p] = endpoint;
            if (endpoints.containsKey(endpoint)) {
              endpoints[endpoint] = endpoints[endpoint]! + 1;
            } else {
              endpoints[endpoint] = 1;
            }
            break;
          }
        }
      }
      if (proposed.isEmpty) {
        return round + 1;
      }
      for (final entry in proposed.entries) {
        if (endpoints[entry.value]! == 1) {
          positions.remove(entry.key);
          positions.add(entry.value);
        }
      }
      final firstDirection = directions.removeAt(0);
      directions.add(firstDirection);
    }
  }

  static const MINVALUE = -9223372036854775808;
  static const MAXVALUE = 9223372036854775807;

  int rectangle(List<Position> positions) {
    int minX = MAXVALUE;
    int maxX = MINVALUE;
    int minY = MAXVALUE;
    int maxY = MINVALUE;
    for (final p in positions) {
      minX = min<int>(minX, p.x);
      maxX = max<int>(maxX, p.x);
      minY = min<int>(minY, p.y);
      maxY = max<int>(maxY, p.y);
    }
    return (maxX + 1 - minX) * (maxY + 1 - minY);
  }

  @override
  int solvePart1() {
    final positions = parseInput();
    final result = algorithm(positions);
    final nElves = result.length;
    return rectangle(result) - nElves;
  }

  @override
  int solvePart2() {
    final positions = parseInput();
    final result = algorithmP2(positions);
    return result;
  }
}
