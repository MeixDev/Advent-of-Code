import '../utils/index.dart';

enum Field {
  ash('.'),
  rock('#');

  final String value;
  const Field(this.value);
}

class MirrorField {
  final List<List<Field>> field;

  MirrorField(this.field);
}

class Day13 extends GenericDay {
  Day13() : super(13);

  void parseLines(List<String> lines) {}

  @override
  List<MirrorField> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<List<List<Field>>> fields = [];
    int x = 0;
    for (final line in lines) {
      if (line.length == 1) {
        x++;
        continue;
      }
      final List<Field> row = [];
      for (final char in line.substring(0, line.length - 1).split('')) {
        row.add(Field.values.firstWhere((e) => e.value == char));
      }
      if (fields.length <= x) fields.add([]);
      fields[x].add(row);
    }
    return fields.map((e) => MirrorField(e)).toList();
  }

  int differences(List<Field> a, List<Field> b, [bool countErrors = false]) {
    int errors = 0;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) errors++;
      if (!countErrors && errors > 0) return errors;
    }
    return errors;
  }

  int solve(List<MirrorField> fields, int allowedDifferences) {
    int fieldIterator = 0;
    int score = 0;
    while (fieldIterator < fields.length) {
      // Analyze for horizontal reflections in the field
      final field = fields[fieldIterator];
      int x = 0;
      int foundMirrorAtX = 100000;
      while (x < field.field.length - 1) {
        final row = field.field[x];
        final nextRow = field.field[x + 1];
        int currentDifferences = 0;
        currentDifferences += differences(row, nextRow, allowedDifferences > 0);
        if (currentDifferences <= allowedDifferences) {
          // Need to check if it stays a mirror
          int backX = 1;
          bool isMirror = true;
          while (x - backX >= 0 && x + 1 + backX < field.field.length) {
            final backRow = field.field[x - backX];
            final backNextRow = field.field[x + backX + 1];
            currentDifferences +=
                differences(backRow, backNextRow, allowedDifferences > 0);
            if (currentDifferences <= allowedDifferences) {
              backX++;
            } else {
              isMirror = false;
              break;
            }
          }
          if (allowedDifferences > 0 &&
              currentDifferences < allowedDifferences) {
            isMirror = false;
          }
          if (isMirror) {
            foundMirrorAtX = x;
            break;
          }
        }
        x++;
      }
      // Analyze for vertical reflections in the field
      int y = 0;
      int foundMirrorAtY = 1000000;
      while (y < field.field[0].length - 1) {
        final column = field.field.map((e) => e[y]).toList();
        final nextColumn = field.field.map((e) => e[y + 1]).toList();
        int currentDifferences = 0;
        currentDifferences +=
            differences(column, nextColumn, allowedDifferences > 0);
        if (currentDifferences <= allowedDifferences) {
          // Need to check if it stays a mirror
          int backY = 1;
          bool isMirror = true;
          while (y - backY >= 0 && y + 1 + backY < field.field[0].length) {
            final backColumn = field.field.map((e) => e[y - backY]).toList();
            final backNextColumn =
                field.field.map((e) => e[y + 1 + backY]).toList();
            currentDifferences +=
                differences(backColumn, backNextColumn, allowedDifferences > 0);
            if (currentDifferences <= allowedDifferences) {
              backY++;
            } else {
              isMirror = false;
              break;
            }
          }
          if (allowedDifferences > 0 &&
              currentDifferences < allowedDifferences) {
            isMirror = false;
          }
          if (isMirror) {
            // print("Found horizontal Mirror at field $fieldIterator and y $y");
            foundMirrorAtY = y;
            break;
          }
        }
        y++;
      }
      if (foundMirrorAtX < foundMirrorAtY) {
        score += 100 * (foundMirrorAtX + 1);
      } else {
        score += (foundMirrorAtY + 1);
      }
      fieldIterator++;
    }
    return score;
  }

  @override
  int solvePart1() {
    final fields = parseInput();
    return solve(fields, 0);
  }

  @override
  int solvePart2() {
    final fields = parseInput();
    return solve(fields, 1);
  }
}
