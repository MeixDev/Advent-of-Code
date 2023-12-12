import '../utils/index.dart';

// I think today we implement Memoization baby
// Source: http://dartery.blogspot.com/2012/09/memoizing-functions-in-dart.html
// As a note tho whoever reads this: I hope there is a cleaner way to implement this, as a lot of those calls were somewhat dynamic only
// It still is like, super interesting, and the gain in speed is INSANE.
// Went from like 5+ minutes to solve 3 lines of my input to 15 seconds top to solve a thousand lines
// Some other probably interesting reads and/or packages I found after I solved it:
// https://www.noveltech.dev/how-memoization-dart-flutter
// https://pub.dev/packages/memoized
// Wish I saw that package earlier though.. NEXT TIME !

enum SpringState {
  functional('.'),
  damaged('#'),
  unknown('?');

  final String value;
  const SpringState(this.value);
}

class Record {
  final List<SpringState> record;
  final List<int> continuousDamagedSprings;

  Record(this.record, this.continuousDamagedSprings);
}

class Day12 extends GenericDay {
  Day12() : super(12);

  void parseLines(List<String> lines) {}

  @override
  List<Record> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final List<Record> records = [];
    for (final line in lines) {
      final List<SpringState> record = [];
      final List<int> continuousDamagedSprings = [];

      final springsMap = line.split(' ')[0];
      final springsInfo = line.split(' ')[1];

      for (final char in springsMap.split('')) {
        switch (char) {
          case '.':
            record.add(SpringState.functional);
            break;
          case '#':
            record.add(SpringState.damaged);
            break;
          case '?':
            record.add(SpringState.unknown);
            break;
          default:
            throw Exception('Unknown char $char');
        }
      }
      for (final number in springsInfo.split(',')) {
        continuousDamagedSprings.add(int.parse(number));
      }

      records.add(Record(record, continuousDamagedSprings));
    }
    return records;
  }

  memoizeSolve(int Function(Function, List<SpringState>, List<int>, int) f) {
    final cache = Map();
    m(m2, List<SpringState> record, List<int> remain, int withinRun) {
      final key = record.toString() + remain.toString() + withinRun.toString();
      if (cache.containsKey(key)) {
        return cache[key];
      } else {
        final result = f(m2, record, remain, withinRun);
        cache[key] = result;
        return result;
      }
    }

    return (List<SpringState> record, List<int> remain, int withinRun) =>
        m(m, record, remain, withinRun);
  }

  int solveDumb(List<SpringState> record, List<int> remain, int withinRun) =>
      solve(solve, record, remain, withinRun);

  int solve(
      solveDef, List<SpringState> record, List<int> remain, int withinRun) {
    if (record.isEmpty) {
      if (withinRun == 0 && remain.isEmpty) {
        return 1;
      }
      if (remain.length == 1 && withinRun != 0 && withinRun == remain[0]) {
        return 1;
      }
      return 0;
    }

    int futurePossibilities = 0;
    for (final state in record) {
      if (state == SpringState.damaged || state == SpringState.unknown) {
        futurePossibilities += 1;
      }
    }
    if (withinRun != 0 &&
        (futurePossibilities + withinRun) <
            (remain.isEmpty
                ? 0
                : remain.reduce((value, element) => value + element))) {
      return 0;
    }
    if (withinRun == 0 &&
        futurePossibilities <
            (remain.isEmpty
                ? 0
                : remain.reduce((value, element) => value + element))) {
      return 0;
    }
    if (withinRun != 0 && remain.length == 0) {
      return 0;
    }
    num currentPossibilities = 0;
    final first = record[0];
    if (first == SpringState.functional &&
        withinRun != 0 &&
        withinRun != remain[0]) return 0;
    if (first == SpringState.functional && withinRun != 0)
      currentPossibilities += solveDef(
        solveDef,
        record.sublist(1),
        remain.sublist(1),
        0,
      );
    if (first == SpringState.unknown &&
        withinRun != 0 &&
        withinRun == remain[0])
      currentPossibilities += solveDef(
        solveDef,
        record.sublist(1),
        remain.sublist(1),
        0,
      );
    if ((first == SpringState.damaged || first == SpringState.unknown) &&
        withinRun != 0)
      currentPossibilities += solveDef(
        solveDef,
        record.sublist(1),
        remain,
        withinRun + 1,
      );
    if ((first == SpringState.damaged || first == SpringState.unknown) &&
        withinRun == 0)
      currentPossibilities += solveDef(
        solveDef,
        record.sublist(1),
        remain,
        1,
      );
    if ((first == SpringState.unknown || first == SpringState.functional) &&
        withinRun == 0)
      currentPossibilities += solveDef(
        solveDef,
        record.sublist(1),
        remain,
        0,
      );
    return currentPossibilities as int;
  }

  @override
  int solvePart1() {
    final records = parseInput();
    num score = 0;
    for (final record in records) {
      final fastSolve = memoizeSolve(solve);
      final lineScore =
          fastSolve(record.record, record.continuousDamagedSprings, 0);
      // print("Line Score: $lineScore");
      score += lineScore;
    }
    return score as int;
  }

  @override
  int solvePart2() {
    final records = parseInput();
    num score = 0;
    for (final record in records) {
      final trueRecord = <SpringState>[];
      final trueContinuousDamagedSprings = <int>[];
      for (int x = 0; x < 5; x++) {
        trueRecord.addAll(record.record);
        trueContinuousDamagedSprings.addAll(record.continuousDamagedSprings);
        if (x < 4) trueRecord.add(SpringState.unknown);
      }
      final fastSolve = memoizeSolve(solve);
      final lineScore = fastSolve(trueRecord, trueContinuousDamagedSprings, 0);
      // print("Line Score: $lineScore");
      score += lineScore;
    }
    return score as int;
  }
}
