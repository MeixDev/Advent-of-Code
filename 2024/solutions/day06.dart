import '../utils/index.dart';

enum LabInfo { empty, visited, wall }

enum Direction { up, right, down, left }

class Guard {
  Position pos;
  Direction dir;

  Guard(this.pos, this.dir);

  Guard addDirection(Direction dir) {
    switch (dir) {
      case Direction.up:
        return Guard(Position(pos.x, pos.y - 1), dir);
      case Direction.right:
        return Guard(Position(pos.x + 1, pos.y), dir);
      case Direction.down:
        return Guard(Position(pos.x, pos.y + 1), dir);
      case Direction.left:
        return Guard(Position(pos.x - 1, pos.y), dir);
      default:
        throw Exception('Invalid direction: $dir');
    }
  }

  Guard changeDirection() {
    switch (dir) {
      case Direction.up:
        return Guard(pos, Direction.right);
      case Direction.right:
        return Guard(pos, Direction.down);
      case Direction.down:
        return Guard(pos, Direction.left);
      case Direction.left:
        return Guard(pos, Direction.up);
      default:
        throw Exception('Invalid direction: $dir');
    }
  }
}

class Day06 extends GenericDay {
  Day06() : super(6);

  (Field<LabInfo>, Guard) parseLines(List<String> lines) {
    Guard guard = Guard(Position(0, 0), Direction.up);
    final List<List<LabInfo>> fieldBase = List.generate(
        lines.length, (_) => List.filled(lines[0].length, LabInfo.empty));
    final Field<LabInfo> field = Field(fieldBase);
    for (var y = 0; y < lines.length; y++) {
      for (var x = 0; x < lines[y].length; x++) {
        switch (lines[y][x]) {
          case '#':
            field.setValueAt(x, y, LabInfo.wall);
            break;
          case '^':
            field.setValueAt(x, y, LabInfo.empty);
            guard = Guard(Position(x, y), Direction.up);
            break;
          case '>':
            field.setValueAt(x, y, LabInfo.empty);
            guard = Guard(Position(x, y), Direction.right);
            break;
          case 'v':
            field.setValueAt(x, y, LabInfo.empty);
            guard = Guard(Position(x, y), Direction.down);
            break;
          case '<':
            field.setValueAt(x, y, LabInfo.empty);
            guard = Guard(Position(x, y), Direction.left);
            break;
          case '.':
            field.setValueAt(x, y, LabInfo.empty);
            break;
          default:
            break;
        }
      }
    }
    return (field, guard);
  }

  @override
  (Field<LabInfo>, Guard) parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  @override
  int solvePart1() {
    final (field, guard) = parseInput();
    Guard movingGuard = guard;
    bool isGuardInside = true;
    int visited = 0;
    while (isGuardInside) {
      field.setValueAt(movingGuard.pos.x, movingGuard.pos.y, LabInfo.visited);
      final nextGuard = movingGuard.addDirection(movingGuard.dir);
      if (!field.isOnField(nextGuard.pos)) {
        isGuardInside = false;
        break;
      }
      if (field.getValueAt(nextGuard.pos.x, nextGuard.pos.y) == LabInfo.wall) {
        movingGuard = movingGuard.changeDirection();
      } else {
        movingGuard = nextGuard;
      }
    }
    field.forEach((x, y) {
      if (field.getValueAt(x, y) == LabInfo.visited) {
        visited++;
      }
    });
    return visited;
  }

  Field<LabInfo> getPart1Field() {
    final (field, guard) = parseInput();
    Guard movingGuard = guard;
    bool isGuardInside = true;
    while (isGuardInside) {
      field.setValueAt(movingGuard.pos.x, movingGuard.pos.y, LabInfo.visited);
      final nextGuard = movingGuard.addDirection(movingGuard.dir);
      if (!field.isOnField(nextGuard.pos)) {
        isGuardInside = false;
        break;
      }
      if (field.getValueAt(nextGuard.pos.x, nextGuard.pos.y) == LabInfo.wall) {
        movingGuard = movingGuard.changeDirection();
      } else {
        movingGuard = nextGuard;
      }
    }
    return field;
  }

