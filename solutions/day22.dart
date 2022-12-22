import '../utils/index.dart';

const int faceHeight = 50;
const int faceWidth = 50;

enum MagicTile {
  empty,
  walkable,
  obstacle,
  hero,
}

enum MagicDirection {
  right,
  down,
  left,
  up;

  MagicDirection turn(bool clockWise) {
    switch (this) {
      case MagicDirection.right:
        return clockWise ? MagicDirection.down : MagicDirection.up;
      case MagicDirection.down:
        return clockWise ? MagicDirection.left : MagicDirection.right;
      case MagicDirection.left:
        return clockWise ? MagicDirection.up : MagicDirection.down;
      case MagicDirection.up:
        return clockWise ? MagicDirection.right : MagicDirection.left;
    }
  }
}

class MagicInstruction {
  bool isStep;
  int? steps;
  bool? clockwise;

  MagicInstruction({
    required this.isStep,
    this.steps,
    this.clockwise,
  });
}

class MagicFieldCube extends Field<MagicFieldP2> {
  MagicFieldCube(List<List<MagicFieldP2>> field) : super(field);

  final magicCube = MagicCube.manual();

  int heroCubeIndex = 1;
  int heroX = 0;
  int heroY = 0;

  MagicFieldP2 fieldFromIndex(int index) {
    switch (index) {
      case 1:
        // return this.getValueAt(2, 0);
        return this.getValueAt(1, 0);
      case 2:
        // return this.getValueAt(0, 1);
        return this.getValueAt(2, 0);
      case 3:
        // return this.getValueAt(1, 1);
        return this.getValueAt(1, 1);
      case 4:
        // return this.getValueAt(2, 1);
        return this.getValueAt(0, 2);
      case 5:
        // return this.getValueAt(2, 2);
        return this.getValueAt(1, 2);
      case 6:
        // return this.getValueAt(3, 2);
        return this.getValueAt(0, 3);
      default:
        throw Exception('Unknown index: $index');
    }
  }

  MagicDirection moveOnField(int steps, MagicDirection direction) {
    MagicDirection cDirection = direction;
    MagicDirection oldDirection = direction;
    for (int i = 0; i < steps; i++) {
      int toGoX = heroX;
      int toGoY = heroY;
      int toGoCubeIndex = heroCubeIndex;
      switch (cDirection) {
        case MagicDirection.right:
          toGoX++;
          break;
        case MagicDirection.down:
          toGoY++;
          break;
        case MagicDirection.left:
          toGoX--;
          break;
        case MagicDirection.up:
          toGoY--;
          break;
      }
      if (toGoX < 0 || toGoX >= faceWidth || toGoY < 0 || toGoY >= faceHeight) {
        if (toGoX < 0) toGoX = 0;
        if (toGoX >= faceWidth) toGoX = faceWidth - 1;
        if (toGoY < 0) toGoY = 0;
        if (toGoY >= faceHeight) toGoY = faceHeight - 1;
        oldDirection = cDirection;
        switch (direction) {
          case MagicDirection.right:
            final connection = magicCube.connections[
                Tuple2<int, MagicDirection>(toGoCubeIndex, cDirection)]!;

            if (connection.item2 == MagicDirection.right) {
              cDirection = connection.item2;
              toGoX = 0;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.left) {
              cDirection = connection.item2;
              toGoX = faceWidth - 1;
              toGoY = (faceHeight - 1) - toGoY;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.up) {
              cDirection = connection.item2;
              toGoX = toGoY;
              toGoY = faceHeight - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.down) {
              cDirection = connection.item2;
              toGoX = (faceHeight - 1) - toGoY;
              toGoY = 0;
              toGoCubeIndex = connection.item1;
            }
            break;
          case MagicDirection.down:
            final connection = magicCube.connections[
                Tuple2<int, MagicDirection>(toGoCubeIndex, cDirection)]!;

            if (connection.item2 == MagicDirection.right) {
              cDirection = connection.item2;
              toGoY = (faceHeight - 1) - toGoX;
              toGoX = 0;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.left) {
              cDirection = connection.item2;
              toGoY = toGoX;
              toGoX = faceWidth - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.up) {
              cDirection = connection.item2;
              toGoX = (faceWidth - 1) - toGoX;
              toGoY = faceHeight - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.down) {
              cDirection = connection.item2;
              toGoY = 0;
              toGoCubeIndex = connection.item1;
            }
            break;
          case MagicDirection.left:
            final connection = magicCube.connections[
                Tuple2<int, MagicDirection>(toGoCubeIndex, cDirection)]!;

            if (connection.item2 == MagicDirection.right) {
              cDirection = connection.item2;
              toGoY = (faceHeight - 1) - toGoY;
              toGoX = 0;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.left) {
              cDirection = connection.item2;
              toGoX = faceWidth - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.up) {
              cDirection = connection.item2;
              toGoX = (faceWidth - 1) - toGoY;
              toGoY = faceHeight - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.down) {
              cDirection = connection.item2;
              toGoX = toGoY;
              toGoY = 0;
              toGoCubeIndex = connection.item1;
            }
            break;
          case MagicDirection.up:
            final connection = magicCube.connections[
                Tuple2<int, MagicDirection>(toGoCubeIndex, cDirection)]!;

            if (connection.item2 == MagicDirection.right) {
              cDirection = connection.item2;
              toGoY = toGoX;
              toGoX = 0;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.left) {
              cDirection = connection.item2;
              toGoY = (faceHeight - 1) - toGoX;
              toGoX = faceWidth - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.up) {
              cDirection = connection.item2;
              toGoY = faceHeight - 1;
              toGoCubeIndex = connection.item1;
            } else if (connection.item2 == MagicDirection.down) {
              cDirection = connection.item2;
              toGoX = (faceWidth - 1) - toGoX;
              toGoY = 0;
              toGoCubeIndex = connection.item1;
            }
            break;
        }
      }
      final currentField = this.fieldFromIndex(toGoCubeIndex);
      if (currentField.getValueAt(toGoX, toGoY) == MagicTile.obstacle) {
        cDirection = oldDirection;
        break;
      }
      heroX = toGoX;
      heroY = toGoY;
      heroCubeIndex = toGoCubeIndex;
      oldDirection = cDirection;
      print("Hero is at $heroX, $heroY, $heroCubeIndex");
    }
    return cDirection;
  }
}

