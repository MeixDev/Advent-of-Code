import 'package:color/color.dart';

import '../utils/index.dart';

class LagoonPoint {
  final Point point;
  final HexColor color;

  LagoonPoint({
    required this.point,
    required this.color,
  });
}

class LagoonEdge {
  final Direction direction;
  final int length;
  final HexColor color;

  LagoonEdge({
    required this.direction,
    required this.length,
    required this.color,
  });
}

class Day18 extends GenericDay {
  Day18() : super(18);

  void parseLines(List<String> lines) {}

  Direction directionFromString(String s) {
    switch (s) {
      case "R":
        return Direction.RIGHT;
      case "L":
        return Direction.LEFT;
      case "U":
        return Direction.UP;
      case "D":
        return Direction.DOWN;
    }
    throw Exception("Invalid direction: $s");
  }

  @override
  List<LagoonEdge> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<LagoonEdge> edges = [];
    for (final line in lines) {
      final parts = line.split(' ');
      final direction = directionFromString(parts[0]);
      final length = int.parse(parts[1]);
      final color = HexColor(
          parts[2].substring(parts[2].indexOf("(") + 1, parts[2].indexOf(")")));
      edges.add(LagoonEdge(
        direction: direction,
        length: length,
        color: color,
      ));
    }
    return edges;
  }

  // Shoelace Formula
  // See: https://www.101computing.net/the-shoelace-algorithm/
  int polygonArea(List<Point> points) {
    num area = 0;
    num sum1 = 0;
    num sum2 = 0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      sum1 += points[i].x * points[j].y;
      sum2 += points[j].x * points[i].y;
    }
    area = (sum1 - sum2).abs() / 2;
    return area.floor();
  }

  int solve(List<LagoonEdge> edges) {
    final points = <Point>[];
    int edgeCounter = 0;
    for (final edge in edges) {
      final lastPoint = points.isEmpty ? Point(0, 0) : points.last;
      final newPoint = Point(
          lastPoint.x + edge.direction.pointPositiveDown.x * edge.length,
          lastPoint.y + edge.direction.pointPositiveDown.y * edge.length);
      points.add(newPoint);
      edgeCounter += edge.length;
    }
    final area = polygonArea(points);
    final result = area + edgeCounter ~/ 2 + 1;
    return result;
  }

  @override
  int solvePart1() {
    final edges = parseInput();
    return solve(edges);
  }

  List<LagoonEdge> convertHexa(List<LagoonEdge> edges) {
    final trueEdges = <LagoonEdge>[];
    final directionList = [
      Direction.RIGHT,
      Direction.DOWN,
      Direction.LEFT,
      Direction.UP,
    ];
    for (final edge in edges) {
      final color = edge.color.toString();
      final value = int.parse(color.substring(0, color.length - 1), radix: 16);
      final _dir = int.parse(color[color.length - 1]);
      final direction = directionList[_dir];
      trueEdges.add(LagoonEdge(
        color: edge.color,
        length: value,
        direction: direction,
      ));
    }
    return trueEdges;
  }

  @override
  int solvePart2() {
    final oldEdges = parseInput();
    final edges = convertHexa(oldEdges);
    return solve(edges);
  }
}
