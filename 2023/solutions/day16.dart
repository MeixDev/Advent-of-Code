import '../utils/index.dart';

enum BeamDirection {
  up(-1, 0),
  right(0, 1),
  down(1, 0),
  left(0, -1);

  final int x;
  final int y;
  const BeamDirection(this.x, this.y);
}

enum BeamTileType {
  empty,
  mirror1,
  mirror2,
  splitterHorizontal,
  splitterVertical,
}

class BeamTile {
  final BeamTileType type;
  final int x;
  final int y;

  BeamTile(this.type, this.x, this.y);
}

class Beam {
  final int x;
  final int y;
  final BeamDirection direction;

  Beam(this.x, this.y, this.direction);
  bool operator ==(other) {
    return other is Beam &&
        x == other.x &&
        y == other.y &&
        direction == other.direction;
  }

  int get hashCode => x.hashCode ^ y.hashCode ^ direction.hashCode;
}

class Day16 extends GenericDay {
  Day16() : super(16);

  void parseLines(List<String> lines) {}

  @override
  List<List<BeamTile>> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<List<BeamTile>> map = [];
    for (int x = 0; x < lines.length; x++) {
      final List<BeamTile> row = [];
      for (int y = 0; y < lines[x].length - 1; y++) {
        switch (lines[x][y]) {
          case '.':
            row.add(BeamTile(BeamTileType.empty, x, y));
            break;
          case '/':
            row.add(BeamTile(BeamTileType.mirror1, x, y));
            break;
          case '\\':
            row.add(BeamTile(BeamTileType.mirror2, x, y));
            break;
          case '-':
            row.add(BeamTile(BeamTileType.splitterHorizontal, x, y));
            break;
          case '|':
            row.add(BeamTile(BeamTileType.splitterVertical, x, y));
            break;
          default:
            throw Exception('Unknown char ${lines[x][y]}');
        }
      }
      map.add(row);
    }
    return map;
  }

  int bfsSolver(List<List<BeamTile>> map, Beam beam) {
    final List<Beam> beams = [];
    final Set<Beam> visited = {};
    beams.add(beam);
    while (beams.isNotEmpty) {
      final beam = beams.removeAt(0);
      int x = beam.x;
      int y = beam.y;
      BeamDirection direction = beam.direction;
      x += direction.x;
      y += direction.y;
      if (x < 0 || y < 0 || x >= map.length || y >= map[x].length) {
        continue;
      }
      final tile = map[x][y];
      final update = <Beam>[];

      if (tile.type == BeamTileType.empty) {
        update.add(Beam(x, y, direction));
      }
      if (tile.type == BeamTileType.splitterHorizontal) {
        if (direction == BeamDirection.up || direction == BeamDirection.down) {
          update.add(Beam(x, y, BeamDirection.left));
          update.add(Beam(x, y, BeamDirection.right));
        } else {
          update.add(Beam(x, y, direction));
        }
      }
      if (tile.type == BeamTileType.splitterVertical) {
        if (direction == BeamDirection.left ||
            direction == BeamDirection.right) {
          update.add(Beam(x, y, BeamDirection.up));
          update.add(Beam(x, y, BeamDirection.down));
        } else {
          update.add(Beam(x, y, direction));
        }
      }
      if (tile.type == BeamTileType.mirror1) {
        if (direction == BeamDirection.left) {
          update.add(Beam(x, y, BeamDirection.down));
        } else if (direction == BeamDirection.right) {
          update.add(Beam(x, y, BeamDirection.up));
        } else if (direction == BeamDirection.up) {
          update.add(Beam(x, y, BeamDirection.right));
        } else if (direction == BeamDirection.down) {
          update.add(Beam(x, y, BeamDirection.left));
        }
      }
      if (tile.type == BeamTileType.mirror2) {
        if (direction == BeamDirection.left) {
          update.add(Beam(x, y, BeamDirection.up));
        } else if (direction == BeamDirection.right) {
          update.add(Beam(x, y, BeamDirection.down));
        } else if (direction == BeamDirection.up) {
          update.add(Beam(x, y, BeamDirection.left));
        } else if (direction == BeamDirection.down) {
          update.add(Beam(x, y, BeamDirection.right));
        }
      }
      for (final newBeam in update) {
        if (!visited.contains(newBeam)) {
          visited.add(newBeam);
          beams.add(newBeam);
        }
      }
    }
    int count = 0;
    // Only add different coordinates in visited
    Set<(int, int)> visitedCoordinates = {};
    for (final beam in visited) {
      if (!visitedCoordinates.contains((beam.x, beam.y))) {
        visitedCoordinates.add((beam.x, beam.y));
        count++;
      }
    }
    return count;
  }

  @override
  int solvePart1() {
    final map = parseInput();
    return bfsSolver(map, Beam(0, -1, BeamDirection.right));
  }

  @override
  int solvePart2() {
    final map = parseInput();
    int maximumEnergized = 0;
    for (int x = 0; x < map.length; x++) {
      final energy = bfsSolver(map, Beam(x, -1, BeamDirection.right));
      if (energy > maximumEnergized) {
        maximumEnergized = energy;
      }
      final energy2 =
          bfsSolver(map, Beam(x, map[x].length, BeamDirection.left));
      if (energy2 > maximumEnergized) {
        maximumEnergized = energy2;
      }
    }
    for (int y = 0; y < map[0].length; y++) {
      final energy = bfsSolver(map, Beam(-1, y, BeamDirection.down));
      if (energy > maximumEnergized) {
        maximumEnergized = energy;
      }
      final energy2 = bfsSolver(map, Beam(map.length, y, BeamDirection.up));
      if (energy2 > maximumEnergized) {
        maximumEnergized = energy2;
      }
    }
    return maximumEnergized;
  }
}
