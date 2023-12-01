import '../utils/index.dart';
import 'package:quiver/iterables.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  List<List<String>> suppliesParse(List<String> supplies) {
    final List<List<String>> suppliesParsed = [];
    int indexBegin = 0;
    int indexEnd = 0;
    for (final line in supplies) {
      if (line.isNotEmpty) {
        indexEnd++;
      } else {
        suppliesParsed.add(supplies.sublist(indexBegin, indexEnd));
        indexBegin = indexEnd + 1;
        indexEnd = indexBegin;
      }
    }
    return suppliesParsed;
  }

  @override
  List<List<int>> parseInput() {
    final inputUtil = InputUtil(1);
    final lines = inputUtil.getPerLine();
    final parsedLines = suppliesParse(lines);
    final parsedLinesInt = parsedLines.map(
      (e) => ParseUtil.stringListToIntList(e),
    );
    return parsedLinesInt.toList();
  }

  @override
  int solvePart1() {
    final elfSupplies = parseInput();
    final maxSupplies = elfSupplies
        .map((e) => e.reduce((value, element) => value + element))
        .toList();
    final maxSupply = max(maxSupplies) ?? 0;
    return maxSupply;
  }

  @override
  int solvePart2() {
    final elfSupplies = parseInput();
    final maxSupplies = elfSupplies
        .map((e) => e.reduce((value, element) => value + element))
        .toList();
    final sortMaxSupplies = maxSupplies..sort();
    final invertedMaxSupplies = sortMaxSupplies.reversed.toList();
    final threeBiggestSupplies = invertedMaxSupplies.sublist(0, 3);
    final maxSupply =
        threeBiggestSupplies.reduce((value, element) => value + element);
    return maxSupply;
  }
}
