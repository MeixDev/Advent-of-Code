import '../utils/index.dart';

class Card {
  int cardId;
  List<int> winningNumbers;
  List<int> numbers;

  Card(
      {required this.cardId,
      required this.winningNumbers,
      required this.numbers});
}

class Day04 extends GenericDay {
  Day04() : super(4);

  void parseLines(List<String> lines) {}

  @override
  List<Card> parseInput() {
    final inputUtil = InputUtil(day);
    final cards = <Card>[];
    final lines = inputUtil.getPerLine();
    int cardId = 1;
    for (final line in lines) {
      final winningNumbers = <int>[];
      final numbers = <int>[];
      var split = line.split(' ');
      split = split.getRange(2, split.length).toList();
      // Remove any empty strings from the split list
      split.removeWhere((element) => element.isEmpty);
      final subSplit = split;
      bool winningPhase = true;
      int x = 0;
      while (x < subSplit.length) {
        if (subSplit.elementAt(x).startsWith('|')) {
          winningPhase = false;
          x++;
          continue;
        }
        final value = int.tryParse(subSplit.elementAt(x)) ?? -1;
        if (winningPhase) {
          winningNumbers.add(value);
        } else {
          numbers.add(value);
        }
        x++;
      }
      cards.add(Card(
          cardId: cardId, winningNumbers: winningNumbers, numbers: numbers));
      cardId++;
    }
    return cards;
  }

  @override
  int solvePart1() {
    final cards = parseInput();
    int score = 0;
    for (final card in cards) {
      int cardScore = 0;
      for (final number in card.numbers) {
        if (card.winningNumbers.contains(number)) {
          if (cardScore == 0) {
            cardScore = 1;
          } else {
            cardScore *= 2;
          }
        }
      }
      score += cardScore;
    }
    return score;
  }

  @override
  int solvePart2() {
    final originalCards = parseInput();
    final recursiveCards = originalCards;
    int cardIndex = 0;
    while (cardIndex < recursiveCards.length) {
      final card = recursiveCards[cardIndex];
      int cardScore = 0;
      for (final number in card.numbers) {
        if (card.winningNumbers.contains(number)) {
          cardScore++;
        }
      }
      int y = card.cardId + 1;
      while (y <= card.cardId + cardScore) {
        if (y > originalCards.length) {
          break;
        }
        recursiveCards.add(originalCards[y - 1]);
        y++;
      }
      cardIndex++;
    }
    return recursiveCards.length;
  }
}
