import '../utils/index.dart';

class SourceDestination {
  final int initialDestination;
  final int initialSource;
  final int range;

  SourceDestination({
    required this.initialDestination,
    required this.initialSource,
    required this.range,
  });
}

class Instructions {
  List<int> seeds;
  List<List<SourceDestination>> ranges;

  Instructions({
    required this.seeds,
    required this.ranges,
  });
}

class SeedRange {
  final int seed;
  final int range;

  SeedRange({required this.seed, required this.range});
}

class InstructionsP2 {
  List<SeedRange> seeds;
  List<List<SourceDestination>> ranges;

  InstructionsP2({
    required this.seeds,
    required this.ranges,
  });
}

class Day05 extends GenericDay {
  Day05() : super(5);

  void parseLines(List<String> lines) {}

  @override
  Instructions parseInput() {
    final lines = input.getPerLine();
    int lineIndex = 0;
    final seedLine = lines[lineIndex];
    var split = seedLine.split(' ');
    split = split.getRange(1, split.length).toList();
    final seeds = <int>[];
    for (final seed in split) {
      seeds.add(int.tryParse(seed) ?? -1);
    }
    lineIndex += 3;
    int step = 0;
    final ranges = List<List<SourceDestination>>.generate(
        7, (index) => List<SourceDestination>.empty(growable: true));
    while (step != 7) {
      while (lineIndex < lines.length && lines[lineIndex].length > 1) {
        final line = lines[lineIndex];
        final split = line.split(' ');
        final initialDestination = int.tryParse(split[0]) ?? -1;
        final initialSource = int.tryParse(split[1]) ?? -1;
        final range = int.tryParse(split[2]) ?? -1;
        ranges[step].add(SourceDestination(
            initialDestination: initialDestination,
            initialSource: initialSource,
            range: range));
        lineIndex++;
      }
      step++;
      lineIndex += 2;
    }
    return Instructions(seeds: seeds, ranges: ranges);
  }

  InstructionsP2 parseInputP2() {
    final lines = input.getPerLine();
    int lineIndex = 0;
    final seedLine = lines[lineIndex];
    var split = seedLine.split(' ');
    split = split.getRange(1, split.length).toList();
    final seeds = <int>[];
    for (final seed in split) {
      seeds.add(int.tryParse(seed) ?? -1);
    }
    int seedIndex = 0;
    final seedRanges = <SeedRange>[];
    while (seedIndex < seeds.length) {
      seedRanges
          .add(SeedRange(seed: seeds[seedIndex], range: seeds[seedIndex + 1]));
      seedIndex += 2;
    }
    lineIndex += 3;
    int step = 0;
    final ranges = List<List<SourceDestination>>.generate(
        7, (index) => List<SourceDestination>.empty(growable: true));
    while (step != 7) {
      while (lineIndex < lines.length && lines[lineIndex].length > 1) {
        final line = lines[lineIndex];
        final split = line.split(' ');
        final initialDestination = int.tryParse(split[0]) ?? -1;
        final initialSource = int.tryParse(split[1]) ?? -1;
        final range = int.tryParse(split[2]) ?? -1;
        ranges[step].add(SourceDestination(
            initialDestination: initialDestination,
            initialSource: initialSource,
            range: range));
        lineIndex++;
      }
      step++;
      lineIndex += 2;
    }
    return InstructionsP2(seeds: seedRanges, ranges: ranges);
  }

  @override
  int solvePart1() {
    final instructions = parseInput();
    final seeds = instructions.seeds;
    int lowestLocation = -1;
    for (final seed in seeds) {
      int step = 0;
      int currentValue = seed;
      while (step != 7) {
        final range = instructions.ranges[step];
        for (final sourceDestination in range) {
          final source = sourceDestination.initialSource;
          if (source <= currentValue &&
              currentValue <= source + sourceDestination.range) {
            currentValue = sourceDestination.initialDestination +
                (currentValue - sourceDestination.initialSource);
            break;
          }
        }
        step++;
      }
      if (lowestLocation == -1 || currentValue < lowestLocation) {
        lowestLocation = currentValue;
      }
    }
    return lowestLocation;
  }

  @override
  int solvePart2() {
    final instructions = parseInputP2();
    final seeds = instructions.seeds;
    int lowestLocation = -1;
    for (final seed in seeds) {
      final initValue = seed.seed;
      int seedIterator = 0;
      while (seedIterator < seed.range) {
        int currentValue = initValue + seedIterator;
        int step = 0;
        while (step != 7) {
          final range = instructions.ranges[step];
          for (final sourceDestination in range) {
            final source = sourceDestination.initialSource;
            if (source <= currentValue &&
                currentValue <= source + sourceDestination.range) {
              currentValue = sourceDestination.initialDestination +
                  (currentValue - sourceDestination.initialSource);
              break;
            }
          }
          step++;
        }
        if (lowestLocation == -1 || currentValue < lowestLocation) {
          lowestLocation = currentValue;
        }
        seedIterator++;
      }
    }
    return lowestLocation;
  }
}
