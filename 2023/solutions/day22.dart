import 'dart:math';

import '../utils/index.dart';

class Brick3D {
  final int x0;
  final int y0;
  final int z0;
  final int x1;
  final int y1;
  final int z1;

  Brick3D(this.x0, this.y0, this.z0, this.x1, this.y1, this.z1);

  List<Point3D> get points {
    final points = <Point3D>[];
    for (var x = x0; x <= x1; x++) {
      for (var y = y0; y <= y1; y++) {
        for (var z = z0; z <= z1; z++) {
          points.add(Point3D(x, y, z));
        }
      }
    }
    return points;
  }
}

class BrickInfo {
  final List<Brick3D> bricks;
  final Map<int, Set<int>> supportingBricks;
  final Map<int, Set<int>> supportedBy;

  BrickInfo({
    required this.bricks,
    required this.supportingBricks,
    required this.supportedBy,
  });
}

class Day22 extends GenericDay {
  Day22() : super(22);

  void parseLines(List<String> lines) {}

  @override
  List<Brick3D> parseInput() {
    final lines = input.getPerLine();
    final bricks = <Brick3D>[];
    for (final line in lines) {
      final parts = line.split('~');
      final coords0 = parts[0].split(',');
      final coords1 = parts[1].split(',');
      bricks.add(Brick3D(
        int.parse(coords0[0]),
        int.parse(coords0[1]),
        int.parse(coords0[2]),
        int.parse(coords1[0]),
        int.parse(coords1[1]),
        int.parse(coords1[2]),
      ));
    }
    return bricks;
  }

  BrickInfo supportGraph() {
    final bricks = parseInput();
    bricks.sort((a, b) => a.z0.compareTo(b.z0));

    final Map<(int, int, int), int> settledPositions = {};
    final Map<(int, int), int> highestZPerPoint = {};

    final Map<int, Set<int>> supportingBricks = {};
    final Map<int, Set<int>> supportedBy = {};

    for (int idx = 0; idx < bricks.length; idx++) {
      final brick = bricks[idx];
      final zList = <int>[
        for (var x = brick.x0; x <= brick.x1; x++)
          for (var y = brick.y0; y <= brick.y1; y++)
            for (var z = brick.z0; z <= brick.z1; z++)
              z - (highestZPerPoint[(x, y)] ?? 0) - 1
      ];
      final deltaZ = minFromList(zList);
      final b = Brick3D(
        brick.x0,
        brick.y0,
        brick.z0 - deltaZ,
        brick.x1,
        brick.y1,
        brick.z1 - deltaZ,
      );
      final bTest = Brick3D(
        brick.x0,
        brick.y0,
        brick.z0 - deltaZ - 1,
        brick.x1,
        brick.y1,
        brick.z1 - deltaZ - 1,
      );
      for (final p in bTest.points) {
        final idx2 = settledPositions[(p.x, p.y, p.z)];
        if (idx2 != null) {
          supportingBricks.putIfAbsent(idx2, () => {}).add(idx);
          supportedBy.putIfAbsent(idx, () => {}).add(idx2);
        }
      }
      for (final p in b.points) {
        settledPositions[(p.x, p.y, p.z)] = idx;
        highestZPerPoint[(p.x, p.y)] =
            max(p.z, highestZPerPoint[(p.x, p.y)] ?? p.z);
      }
      bricks[idx] = b;
    }
    return BrickInfo(
      bricks: bricks,
      supportingBricks: supportingBricks,
      supportedBy: supportedBy,
    );
  }

  int minFromList(List<int> list) {
    int min = list[0];
    for (final element in list) {
      if (element < min) {
        min = element;
      }
    }
    return min;
  }

  @override
  int solvePart1() {
    final brickInfo = supportGraph();
    final bricks = brickInfo.bricks;
    final supportingBricks = brickInfo.supportingBricks;
    final supportedBy = brickInfo.supportedBy;

    int count = 0;

    for (int i = 0; i < bricks.length; i++) {
      final supported = supportingBricks[i] ?? {};
      final supporting = supportedBy.entries
          .where((element) => supported.contains(element.key));
      if (supporting.every((element) => element.value.length != 1)) {
        count++;
      }
    }
    return count;
  }

  @override
  int solvePart2() {
    final brickInfo = supportGraph();
    final bricks = brickInfo.bricks;
    final supportingBricks = brickInfo.supportingBricks;
    final supportedBy = brickInfo.supportedBy;

    int count = 0;

    for (int i = 0; i < bricks.length; i++) {
      final lostSupports = <int>{};
      lostSupports.add(i);

      final todo = supportingBricks[i]?.toList() ?? [];
      while (todo.isNotEmpty) {
        final k = todo.removeLast();
        if (lostSupports.contains(k)) {
          continue;
        }

        final supporting = supportedBy[k] ?? {};
        if (supporting.every((element) => lostSupports.contains(element))) {
          count++;
          lostSupports.add(k);
          todo.addAll(supportingBricks[k] ?? []);
        }
      }
    }
    return count;
  }
}
