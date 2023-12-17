import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class CityBlock {
  int heatLoss;

  CityBlock(this.heatLoss);
}

class PointInDirection extends Equatable {
  final Point point;
  final Direction direction;
  final int line;

  PointInDirection(this.point, this.direction, this.line);

  List<PointInDirection> neighbors() {
    final List<PointInDirection> neighbors = [];
    if (line < 3) {
      neighbors.add(PointInDirection(
          point + direction.pointPositiveDown, direction, line + 1));
    }
    neighbors.add(PointInDirection(
        point + direction.left.pointPositiveDown, direction.left, 1));
    neighbors.add(PointInDirection(
        point + direction.right.pointPositiveDown, direction.right, 1));
    return neighbors;
  }

  List<PointInDirection> ultraCrucibleNeighbors() {
    final List<PointInDirection> neighbors = [];
    if (line < 10) {
      neighbors.add(PointInDirection(
          point + direction.pointPositiveDown, direction, line + 1));
    }
    if (line >= 4) {
      neighbors.add(PointInDirection(
          point + direction.left.pointPositiveDown, direction.left, 1));
      neighbors.add(PointInDirection(
          point + direction.right.pointPositiveDown, direction.right, 1));
    }
    return neighbors;
  }

  @override
  List<Object?> get props => [point, direction, line];

  operator ==(Object other) {
    if (other is PointInDirection) {
      return point == other.point &&
          direction == other.direction &&
          line == other.line;
    }
    return false;
  }

  @override
  int get hashCode =>
      (point.x * 1000) ^
      (point.y * 100) ^
      (direction.hashCode * 10) ^
      line.hashCode;
}

int solveAStar(List<List<CityBlock>> map) {
  final start = PointInDirection(Point(0, 0), Direction.RIGHT, 0);
  final end = Point(map.length - 1, map[0].length - 1);
  final path = findShortestPathByPredicate(
      start: start,
      endCondition: (p) => p.point == end,
      neighbors: (p) {
        final neighbors = p.neighbors();
        return neighbors
            .where((n) =>
                n.point.x >= 0 &&
                n.point.y >= 0 &&
                n.point.x < map.length &&
                n.point.y < map[0].length)
            .toList();
      },
      cost: (_, next) => map[next.point.x][next.point.y].heatLoss,
      heuristic: (_) => 0);
  return path.getEndScore();
}

int solveUltraAStar(List<List<CityBlock>> map) {
  final start = PointInDirection(Point(0, 0), Direction.DOWN, 0);
  final end = Point(map.length - 1, map[0].length - 1);
  final path = findShortestPathByPredicate(
      start: start,
      endCondition: (p) => p.point == end && p.line >= 4,
      neighbors: (p) {
        final neighbors = p.ultraCrucibleNeighbors();
        return neighbors
            .where((n) =>
                n.point.x >= 0 &&
                n.point.y >= 0 &&
                n.point.x < map.length &&
                n.point.y < map[0].length)
            .toList();
      },
      cost: (_, next) => map[next.point.x][next.point.y].heatLoss,
      heuristic: (_) => 0);
  return path.getEndScore();
}

class Day17 extends GenericDay {
  Day17() : super(17);

  void parseLines(List<String> lines) {}

  @override
  List<List<CityBlock>> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<List<CityBlock>> map = [];
    for (int x = 0; x < lines.length; x++) {
      final List<CityBlock> row = [];
      for (int y = 0; y < lines[x].length - 1; y++) {
        row.add(CityBlock(int.parse(lines[x][y])));
      }
      map.add(row);
    }
    return map;
  }

  @override
  int solvePart1() {
    final map = parseInput();
    final score = solveAStar(map);
    return score;
  }

  @override
  int solvePart2() {
    final map = parseInput();
    final score = solveUltraAStar(map);
    return score;
  }
}