  @override
  int solvePart2() {
    final (field, guard) = parseInput();
    final part1Field = getPart1Field();
    Field<LabInfo> visitedField = field.copy();

    Position? moveUntilWall(Guard guard) {
      Position next = guard.pos;
      Guard nextGuard = guard;
      while (field.isOnField(next)) {
        final last = next;
        next = nextGuard.addDirection(nextGuard.dir).pos;
        nextGuard = nextGuard.addDirection(nextGuard.dir);
        if (!field.isOnField(next)) {
          return null;
        }
        final visitedValue = visitedField.getValueAt(next.x, next.y);
        visitedField.setValueAt(last.x, last.y, LabInfo.visited);
        if (visitedValue == LabInfo.wall) {
          return last;
        }
      }
      return null;
    }

    bool isLoopTest() {
      final List<Tuple2<Position, Position>> paths = [];
      Guard testGuard = guard;
      while (true) {
        visitedField.setValueAt(
            testGuard.pos.x, testGuard.pos.y, LabInfo.visited);
        final next = moveUntilWall(testGuard);
        if (next == null) {
          return false;
        }
        final path = Tuple2(testGuard.pos, next);
        if (paths.contains(path)) {
          // LOOP
          return true;
        }
        paths.add(path);
        testGuard = Guard(next, testGuard.dir);
        testGuard = testGuard.changeDirection();
      }
    }

    int possibleObstaclesNum = 0;
    // Testing every point, it sucks.
    // Update: Optimized with Part 1 path. Smart. Still slow as peck.
    for (int y = 0; y < field.height; y++) {
      for (int x = 0; x < field.width; x++) {
        if (field.getValueAt(x, y) == LabInfo.wall) {
          continue;
        }
        if (part1Field.getValueAt(x, y) != LabInfo.visited) {
          continue;
        }
        final obstacle = Position(x, y);
        visitedField = field.copy();
        visitedField.setValueAt(obstacle.x, obstacle.y, LabInfo.wall);
        if (isLoopTest()) {
          possibleObstaclesNum++;
        }
      }
    }
    return possibleObstaclesNum;
  }

  // @override
  // int solvePart2() {
  //   final (field, guard) = parseInput();
  //   Guard movingGuard = guard;
  //   bool isGuardInside = true;
  //   Set<Position> possibleObstacles = {};
  //   int possibleObstaclesNum = 0;
  //   Map<Position, List<Direction>> visitedDirections = {};
  //   while (isGuardInside) {
  //     field.setValueAt(movingGuard.pos.x, movingGuard.pos.y, LabInfo.visited);
  //     visitedDirections.putIfAbsent(movingGuard.pos, () => []);
  //     if (!visitedDirections[movingGuard.pos]!.contains(movingGuard.dir)) {
  //       visitedDirections[movingGuard.pos]!.add(movingGuard.dir);
  //       if (visitedDirections[movingGuard.pos]!.length > 1) {
  //         print(
  //             "${visitedDirections[movingGuard.pos]!.length} directions at ${movingGuard.pos}");
  //       }
  //     }
  //     final nextGuard = movingGuard.addDirection(movingGuard.dir);
  //     if (!field.isOnField(nextGuard.pos)) {
  //       isGuardInside = false;
  //       break;
  //     }
  //     if (field.getValueAt(nextGuard.pos.x, nextGuard.pos.y) == LabInfo.wall) {
  //       movingGuard = movingGuard.changeDirection();
  //     } else {
  //       movingGuard = nextGuard;
  //     }
  //     final acceptableDirection = movingGuard.changeDirection().dir;
  //     Guard checkDirection = movingGuard.addDirection(acceptableDirection);
  //     while (field.isOnField(checkDirection.pos) &&
  //         field.getValueAt(checkDirection.pos.x, checkDirection.pos.y) !=
  //             LabInfo.wall) {
  //       if (field.getValueAt(checkDirection.pos.x, checkDirection.pos.y) ==
  //           LabInfo.visited) {
  //         if (visitedDirections[checkDirection.pos]!
  //             .contains(acceptableDirection)) {
  //           print(
  //               'Guard at position ${nextGuard.pos} looking ${nextGuard.dir.name} could loop with a wall at ${movingGuard.addDirection(movingGuard.dir).pos}');
  //           possibleObstacles
  //               .add(movingGuard.addDirection(movingGuard.dir).pos);
  //           possibleObstaclesNum += 1;
  //           break;
  //         }
  //       }
  //       checkDirection = checkDirection.addDirection(acceptableDirection);
  //     }
  //   }
  //   print(possibleObstacles);
  //   print(possibleObstaclesNum);
  //   return possibleObstacles.length;
  // }
}
