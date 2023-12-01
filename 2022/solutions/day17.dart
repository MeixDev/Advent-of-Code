import '../utils/index.dart';

typedef HeightMap = Tuple7<int, int, int, int, int, int, int>;

enum DirectionWind {
  left,
  right,
}

class Cache {
  final HeightMap heightMap;
  final int tetrominoType;
  final int windIndex;
  final int round;
  final int heightAtTime;

  Cache(this.heightMap, this.tetrominoType, this.windIndex, this.round,
      this.heightAtTime);

  bool operator ==(o) =>
      o is Cache &&
      o.tetrominoType == tetrominoType &&
      o.windIndex == windIndex &&
      o.heightMap == heightMap;
}

class Tetromino {
  final int height;
  final int width;
  final List<List<bool>> matrix;

  Tetromino(this.height, this.width, this.matrix);

  factory Tetromino.first() {
    return Tetromino(1, 4, [
      [true, true, true, true],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
    ]);
  }

  factory Tetromino.second() {
    return Tetromino(3, 3, [
      [false, true, false, false],
      [true, true, true, false],
      [false, true, false, false],
      [false, false, false, false],
    ]);
  }

  factory Tetromino.third() {
    return Tetromino(3, 3, [
      [false, false, true, false],
      [false, false, true, false],
      [true, true, true, false],
      [false, false, false, false],
    ]);
  }

  factory Tetromino.fourth() {
    return Tetromino(4, 1, [
      [true, false, false, false],
      [true, false, false, false],
      [true, false, false, false],
      [true, false, false, false],
    ]);
  }

  factory Tetromino.fifth() {
    return Tetromino(2, 2, [
      [true, true, false, false],
      [true, true, false, false],
      [false, false, false, false],
      [false, false, false, false],
    ]);
  }
}

class FallingTetromino {
  final Tetromino tetromino;
  int x;
  int y;

  FallingTetromino(this.tetromino, this.x, this.y);
}

class Day17 extends GenericDay {
  Day17() : super(17);
  @override
  List<DirectionWind> parseInput() {
    final inputUtil = InputUtil(17);
    final string = inputUtil.asString;
    // final string = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>";
    final List<DirectionWind> directions = [];
    for (final char in string.split('')) {
      if (char == '<') {
        directions.add(DirectionWind.left);
      } else {
        directions.add(DirectionWind.right);
      }
    }
    return directions;
  }

