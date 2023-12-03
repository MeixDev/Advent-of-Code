import '../utils/index.dart';

class Symbol {
  final int x;
  final int y;
  final String symbol;
  final int adjacentTo;
  final List<int> adjacentValues;

  Symbol({
    required this.x,
    required this.y,
    required this.symbol,
    this.adjacentTo = 0,
    this.adjacentValues = const [],
  });
}

class Number {
  final int value;
  final int x;
  final int y;
  final int width;
  final bool nearSymbol;

  Number({
    required this.value,
    required this.x,
    required this.y,
    required this.width,
    required this.nearSymbol,
  });
}

class Manual {
  List<Symbol> symbols;
  List<Number> numbers;

  Manual({required this.symbols, required this.numbers});
}

class Day03 extends GenericDay {
  Day03() : super(3);

  Manual parseLines(List<String> lines) {
    List<Symbol> symbols = [];
    final List<Number> numbers = [];
    int y = 0;
    for (final line in lines) {
      int x = 0;
      // Split but remove last
      final chars = line.split('').getRange(0, line.length - 1).toList();
      for (final char in chars) {
        if (char != '.' && !char.startsWith(RegExp(r'[0-9]'))) {
          symbols.add(Symbol(x: x, y: y, symbol: char));
        }
        x++;
      }
      y++;
    }
    y = 0;
    for (final line in lines) {
      int x = 0;
      // Split but remove last
      final chars = line.split('').getRange(0, line.length - 1).toList();
      while (x < chars.length) {
        final char = chars[x];
        if (char.startsWith(RegExp(r'[0-9]'))) {
          int width = 0;
          while (x + width < chars.length &&
              chars[x + width].startsWith(RegExp(r'[0-9]'))) {
            width++;
          }
          final value = int.tryParse(line.substring(x, x + width)) ?? -1;
          bool nearSymbol = false;
          List<Symbol> updatedList = [];
          symbols.forEach((symbol) {
            final xDiff = (symbol.x - x);
            if (xDiff >= -1 && xDiff <= width) {
              final yDiff = (symbol.y - y);
              if (yDiff >= -1 && yDiff <= 1) {
                nearSymbol = true;
                final newSymbol = Symbol(
                  x: symbol.x,
                  y: symbol.y,
                  symbol: symbol.symbol,
                  adjacentTo: symbol.adjacentTo + 1,
                  adjacentValues: [...symbol.adjacentValues, value],
                );
                updatedList.add(newSymbol);
                return;
              }
            }
            updatedList.add(symbol);
          });
          symbols = updatedList;
          final number = Number(
            value: value,
            x: x,
            y: y,
            width: width,
            nearSymbol: nearSymbol,
          );
          numbers.add(number);
          if (width >= 1) {
            x += width;
          } else {
            x++;
          }
        }
        x++;
      }
      y++;
    }
    return Manual(symbols: symbols, numbers: numbers);
  }

  @override
  Manual parseInput() {
    final inputUtil = InputUtil(day);
    final lines = inputUtil.getPerLine();
    final manual = parseLines(lines);
    return manual;
  }

  @override
  int solvePart1() {
    final manual = parseInput();
    int sum = 0;
    for (final number in manual.numbers) {
      if (number.nearSymbol) {
        sum += number.value;
      }
    }
    return sum;
  }

  @override
  int solvePart2() {
    final manual = parseInput();
    int sum = 0;
    for (final symbol in manual.symbols) {
      if (symbol.symbol == '*' && symbol.adjacentTo == 2) {
        sum += symbol.adjacentValues.reduce((a, b) => a * b);
      }
    }
    return sum;
  }
}
