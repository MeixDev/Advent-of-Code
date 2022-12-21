import '../utils/index.dart';

enum MonkeyOperation {
  addition,
  subtraction,
  multiplication,
  division,
}

class MathMonkey {
  bool isOperation;
  String name;
  int? value;
  MonkeyOperation? operation;
  Tuple2<String, String>? operands;

  MathMonkey({
    required this.name,
    required this.isOperation,
    this.value,
    this.operation,
    this.operands,
  });
}

class Day21 extends GenericDay {
  Day21() : super(21);
  @override
  List<MathMonkey> parseInput() {
    final inputUtil = InputUtil(21);
    final lines = inputUtil.getPerLine();
    final List<MathMonkey> monkeys = [];
    for (final line in lines) {
      final parts = line.split(' ');
      final name = parts[0].replaceAll(':', '');
      if (int.tryParse(parts[1]) != null) {
        final value = int.parse(parts[1]);
        monkeys.add(MathMonkey(name: name, isOperation: false, value: value));
      } else {
        final operand1 = parts[1];
        final operand2 = parts[3];
        final MonkeyOperation operation;
        switch (parts[2]) {
          case '+':
            operation = MonkeyOperation.addition;
            break;
          case '-':
            operation = MonkeyOperation.subtraction;
            break;
          case '*':
            operation = MonkeyOperation.multiplication;
            break;
          case '/':
            operation = MonkeyOperation.division;
            break;
          default:
            throw Exception('Unknown operation: ${parts[2]}');
        }
        monkeys.add(MathMonkey(
            name: name,
            isOperation: true,
            operation: operation,
            operands: Tuple2(operand1, operand2)));
      }
    }
    return monkeys;
  }

  int solve(List<MathMonkey> stack, List<MathMonkey> monkeys) {
    int score = 0;
    while (stack.isNotEmpty) {
      final monkey = stack.removeLast();
      if (monkey.isOperation) {
        final operand1 = monkeys
            .firstWhere((element) => element.name == monkey.operands!.item1);
        final operand2 = monkeys
            .firstWhere((element) => element.name == monkey.operands!.item2);
        int value1 = 0;
        int value2 = 0;
        if (operand1.isOperation) {
          stack.add(operand1);
          value1 = solve(stack, monkeys);
        } else {
          value1 = operand1.value!;
        }
        if (operand2.isOperation) {
          stack.add(operand2);
          value2 = solve(stack, monkeys);
        } else {
          value2 = operand2.value!;
        }
        switch (monkey.operation) {
          case MonkeyOperation.addition:
            score = value1 + value2;
            break;
          case MonkeyOperation.subtraction:
            score = value1 - value2;
            break;
          case MonkeyOperation.multiplication:
            score = value1 * value2;
            break;
          case MonkeyOperation.division:
            score = value1 ~/ value2;
            break;
          default:
            throw Exception('Unknown operation: ${monkey.operation}');
        }
      }
    }
    return score;
  }

  @override
  int solvePart1() {
    final monkeys = parseInput();
    int score = 0;
    final rootMonkey = monkeys.firstWhere((element) => element.name == 'root');
    final stack = [rootMonkey];
    score = solve(stack, monkeys);
    return score;
  }

  @override
  int solvePart2() {
    final monkeys = parseInput();
    int score = 0;
    final rootMonkey = monkeys.firstWhere((element) => element.name == 'root');
    rootMonkey.operation = MonkeyOperation.subtraction;
    monkeys.removeWhere((element) => element.name == 'root');
    monkeys.add(rootMonkey);
    final humn = monkeys.firstWhere((element) => element.name == 'humn');
    humn.value = 1;
    monkeys.removeWhere((element) => element.name == 'humn');
    monkeys.add(humn);
    int lowerBound = 0;
    int upperBound = 0;
    while (true) {
      final stack = [rootMonkey];
      score = solve(stack, monkeys);
      if (score == 0) {
        break;
      }
      final humn2 = monkeys.firstWhere((element) => element.name == 'humn');
      if (score < 0) {
        lowerBound = humn2.value!;
      } else {
        upperBound = humn2.value!;
      }

      if (lowerBound == 0 || upperBound == 0) {
        humn2.value = humn2.value! * 2;
      } else {
        humn2.value = (lowerBound + upperBound) ~/ 2;
      }
      monkeys.removeWhere((element) => element.name == 'humn');
      monkeys.add(humn2);
    }
    final bestHuman = monkeys.firstWhere((element) => element.name == 'humn');
    return bestHuman.value!;
  }
}