  bool canMovePiece(Field<bool> f, FallingTetromino t, Position p) {
    final x = t.x + p.x;
    final y = t.y + p.y;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (t.tetromino.matrix[j][i] == false) {
          continue;
        }
        final xToCheck = x + i;
        final yToCheck = y - j;
        if (xToCheck < 0 || xToCheck >= f.width) {
          return false;
        }
        if (yToCheck < 0) {
          return false;
        }
        if (f.getValueAt(xToCheck, yToCheck) == true) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  int solvePart1() {
    final directions = parseInput();
    Field<bool> field =
        Field<bool>(List.generate(30000, (index) => List.filled(7, false)));
    for (int x = 0; x < 7; x++) {
      field.setValueAt(x, 0, true);
    }
    int maxHeight = 0;
    final List<Tetromino> tetrominos = [
      Tetromino.first(),
      Tetromino.second(),
      Tetromino.third(),
      Tetromino.fourth(),
      Tetromino.fifth(),
    ];
    final List<Position> moves = [
      Position(0, 1), // Move up
      Position(0, -1), // Move down
      Position(-1, 0), // Move left
      Position(1, 0), // Move right
    ];
    final plow = [3, 1, 1, 0, 2];
    int wind = 0;
    for (int rounds = 0; rounds < 2022; rounds++) {
      final _tetromino = tetrominos[rounds % 5];
      FallingTetromino fTetromino =
          FallingTetromino(_tetromino, 2, maxHeight + 3 + 4 - plow[rounds % 5]);
      bool hasStopped = false;
      while (!hasStopped) {
        final direction = directions[wind];
        wind += 1;
        if (wind >= directions.length) wind = 0;
        if (direction == DirectionWind.left) {
          if (canMovePiece(field, fTetromino, moves[2])) {
            fTetromino.x += moves[2].x;
          }
        } else {
          if (canMovePiece(field, fTetromino, moves[3])) {
            fTetromino.x += moves[3].x;
          }
        }
        if (canMovePiece(field, fTetromino, moves[1])) {
          fTetromino.y += moves[1].y;
        } else {
          for (int i = 0; i < 4; i += 1) {
            for (int j = 0; j < 4; j += 1) {
              if (fTetromino.tetromino.matrix[j][i] == true) {
                final x = fTetromino.x + i;
                final y = fTetromino.y - j;
                field.setValueAt(x, y, true);
              }
            }
          }
          hasStopped = true;
          for (int c = field.height - 1; c > 0; c--) {
            final row = field.getRow(c);
            if (row.contains(true)) {
              maxHeight = c;
              break;
            }
          }
        }
      }
    }
    return maxHeight;
  }

  bool canMovePieceP2(List<List<bool>> f, FallingTetromino t, Position p) {
    final x = t.x + p.x;
    final y = t.y + p.y;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (t.tetromino.matrix[j][i] == false) {
          continue;
        }
        final xToCheck = x + i;
        final yToCheck = y - j;
        if (xToCheck < 0 || xToCheck >= 7) {
          return false;
        }
        if (yToCheck < 0) {
          return false;
        }
        if (f[yToCheck][xToCheck] == true) {
          return false;
        }
      }
    }
    return true;
  }

  Cache cacheEntry(
      List<List<bool>> field, int wind, int tPid, int maxHeight, int rounds) {
    List<int> hfm = [];
    for (int i = 0; i < 7; i++) {
      for (final row in field.reversed.toList()) {
        if (row[i] == true) {
          hfm.add(maxHeight - field.indexOf(row));
          break;
        }
      }
    }
    HeightMap heightMap = HeightMap(
      hfm[0],
      hfm[1],
      hfm[2],
      hfm[3],
      hfm[4],
      hfm[5],
      hfm[6],
    );
    return Cache(
      heightMap,
      tPid,
      wind,
      rounds,
      maxHeight,
    );
  }

  @override
  int solvePart2() {
    final directions = parseInput();
    List<List<bool>> field = [];
    field.add(List.filled(7, true));
    for (int i = 0; i < 8; i++) {
      field.add(List.filled(7, false));
    }
    final List<Cache> cache = [];
    int maxHeight = 0;
    final List<Tetromino> tetrominos = [
      Tetromino.first(),
      Tetromino.second(),
      Tetromino.third(),
      Tetromino.fourth(),
      Tetromino.fifth(),
    ];
    final List<Position> moves = [
      Position(0, 1), // Move up
      Position(0, -1), // Move down
      Position(-1, 0), // Move left
      Position(1, 0), // Move right
    ];
    final plow = [3, 1, 1, 0, 2];
    int wind = 0;
    final limit = 1000000000000;
    final stopwatch = Stopwatch()..start();
    for (int rounds = 0; rounds < limit; rounds++) {
      if (stopwatch.elapsedMilliseconds > 1000) {
        print('Rounds: $rounds');
        stopwatch.reset();
      }
      int tPid = rounds % 5;
      final _tetromino = tetrominos[tPid];
      FallingTetromino fTetromino =
          FallingTetromino(_tetromino, 2, maxHeight + 3 + 4 - plow[tPid]);
      bool hasStopped = false;
      while (!hasStopped) {
        final direction = directions[wind];
        wind += 1;
        if (wind >= directions.length) wind = 0;
        if (direction == DirectionWind.left) {
          if (canMovePieceP2(field, fTetromino, moves[2])) {
            fTetromino.x += moves[2].x;
          }
        } else {
          if (canMovePieceP2(field, fTetromino, moves[3])) {
            fTetromino.x += moves[3].x;
          }
        }
        if (canMovePieceP2(field, fTetromino, moves[1])) {
          fTetromino.y += moves[1].y;
        } else {
          for (int i = 0; i < 4; i += 1) {
            for (int j = 0; j < 4; j += 1) {
              if (fTetromino.tetromino.matrix[j][i] == true) {
                final x = fTetromino.x + i;
                final y = fTetromino.y - j;
                field[y][x] = true;
              }
            }
          }
          hasStopped = true;
          for (int c = field.length - 1; c > 0; c--) {
            final row = field[c];
            if (row.contains(true)) {
              maxHeight = c;
              for (int i = field.length; i < maxHeight + 8; i++) {
                field.add(List.filled(7, false));
              }
              final cEntry = cacheEntry(field, wind, tPid, maxHeight, rounds);
              if (cache.any((element) => element == cEntry)) {
                print('Found a loop!!!');
                Cache lastValue =
                    cache.firstWhere((element) => element == cEntry);
                final cycleLength = rounds - lastValue.round;
                print('Loop size: $cycleLength');
                final cyclesToGo = ((limit - rounds) / cycleLength).floor();
                rounds += cyclesToGo * cycleLength;
                final bonus =
                    cyclesToGo * (cEntry.heightAtTime - lastValue.heightAtTime);
                rounds += 1;
                for (final _; rounds < limit; rounds++) {
                  int tPid = rounds % 5;
                  final _tetromino = tetrominos[tPid];
                  FallingTetromino fTetromino = FallingTetromino(
                      _tetromino, 2, maxHeight + 3 + 4 - plow[tPid]);
                  bool hasStopped = false;
                  while (!hasStopped) {
                    final direction = directions[wind];
                    wind += 1;
                    if (wind >= directions.length) wind = 0;
                    if (direction == DirectionWind.left) {
                      if (canMovePieceP2(field, fTetromino, moves[2])) {
                        fTetromino.x += moves[2].x;
                      }
                    } else {
                      if (canMovePieceP2(field, fTetromino, moves[3])) {
                        fTetromino.x += moves[3].x;
                      }
                    }
                    if (canMovePieceP2(field, fTetromino, moves[1])) {
                      fTetromino.y += moves[1].y;
                    } else {
                      for (int i = 0; i < 4; i += 1) {
                        for (int j = 0; j < 4; j += 1) {
                          if (fTetromino.tetromino.matrix[j][i] == true) {
                            final x = fTetromino.x + i;
                            final y = fTetromino.y - j;
                            field[y][x] = true;
                          }
                        }
                      }
                      hasStopped = true;
                      for (int c = field.length - 1; c > 0; c--) {
                        final row = field[c];
                        if (row.contains(true)) {
                          maxHeight = c;
                          for (int i = field.length; i < maxHeight + 8; i++) {
                            field.add(List.filled(7, false));
                          }
                          break;
                        }
                      }
                    }
                  }
                }
                return maxHeight + bonus;
              }
              cache.add(cEntry);
              break;
            }
          }
        }
      }
    }
    return maxHeight;
  }
}
