import '../utils/index.dart';

import 'package:collection/collection.dart';

enum HandType {
  highCard,
  pair,
  twoPair,
  threeOfAKind,
  fullHouse,
  fourOfAKind,
  fiveOfAKind,
}

class CamelHand {
  final List<int> cards;
  final int bid;
  final HandType type;

  CamelHand({required this.cards, required this.bid, required this.type});
}

class Day07 extends GenericDay {
  Day07() : super(7);

  void parseLines(List<String> lines) {}

  @override
  List<CamelHand> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final camelHands = <CamelHand>[];
    for (final line in lines) {
      final split = line.split(' ');
      int x = 0;
      final cards = split[0].split('');
      while (x < cards.length) {
        final card = cards[x];
        if (card == 'A') {
          cards[x] = '14';
        } else if (card == 'T') {
          cards[x] = '10';
        } else if (card == 'J') {
          cards[x] = '11';
        } else if (card == 'Q') {
          cards[x] = '12';
        } else if (card == 'K') {
          cards[x] = '13';
        }
        x++;
      }
      final cardsInt = cards.map(int.parse).toList();
      final bid = int.parse(split[1]);
      Map<int, int> cardCount = {};
      for (final card in cardsInt) {
        if (cardCount.containsKey(card)) {
          cardCount[card] = cardCount[card]! + 1;
        } else {
          cardCount[card] = 1;
        }
      }

      if (cardCount.values.any((element) => element == 5)) {
        camelHands.add(
            CamelHand(cards: cardsInt, bid: bid, type: HandType.fiveOfAKind));
      } else if (cardCount.values.any((element) => element == 4)) {
        camelHands.add(
            CamelHand(cards: cardsInt, bid: bid, type: HandType.fourOfAKind));
      } else if (cardCount.values.any((element) => element == 3)) {
        if (cardCount.values.any((element) => element == 2)) {
          camelHands.add(
              CamelHand(cards: cardsInt, bid: bid, type: HandType.fullHouse));
        } else {
          camelHands.add(CamelHand(
              cards: cardsInt, bid: bid, type: HandType.threeOfAKind));
        }
      } else if (cardCount.values.where((element) => element == 2).length ==
          2) {
        camelHands
            .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.twoPair));
      } else if (cardCount.values.any((element) => element == 2)) {
        camelHands
            .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.pair));
      } else {
        camelHands
            .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.highCard));
      }
    }
    return camelHands;
  }

  List<CamelHand> parseInputP2() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final camelHands = <CamelHand>[];
    for (final line in lines) {
      final split = line.split(' ');
      int x = 0;
      final cards = split[0].split('');
      while (x < cards.length) {
        final card = cards[x];
        if (card == 'A') {
          cards[x] = '14';
        } else if (card == 'T') {
          cards[x] = '10';
        } else if (card == 'J') {
          cards[x] = '1';
        } else if (card == 'Q') {
          cards[x] = '12';
        } else if (card == 'K') {
          cards[x] = '13';
        }
        x++;
      }
      final cardsInt = cards.map(int.parse).toList();
      final bid = int.parse(split[1]);
      Map<int, int> cardCount = {};
      for (final card in cardsInt) {
        if (cardCount.containsKey(card)) {
          cardCount[card] = cardCount[card]! + 1;
        } else {
          cardCount[card] = 1;
        }
      }

      final jokerLength = cardCount[1] ?? 0;
      if (cardCount.values.any((element) => element == 5)) {
        camelHands.add(
            CamelHand(cards: cardsInt, bid: bid, type: HandType.fiveOfAKind));
        continue;
      } else if (cardCount.values.any((element) => element == 4)) {
        if (jokerLength == 1 || jokerLength == 4) {
          camelHands.add(
              CamelHand(cards: cardsInt, bid: bid, type: HandType.fiveOfAKind));
          continue;
        }
        camelHands.add(
            CamelHand(cards: cardsInt, bid: bid, type: HandType.fourOfAKind));
        continue;
      } else if (cardCount.values.any((element) => element == 3)) {
        if (cardCount.values.any((element) => element == 2)) {
          if (jokerLength == 2 || jokerLength == 3) {
            camelHands.add(CamelHand(
                cards: cardsInt, bid: bid, type: HandType.fiveOfAKind));
            continue;
          }
          camelHands.add(
              CamelHand(cards: cardsInt, bid: bid, type: HandType.fullHouse));
          continue;
        } else {
          if (jokerLength == 1 || jokerLength == 3) {
            camelHands.add(CamelHand(
                cards: cardsInt, bid: bid, type: HandType.fourOfAKind));
            continue;
          }
          camelHands.add(CamelHand(
              cards: cardsInt, bid: bid, type: HandType.threeOfAKind));
          continue;
        }
      } else if (cardCount.values.where((element) => element == 2).length ==
          2) {
        if (jokerLength == 2) {
          camelHands.add(
              CamelHand(cards: cardsInt, bid: bid, type: HandType.fourOfAKind));
          continue;
        }
        if (jokerLength == 1) {
          camelHands.add(
              CamelHand(cards: cardsInt, bid: bid, type: HandType.fullHouse));
          continue;
        }
        camelHands
            .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.twoPair));
        continue;
      } else if (cardCount.values.any((element) => element == 2)) {
        if (jokerLength == 1 || jokerLength == 2) {
          camelHands.add(CamelHand(
              cards: cardsInt, bid: bid, type: HandType.threeOfAKind));
          continue;
        }
        camelHands
            .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.pair));
        continue;
      } else {
        if (jokerLength == 1) {
          camelHands
              .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.pair));
          continue;
        }
        camelHands
            .add(CamelHand(cards: cardsInt, bid: bid, type: HandType.highCard));
        continue;
      }
    }
    return camelHands;
  }

  @override
  int solvePart1() {
    final hands = parseInput();
    final Map<HandType, List<CamelHand>> handMap = {
      HandType.highCard: [],
      HandType.pair: [],
      HandType.twoPair: [],
      HandType.threeOfAKind: [],
      HandType.fullHouse: [],
      HandType.fourOfAKind: [],
      HandType.fiveOfAKind: [],
    };
    final Map<HandType, List<CamelHand>> sortedHands = {};
    for (final hand in hands) {
      handMap[hand.type]!.add(hand);
    }
    for (final entry in handMap.entries) {
      final hands = entry.value;
      // Compare each hand to other hands, by comparing the value of the first card. If the first card is the same, compare the second card, and so on.
      hands.sort((a, b) {
        for (int i = 0; i < a.cards.length; i++) {
          if (a.cards[i] > b.cards[i]) {
            return -1;
          } else if (a.cards[i] < b.cards[i]) {
            return 1;
          }
        }
        return 0;
      });
      sortedHands[entry.key] = hands;
    }
    int score = 0;
    int rank = 1;
    for (final entry in sortedHands.entries) {
      final hands = entry.value.reversed.toList();
      int totalScore = 0;
      for (int i = 0; i < hands.length; i++) {
        final hand = hands[i];
        totalScore += hand.bid * rank;
        // print(
        //     "Hand with bid ${hand.bid} and rank $rank scores ${hand.bid * rank}");
        rank++;
      }
      score += totalScore;
    }
    return score;
  }

  @override
  int solvePart2() {
    final hands = parseInputP2();
    final Map<HandType, List<CamelHand>> handMap = {
      HandType.highCard: [],
      HandType.pair: [],
      HandType.twoPair: [],
      HandType.threeOfAKind: [],
      HandType.fullHouse: [],
      HandType.fourOfAKind: [],
      HandType.fiveOfAKind: [],
    };
    final Map<HandType, List<CamelHand>> sortedHands = {};
    for (final hand in hands) {
      handMap[hand.type]!.add(hand);
    }
    for (final entry in handMap.entries) {
      final hands = entry.value;
      // Compare each hand to other hands, by comparing the value of the first card. If the first card is the same, compare the second card, and so on.
      hands.sort((a, b) {
        for (int i = 0; i < a.cards.length; i++) {
          if (a.cards[i] > b.cards[i]) {
            return -1;
          } else if (a.cards[i] < b.cards[i]) {
            return 1;
          }
        }
        return 0;
      });
      sortedHands[entry.key] = hands;
    }
    int score = 0;
    int rank = 1;
    for (final entry in sortedHands.entries) {
      final hands = entry.value.reversed.toList();
      int totalScore = 0;
      for (int i = 0; i < hands.length; i++) {
        final hand = hands[i];
        totalScore += hand.bid * rank;
        // if (hand.cards.contains(1)) {
        //   print("Joker in hand ${hand.cards}");
        //   print(
        //       "Hand of type ${hand.type.name} with bid ${hand.bid} and rank $rank scores ${hand.bid * rank}");
        // }
        rank++;
      }
      score += totalScore;
    }
    return score;
  }
}
