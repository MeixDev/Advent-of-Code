import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../utils/index.dart';

enum GardenTile {
  passable,
  wall,
}

class GardenPointAtStep extends Equatable {
  final GardenTile tile;
  final Point point;
  final int step;

  GardenPointAtStep(this.tile, this.point, this.step);

  factory GardenPointAtStep.fromPoint(GardenPoint point, int newStep) {
    return GardenPointAtStep(point.tile, point.point, newStep);
  }

  List<GardenPointAtStep> neighbors(List<List<GardenPoint>> map) {
    final List<GardenPointAtStep> neighbors = [];
    if (point.x > 0) {
      if (map[point.y][point.x - 1].tile == GardenTile.passable)
        neighbors.add(
            GardenPointAtStep.fromPoint(map[point.y][point.x - 1], step + 1));
    }
    if (point.x < map[point.y].length - 1) {
      if (map[point.y][point.x + 1].tile == GardenTile.passable)
        neighbors.add(
            GardenPointAtStep.fromPoint(map[point.y][point.x + 1], step + 1));
    }
    if (point.y > 0) {
      if (map[point.y - 1][point.x].tile == GardenTile.passable)
        neighbors.add(
            GardenPointAtStep.fromPoint(map[point.y - 1][point.x], step + 1));
    }
    if (point.y < map.length - 1) {
      if (map[point.y + 1][point.x].tile == GardenTile.passable)
        neighbors.add(
            GardenPointAtStep.fromPoint(map[point.y + 1][point.x], step + 1));
    }
    return neighbors;
  }

  @override
  List<Object?> get props => [tile, point, step];

  operator ==(Object other) {
    if (other is GardenPointAtStep) {
      return tile == other.tile && point == other.point && step == other.step;
    }
    throw Exception("Invalid comparison");
  }
}

class GardenPoint extends Equatable {
  final GardenTile tile;
  final Point point;

  GardenPoint(this.tile, this.point);

  List<GardenPoint> neighbors(List<List<GardenPoint>> map) {
    final List<GardenPoint> neighbors = [];
    if (point.x > 0) {
      if (map[point.y][point.x - 1].tile == GardenTile.passable)
        neighbors.add(map[point.y][point.x - 1]);
    }
    if (point.x < map[point.y].length - 1) {
      if (map[point.y][point.x + 1].tile == GardenTile.passable)
        neighbors.add(map[point.y][point.x + 1]);
    }
    if (point.y > 0) {
      if (map[point.y - 1][point.x].tile == GardenTile.passable)
        neighbors.add(map[point.y - 1][point.x]);
    }
    if (point.y < map.length - 1) {
      if (map[point.y + 1][point.x].tile == GardenTile.passable)
        neighbors.add(map[point.y + 1][point.x]);
    }
    return neighbors;
  }

  @override
  List<Object?> get props => [tile, point];

  operator ==(Object other) {
    if (other is GardenPoint) {
      return tile == other.tile && point == other.point;
    }
    throw Exception("Invalid comparison");
  }
}

class Garden {
  List<List<GardenPoint>> map;
  Point start;

  Garden({required this.map, required this.start});

  GardenPoint get(Point point) {
    return map[point.y][point.x];
  }
}

// int solveAStarGarden(Garden garden, int maxSteps) {
//   final start = GardenPointAtStep.fromPoint(garden.get(garden.start), 0);
//   // We want to get all acccessible tiles in a maximum of 64 steps
//   final path = findShortestPathByPredicate<GardenPointAtStep>(
//     start: start,
//     endCondition: (GardenPointAtStep point) => point.step == maxSteps,
//     neighbors: (GardenPointAtStep point) {
//       final neighbors = point.neighbors(garden.map);
//       return neighbors;
//     },
//     cost: (GardenPointAtStep a, GardenPointAtStep b) => 1,
//     heuristic: (GardenPointAtStep point) => 0,
//   );
//   int score = 0;
//   final pointsOk = <Point>[];
//   for (final entry in path.result.entries) {
//     if (entry.value.cost == maxSteps - 1) {
//       score++;
//       pointsOk.add(entry.key.point);
//     }
//   }
//   for (final row in garden.map) {
//     print(row
//         .map((e) => pointsOk.contains(e.point)
//             ? 'O'
//             : (e.tile == GardenTile.passable ? '.' : '#'))
//         .join(''));
//   }
//   return score;
// }

class Day21 extends GenericDay {
  Day21() : super(21);

  void parseLines(List<String> lines) {}

  @override
  Garden parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<List<GardenPoint>> garden = [];
    late final Point start;
    for (final line in lines) {
      final row = <GardenPoint>[];
      for (final c in line.split('')) {
        final point = Point(row.length, garden.length);
        switch (c) {
          case '.':
            row.add(GardenPoint(GardenTile.passable, point));
            break;
          case '#':
            row.add(GardenPoint(GardenTile.wall, point));
            break;
          case 'S':
            start = Point(row.length, garden.length);
            row.add(GardenPoint(GardenTile.passable, point));
            break;
        }
      }
      garden.add(row);
    }
    return Garden(map: garden, start: start);
  }

  @override
  int solvePart1() {
    final garden = parseInput();
    final map = garden.map;
    final gridSize = map.length;
    // final start = Point(garden.start.y, garden.start.x);
    final start = garden.start;
    HashSet<Point> visited = HashSet();
    visited.add(start);
    for (int i = 0; i < 64; i++) {
      visited = HashSet.from(visited.expand((point) {
        final neighbors = point.neighbors;
        final validNeighbors = neighbors.where((e) =>
            e.x >= 0 &&
            e.y >= 0 &&
            e.x < gridSize &&
            e.y < gridSize &&
            map[e.y][e.x].tile == GardenTile.passable);
        return validNeighbors;
      }));
    }
    return visited.length;
  }

  @override
  int solvePart2() {
    final garden = parseInput();
    final map = garden.map;
    final gridSize = map.length;
    // final start = Point(garden.start.y, garden.start.x);
    final absurdSteps = 26501365;
    // final absurdSteps = 5000;
    final gridsCount = absurdSteps ~/ gridSize;
    final remains = absurdSteps % gridSize;
    final start = garden.start;

    final sequence = <int>[];
    HashSet<Point> visited = HashSet();
    visited.add(start);
    int steps = 0;
    for (int i = 0; i < 3; i++) {
      for (; steps < i * gridSize + remains; steps++) {
        // Hurray for the funky modulo trick to keep a positive index.
        // Wish I remembered from where I learnt that.
        visited = HashSet.from(visited.expand((point) {
          final neighbors = point.neighbors;
          final validNeighbors = neighbors.where((e) =>
              map[((e.y % gridSize) + gridSize) % gridSize]
                      [((e.x % gridSize) + gridSize) % gridSize]
                  .tile ==
              GardenTile.passable);
          return validNeighbors;
        }));
      }
      sequence.add(visited.length);
    }

    // Thanks to the sequence, we can now solve the quadratic
    // result = a * n^2 + b * n + c
    final c = sequence[0];
    final tmp1 = sequence[1] - sequence[0];
    final tmp2 = sequence[2] - sequence[0];
    final tmp3 = tmp2 - (2 * tmp1);
    final a = tmp3 ~/ 2;
    final b = tmp1 - a;
    final result = quadraticGoBrrrr(gridsCount, a, b, c);
    return result;
  }

  int quadraticGoBrrrr(int x, int a, int b, int c) {
    return a * (x * x) + b * x + c;
  }
}
