import 'dart:math';

import 'package:equatable/equatable.dart';

import '../utils/index.dart';

enum LongWalkTile {
  path('.'),
  forest('#'),
  slopeDown('v'),
  slopeUp('^'),
  slopeLeft('<'),
  slopeRight('>');

  final String value;
  const LongWalkTile(this.value);
}

class PointWalk extends Equatable {
  final Point point;
  final LongWalkTile tile;

  PointWalk(this.point, this.tile);

  @override
  List<Object?> get props => [point, tile];
}

class Day23 extends GenericDay {
  Day23() : super(23);

  void parseLines(List<String> lines) {}

  @override
  List<List<PointWalk>> parseInput({bool noSlopes = false}) {
    final lines = input.getPerLine();
    final result = <List<PointWalk>>[];
    int y = 0;
    for (final line in lines) {
      int x = 0;
      final row = <PointWalk>[];
      for (final char in line.split('')) {
        switch (char) {
          case '#':
            row.add(PointWalk(Point(x, y), LongWalkTile.forest));
            break;
          case '.':
            row.add(PointWalk(Point(x, y), LongWalkTile.path));
            break;
          case 'v':
            if (noSlopes) {
              row.add(PointWalk(Point(x, y), LongWalkTile.path));
              break;
            }
            row.add(PointWalk(Point(x, y), LongWalkTile.slopeDown));
            break;
          case '^':
            if (noSlopes) {
              row.add(PointWalk(Point(x, y), LongWalkTile.path));
              break;
            }
            row.add(PointWalk(Point(x, y), LongWalkTile.slopeUp));
            break;
          case '<':
            if (noSlopes) {
              row.add(PointWalk(Point(x, y), LongWalkTile.path));
              break;
            }
            row.add(PointWalk(Point(x, y), LongWalkTile.slopeLeft));
            break;
          case '>':
            if (noSlopes) {
              row.add(PointWalk(Point(x, y), LongWalkTile.path));
              break;
            }
            row.add(PointWalk(Point(x, y), LongWalkTile.slopeRight));
            break;
        }
        x++;
      }
      result.add(row);
      y++;
    }
    return result;
  }

  late final List<List<bool>> visited;
  late final List<List<int>> scoreGrid;

  void visitP1(List<List<PointWalk>> input, int y, int x, int steps) {
    if (input[y][x].tile == LongWalkTile.forest) {
      return;
    }
    if (visited[y][x]) {
      return;
    }
    visited[y][x] = true;
    scoreGrid[y][x] = max(scoreGrid[y][x], steps);

    if ((x > 0) &&
        (input[y][x].tile == LongWalkTile.path ||
            input[y][x].tile == LongWalkTile.slopeLeft)) {
      visitP1(input, y, x - 1, steps + 1);
    }
    if ((x < input[0].length - 1) &&
        (input[y][x].tile == LongWalkTile.path ||
            input[y][x].tile == LongWalkTile.slopeRight)) {
      visitP1(input, y, x + 1, steps + 1);
    }
    if ((y > 0) &&
        (input[y][x].tile == LongWalkTile.path ||
            input[y][x].tile == LongWalkTile.slopeUp)) {
      visitP1(input, y - 1, x, steps + 1);
    }
    if ((y < input.length - 1) &&
        (input[y][x].tile == LongWalkTile.path ||
            input[y][x].tile == LongWalkTile.slopeDown)) {
      visitP1(input, y + 1, x, steps + 1);
    }
    visited[y][x] = false;
  }

  @override
  int solvePart1() {
    final map = parseInput();
    // Display map
    // for (final row in map) {
    //   for (final point in row) {
    //     stdout.write(point.tile.value);
    //   }
    //   stdout.write('\n');
    // }
    visited = List.generate(
      map.length,
      (_) => List.generate(map[0].length, (_) => false),
    );
    scoreGrid = List.generate(
      map.length,
      (_) => List.generate(map[0].length, (_) => 0),
    );
    visitP1(map, 0, 1, 0);
    return scoreGrid[map.length - 1][map[0].length - 2];
  }

  late final Map<Point, int> maxPaths;
  late final Map<Point, bool> visitedP2;

  void visitP2(
    Set<Point> nodes,
    Map<Point, Map<Point, int>> edges,
    Point node,
    int path,
  ) {
    if (visitedP2.containsKey(node) && visitedP2[node]!) {
      return;
    }
    visitedP2[node] = true;

    maxPaths[node] = max(maxPaths[node] ?? 0, path);

    if (edges.keys.any((element) => element == node)) {
      for (final edge in edges[node]!.entries) {
        visitP2(nodes, edges, edge.key, path + edge.value);
      }
    }
    visitedP2[node] = false;
  }