class MagicFieldP2 extends Field<MagicTile> {
  MagicFieldP2(List<List<MagicTile>> field) : super(field);

  @override
  String toString() {
    String result = '';
    for (final row in field) {
      for (final elem in row) {
        switch (elem) {
          case MagicTile.empty:
            result += ' ';
            break;
          case MagicTile.walkable:
            result += '.';
            break;
          case MagicTile.obstacle:
            result += '#';
            break;
          case MagicTile.hero:
            result += 'H';
            break;
        }
      }
      result += '\n';
    }
    result += '\n';
    return result;
  }
}

class MagicField extends Field<MagicTile> {
  MagicField(List<List<MagicTile>> field, this.hero) : super(field);

  Position hero;

  @override
  String toString() {
    String result = '';
    for (final row in field) {
      for (final elem in row) {
        switch (elem) {
          case MagicTile.empty:
            result += ' ';
            break;
          case MagicTile.walkable:
            result += '.';
            break;
          case MagicTile.obstacle:
            result += '#';
            break;
          case MagicTile.hero:
            result += 'H';
            break;
        }
      }
      result += '\n';
    }
    result += '\n';
    return result;
  }

  bool isOnFieldAt(int x, int y) => isOnField(Position(x, y));

  void moveOnField(int steps, MagicDirection direction) {
    setValueAtPosition(hero, MagicTile.walkable);
    for (int i = 0; i < steps; i++) {
      int toGoX = hero.x;
      int toGoY = hero.y;
      switch (direction) {
        case MagicDirection.right:
          toGoX++;
          break;
        case MagicDirection.down:
          toGoY++;
          break;
        case MagicDirection.left:
          toGoX--;
          break;
        case MagicDirection.up:
          toGoY--;
          break;
      }
      if (!isOnFieldAt(toGoX, toGoY) ||
          getValueAt(toGoX, toGoY) == MagicTile.empty) {
        switch (direction) {
          case MagicDirection.right:
            // Get leftmost walkable tile on the same Y
            int leftmostWalkableX = 0;
            while (getValueAt(leftmostWalkableX, toGoY) == MagicTile.empty) {
              leftmostWalkableX++;
            }
            toGoX = leftmostWalkableX;
            break;
          case MagicDirection.down:
            // Get upmost walkable tile on the same X
            int upmostWalkableY = 0;
            while (getValueAt(toGoX, upmostWalkableY) == MagicTile.empty) {
              upmostWalkableY++;
            }
            toGoY = upmostWalkableY;
            break;
          case MagicDirection.left:
            // Get rightmost walkable tile on the same Y
            int rightmostWalkableX = width - 1;
            while (getValueAt(rightmostWalkableX, toGoY) == MagicTile.empty) {
              rightmostWalkableX--;
            }
            toGoX = rightmostWalkableX;
            break;
          case MagicDirection.up:
            // Get downmost walkable tile on the same X
            int downmostWalkableY = height - 1;
            while (getValueAt(toGoX, downmostWalkableY) == MagicTile.empty) {
              downmostWalkableY--;
            }
            toGoY = downmostWalkableY;
            break;
        }
      }
      if (getValueAt(toGoX, toGoY) == MagicTile.obstacle) {
        break;
      }
      setValueAtPosition(hero, MagicTile.walkable);
      hero = Position(toGoX, toGoY);
      setValueAtPosition(hero, MagicTile.hero);
    }
  }

