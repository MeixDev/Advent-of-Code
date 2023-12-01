import 'dart:io';

import '../utils/index.dart';

class RockyField extends Field<RockyTile> {
  RockyField(List<List<RockyTile>> field) : super(field);

  int floorY = 0;
}

class RockyTile {
  final bool obstacle;
  final bool sand;

  bool get filled => obstacle || sand;

  RockyTile(this.obstacle, this.sand);
}

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  Field<RockyTile> parseInput() {
    final inputUtil = InputUtil(14);
    final Field<RockyTile> field = Field<RockyTile>(
        List<List<RockyTile>>.generate(
            200,
            (index) => List<RockyTile>.generate(
                130, (index) => RockyTile(false, false))));
    final lines = inputUtil.getPerLine();
    for (final line in lines) {
      final split = line.split(' ');
      final List<Position> positions = [];
      for (int i = 0; i < split.length; i++) {
        if (split[i] != "->") {
          final pos = split[i].split(',');
          positions.add(Position(int.parse(pos[0]) - 420, int.parse(pos[1])));
        }
      }
      for (int i = 1; i < positions.length; i++) {
        final prevPos = positions[i - 1];
        final pos = positions[i];
        if (prevPos.x == pos.x) {
          final min = prevPos.y < pos.y ? prevPos.y : pos.y;
          final max = prevPos.y > pos.y ? prevPos.y : pos.y;
          for (int y = min; y <= max; y++) {
            field.setValueAtPosition(
                Position(prevPos.x, y), RockyTile(true, false));
          }
        } else {
          final min = prevPos.x < pos.x ? prevPos.x : pos.x;
          final max = prevPos.x > pos.x ? prevPos.x : pos.x;
          for (int x = min; x <= max; x++) {
            field.setValueAtPosition(
                Position(x, prevPos.y), RockyTile(true, false));
          }
        }
      }
    }
    return field;
  }

  RockyField parseInputP2() {
    final inputUtil = InputUtil(14);
    int maxY = 0;
    final RockyField field = RockyField(List<List<RockyTile>>.generate(
        200,
        (index) => List<RockyTile>.generate(
            1000, (index) => RockyTile(false, false))));
    final lines = inputUtil.getPerLine();
    for (final line in lines) {
      final split = line.split(' ');
      final List<Position> positions = [];
      for (int i = 0; i < split.length; i++) {
        if (split[i] != "->") {
          final pos = split[i].split(',');
          positions.add(Position(int.parse(pos[0]), int.parse(pos[1])));
        }
      }
      for (int i = 1; i < positions.length; i++) {
        final prevPos = positions[i - 1];
        final pos = positions[i];
        if (prevPos.y > maxY) {
          maxY = prevPos.y;
        }
        if (pos.y > maxY) {
          maxY = pos.y;
        }
        if (prevPos.x == pos.x) {
          final min = prevPos.y < pos.y ? prevPos.y : pos.y;
          final max = prevPos.y > pos.y ? prevPos.y : pos.y;
          for (int y = min; y <= max; y++) {
            field.setValueAtPosition(
                Position(prevPos.x, y), RockyTile(true, false));
          }
        } else {
          final min = prevPos.x < pos.x ? prevPos.x : pos.x;
          final max = prevPos.x > pos.x ? prevPos.x : pos.x;
          for (int x = min; x <= max; x++) {
            field.setValueAtPosition(
                Position(x, prevPos.y), RockyTile(true, false));
          }
        }
      }
    }
    for (int x = 0; x < field.width; x++) {
      field.setValueAt(x, maxY + 2, RockyTile(true, false));
    }
    field.floorY = maxY + 2;
    return field;
  }

  void printField(Field<RockyTile> field) {
    for (int i = 0; i < field.height; i++) {
      final row = field.getRow(i);

      for (final tile in row) {
        if (tile.obstacle) {
          stdout.write('#');
        } else if (tile.sand) {
          stdout.write('o');
        } else {
          stdout.write('.');
        }
      }
      stdout.writeln();
    }
  }

  @override
  int solvePart1() {
    final field = parseInput();
    int score = 0;
    bool sandRested = true;
    while (sandRested) {
      Position sandPos = Position(80, 0);
      bool sandMoved = true;
      while (sandMoved) {
        if (sandPos.y >= field.height - 1) {
          sandRested = false;
          break;
        }
        if (field.getValueAt(sandPos.x, sandPos.y + 1).filled) {
          if (field.getValueAt(sandPos.x - 1, sandPos.y + 1).filled) {
            if (field.getValueAt(sandPos.x + 1, sandPos.y + 1).filled) {
              sandMoved = false;
              score += 1;
              field.setValueAtPosition(sandPos, RockyTile(false, true));
            } else {
              sandPos = Position(sandPos.x + 1, sandPos.y + 1);
            }
          } else {
            sandPos = Position(sandPos.x - 1, sandPos.y + 1);
          }
        } else {
          sandPos = Position(sandPos.x, sandPos.y + 1);
        }
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final field = parseInputP2();
    int score = 0;
    bool sandFlows = true;
    while (sandFlows) {
      Position sandPos = Position(500, 0);
      bool sandMoved = true;
      while (sandMoved) {
        if (field.getValueAt(sandPos.x, sandPos.y + 1).filled) {
          if (field.getValueAt(sandPos.x - 1, sandPos.y + 1).filled) {
            if (field.getValueAt(sandPos.x + 1, sandPos.y + 1).filled) {
              sandMoved = false;
              score += 1;
              field.setValueAtPosition(sandPos, RockyTile(false, true));
              if (sandPos.x == 500 && sandPos.y == 0) {
                sandFlows = false;
              }
            } else {
              sandPos = Position(sandPos.x + 1, sandPos.y + 1);
            }
          } else {
            sandPos = Position(sandPos.x - 1, sandPos.y + 1);
          }
        } else {
          sandPos = Position(sandPos.x, sandPos.y + 1);
        }
      }
    }
    return score;
  }
}