  @override
  int solvePart2() {
    // final map = parseInput(noSlopes: true);
    final map = parseInput();
    final nodes = <Point>{};
    nodes.add(Point(1, 0));
    nodes.add(Point(map[0].length - 2, map.length - 1));
    for (int j = 0; j < map.length; j++) {
      for (int i = 0; i < map[0].length; i++) {
        if (map[j][i].tile == LongWalkTile.forest) continue;
        int neighbors = 0;
        if (i > 0)
          neighbors += map[j][i - 1].tile != LongWalkTile.forest ? 1 : 0;
        if (i < map[0].length - 1)
          neighbors += map[j][i + 1].tile != LongWalkTile.forest ? 1 : 0;
        if (j > 0)
          neighbors += map[j - 1][i].tile != LongWalkTile.forest ? 1 : 0;
        if (j < map.length - 1)
          neighbors += map[j + 1][i].tile != LongWalkTile.forest ? 1 : 0;
        if (neighbors > 2) {
          nodes.add(Point(i, j));
        }
      }
    }

    ({int y, int x, int length}) findLength(int y, int x, LongWalkTile tile) {
      final visitedInline = <Point>{};

      bool isVisited(int y, int x) {
        // print('isVisited($y, $x)');
        // print(
        //     '${visitedInline.any((element) => element.x == x && element.y == y)}');
        return visitedInline.any((element) => element.x == x && element.y == y);
      }

      visitedInline.add(Point(x, y));
      switch (tile) {
        case LongWalkTile.slopeLeft:
          x -= 1;
          break;
        case LongWalkTile.slopeRight:
          x += 1;
          break;
        case LongWalkTile.slopeUp:
          y -= 1;
          break;
        case LongWalkTile.slopeDown:
          y += 1;
          break;
        default:
          break;
      }

      int length = 0;
      if (map[y][x].tile == LongWalkTile.forest) {
        return (y: y, x: x, length: length);
      }

      while (!nodes.any((element) => element.x == x && element.y == y)) {
        // while (nodes.contains(Point(x, y))) {
        length++;
        visitedInline.add(Point(x, y));
        if ((x > 0) &&
            (map[y][x - 1].tile != LongWalkTile.forest) &&
            !isVisited(y, x - 1))
          x -= 1;
        else if ((y > 0) &&
            (map[y - 1][x].tile != LongWalkTile.forest) &&
            !isVisited(y - 1, x))
          y -= 1;
        else if ((x < map[0].length - 1) &&
            (map[y][x + 1].tile != LongWalkTile.forest) &&
            !isVisited(y, x + 1))
          x += 1;
        else if ((y < map.length - 1) &&
            (map[y + 1][x].tile != LongWalkTile.forest) &&
            !isVisited(y + 1, x)) y += 1;
      }
      return (y: y, x: x, length: length + 1);
    }

    final edges = <Point, Map<Point, int>>{};

    for (final node in nodes) {
      final originY = node.y;
      final originX = node.x;
      if (originX > 0) {
        final res = findLength(originY, originX, LongWalkTile.slopeLeft);
        final y = res.y;
        final x = res.x;
        final length = res.length;
        if (length > 1) {
          edges.putIfAbsent(Point(originX, originY), () => {});
          edges[Point(originX, originY)]!
              .putIfAbsent(Point(x, y), () => length);
          edges[Point(originX, originY)]![Point(x, y)] = length;
        }
      }
      if (originX < map[0].length - 1) {
        final res = findLength(originY, originX, LongWalkTile.slopeRight);
        final y = res.y;
        final x = res.x;
        final length = res.length;
        if (length > 1) {
          edges.putIfAbsent(Point(originX, originY), () => {});
          edges[Point(originX, originY)]!
              .putIfAbsent(Point(x, y), () => length);
          edges[Point(originX, originY)]![Point(x, y)] = length;
        }
      }
      if (originY > 0) {
        final res = findLength(originY, originX, LongWalkTile.slopeUp);
        final y = res.y;
        final x = res.x;
        final length = res.length;
        if (length > 1) {
          edges.putIfAbsent(Point(originX, originY), () => {});
          edges[Point(originX, originY)]!
              .putIfAbsent(Point(x, y), () => length);
          edges[Point(originX, originY)]![Point(x, y)] = length;
        }
      }
      if (originY < map.length - 1) {
        final res = findLength(originY, originX, LongWalkTile.slopeDown);
        final y = res.y;
        final x = res.x;
        final length = res.length;
        if (length > 1) {
          edges.putIfAbsent(Point(originX, originY), () => {});
          edges[Point(originX, originY)]!
              .putIfAbsent(Point(x, y), () => length);
          edges[Point(originX, originY)]![Point(x, y)] = length;
        }
      }
    }
    maxPaths = <Point, int>{};
    visitedP2 = <Point, bool>{};
    visitP2(nodes, edges, Point(1, 0), 0);

    return maxPaths[Point(map[0].length - 2, map.length - 1)]!;
  }
}