  void setHeroPosition(Position p) {
    hero = p;
  }
}

class MagicGame {
  MagicField field;
  List<MagicInstruction> instructions;

  MagicGame(this.field, this.instructions);
}

class MagicGameP2 {
  MagicFieldCube fields;
  List<MagicInstruction> instructions;

  MagicGameP2(this.fields, this.instructions);
}

class MagicCube {
  List<List<int>> regions;
  Map<Tuple2<int, MagicDirection>, Tuple2<int, MagicDirection>> connections;

  MagicCube(this.regions, this.connections);

  // EXAMPLE CUBE
  // factory MagicCube.manual() {
  //   final regions = List.generate(
  //     3,
  //     (index) => List.generate(
  //       4,
  //       (index) => -1,
  //     ),
  //   );
  //   regions[0][2] = 1;
  //   regions[1][0] = 2;
  //   regions[1][1] = 3;
  //   regions[1][2] = 4;
  //   regions[2][2] = 5;
  //   regions[2][3] = 6;

  //   Map<Tuple2<int, MagicDirection>, Tuple2<int, MagicDirection>> connections =
  //       {};

  //   connections[Tuple2(1, MagicDirection.right)] = Tuple2(
  //     6,
  //     MagicDirection.left,
  //   );
  //   connections[Tuple2(1, MagicDirection.down)] = Tuple2(
  //     4,
  //     MagicDirection.down,
  //   );
  //   connections[Tuple2(1, MagicDirection.left)] = Tuple2(
  //     3,
  //     MagicDirection.down,
  //   );
  //   connections[Tuple2(1, MagicDirection.up)] = Tuple2(
  //     2,
  //     MagicDirection.down,
  //   );

  //   connections[Tuple2(2, MagicDirection.right)] = Tuple2(
  //     3,
  //     MagicDirection.right,
  //   );
  //   connections[Tuple2(2, MagicDirection.down)] = Tuple2(
  //     5,
  //     MagicDirection.up,
  //   );
  //   connections[Tuple2(2, MagicDirection.left)] = Tuple2(
  //     6,
  //     MagicDirection.up,
  //   );
  //   connections[Tuple2(2, MagicDirection.up)] = Tuple2(
  //     1,
  //     MagicDirection.down,
  //   );

  //   connections[Tuple2(3, MagicDirection.right)] = Tuple2(
  //     4,
  //     MagicDirection.right,
  //   );
  //   connections[Tuple2(3, MagicDirection.down)] = Tuple2(
  //     5,
  //     MagicDirection.right,
  //   );
  //   connections[Tuple2(3, MagicDirection.left)] = Tuple2(
  //     2,
  //     MagicDirection.left,
  //   );
  //   connections[Tuple2(3, MagicDirection.up)] = Tuple2(
  //     1,
  //     MagicDirection.right,
  //   );

  //   connections[Tuple2(4, MagicDirection.right)] = Tuple2(
  //     6,
  //     MagicDirection.down,
  //   );
  //   connections[Tuple2(4, MagicDirection.down)] = Tuple2(
  //     5,
  //     MagicDirection.down,
  //   );
  //   connections[Tuple2(4, MagicDirection.left)] = Tuple2(
  //     3,
  //     MagicDirection.left,
  //   );
  //   connections[Tuple2(4, MagicDirection.up)] = Tuple2(
  //     1,
  //     MagicDirection.up,
  //   );

