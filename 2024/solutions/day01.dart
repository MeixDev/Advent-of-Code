import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  Tuple2<List<int>, List<int>> parseLines(List<String> lines) {
    final List<int> list1Numbers = [];
    final List<int> list2Numbers = [];
    for (final line in lines) {
      final numbers = line.split('   ');
      list1Numbers.add(int.parse(numbers[0]));
      list2Numbers.add(int.parse(numbers[1]));
    }
    return Tuple2(list1Numbers, list2Numbers);
  }

  @override
  Tuple2<List<int>, List<int>> parseInput() {
    final lines = input.getPerLine();
    final parsedLines = parseLines(lines);
    return parsedLines;
  }

  int comparator(int a, int b) {
    return a.compareTo(b);
  }

  @override
  int solvePart1() {
    final Tuple2<List<int>, List<int>> numbers = parseInput();
    final List<int> list1 = numbers.item1.sorted(comparator);
    final List<int> list2 = numbers.item2.sorted(comparator);
    int index = 0;
    int sum = 0;
    while (index < list1.length) {
      sum += (list1[index] - list2[index]).abs();
      index++;
    }
    return sum;
  }

  @override
  int solvePart2() {
    final Tuple2<List<int>, List<int>> numbers = parseInput();
    final List<int> list1 = numbers.item1.sorted(comparator);
    final List<int> list2 = numbers.item2.sorted(comparator);
    int index = 0;
    int sum = 0;
    while (index < list1.length) {
      final int count =
          list2.where((element) => element == list1[index]).length;
      sum += list1[index] * count;
      index++;
    }
    return sum;
  }
}
