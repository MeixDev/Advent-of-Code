import '../utils/index.dart';
import 'dart:math' as math;

class Blueprint {
  int blueprintIndex;
  int oreRobotOrePrice;
  int clayRobotOrePrice;
  int obsidianRobotOrePrice;
  int obsidianRobotClayPrice;
  int geodeRobotOrePrice;
  int geodeRobotObsidianPrice;

  int get oreMaxPrice => math.max(
        clayRobotOrePrice,
        math.max(
          obsidianRobotOrePrice,
          geodeRobotOrePrice,
        ),
      );

  Blueprint(
    this.blueprintIndex,
    this.oreRobotOrePrice,
    this.clayRobotOrePrice,
    this.obsidianRobotOrePrice,
    this.obsidianRobotClayPrice,
    this.geodeRobotOrePrice,
    this.geodeRobotObsidianPrice,
  );
}

class DiggingOperation {
  int oreRobotCount;
  int clayRobotCount;
  int obsidianRobotCount;
  int geodeRobotCount;

  int oreCount;
  int clayCount;
  int obsidianCount;
  int openGeodeCount;

  int timeLeft;

  DiggingOperation({
    this.oreRobotCount = 1,
    this.clayRobotCount = 0,
    this.obsidianRobotCount = 0,
    this.geodeRobotCount = 0,
    this.oreCount = 0,
    this.clayCount = 0,
    this.obsidianCount = 0,
    this.openGeodeCount = 0,
    this.timeLeft = 24,
  });

  DiggingOperation clone() {
    return DiggingOperation(
      oreRobotCount: oreRobotCount,
      clayRobotCount: clayRobotCount,
      obsidianRobotCount: obsidianRobotCount,
      geodeRobotCount: geodeRobotCount,
      oreCount: oreCount,
      clayCount: clayCount,
      obsidianCount: obsidianCount,
      openGeodeCount: openGeodeCount,
      timeLeft: timeLeft,
    );
  }
}

class Day19 extends GenericDay {
  Day19() : super(19);
  @override
  List<Blueprint> parseInput() {
    final inputUtil = InputUtil(19);
    final lines = inputUtil.getPerLine();
    final blueprints = <Blueprint>[];
    for (final line in lines) {
      final split = line.split(' ');
      final blueprintIndex = int.parse(split[1].replaceAll(':', ''));
      final oreRobotOrePrice = int.parse(split[6]);
      final clayRobotOrePrice = int.parse(split[12]);
      final obsidianRobotOrePrice = int.parse(split[18]);
      final obsidianRobotClayPrice = int.parse(split[21]);
      final geodeRobotOrePrice = int.parse(split[27]);
      final geodeRobotObsidianPrice = int.parse(split[30]);
      blueprints.add(
        Blueprint(
          blueprintIndex,
          oreRobotOrePrice,
          clayRobotOrePrice,
          obsidianRobotOrePrice,
          obsidianRobotClayPrice,
          geodeRobotOrePrice,
          geodeRobotObsidianPrice,
        ),
      );
    }
    return blueprints;
  }

  int searchForGeodes(Blueprint bp, DiggingOperation op, int floor) {
    if (op.timeLeft == 0) {
      return op.openGeodeCount;
    }

    if (op.openGeodeCount +
            op.timeLeft * op.geodeRobotCount +
            op.timeLeft * (op.timeLeft - 1) / 2 <=
        floor) {
      return 0;
    }

    final tryOre =
        op.oreCount >= bp.oreRobotOrePrice && op.oreRobotCount < bp.oreMaxPrice;
    final tryClay = op.oreCount >= bp.clayRobotOrePrice;
    final tryObsidian = op.oreCount >= bp.obsidianRobotOrePrice &&
        op.clayCount >= bp.obsidianRobotClayPrice;
    final tryGeode = op.oreCount >= bp.geodeRobotOrePrice &&
        op.obsidianCount >= bp.geodeRobotObsidianPrice;

    op.timeLeft -= 1;
    op.oreCount += op.oreRobotCount;
    op.clayCount += op.clayRobotCount;
    op.obsidianCount += op.obsidianRobotCount;
    op.openGeodeCount += op.geodeRobotCount;

    // Priority to geode robots as they're virtually the best
    int best = floor;
    if (tryGeode) {
      final opAttempt = op.clone();
      opAttempt.geodeRobotCount += 1;
      opAttempt.oreCount -= bp.geodeRobotOrePrice;
      opAttempt.obsidianCount -= bp.geodeRobotObsidianPrice;
      best = math.max(best, searchForGeodes(bp, opAttempt, best));
    }
    if (tryObsidian) {
      final opAttempt = op.clone();
      opAttempt.obsidianRobotCount += 1;
      opAttempt.oreCount -= bp.obsidianRobotOrePrice;
      opAttempt.clayCount -= bp.obsidianRobotClayPrice;
      best = math.max(best, searchForGeodes(bp, opAttempt, best));
    }
    if (tryClay) {
      final opAttempt = op.clone();
      opAttempt.clayRobotCount += 1;
      opAttempt.oreCount -= bp.clayRobotOrePrice;
      best = math.max(best, searchForGeodes(bp, opAttempt, best));
    }
    if (tryOre) {
      final opAttempt = op.clone();
      opAttempt.oreRobotCount += 1;
      opAttempt.oreCount -= bp.oreRobotOrePrice;
      best = math.max(best, searchForGeodes(bp, opAttempt, best));
    }
    best = math.max(best, searchForGeodes(bp, op.clone(), best));
    return best;
  }

  @override
  int solvePart1() {
    final stopwatch = Stopwatch()..start();
    final blueprints = parseInput();
    int score = 0;
    for (final blueprint in blueprints) {
      DiggingOperation op = DiggingOperation();

      final maxGeodes = searchForGeodes(blueprint, op, 0);
      score += maxGeodes * blueprint.blueprintIndex;
    }
    stopwatch.stop();
    print("${stopwatch.elapsedMilliseconds} ms");
    return score;
  }

  @override
  int solvePart2() {
    final stopwatch = Stopwatch()..start();
    final blueprints = parseInput();
    int score = 0;
    for (final blueprint in blueprints.sublist(0, 3)) {
      DiggingOperation op = DiggingOperation(timeLeft: 32);

      final maxGeodes = searchForGeodes(blueprint, op, 0);
      if (score == 0) {
        score = maxGeodes;
      } else {
        score *= maxGeodes;
      }
    }
    stopwatch.stop();
    print("${stopwatch.elapsedMilliseconds} ms");
    return score;
  }
}
