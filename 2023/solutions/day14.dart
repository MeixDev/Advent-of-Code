import '../utils/index.dart';

enum PlatformTile {
  empty('.'),
  cubeRock('#'),
  roundRock('O');

  final String char;
  const PlatformTile(this.char);
}

class Platform {
  List<List<PlatformTile>> ogMap;

  Platform(this.ogMap);
}

class Day14 extends GenericDay {
  Day14() : super(14);

  void parseLines(List<String> lines) {}

  @override
  Platform parseInput() {
    final lines = input.getPerLine();
    final List<List<PlatformTile>> map = [];
    for (final line in lines) {
      final List<PlatformTile> row = [];
      for (final char in line.substring(0, line.length - 1).split('')) {
        switch (char) {
          case '.':
            row.add(PlatformTile.empty);
            break;
          case '#':
            row.add(PlatformTile.cubeRock);
            break;
          case 'O':
            row.add(PlatformTile.roundRock);
            break;
          default:
            throw Exception('Unknown char $char');
        }
      }
      map.add(row);
    }
    return Platform(map);
  }

  @override
  int solvePart1() {
    final map = parseInput();
    final List<List<PlatformTile>> tiltedMap = map.ogMap;
    int x = 0;
    while (x < tiltedMap.length) {
      // Tilting all round rock to the north
      for (int y = 0; y < tiltedMap[x].length; y++) {
        if (tiltedMap[x][y] == PlatformTile.roundRock) {
          int newX = x;
          while (newX > 0 && tiltedMap[newX - 1][y] == PlatformTile.empty) {
            newX--;
          }
          if (newX != x) {
            tiltedMap[newX][y] = PlatformTile.roundRock;
            tiltedMap[x][y] = PlatformTile.empty;
          }
        }
      }
      x++;
    }
    int load = 0;
    x = 0;
    while (x < tiltedMap.length) {
      for (int y = 0; y < tiltedMap[x].length; y++) {
        if (tiltedMap[x][y] == PlatformTile.roundRock) {
          load += tiltedMap.length - x;
        }
      }
      x++;
    }
    // print(map.ogMap
    //     .map((row) => row.map((tile) => tile.char).join(''))
    //     .join('\n'));
    // print('\n---------------\n');
    // print(tiltedMap
    //     .map((row) => row.map((tile) => tile.char).join(''))
    //     .join('\n'));
    return load;
  }

  @override
  int solvePart2() {
    final map = parseInput();
    final List<List<PlatformTile>> tiltedMap = map.ogMap;
    final Map<int, String> seen = {};
    bool foundLoop = false;
    for (int iterations = 0; iterations < 1000000000; iterations++) {
      if (!foundLoop) {
        final strVisualization = tiltedMap
            .map((row) => row.map((tile) => tile.char).join(''))
            .join('\n');
        if (seen.containsValue(strVisualization)) {
          final firstSeen = seen.entries
              .firstWhere((entry) => entry.value == strVisualization);
          print('Found a loop at $iterations with ${firstSeen.key}');
          final loopLength = iterations - firstSeen.key;
          final remainingIterations = 1000000000 - iterations;
          final remainingIterationsInLoop = remainingIterations % loopLength;
          iterations = 1000000000 - remainingIterationsInLoop;
          foundLoop = true;
        }
        seen[iterations] = strVisualization;
      }
      // Tilting all round rock to the north
      for (int x = 0; x < tiltedMap.length; x++) {
        for (int y = 0; y < tiltedMap[x].length; y++) {
          if (tiltedMap[x][y] == PlatformTile.roundRock) {
            int newX = x;
            while (newX > 0 && tiltedMap[newX - 1][y] == PlatformTile.empty) {
              newX--;
            }
            if (newX != x) {
              tiltedMap[newX][y] = PlatformTile.roundRock;
              tiltedMap[x][y] = PlatformTile.empty;
            }
          }
        }
      }
      // West
      for (int y = 0; y < tiltedMap[0].length; y++) {
        for (int x = 0; x < tiltedMap.length; x++) {
          if (tiltedMap[x][y] == PlatformTile.roundRock) {
            int newY = y;
            while (newY > 0 && tiltedMap[x][newY - 1] == PlatformTile.empty) {
              newY--;
            }
            if (newY != y) {
              tiltedMap[x][newY] = PlatformTile.roundRock;
              tiltedMap[x][y] = PlatformTile.empty;
            }
          }
        }
      }
      // South
      for (int x = tiltedMap.length - 1; x >= 0; x--) {
        for (int y = tiltedMap[x].length - 1; y >= 0; y--) {
          if (tiltedMap[x][y] == PlatformTile.roundRock) {
            int newX = x;
            while (newX < tiltedMap.length - 1 &&
                tiltedMap[newX + 1][y] == PlatformTile.empty) {
              newX++;
            }
            if (newX != x) {
              tiltedMap[newX][y] = PlatformTile.roundRock;
              tiltedMap[x][y] = PlatformTile.empty;
            }
          }
        }
      }
      // East
      for (int y = tiltedMap[0].length - 1; y >= 0; y--) {
        for (int x = tiltedMap.length - 1; x >= 0; x--) {
          if (tiltedMap[x][y] == PlatformTile.roundRock) {
            int newY = y;
            while (newY < tiltedMap[0].length - 1 &&
                tiltedMap[x][newY + 1] == PlatformTile.empty) {
              newY++;
            }
            if (newY != y) {
              tiltedMap[x][newY] = PlatformTile.roundRock;
              tiltedMap[x][y] = PlatformTile.empty;
            }
          }
        }
      }
    }
    int load = 0;
    int x = 0;
    while (x < tiltedMap.length) {
      for (int y = 0; y < tiltedMap[x].length; y++) {
        if (tiltedMap[x][y] == PlatformTile.roundRock) {
          load += tiltedMap.length - x;
        }
      }
      x++;
    }
    // print(map.ogMap
    //     .map((row) => row.map((tile) => tile.char).join(''))
    //     .join('\n'));
    // print('\n---------------\n');
    // print(tiltedMap
    //     .map((row) => row.map((tile) => tile.char).join(''))
    //     .join('\n'));
    return load;
  }
}
