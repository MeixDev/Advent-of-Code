import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  Field<String> parseLines(List<String> lines) {
    final List<List<String>> decomposedLines = [];
    for (final line in lines) {
      final decomposedLine = line.split('');
      if (!"ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(decomposedLine.last)) {
        decomposedLine.removeLast();
      }
      decomposedLines.add(decomposedLine);
    }
    final Field<String> field = Field<String>(decomposedLines);
    return field;
  }

  @override
  Field<String> parseInput() {
    final lines = input.getPerLine();
    final field = parseLines(lines);
    return field;
  }

  int tryFindXmas(Field<String> field, int x, int y, List<String> mas,
      Position? direction) {
    final neighbours = field.neighbours(x, y);
    int found = 0;
    if (direction == null) {
      for (final neighbour in neighbours) {
        final neighValue = field.getValueAt(neighbour.x, neighbour.y);
        if (neighValue == mas[0]) {
          if (mas.length == 1) {
            return 1;
          }
          // print(
          //     "Found ${mas[0]} at ${neighbour.x}, ${neighbour.y}. Progressing to search ${mas[1]}");
          found += tryFindXmas(field, neighbour.x, neighbour.y, mas.sublist(1),
              Position(neighbour.x - x, neighbour.y - y));
        }
      }
    } else {
      final nextX = x + direction.x;
      final nextY = y + direction.y;
      if (!field.isOnField(Position(nextX, nextY))) {
        return 0;
      }
      final nextValue = field.getValueAt(nextX, nextY);
      if (nextValue == mas[0]) {
        if (mas.length == 1) {
          return 1;
        }
        // print(
        //     "Found ${mas[0]} at $nextX, $nextY. Progressing to search ${mas[1]}");
        found += tryFindXmas(field, nextX, nextY, mas.sublist(1), direction);
      }
    }
    return found;
  }

  @override
  int solvePart1() {
    final field = parseInput();
    // print(field.toString());
    int sum = 0;
    field.forEach((int x, int y) {
      if (field.getValueAt(x, y) == 'X') {
        // print('Found X at $x, $y');
        final mas = <String>['M', 'A', 'S'];
        final found = tryFindXmas(field, x, y, mas, null);
        sum += found;
      }
    });
    return sum;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    // print(field.toString());
    int sum = 0;
    field.forEach((int x, int y) {
      if (field.getValueAt(x, y) == 'A') {
        // print('Found X at $x, $y');
        final crossMas = field.diagonals(x, y);
        if (crossMas.length != 4) {
          return;
        }

        final mas =
            crossMas.map((pos) => field.getValueAt(pos.x, pos.y)).toList();

        if ((mas[0] == 'M' &&
                mas[1] == 'M' &&
                mas[2] == 'S' &&
                mas[3] == 'S') ||
            (mas[0] == 'S' &&
                mas[1] == 'S' &&
                mas[2] == 'M' &&
                mas[3] == 'M') ||
            (mas[0] == 'S' &&
                mas[1] == 'M' &&
                mas[2] == 'M' &&
                mas[3] == 'S') ||
            (mas[0] == 'M' &&
                mas[1] == 'S' &&
                mas[2] == 'S' &&
                mas[3] == 'M')) {
          sum += 1;
        }
      }
    });
    return sum;
  }
}