  //   connections[Tuple2(5, MagicDirection.right)] = Tuple2(
  //     6,
  //     MagicDirection.right,
  //   );
  //   connections[Tuple2(5, MagicDirection.down)] = Tuple2(
  //     2,
  //     MagicDirection.up,
  //   );
  //   connections[Tuple2(5, MagicDirection.left)] = Tuple2(
  //     3,
  //     MagicDirection.up,
  //   );
  //   connections[Tuple2(5, MagicDirection.up)] = Tuple2(
  //     4,
  //     MagicDirection.up,
  //   );

  //   connections[Tuple2(6, MagicDirection.right)] = Tuple2(
  //     1,
  //     MagicDirection.left,
  //   );
  //   connections[Tuple2(6, MagicDirection.down)] = Tuple2(
  //     2,
  //     MagicDirection.right,
  //   );
  //   connections[Tuple2(6, MagicDirection.left)] = Tuple2(
  //     5,
  //     MagicDirection.left,
  //   );
  //   connections[Tuple2(6, MagicDirection.up)] = Tuple2(
  //     4,
  //     MagicDirection.left,
  //   );

  //   return MagicCube(regions, connections);
  // }

  factory MagicCube.manual() {
    final regions = List.generate(
      4,
      (index) => List.generate(
        3,
        (index) => -1,
      ),
    );
    regions[0][1] = 1;
    regions[0][2] = 2;
    regions[1][1] = 3;
    regions[2][0] = 4;
    regions[2][1] = 5;
    regions[3][0] = 6;

    Map<Tuple2<int, MagicDirection>, Tuple2<int, MagicDirection>> connections =
        {};

    connections[Tuple2(1, MagicDirection.right)] = Tuple2(
      2,
      MagicDirection.right,
    );
    connections[Tuple2(1, MagicDirection.down)] = Tuple2(
      3,
      MagicDirection.down,
    );
    connections[Tuple2(1, MagicDirection.left)] = Tuple2(
      4,
      MagicDirection.right,
    );
    connections[Tuple2(1, MagicDirection.up)] = Tuple2(
      6,
      MagicDirection.right,
    );

    connections[Tuple2(2, MagicDirection.right)] = Tuple2(
      5,
      MagicDirection.left,
    );
    connections[Tuple2(2, MagicDirection.down)] = Tuple2(
      3,
      MagicDirection.left,
    );
    connections[Tuple2(2, MagicDirection.left)] = Tuple2(
      1,
      MagicDirection.left,
    );
    connections[Tuple2(2, MagicDirection.up)] = Tuple2(
      6,
      MagicDirection.up,
    );

    connections[Tuple2(3, MagicDirection.right)] = Tuple2(
      2,
      MagicDirection.up,
    );
    connections[Tuple2(3, MagicDirection.down)] = Tuple2(
      5,
      MagicDirection.down,
    );
    connections[Tuple2(3, MagicDirection.left)] = Tuple2(
      4,
      MagicDirection.down,
    );
    connections[Tuple2(3, MagicDirection.up)] = Tuple2(
      1,
      MagicDirection.up,
    );

    connections[Tuple2(4, MagicDirection.right)] = Tuple2(
      5,
      MagicDirection.right,
    );
    connections[Tuple2(4, MagicDirection.down)] = Tuple2(
      6,
      MagicDirection.down,
    );
    connections[Tuple2(4, MagicDirection.left)] = Tuple2(
      1,
      MagicDirection.right,
    );
    connections[Tuple2(4, MagicDirection.up)] = Tuple2(
      3,
      MagicDirection.right,
    );

    connections[Tuple2(5, MagicDirection.right)] = Tuple2(
      2,
      MagicDirection.left,
    );
    connections[Tuple2(5, MagicDirection.down)] = Tuple2(
      6,
      MagicDirection.left,
    );
    connections[Tuple2(5, MagicDirection.left)] = Tuple2(
      4,
      MagicDirection.left,
    );
    connections[Tuple2(5, MagicDirection.up)] = Tuple2(
      3,
      MagicDirection.up,
    );

    connections[Tuple2(6, MagicDirection.right)] = Tuple2(
      5,
      MagicDirection.up,
    );
    connections[Tuple2(6, MagicDirection.down)] = Tuple2(
      2,
      MagicDirection.down,
    );
    connections[Tuple2(6, MagicDirection.left)] = Tuple2(
      1,
      MagicDirection.down,
    );
    connections[Tuple2(6, MagicDirection.up)] = Tuple2(
      4,
      MagicDirection.up,
    );

    return MagicCube(regions, connections);
  }
}

