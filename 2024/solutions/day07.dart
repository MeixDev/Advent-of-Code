import '../utils/index.dart';

class EquationEnigma {
  final int result;
  final List<int> numbers;

  EquationEnigma(this.result, this.numbers);
}

class Day07 extends GenericDay {
  Day07() : super(7);

  List<EquationEnigma> parseLines(List<String> lines) {
    final List<EquationEnigma> equations = [];
    for (final line in lines) {
      final resultString = line.substring(0, line.indexOf(':'));
      final numbersString = line.substring(line.indexOf(':') + 2);
      final result = int.parse(resultString);
      final parts = numbersString.split(' ');
      final numbers = parts.map(int.parse).toList();
      equations.add(EquationEnigma(result, numbers));
    }
    return equations;
  }

  @override
  List<EquationEnigma> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  bool equationStep(EquationEnigma equation, int index, int currentValue) {
    final result = equation.result;
    if (index == equation.numbers.length) {
      return currentValue == result;
    }
    final numbers = equation.numbers;
    final v = numbers[index];
    final sum = currentValue + v;
    final mul = currentValue * v;
    final sumPath = equationStep(equation, index + 1, sum);
    final mulPath = equationStep(equation, index + 1, mul);
    if (sumPath || mulPath) {
      return true;
    }
    return false;
  }

  @override
  int solvePart1() {
    final equations = parseInput();
    int sum = 0;
    for (final equation in equations) {
      final result = equation.result;
      final numbers = equation.numbers;
      final canBeSolved = equationStep(equation, 1, numbers[0]);
      if (canBeSolved) {
        // print('Found solution for ${equation.result}');
        sum += result;
      }
    }
    return sum;
  }

  bool equationStepP2(EquationEnigma equation, int index, int currentValue) {
    final result = equation.result;
    if (index == equation.numbers.length) {
      return currentValue == result;
    }
    final numbers = equation.numbers;
    final v = numbers[index];
    final sum = currentValue + v;
    final mul = currentValue * v;
    final merge = int.parse("$currentValue$v");
    final sumPath = equationStepP2(equation, index + 1, sum);
    final mulPath = equationStepP2(equation, index + 1, mul);
    final mergePath = equationStepP2(equation, index + 1, merge);
    if (sumPath || mulPath || mergePath) {
      return true;
    }
    return false;
  }

  @override
  int solvePart2() {
    final equations = parseInput();
    int sum = 0;
    for (final equation in equations) {
      final result = equation.result;
      final numbers = equation.numbers;
      final canBeSolved = equationStepP2(equation, 1, numbers[0]);
      if (canBeSolved) {
        // print('Found solution for ${equation.result}');
        sum += result;
      }
    }
    return sum;
  }
}
