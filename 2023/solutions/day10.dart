import '../utils/index.dart';

enum FloorPipe {
  floor('.'),
  start('S'),
  northSouth('|'),
  westEast('-'),
  northWest('J'),
  northEast('L'),
  southWest('7'),
  southEast('F');

  final String _value;
  const FloorPipe(this._value);

  @override
  String toString() => _value;
}

enum MoveDirection {
  north,
  south,
  west,
  east,
}

class Pipe {
  final int x;
  final int y;
  final FloorPipe type;

  Pipe(this.x, this.y, this.type);
}

class PipeMap {
  final List<List<FloorPipe>> _map;
  final int startX;
  final int startY;

  PipeMap(this._map, this.startX, this.startY);

  FloorPipe get(int x, int y) {
    if (x < 0 || y < 0 || x >= _map.length || y >= _map[x].length) {
      return FloorPipe.floor;
    }
    return _map[x][y];
  }

  void set(int x, int y, FloorPipe pipe) {
    if (x < 0 || y < 0 || x >= _map.length || y >= _map[x].length) {
      return;
    }
    _map[x][y] = pipe;
  }
}

class Day10 extends GenericDay {
  Day10() : super(10);

  void parseLines(List<String> lines) {}

  @override
  PipeMap parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    int startX = 0;
    int startY = 0;
    final map = <List<FloorPipe>>[];
    int x = 0;
    while (x < lines.length) {
      int y = 0;
      final row = <FloorPipe>[];
      while (y < lines[x].length - 1) {
        switch (lines[x][y]) {
          case '.':
            row.add(FloorPipe.floor);
            break;
          case '|':
            row.add(FloorPipe.northSouth);
            break;
          case '-':
            row.add(FloorPipe.westEast);
            break;
          case 'L':
            row.add(FloorPipe.northEast);
            break;
          case 'J':
            row.add(FloorPipe.northWest);
            break;
          case '7':
            row.add(FloorPipe.southWest);
            break;
          case 'F':
            row.add(FloorPipe.southEast);
            break;
          case 'S':
            row.add(FloorPipe.start);
            startX = x;
            startY = y;
            break;
          default:
            throw Exception('Unknown pipe type: ${lines[x][y]}');
        }
        y++;
      }
      map.add(row);
      x++;
    }
    return PipeMap(map, startX, startY);
  }

  @override
  int solvePart1() {
    final pipeMap = parseInput();
    final startX = pipeMap.startX;
    final startY = pipeMap.startY;
    // We must explore connecting pipes from the start pipe in order to find a full loop
    int score = 0;
    bool looped = false;
    final directions = <MoveDirection>[
      MoveDirection.north,
      MoveDirection.south,
      MoveDirection.west,
      MoveDirection.east,
    ];
    for (final baseDirection in directions) {
      // print("Attempting new direction: $baseDirection");
      if (looped) {
        break;
      }
      int x = startX;
      int y = startY;
      int steps = 0;
      bool stuck = false;
      MoveDirection direction = baseDirection;
      while (!stuck) {
        switch (direction) {
          case MoveDirection.north:
            x--;
            break;
          case MoveDirection.south:
            x++;
            break;
          case MoveDirection.west:
            y--;
            break;
          case MoveDirection.east:
            y++;
            break;
        }
        steps++;
        // print('x: $x, y: $y, steps: $steps');
        if (x < 0 ||
            y < 0 ||
            x >= pipeMap._map.length ||
            y >= pipeMap._map[x].length) {
          // print('Out of bounds');
          stuck = true;
          break;
        }
        if (pipeMap.get(x, y) == FloorPipe.start) {
          // We've looped back to the start
          looped = true;
          break;
        }
        final tile = pipeMap.get(x, y);
        // print('Tile: $tile on $x, $y');
        switch (tile) {
          case FloorPipe.floor:
            stuck = true;
            break;
          case FloorPipe.northSouth:
            if (direction == MoveDirection.west ||
                direction == MoveDirection.east) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.north) {
              // x--;
              direction = MoveDirection.north;
            }
            if (direction == MoveDirection.south) {
              // x++;
              direction = MoveDirection.south;
            }
            break;
          case FloorPipe.westEast:
            if (direction == MoveDirection.north ||
                direction == MoveDirection.south) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.west) {
              // y--;
              direction = MoveDirection.west;
            }
            if (direction == MoveDirection.east) {
              // y++;
              direction = MoveDirection.east;
            }
            break;
          case FloorPipe.northWest:
            if (direction == MoveDirection.north ||
                direction == MoveDirection.west) {
              stuck = true;
              break;
            }
            // if (direction == MoveDirection.east) {
            //   if (lastPipe != FloorPipe.westEast &&
            //       lastPipe != FloorPipe.northEast &&
            //       lastPipe != FloorPipe.southEast &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            // if (direction == MoveDirection.south) {
            //   if (lastPipe != FloorPipe.northSouth &&
            //       lastPipe != FloorPipe.northEast &&
            //       lastPipe != FloorPipe.northWest &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            if (direction == MoveDirection.east) {
              // x--;
              direction = MoveDirection.north;
            }
            if (direction == MoveDirection.south) {
              // y--;
              direction = MoveDirection.west;
            }
            break;
          case FloorPipe.northEast:
            if (direction == MoveDirection.north ||
                direction == MoveDirection.east) {
              stuck = true;
              break;
            }
            // if (direction == MoveDirection.west) {
            //   if (lastPipe != FloorPipe.westEast &&
            //       lastPipe != FloorPipe.northWest &&
            //       lastPipe != FloorPipe.southWest &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            // if (direction == MoveDirection.north) {
            //   if (lastPipe != FloorPipe.northSouth &&
            //       lastPipe != FloorPipe.southEast &&
            //       lastPipe != FloorPipe.southWest &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            if (direction == MoveDirection.west) {
              // x--;
              direction = MoveDirection.north;
            }
            if (direction == MoveDirection.south) {
              // y++;
              direction = MoveDirection.east;
            }
            break;
          case FloorPipe.southWest:
            if (direction == MoveDirection.south ||
                direction == MoveDirection.west) {
              stuck = true;
              break;
            }
            // if (direction == MoveDirection.east) {
            //   if (lastPipe != FloorPipe.westEast &&
            //       lastPipe != FloorPipe.northEast &&
            //       lastPipe != FloorPipe.southEast &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            // if (direction == MoveDirection.north) {
            //   if (lastPipe != FloorPipe.northSouth &&
            //       lastPipe != FloorPipe.southEast &&
            //       lastPipe != FloorPipe.southWest &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            if (direction == MoveDirection.east) {
              // x++;
              direction = MoveDirection.south;
            }
            if (direction == MoveDirection.north) {
              // y--;
              direction = MoveDirection.west;
            }
            break;
          case FloorPipe.southEast:
            if (direction == MoveDirection.south ||
                direction == MoveDirection.east) {
              stuck = true;
              break;
            }
            // if (direction == MoveDirection.west) {
            //   if (lastPipe != FloorPipe.westEast &&
            //       lastPipe != FloorPipe.northWest &&
            //       lastPipe != FloorPipe.southWest &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            // if (direction == MoveDirection.north) {
            //   if (lastPipe != FloorPipe.northSouth &&
            //       lastPipe != FloorPipe.southEast &&
            //       lastPipe != FloorPipe.southWest &&
            //       lastPipe != FloorPipe.start) {
            //     stuck = true;
            //     break;
            //   }
            // }
            if (direction == MoveDirection.west) {
              // x++;
              direction = MoveDirection.south;
            }
            if (direction == MoveDirection.north) {
              // y++;
              direction = MoveDirection.east;
            }
            break;
          default:
            throw Exception('Unknown pipe type: ${pipeMap.get(x, y)}');
        }
      }
      if (looped) {
        score = ((steps - 1) / 2).floor() + 1;
        break;
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final pipeMap = parseInput();
    final startX = pipeMap.startX;
    final startY = pipeMap.startY;
    // We must explore connecting pipes from the start pipe in order to find a full loop
    int score = 0;
    bool looped = false;
    final directions = <MoveDirection>[
      MoveDirection.north,
      MoveDirection.south,
      MoveDirection.west,
      MoveDirection.east,
    ];
    List<Pipe> goodPipes = [];
    for (final baseDirection in directions) {
      // print("Attempting new direction: $baseDirection");

      if (looped) {
        break;
      }
      final pipes = <Pipe>[];
      int x = startX;
      int y = startY;
      bool stuck = false;
      MoveDirection direction = baseDirection;
      while (!stuck) {
        pipes.add(Pipe(x, y, pipeMap.get(x, y)));
        switch (direction) {
          case MoveDirection.north:
            x--;
            break;
          case MoveDirection.south:
            x++;
            break;
          case MoveDirection.west:
            y--;
            break;
          case MoveDirection.east:
            y++;
            break;
        }
        // print('x: $x, y: $y, steps: $steps');
        if (x < 0 ||
            y < 0 ||
            x >= pipeMap._map.length ||
            y >= pipeMap._map[x].length) {
          // print('Out of bounds');
          stuck = true;
          break;
        }
        if (pipeMap.get(x, y) == FloorPipe.start) {
          // We've looped back to the start
          looped = true;
          goodPipes = pipes;
          break;
        }
        final tile = pipeMap.get(x, y);
        // print('Tile: $tile on $x, $y');
        switch (tile) {
          case FloorPipe.floor:
            stuck = true;
            break;
          case FloorPipe.northSouth:
            if (direction == MoveDirection.west ||
                direction == MoveDirection.east) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.north) {
              direction = MoveDirection.north;
            }
            if (direction == MoveDirection.south) {
              direction = MoveDirection.south;
            }
            break;
          case FloorPipe.westEast:
            if (direction == MoveDirection.north ||
                direction == MoveDirection.south) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.west) {
              direction = MoveDirection.west;
            }
            if (direction == MoveDirection.east) {
              direction = MoveDirection.east;
            }
            break;
          case FloorPipe.northWest:
            if (direction == MoveDirection.north ||
                direction == MoveDirection.west) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.east) {
              direction = MoveDirection.north;
            }
            if (direction == MoveDirection.south) {
              direction = MoveDirection.west;
            }
            break;
          case FloorPipe.northEast:
            if (direction == MoveDirection.north ||
                direction == MoveDirection.east) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.west) {
              direction = MoveDirection.north;
            }
            if (direction == MoveDirection.south) {
              direction = MoveDirection.east;
            }
            break;
          case FloorPipe.southWest:
            if (direction == MoveDirection.south ||
                direction == MoveDirection.west) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.east) {
              direction = MoveDirection.south;
            }
            if (direction == MoveDirection.north) {
              direction = MoveDirection.west;
            }
            break;
          case FloorPipe.southEast:
            if (direction == MoveDirection.south ||
                direction == MoveDirection.east) {
              stuck = true;
              break;
            }
            if (direction == MoveDirection.west) {
              direction = MoveDirection.south;
            }
            if (direction == MoveDirection.north) {
              direction = MoveDirection.east;
            }
            break;
          default:
            throw Exception('Unknown pipe type: ${pipeMap.get(x, y)}');
        }
      }
      if (looped) {
        break;
      }
    }
    final cleanedMap = List<List<Pipe>>.generate(
      pipeMap._map.length,
      (i) => List<Pipe>.generate(
        pipeMap._map[0].length,
        (j) {
          return Pipe(i, j, FloorPipe.floor);
        },
      ),
    );
    for (final pipe in goodPipes) {
      cleanedMap[pipe.x][pipe.y] = pipe;
    }
    cleanedMap[goodPipes[0].x][goodPipes[0].y] = Pipe(
        goodPipes[0].x,
        goodPipes[0].y,
        FloorPipe.northWest); // This is hardcoded according to my input
    final List<String> cleanedMapString = [];
    for (final row in cleanedMap) {
      final rowString = <String>[];
      for (final pipe in row) {
        rowString.add(pipe.type.toString());
      }
      cleanedMapString.add(rowString.join(''));
    }
    score = 0;
    for (final row in cleanedMapString) {
      int interior = 0;
      String rowString = row.replaceAll('-', '');
      rowString = rowString.replaceAll('F7', '');
      rowString = rowString.replaceAll('LJ', '');
      rowString = rowString.replaceAll('FJ', '|');
      rowString = rowString.replaceAll('L7', '|');
      final rowStringList = rowString.split('');
      for (final char in rowStringList) {
        if (char == '|') {
          interior++;
        }
        if (interior % 2 == 1 && char == '.') {
          score++;
        }
      }
    }

    return score;
  }
}
