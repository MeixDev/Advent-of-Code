import '../utils/index.dart';

class Race {
  final int time;
  final int distance;

  Race({required this.time, required this.distance});
}

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<Race> parseInput() {
    final races = <Race>[];
    // Input Races:
    races.add(Race(time: 54, distance: 446));
    races.add(Race(time: 81, distance: 1292));
    races.add(Race(time: 70, distance: 1035));
    races.add(Race(time: 88, distance: 1007));

    // Example Races:
    // races.add(Race(time: 7, distance: 9));
    // races.add(Race(time: 15, distance: 40));
    // races.add(Race(time: 30, distance: 200));
    return races;
  }

  Race parseInputP2() {
    // Input Race:
    return Race(time: 54817088, distance: 446129210351007);

    // Example Race:
    // return Race(time: 71530, distance: 940200);
  }

  @override
  int solvePart1() {
    final races = parseInput();
    int score = 1;
    for (final race in races) {
      int x = 0;
      int y = race.time;
      while (true) {
        final speed = x;
        final time = race.time - x;
        final distance = speed * time;
        if (distance > race.distance) {
          break;
        }
        x++;
      }
      while (true) {
        final speed = y;
        final time = race.time - y;
        final distance = speed * time;
        if (distance > race.distance) {
          break;
        }
        y--;
      }
      final totalSolutions = y - x + 1;
      score *= totalSolutions;
    }
    return score;
  }

  @override
  int solvePart2() {
    final race = parseInputP2();
    int score = 1;
    int x = 0;
    int y = race.time;
    while (true) {
      final speed = x;
      final time = race.time - x;
      final distance = speed * time;
      if (distance > race.distance) {
        break;
      }
      x++;
    }
    while (true) {
      final speed = y;
      final time = race.time - y;
      final distance = speed * time;
      if (distance > race.distance) {
        break;
      }
      y--;
    }
    final totalSolutions = y - x + 1;
    score *= totalSolutions;
    return score;
  }
}
