import '../utils/index.dart';

enum GalaxyTile {
  empty,
  galaxy,
}

class Galaxy {
  final int x;
  final int y;

  Galaxy(this.x, this.y);
}

class GalaxyMap {
  final List<List<GalaxyTile>> map;
  final List<Galaxy> galaxies;
  final List<int> emptyX;
  final List<int> emptyY;

  GalaxyMap(this.map, this.galaxies, this.emptyX, this.emptyY);
}

class Day11 extends GenericDay {
  Day11() : super(11);

  void parseLines(List<String> lines) {}

  @override
  GalaxyMap parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<List<GalaxyTile>> map = [];
    for (final line in lines) {
      final List<GalaxyTile> row = [];
      for (final char in line.substring(0, line.length - 1).split('')) {
        switch (char) {
          case '.':
            row.add(GalaxyTile.empty);
            break;
          case '#':
            row.add(GalaxyTile.galaxy);
            break;
          default:
            throw Exception('Unknown char $char');
        }
      }
      map.add(row);
    }
    final List<int> emptyX = [];
    final List<int> emptyY = [];
    for (int i = 0; i < map.length; i++) {
      final row = map[i];
      if (row.every((element) => element == GalaxyTile.empty)) {
        emptyY.add(i);
      }
    }
    for (int i = 0; i < map[0].length; i++) {
      final column = map.map((e) => e[i]);
      if (column.every((element) => element == GalaxyTile.empty)) {
        emptyX.add(i);
      }
    }
    final List<Galaxy> galaxies = [];
    for (int y = 0; y < map.length; y++) {
      final row = map[y];
      for (int x = 0; x < row.length; x++) {
        final tile = row[x];
        if (tile == GalaxyTile.galaxy) {
          galaxies.add(Galaxy(x, y));
        }
      }
    }
    final galaxyMap = GalaxyMap(map, galaxies, emptyX, emptyY);
    // print(galaxyMap.map
    //     .map((e) => e.map((e) => e == GalaxyTile.empty ? '.' : '#').join(''))
    //     .join('\n'));
    return galaxyMap;
  }

  int solve(int expansionSize) {
    final map = parseInput();
    final realExpansion = expansionSize - 1;
    final Map<(Galaxy, Galaxy), int> distances = {};
    for (int i = 0; i < map.galaxies.length; i++) {
      final galaxy1 = map.galaxies[i];
      for (int j = i + 1; j < map.galaxies.length; j++) {
        final galaxy2 = map.galaxies[j];
        int distance = (galaxy1.x - galaxy2.x).abs() +
            (galaxy1.y - galaxy2.y).abs(); // Manhattan distance
        // Check if there are emptyX and emptyY in between, and add realExpansion for each
        map.emptyX.forEach((emptyX) {
          if (emptyX > galaxy1.x && emptyX < galaxy2.x ||
              emptyX < galaxy1.x && emptyX > galaxy2.x) {
            distance += realExpansion;
          }
        });
        map.emptyY.forEach((emptyY) {
          if (emptyY > galaxy1.y && emptyY < galaxy2.y ||
              emptyY < galaxy1.y && emptyY > galaxy2.y) {
            distance += realExpansion;
          }
        });
        distances[(galaxy1, galaxy2)] = distance;
      }
    }
    final score = distances.entries
        .map((e) => e.value)
        .reduce((value, element) => value + element);
    return score;
  }

  @override
  int solvePart1() {
    return solve(2);
  }

  @override
  int solvePart2() {
    return solve(1000000);
  }
}