class Day22 extends GenericDay {
  Day22() : super(22);
  @override
  MagicGame parseInput() {
    final inputUtil = InputUtil(22);
    final lines = inputUtil.getPerLine();
    final instructionLine = lines.removeLast();
    lines.removeLast(); // Removes empty line
    int maxLength = 0;
    for (final line in lines) {
      if (line.length > maxLength) {
        maxLength = line.length;
      }
    }
    final fieldList = List.generate(
      lines.length,
      (index) => List.generate(
        maxLength,
        (index) => MagicTile.empty,
      ),
    );
    final field = MagicField(fieldList, Position(0, 0));
    for (int y = 0; y < lines.length; y++) {
      for (int x = 0; x < lines[y].length; x++) {
        switch (lines[y][x]) {
          case '#':
            field.setValueAt(x, y, MagicTile.obstacle);
            break;
          case '.':
            field.setValueAt(x, y, MagicTile.walkable);
            break;
          case ' ':
            field.setValueAt(x, y, MagicTile.empty);
            break;
        }
      }
    }
    for (int x = 0; x < lines[0].length; x++) {
      if (lines[0][x] == '.') {
        field.setHeroPosition(Position(x, 0));
        field.setValueAt(x, 0, MagicTile.hero);
        break;
      }
    }
    final List<MagicInstruction> instructions = [];
    for (int i = 0; i < instructionLine.length; i++) {
      final subString = instructionLine.substring(i);
      if (subString[0] == 'R' || subString[0] == 'L') {
        switch (subString[0]) {
          case 'R':
            instructions.add(MagicInstruction(isStep: false, clockwise: true));
            break;
          case 'L':
            instructions.add(MagicInstruction(isStep: false, clockwise: false));
            break;
        }
      } else {
        final indexOfR = subString.indexOf('R');
        final indexOfL = subString.indexOf('L');
        int maxL = 0;
        if (indexOfR != -1 || indexOfL != -1) {
          if (indexOfR == -1) {
            maxL += indexOfL;
          } else if (indexOfL == -1) {
            maxL += indexOfR;
          } else {
            if (indexOfR < indexOfL) {
              maxL += indexOfR;
            } else {
              maxL += indexOfL;
            }
          }
        } else {
          maxL = subString.length;
        }
        final subString2 = instructionLine.substring(i, i + maxL);
        final steps = int.parse(subString2);
        if (steps >= 10) {
          i++;
        }
        if (steps >= 100) {
          i++;
        }
        instructions.add(MagicInstruction(isStep: true, steps: steps));
      }
    }
    return MagicGame(field, instructions);
  }

  @override
  int solvePart1() {
    final game = parseInput();
    final field = game.field;
    final instructions = game.instructions;
    MagicDirection currentDirection = MagicDirection.right;
    for (final instruction in instructions) {
      if (instruction.isStep) {
        field.moveOnField(instruction.steps!, currentDirection);
      } else {
        currentDirection = currentDirection.turn(instruction.clockwise!);
      }
    }
    return (field.hero.y + 1) * 1000 +
        (field.hero.x + 1) * 4 +
        currentDirection.index;
  }

