import '../utils/index.dart';

class AntennaPoint {
  final String? type;
  bool isAntinode;

  AntennaPoint(this.type) : isAntinode = false;

  AntennaPoint hasAntinode() {
    isAntinode = true;
    return this;
  }

  @override
  String toString({bool antinodesFront = true}) {
    if (antinodesFront) {
      return isAntinode ? '#' : type ?? '.';
    }
    return type ?? '.';
  }
}

String antennaTypes =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

class Day08 extends GenericDay {
  Day08() : super(8);

  Field<AntennaPoint> parseLines(List<String> lines) {
    final Field<AntennaPoint> field = Field(List.generate(lines.length,
        (_) => List.filled(lines[0].length - 1, AntennaPoint(null))));
    for (var y = 0; y < lines.length; y++) {
      for (var x = 0; x < lines[y].length; x++) {
        final char = lines[y][x];
        if (antennaTypes.contains(char)) {
          field.setValueAt(x, y, AntennaPoint(char));
        }
      }
    }
    return field;
  }

  @override
  Field<AntennaPoint> parseInput() {
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  @override
  int solvePart1() {
    final Field<AntennaPoint> field = parseInput();
    // print(field.toString());
    final Map<String, List<Position>> antennasPerType = {};
    for (var y = 0; y < field.height; y++) {
      for (var x = 0; x < field.width; x++) {
        final point = field.getValueAt(x, y);
        if (point.type != null) {
          if (antennasPerType.containsKey(point.type)) {
            antennasPerType[point.type]!.add(Position(x, y));
          } else {
            antennasPerType[point.type!] = [Position(x, y)];
          }
        }
      }
    }
    Set<Position> antinodes = {};
    for (final MapEntry<String, List<Position>> entry
        in antennasPerType.entries) {
      final type = entry.key;
      final positions = entry.value;
      if (positions.length == 1) {
        continue;
      }
      for (int i = 0; i < positions.length; i++) {
        for (int j = i + 1; j < positions.length; j++) {
          // Calc the vector between the two points
          final xDiff = positions[j].x - positions[i].x;
          final yDiff = positions[j].y - positions[i].y;
          final antinode1 =
              Position(positions[i].x - xDiff, positions[i].y - yDiff);
          if (field.isOnField(antinode1)) {
            field.setValueAt(
                antinode1.x, antinode1.y, AntennaPoint(type).hasAntinode());
            antinodes.add(antinode1);
          }
          final antinode2 =
              Position(positions[j].x + xDiff, positions[j].y + yDiff);
          if (field.isOnField(antinode2)) {
            field.setValueAt(
                antinode2.x, antinode2.y, AntennaPoint(type).hasAntinode());
            antinodes.add(antinode2);
          }
        }
      }
    }
    // print(antennasPerType);
    // print(antinodes);
    // print(field.toString());
    return antinodes.length;
  }

  @override
  int solvePart2() {
    final Field<AntennaPoint> field = parseInput();
    // print(field.toString());
    final Map<String, List<Position>> antennasPerType = {};
    for (var y = 0; y < field.height; y++) {
      for (var x = 0; x < field.width; x++) {
        final point = field.getValueAt(x, y);
        if (point.type != null) {
          if (antennasPerType.containsKey(point.type)) {
            antennasPerType[point.type]!.add(Position(x, y));
          } else {
            antennasPerType[point.type!] = [Position(x, y)];
          }
        }
      }
    }
    Set<Position> antinodes = {};
    for (final MapEntry<String, List<Position>> entry
        in antennasPerType.entries) {
      final type = entry.key;
      final positions = entry.value;
      if (positions.length == 1) {
        continue;
      }
      for (int i = 0; i < positions.length; i++) {
        for (int j = i + 1; j < positions.length; j++) {
          // Calc the vector between the two points
          final xDiff = positions[j].x - positions[i].x;
          final yDiff = positions[j].y - positions[i].y;
          Position antinode1 =
              Position(positions[i].x - xDiff, positions[i].y - yDiff);
          while (field.isOnField(antinode1)) {
            field.setValueAt(
                antinode1.x, antinode1.y, AntennaPoint(type).hasAntinode());
            antinodes.add(antinode1);
            antinode1 = Position(antinode1.x - xDiff, antinode1.y - yDiff);
          }
          Position antinode2 =
              Position(positions[j].x + xDiff, positions[j].y + yDiff);
          while (field.isOnField(antinode2)) {
            field.setValueAt(
                antinode2.x, antinode2.y, AntennaPoint(type).hasAntinode());
            antinodes.add(antinode2);
            antinode2 = Position(antinode2.x + xDiff, antinode2.y + yDiff);
          }
          antinodes.add(positions[j]);
          antinodes.add(positions[i]);
        }
      }
    }
    // print(antennasPerType);
    // print(antinodes);
    // print(field.toString());
    return antinodes.length;
  }
}
