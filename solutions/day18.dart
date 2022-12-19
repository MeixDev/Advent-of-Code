import '../utils/index.dart';
import 'dart:math' as math;

typedef Array3D = List<List<List<bool>>>;

class Point3D {
  int x;
  int y;
  int z;
  Point3D(this.x, this.y, this.z);

  List<Point3D> get neighbors {
    final List<Point3D> neighbors = [];
    for (int dz = -1; dz <= 1; dz++) {
      for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
          if (dx.abs() + dy.abs() + dz.abs() == 1) {
            neighbors.add(Point3D(x + dx, y + dy, z + dz));
          }
        }
      }
    }
    return neighbors;
  }

  bool operator ==(other) {
    return other is Point3D && other.x == x && other.y == y && other.z == z;
  }

  @override
  int get hashCode => this.z * 1000000 + this.y * 1000 + this.x;
}

class Day18 extends GenericDay {
  Day18() : super(18);
  @override
  Array3D parseInput() {
    final inputUtil = InputUtil(18);
    final lines = inputUtil.getPerLine();
    final Array3D space3d = List.generate(
      30,
      (index) => List.generate(
        30,
        (index) => List.filled(30, false),
      ),
    );
    for (final line in lines) {
      final coords = line.split(',');
      final x = int.parse(coords[0]);
      final y = int.parse(coords[1]);
      final z = int.parse(coords[2]);
      space3d[z][y][x] = true;
    }
    return space3d;
  }

  @override
  int solvePart1() {
    final stopwatch = Stopwatch()..start();
    final space3d = parseInput();
    int score = 0;
    for (int z = 0; z < space3d.length; z++) {
      for (int y = 0; y < space3d[z].length; y++) {
        for (int x = 0; x < space3d[z][y].length; x++) {
          if (!space3d[z][y][x]) {
            continue;
          }
          // check z differences
          if (z > 0) {
            if (!space3d[z - 1][y][x]) {
              score += 1;
            }
          } else {
            score += 1;
          }
          if (z < space3d.length - 1) {
            if (!space3d[z + 1][y][x]) {
              score += 1;
            }
          } else {
            score += 1;
          }
          // check y differences
          if (y > 0) {
            if (!space3d[z][y - 1][x]) {
              score += 1;
            }
          } else {
            score += 1;
          }
          if (y < space3d[z].length - 1) {
            if (!space3d[z][y + 1][x]) {
              score += 1;
            }
          } else {
            score += 1;
          }
          // check x differences
          if (x > 0) {
            if (!space3d[z][y][x - 1]) {
              score += 1;
            }
          } else {
            score += 1;
          }
          if (x < space3d[z][y].length - 1) {
            if (!space3d[z][y][x + 1]) {
              score += 1;
            }
          } else {
            score += 1;
          }
        }
      }
    }
    stopwatch.stop();
    print("${stopwatch.elapsedMilliseconds} ms");
    return score;
  }

  List<Point3D> parseInputP2() {
    final inputUtil = InputUtil(18);
    final lines = inputUtil.getPerLine();
    final List<Point3D> points = [];
    for (final line in lines) {
      final coords = line.split(',');
      final x = int.parse(coords[0]);
      final y = int.parse(coords[1]);
      final z = int.parse(coords[2]);
      points.add(Point3D(x, y, z));
    }
    return points;
  }

  @override
  int solvePart2() {
    final stopwatch = Stopwatch()..start();
    final Set<Point3D> missing = {};
    int score = 0;
    final points = parseInputP2();
    for (final point in points) {
      final neighbors = point.neighbors;
      for (final neighbor in neighbors) {
        if (!points.contains(neighbor)) {
          missing.add(neighbor);
        }
      }
    }

    final minX = points.map((e) => e.x).reduce(math.min);
    final minY = points.map((e) => e.y).reduce(math.min);
    final minZ = points.map((e) => e.z).reduce(math.min);
    final maxX = points.map((e) => e.x).reduce(math.max);
    final maxY = points.map((e) => e.y).reduce(math.max);
    final maxZ = points.map((e) => e.z).reduce(math.max);

    for (final missingPoint in missing) {
      final seen = Set<Point3D>();
      seen.add(missingPoint);
      final queue = List<Point3D>.from(seen);
      // is an interior point unless proven otherwise
      bool interior = true;
      outerloop:
      while (queue.isNotEmpty) {
        final next = queue.first;
        queue.removeAt(0);
        for (final neighbor in next.neighbors) {
          if (neighbor.x < minX ||
              neighbor.x > maxX ||
              neighbor.y < minY ||
              neighbor.y > maxY ||
              neighbor.z < minZ ||
              neighbor.z > maxZ) {
            interior = false;
            break outerloop;
          }
          if (points.contains(neighbor)) {
            continue;
          }
          if (!seen.contains(neighbor)) {
            seen.add(neighbor);
            queue.add(neighbor);
          }
        }
      }
      if (interior) {
        points.addAll(seen);
      }
    }

    for (final point in points) {
      final neighbors = point.neighbors;
      for (final neighbor in neighbors) {
        if (!points.contains(neighbor)) {
          score += 1;
        }
      }
    }
    stopwatch.stop();
    print("${stopwatch.elapsedMilliseconds} ms");
    return score;
  }
}
