import '../utils/index.dart';

enum OpponentChoice {
  rock,
  paper,
  scissors,
}

enum PlayerChoice {
  none,
  rock,
  paper,
  scissors,
}

class Day02 extends GenericDay {
  Day02() : super(2);

  List<Tuple2<OpponentChoice, PlayerChoice>> parseGames(List<String> games) {
    final result = <Tuple2<OpponentChoice, PlayerChoice>>[];
    for (final game in games) {
      if (game.isEmpty) {
        continue;
      }
      final parts = game.split(' ');
      final opponent = parts[0];
      final player = parts[1];
      result.add(Tuple2(
        opponent == 'A'
            ? OpponentChoice.rock
            : opponent == 'B'
                ? OpponentChoice.paper
                : OpponentChoice.scissors,
        player == 'X'
            ? PlayerChoice.rock
            : player == 'Y'
                ? PlayerChoice.paper
                : player == 'Z'
                    ? PlayerChoice.scissors
                    : PlayerChoice.none,
      ));
    }
    return result;
  }

  @override
  List<Tuple2<OpponentChoice, PlayerChoice>> parseInput() {
    final inputUtil = InputUtil(2);
    final games = inputUtil.getPerLine();
    final played = parseGames(games);
    return played;
  }

  @override
  int solvePart1() {
    final played = parseInput();
    int score = 0;
    for (final game in played) {
      score += game.item2.index;
      if (game.item1 == OpponentChoice.rock) {
        if (game.item2 == PlayerChoice.rock) {
          // Draw
          score += 3;
        } else if (game.item2 == PlayerChoice.paper) {
          // Player wins
          score += 6;
        } else {
          // Opponent wins
          score += 0;
        }
      } else if (game.item1 == OpponentChoice.paper) {
        if (game.item2 == PlayerChoice.rock) {
          score += 0;
        } else if (game.item2 == PlayerChoice.paper) {
          score += 3;
        } else {
          score += 6;
        }
      } else if (game.item1 == OpponentChoice.scissors) {
        if (game.item2 == PlayerChoice.rock) {
          score += 6;
        } else if (game.item2 == PlayerChoice.paper) {
          score += 0;
        } else {
          score += 3;
        }
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final played = parseInput();
    int score = 0;
    for (final game in played) {
      if (game.item2 == PlayerChoice.rock) {
        // You need to lose
        if (game.item1 == OpponentChoice.rock) {
          // Play scissors + lose. Scissors are worth 3 points.
          score += 3;
        } else if (game.item1 == OpponentChoice.paper) {
          // Play rock + lose. Rock is worth 1 points.
          score += 1;
        } else {
          // Play paper + lose. Paper is worth 2 points.
          score += 2;
        }
      } else if (game.item2 == PlayerChoice.paper) {
        // You need to draw
        if (game.item1 == OpponentChoice.rock) {
          // Play rock + draw. Rock is worth 1 points + 3 for draw.
          score += 4;
        } else if (game.item1 == OpponentChoice.paper) {
          // Play paper + draw. Paper is worth 2 points + 3 for draw.
          score += 5;
        } else {
          // Play scissors + draw. Scissors is worth 3 points + 3 for draw.
          score += 6;
        }
      } else if (game.item2 == PlayerChoice.scissors) {
        // You need to win
        if (game.item1 == OpponentChoice.rock) {
          // Play paper and win. 2 + 6
          score += 8;
        } else if (game.item1 == OpponentChoice.paper) {
          // Play scissors and win. 3 + 6
          score += 9;
        } else {
          // Play rock and win. 1 + 6
          score += 7;
        }
      }
    }
    return score;
  }
}
