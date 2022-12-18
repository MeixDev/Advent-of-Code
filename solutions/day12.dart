import '../utils/index.dart';

import 'dart:math' as math;

int convertCharToElevation(String s) {
  switch (s) {
    case 'S':
      return 0;
    case 'E':
      return 25;
    default:
      final value = s.codeUnitAt(0) - 97;
      return value;
  }
}

class Maze {
  List<List<Tile>> tiles;
  Tile start;
  Tile goal;

  Maze(this.tiles, this.start, this.goal);

  factory Maze.parse(String map) {
    final tiles = <List<Tile>>[];
    final rows = map.trim().split('\n');
    Tile? start;
    Tile? goal;

    for (var rowNum = 0; rowNum < rows.length; rowNum++) {
      final row = <Tile>[];
      final lineTiles = rows[rowNum].trim().split('');

      for (var colNum = 0; colNum < lineTiles.length; colNum++) {
        final t = lineTiles[colNum];
        final tile = Tile(colNum, rowNum, convertCharToElevation(t));
        if (t == 'S') {
          start = tile;
        }
        if (t == 'E') {
          goal = tile;
        }
        row.add(tile);
      }

      tiles.add(row);
    }

    return Maze(tiles, start!, goal!);
  }
}

class Tile {
  final int x, y;
  final int elevation;
  final int _hashcode;
  final String _str;

  Tile(this.x, this.y, this.elevation)
      : _hashcode = '$x,$y'.hashCode,
        _str = '[X:$x, Y:$y]';

  @override
  String toString() => _str;

  @override
  int get hashCode => _hashcode;

  @override
  bool operator ==(Object other) =>
      other is Tile && x == other.x && y == other.y;
}

double heuristic(Tile tile, Tile goal) {
  final x = tile.x - goal.x;
  final y = tile.y - goal.y;
  return math.sqrt(x * x + y * y);
}

class Day12 extends GenericDay {
  Day12() : super(12);
  @override
  Maze parseInput() {
    final inputUtil = InputUtil(12);
    final textMap = inputUtil.asString;
    final maze = Maze.parse(textMap);
    return maze;
  }

  Iterable<L>? aStarPath<L>({
    required L start,
    required L goal,
    required double Function(L) estimatedDistance,
    required double Function(L, L) costTo,
    required Iterable<L> Function(L) neighborsOf,
  }) {
    final cameFrom = <L, L>{};
    final gScore = <L, double>{start: 0};
    final fScore = <L, double>{start: estimatedDistance(start)};
    int compareByScore(L a, L b) =>
        (fScore[a] ?? double.infinity).compareTo(fScore[b] ?? double.infinity);
    final openHeap = PriorityQueue<L>(compareByScore)..add(start);
    final openSet = {start};

    while (openSet.isNotEmpty) {
      L current = openHeap.removeFirst();
      openSet.remove(current);
      if (current == goal) {
        final path = [current];
        while (cameFrom.keys.contains(current)) {
          current = cameFrom[current] as L;
          path.insert(0, current);
        }
        return path;
      }
      for (final neighbor in neighborsOf(current)) {
        final tentativeScore =
            (gScore[current] ?? double.infinity) + costTo(current, neighbor);
        if (tentativeScore < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeScore;
          fScore[neighbor] = tentativeScore + estimatedDistance(neighbor);
          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
            openHeap.add(neighbor);
          }
        }
      }
    }
    return null;
  }

  @override
  int solvePart1() {
    final maze = parseInput();
    final path = aStarPath<Tile>(
      start: maze.start,
      goal: maze.goal,
      estimatedDistance: (tile) => heuristic(tile, maze.goal),
      costTo: (a, b) {
        final elevationDiff = b.elevation - a.elevation;
        if (elevationDiff > 1) {
          return double.infinity;
        }
        return 1;
      },
      neighborsOf: (tile) {
        final neighbors = <Tile>[];
        final x = tile.x;
        final y = tile.y;
        if (x > 0) {
          neighbors.add(maze.tiles[y][x - 1]);
        }
        if (x < maze.tiles[y].length - 1) {
          neighbors.add(maze.tiles[y][x + 1]);
        }
        if (y > 0) {
          neighbors.add(maze.tiles[y - 1][x]);
        }
        if (y < maze.tiles.length - 1) {
          neighbors.add(maze.tiles[y + 1][x]);
        }
        return neighbors;
      },
    );
    return path!.length - 1;
  }

  @override
  int solvePart2() {
    final maze = parseInput();
    final List<Iterable<Tile>> paths = [];
    for (final tilesRow in maze.tiles) {
      for (final tile in tilesRow) {
        if (tile.elevation == 0) {
          final path = aStarPath<Tile>(
            start: tile,
            goal: maze.goal,
            estimatedDistance: (tile) => heuristic(tile, maze.goal),
            costTo: (a, b) {
              final elevationDiff = b.elevation - a.elevation;
              if (elevationDiff > 1) {
                return double.infinity;
              }
              return 1;
            },
            neighborsOf: (tile) {
              final neighbors = <Tile>[];
              final x = tile.x;
              final y = tile.y;
              if (x > 0) {
                neighbors.add(maze.tiles[y][x - 1]);
              }
              if (x < maze.tiles[y].length - 1) {
                neighbors.add(maze.tiles[y][x + 1]);
              }
              if (y > 0) {
                neighbors.add(maze.tiles[y - 1][x]);
              }
              if (y < maze.tiles.length - 1) {
                neighbors.add(maze.tiles[y + 1][x]);
              }
              return neighbors;
            },
          );
          if (path != null) {
            paths.add(path);
          }
        }
      }
    }
    final returnPath = paths.reduce(
        (value, element) => value.length < element.length ? value : element);
    return returnPath.length - 1;
  }
}