  MagicGameP2 parseInputP2() {
    final inputUtil = InputUtil(22);
    final lines = inputUtil.getPerLine();
    final instructionLine = lines.removeLast();
    lines.removeLast(); // Removes empty line
    int maxLength = 0;
    for (final line in lines) {
      if (line.length > maxLength) {
        maxLength = line.length;
      }
    }
    final fieldList = List.generate(
      lines.length,
      (index) => List.generate(
        maxLength,
        (index) => MagicTile.empty,
      ),
    );
    final field = MagicField(fieldList, Position(0, 0));
    for (int y = 0; y < lines.length; y++) {
      for (int x = 0; x < lines[y].length; x++) {
        switch (lines[y][x]) {
          case '#':
            field.setValueAt(x, y, MagicTile.obstacle);
            break;
          case '.':
            field.setValueAt(x, y, MagicTile.walkable);
            break;
          case ' ':
            field.setValueAt(x, y, MagicTile.empty);
            break;
        }
      }
    }
    final List<MagicFieldP2> fields = [];
    // NOTE: Example is 3 / 4
    for (int y = 0; y < 4; y++) {
      for (int x = 0; x < 3; x++) {
        final fieldList = List.generate(
          faceHeight,
          (index) => List.generate(
            faceWidth,
            (index) => MagicTile.empty,
          ),
        );
        final mfield = MagicFieldP2(fieldList);
        for (int j = 0; j < faceHeight; j++) {
          for (int k = 0; k < faceWidth; k++) {
            mfield.setValueAt(k, j,
                field.getValueAt((x * faceWidth) + k, (y * faceHeight) + j));
          }
        }
        fields.add(mfield);
      }
    }
    for (int x = 0; x < lines[0].length; x++) {
      if (lines[0][x] == '.') {
        field.setHeroPosition(Position(x, 0));
        field.setValueAt(x, 0, MagicTile.hero);
        break;
      }
    }
    final List<MagicInstruction> instructions = [];
    for (int i = 0; i < instructionLine.length; i++) {
      final subString = instructionLine.substring(i);
      if (subString[0] == 'R' || subString[0] == 'L') {
        switch (subString[0]) {
          case 'R':
            instructions.add(MagicInstruction(isStep: false, clockwise: true));
            break;
          case 'L':
            instructions.add(MagicInstruction(isStep: false, clockwise: false));
            break;
        }
      } else {
        final indexOfR = subString.indexOf('R');
        final indexOfL = subString.indexOf('L');
        int maxL = 0;
        if (indexOfR != -1 || indexOfL != -1) {
          if (indexOfR == -1) {
            maxL += indexOfL;
          } else if (indexOfL == -1) {
            maxL += indexOfR;
          } else {
            if (indexOfR < indexOfL) {
              maxL += indexOfR;
            } else {
              maxL += indexOfL;
            }
          }
        } else {
          maxL = subString.length;
        }
        final subString2 = instructionLine.substring(i, i + maxL);
        final steps = int.parse(subString2);
        if (steps >= 10) {
          i++;
        }
        if (steps >= 100) {
          i++;
        }
        instructions.add(MagicInstruction(isStep: true, steps: steps));
      }
    }
    // Example Cube
    // final magicFieldCubeList = [
    //   [
    //     fields[0],
    //     fields[1],
    //     fields[2],
    //     fields[3],
    //   ],
    //   [
    //     fields[4],
    //     fields[5],
    //     fields[6],
    //     fields[7],
    //   ],
    //   [
    //     fields[8],
    //     fields[9],
    //     fields[10],
    //     fields[11],
    //   ],
    // ];
    final magicFieldCubeList = [
      [
        fields[0],
        fields[1],
        fields[2],
      ],
      [
        fields[3],
        fields[4],
        fields[5],
      ],
      [
        fields[6],
        fields[7],
        fields[8],
      ],
      [
        fields[9],
        fields[10],
        fields[11],
      ]
    ];
    final cube = MagicFieldCube(magicFieldCubeList);
    return MagicGameP2(cube, instructions);
  }

  @override
  int solvePart2() {
    final game = parseInputP2();
    final cube = game.fields;
    final instructions = game.instructions;
    MagicDirection currentDirection = MagicDirection.right;
    for (final instruction in instructions) {
      if (instruction.isStep) {
        currentDirection =
            cube.moveOnField(instruction.steps!, currentDirection);
      } else {
        currentDirection = currentDirection.turn(instruction.clockwise!);
      }
    }
    int yOffset = 0;
    int xOffset = 0;
    switch (cube.heroCubeIndex) {
      case 1:
        xOffset = 1;
        break;
      case 2:
        xOffset = 2;
        break;
      case 3:
        xOffset = 1;
        yOffset = 1;
        break;
      case 4:
        yOffset = 2;
        break;
      case 5:
        xOffset = 1;
        yOffset = 2;
        break;
      case 6:
        yOffset = 3;
        break;
    }
    print("Hero Y (Row): ${((yOffset * faceHeight) + cube.heroY + 1)}");
    print("Hero X (Column): ${((xOffset * faceWidth) + cube.heroX + 1)}");
    print("Hero Direction: ${currentDirection.index}");
    return ((yOffset * faceHeight) + cube.heroY + 1) * 1000 +
        ((xOffset * faceWidth) + cube.heroX + 1) * 4 +
        currentDirection.index;
  }
}
