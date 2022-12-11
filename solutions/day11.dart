import '../utils/index.dart';

typedef OperationCallback = int Function(int);
typedef TestCallback = bool Function(int);

typedef OperationBigCallback = BigInt Function(BigInt);
typedef TestBigCallback = bool Function(BigInt);

class Monkey {
  final List<int> items;
  final OperationCallback operationCallback;
  final TestCallback testCallback;
  final int mod;
  final int throwToIfTrue;
  final int throwToIfFalse;
  int timesInspected;

  Monkey(this.items, this.operationCallback, this.testCallback, this.mod,
      this.throwToIfTrue, this.throwToIfFalse,
      [this.timesInspected = 0]) {}
}

class Day11 extends GenericDay {
  Day11() : super(11);
  @override
  List<Monkey> parseInput() {
    final List<Monkey> monkeys = [];
    monkeys.add(
      Monkey([71, 56, 50, 73], (p0) => p0 * 11, (p0) => p0 % 13 == 0, 13, 1, 7),
    );
    monkeys.add(
      Monkey([70, 89, 82], (p0) => p0 + 1, (p0) => p0 % 7 == 0, 7, 3, 6),
    );
    monkeys.add(
      Monkey([52, 95], (p0) => p0 * p0, (p0) => p0 % 3 == 0, 3, 5, 4),
    );
    monkeys.add(
      Monkey(
          [94, 64, 69, 87, 70], (p0) => p0 + 2, (p0) => p0 % 19 == 0, 19, 2, 6),
    );
    monkeys.add(
      Monkey([98, 72, 98, 53, 97, 51], (p0) => p0 + 6, (p0) => p0 % 5 == 0, 5,
          0, 5),
    );
    monkeys.add(
      Monkey([79], (p0) => p0 + 7, (p0) => p0 % 2 == 0, 2, 7, 0),
    );
    monkeys.add(
      Monkey([77, 55, 63, 93, 66, 90, 88, 71], (p0) => p0 * 7,
          (p0) => p0 % 11 == 0, 11, 2, 4),
    );
    monkeys.add(
      Monkey([54, 97, 87, 70, 59, 82, 59], (p0) => p0 + 8, (p0) => p0 % 17 == 0,
          17, 1, 3),
    );
    // Test
    // monkeys.add(
    //   Monkey([79, 98], (p0) => p0 * 19, (p0) => p0 % 23 == 0, 23, 2, 3),
    // );
    // monkeys.add(
    //   Monkey([54, 65, 75, 74], (p0) => p0 + 6, (p0) => p0 % 19 == 0, 19, 2, 0),
    // );
    // monkeys.add(
    //   Monkey([79, 60, 97], (p0) => p0 * p0, (p0) => p0 % 13 == 0, 13, 1, 3),
    // );
    // monkeys.add(
    //   Monkey([74], (p0) => p0 + 3, (p0) => p0 % 17 == 0, 17, 0, 1),
    // );
    return monkeys;
  }

  @override
  int solvePart1() {
    final monkeys = parseInput();
    for (int i = 0; i < 20; i++) {
      for (final monkey in monkeys) {
        for (final item in monkey.items) {
          monkey.timesInspected += 1;
          int newItem = monkey.operationCallback(item);
          int newNewItem = (newItem / 3).floor();
          if (monkey.testCallback(newNewItem)) {
            monkeys[monkey.throwToIfTrue].items.add(newNewItem);
          } else {
            monkeys[monkey.throwToIfFalse].items.add(newNewItem);
          }
        }
        monkey.items.clear();
      }
    }
    int highest = 0;
    int highest2 = 0;
    for (final monkey in monkeys) {
      if (monkey.timesInspected > highest2) {
        if (monkey.timesInspected > highest) {
          highest2 = highest;
          highest = monkey.timesInspected;
        } else {
          highest2 = monkey.timesInspected;
        }
      }
    }
    return highest * highest2;
  }

  int lcm(int a, int b) => (a * b) ~/ gcd(a, b);

  int gcd(int a, int b) {
    while (b != 0) {
      var t = b;
      b = a % t;
      a = t;
    }
    return a;
  }

  @override
  int solvePart2() {
    final monkeys = parseInput();
    int lcm = 1;
    for (final monkey in monkeys) {
      lcm = lcm * monkey.mod ~/ gcd(lcm, monkey.mod);
    }
    for (int i = 0; i < 10000; i++) {
      for (final monkey in monkeys) {
        for (final item in monkey.items) {
          monkey.timesInspected += 1;
          int newItem = monkey.operationCallback(item);
          newItem = newItem % lcm;
          // int newNewItem = (newItem / 3).floor();
          if (monkey.testCallback(newItem)) {
            monkeys[monkey.throwToIfTrue].items.add(newItem);
          } else {
            monkeys[monkey.throwToIfFalse].items.add(newItem);
          }
        }
        monkey.items.clear();
      }
    }
    int highest = 0;
    int highest2 = 0;
    for (final monkey in monkeys) {
      if (monkey.timesInspected > highest2) {
        if (monkey.timesInspected > highest) {
          highest2 = highest;
          highest = monkey.timesInspected;
        } else {
          highest2 = monkey.timesInspected;
        }
      }
    }
    return highest * highest2;
  }
}
