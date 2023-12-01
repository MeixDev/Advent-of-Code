import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  Tuple2<String, String> splitMiddle(String s) {
    final middle = s.length ~/ 2;
    return Tuple2(s.substring(0, middle), s.substring(middle));
  }

  @override
  List<Tuple2<String, String>> parseInput() {
    final inputUtil = InputUtil(3);
    final rucksacks = inputUtil.getPerLine();
    final separatedRucksacks = rucksacks.map((e) => splitMiddle(e)).toList();
    return separatedRucksacks;
  }

  List<Tuple3<String, String, String>> parseInputPart2() {
    final inputUtil = InputUtil(3);
    final rucksacks = inputUtil.getPerLine();
    final List<Tuple3<String, String, String>> groupedSacks = [];
    for (int i = 0; i < rucksacks.length - 1; i += 3) {
      groupedSacks.add(Tuple3(
        rucksacks[i],
        rucksacks[i + 1],
        rucksacks[i + 2],
      ));
    }
    return groupedSacks;
  }

  @override
  int solvePart1() {
    final rucksacks = parseInput();
    int score = 0;
    for (final sack in rucksacks) {
      String uniqueItem = "";
      for (int i = 0; i < sack.item1.length; i++) {
        if (sack.item2.contains(sack.item1[i])) {
          uniqueItem = sack.item1[i];
          break;
        }
      }
      switch (uniqueItem) {
        case "a":
          score += 1;
          break;
        case "b":
          score += 2;
          break;
        case "c":
          score += 3;
          break;
        case "d":
          score += 4;
          break;
        case "e":
          score += 5;
          break;
        case "f":
          score += 6;
          break;
        case "g":
          score += 7;
          break;
        case "h":
          score += 8;
          break;
        case "i":
          score += 9;
          break;
        case "j":
          score += 10;
          break;
        case "k":
          score += 11;
          break;
        case "l":
          score += 12;
          break;
        case "m":
          score += 13;
          break;
        case "n":
          score += 14;
          break;
        case "o":
          score += 15;
          break;
        case "p":
          score += 16;
          break;
        case "q":
          score += 17;
          break;
        case "r":
          score += 18;
          break;
        case "s":
          score += 19;
          break;
        case "t":
          score += 20;
          break;
        case "u":
          score += 21;
          break;
        case "v":
          score += 22;
          break;
        case "w":
          score += 23;
          break;
        case "x":
          score += 24;
          break;
        case "y":
          score += 25;
          break;
        case "z":
          score += 26;
          break;
        case "A":
          score += 27;
          break;
        case "B":
          score += 28;
          break;
        case "C":
          score += 29;
          break;
        case "D":
          score += 30;
          break;
        case "E":
          score += 31;
          break;
        case "F":
          score += 32;
          break;
        case "G":
          score += 33;
          break;
        case "H":
          score += 34;
          break;
        case "I":
          score += 35;
          break;
        case "J":
          score += 36;
          break;
        case "K":
          score += 37;
          break;
        case "L":
          score += 38;
          break;
        case "M":
          score += 39;
          break;
        case "N":
          score += 40;
          break;
        case "O":
          score += 41;
          break;
        case "P":
          score += 42;
          break;
        case "Q":
          score += 43;
          break;
        case "R":
          score += 44;
          break;
        case "S":
          score += 45;
          break;
        case "T":
          score += 46;
          break;
        case "U":
          score += 47;
          break;
        case "V":
          score += 48;
          break;
        case "W":
          score += 49;
          break;
        case "X":
          score += 50;
          break;
        case "Y":
          score += 51;
          break;
        case "Z":
          score += 52;
          break;
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final rucksacks = parseInputPart2();
    int score = 0;
    for (final sack in rucksacks) {
      String uniqueItem = "";
      for (int i = 0; i < sack.item1.length; i++) {
        if (sack.item2.contains(sack.item1[i])) {
          if (sack.item3.contains(sack.item1[i])) {
            uniqueItem = sack.item1[i];
            break;
          }
        }
      }
      switch (uniqueItem) {
        case "a":
          score += 1;
          break;
        case "b":
          score += 2;
          break;
        case "c":
          score += 3;
          break;
        case "d":
          score += 4;
          break;
        case "e":
          score += 5;
          break;
        case "f":
          score += 6;
          break;
        case "g":
          score += 7;
          break;
        case "h":
          score += 8;
          break;
        case "i":
          score += 9;
          break;
        case "j":
          score += 10;
          break;
        case "k":
          score += 11;
          break;
        case "l":
          score += 12;
          break;
        case "m":
          score += 13;
          break;
        case "n":
          score += 14;
          break;
        case "o":
          score += 15;
          break;
        case "p":
          score += 16;
          break;
        case "q":
          score += 17;
          break;
        case "r":
          score += 18;
          break;
        case "s":
          score += 19;
          break;
        case "t":
          score += 20;
          break;
        case "u":
          score += 21;
          break;
        case "v":
          score += 22;
          break;
        case "w":
          score += 23;
          break;
        case "x":
          score += 24;
          break;
        case "y":
          score += 25;
          break;
        case "z":
          score += 26;
          break;
        case "A":
          score += 27;
          break;
        case "B":
          score += 28;
          break;
        case "C":
          score += 29;
          break;
        case "D":
          score += 30;
          break;
        case "E":
          score += 31;
          break;
        case "F":
          score += 32;
          break;
        case "G":
          score += 33;
          break;
        case "H":
          score += 34;
          break;
        case "I":
          score += 35;
          break;
        case "J":
          score += 36;
          break;
        case "K":
          score += 37;
          break;
        case "L":
          score += 38;
          break;
        case "M":
          score += 39;
          break;
        case "N":
          score += 40;
          break;
        case "O":
          score += 41;
          break;
        case "P":
          score += 42;
          break;
        case "Q":
          score += 43;
          break;
        case "R":
          score += 44;
          break;
        case "S":
          score += 45;
          break;
        case "T":
          score += 46;
          break;
        case "U":
          score += 47;
          break;
        case "V":
          score += 48;
          break;
        case "W":
          score += 49;
          break;
        case "X":
          score += 50;
          break;
        case "Y":
          score += 51;
          break;
        case "Z":
          score += 52;
          break;
      }
    }
    return score;
  }
}
