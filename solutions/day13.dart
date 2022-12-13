import 'dart:convert';

import '../utils/index.dart';

enum ListOrIntEnum {
  list,
  integer,
}

class ListOrInt {
  final List<ListOrInt>? list;
  final int? value;
  final ListOrIntEnum type;

  ListOrInt._(this.list, this.value, this.type);

  factory ListOrInt.list(List<ListOrInt>? list) {
    return ListOrInt._(list, null, ListOrIntEnum.list);
  }

  factory ListOrInt.integer(int? value) {
    return ListOrInt._(null, value, ListOrIntEnum.integer);
  }

  @override
  String toString() {
    if (type == ListOrIntEnum.list) {
      return list.toString();
    } else {
      return value.toString();
    }
  }
}

// ListOrInt helper(String s) {
//   List<ListOrInt> result = [];
//   for (int i = 0; i < s.length; i++) {
//     if (s[i] == '[') {
//       result.add(helper(s.substring(i + 1)));
//     } else if (s[i] == ']') {
//       if (result.length == 1)
//         return result[0];
//       else
//         return ListOrInt.list(result);
//     } else if (s[i] != ',') {
//       final v = int.parse(s.substring(i));
//       result.add(ListOrInt.integer(v));
//       if (v >= 10) i++;
//     }
//   }
//   throw Exception('Invalid input');
// }

ListOrInt helper(List l) {
  List<ListOrInt> result = [];
  for (int i = 0; i < l.length; i++) {
    if (l[i] is List) {
      result.add(helper(l[i]));
    } else {
      result.add(ListOrInt.integer(l[i]));
    }
  }
  return ListOrInt.list(result);
}

class Day13 extends GenericDay {
  Day13() : super(13);
  @override
  List<Tuple2<ListOrInt, ListOrInt>> parseInput() {
    final inputUtil = InputUtil(13);
    final lines = inputUtil.getPerLine();
    lines.removeWhere((element) => element.isEmpty);
    final duos = lines.slices(2).toList();
    // final List<Tuple2<ListOrInt, ListOrInt>> duosParsed = [];
    final List<Tuple2<ListOrInt, ListOrInt>> duosParsed = [];
    for (final duo in duos) {
      final decodedJson = jsonDecode(duo[0]);
      final decodedJson2 = jsonDecode(duo[1]);

      duosParsed.add(Tuple2(helper(decodedJson), helper(decodedJson2)));
    }
    return duosParsed;
  }

  int comparison(ListOrInt left, ListOrInt right) {
    if (left.type == ListOrIntEnum.integer &&
        right.type == ListOrIntEnum.integer) {
      return left.value! < right.value!
          ? 1
          : left.value! > right.value!
              ? -1
              : 0;
    } else if (left.type == ListOrIntEnum.list &&
        right.type == ListOrIntEnum.list) {
      for (int i = 0; i < left.list!.length; i++) {
        if (i >= right.list!.length) return -1;
        final result = comparison(left.list![i], right.list![i]);
        if (result != 0) return result;
      }
      if (left.list!.length < right.list!.length) return 1;
      return 0;
    } else if (left.type == ListOrIntEnum.integer &&
        right.type == ListOrIntEnum.list) {
      return comparison(
          ListOrInt.list([ListOrInt.integer(left.value!)]), right);
    } else if (left.type == ListOrIntEnum.list &&
        right.type == ListOrIntEnum.integer) {
      return comparison(
          left, ListOrInt.list([ListOrInt.integer(right.value!)]));
    } else {
      throw Exception('Invalid input');
    }
  }

  @override
  int solvePart1() {
    // final duosParsed = [
    //   Tuple2(
    //       ListOrInt.list([
    //         ListOrInt.integer(1),
    //         ListOrInt.integer(1),
    //         ListOrInt.integer(3),
    //         ListOrInt.integer(1),
    //         ListOrInt.integer(1),
    //       ]),
    //       ListOrInt.list([
    //         ListOrInt.integer(1),
    //         ListOrInt.integer(1),
    //         ListOrInt.integer(5),
    //         ListOrInt.integer(1),
    //         ListOrInt.integer(1),
    //       ])),
    //   Tuple2(
    //       ListOrInt.list([
    //         ListOrInt.list([
    //           ListOrInt.integer(1),
    //         ]),
    //         ListOrInt.list([
    //           ListOrInt.integer(2),
    //           ListOrInt.integer(3),
    //           ListOrInt.integer(4),
    //         ]),
    //       ]),
    //       ListOrInt.list([
    //         ListOrInt.list([
    //           ListOrInt.integer(1),
    //         ]),
    //         ListOrInt.integer(4),
    //       ])),
    //   Tuple2(
    //       ListOrInt.list([
    //         ListOrInt.integer(9),
    //       ]),
    //       ListOrInt.list([
    //         ListOrInt.list([
    //           ListOrInt.integer(8),
    //           ListOrInt.integer(7),
    //           ListOrInt.integer(6),
    //         ]),
    //       ])),
    //   Tuple2(
    //     ListOrInt.list([
    //       ListOrInt.list([
    //         ListOrInt.integer(4),
    //         ListOrInt.integer(4),
    //       ]),
    //       ListOrInt.integer(4),
    //       ListOrInt.integer(4),
    //     ]),
    //     ListOrInt.list([
    //       ListOrInt.list([
    //         ListOrInt.integer(4),
    //         ListOrInt.integer(4),
    //       ]),
    //       ListOrInt.integer(4),
    //       ListOrInt.integer(4),
    //       ListOrInt.integer(4),
    //     ]),
    //   ),
    //   Tuple2(
    //     ListOrInt.list([
    //       ListOrInt.integer(7),
    //       ListOrInt.integer(7),
    //       ListOrInt.integer(7),
    //       ListOrInt.integer(7),
    //     ]),
    //     ListOrInt.list([
    //       ListOrInt.integer(7),
    //       ListOrInt.integer(7),
    //       ListOrInt.integer(7),
    //     ]),
    //   ),
    //   Tuple2(
    //     ListOrInt.list([]),
    //     ListOrInt.list([
    //       ListOrInt.integer(3),
    //     ]),
    //   ),
    //   Tuple2(
    //     ListOrInt.list([
    //       ListOrInt.list([
    //         ListOrInt.list([]),
    //       ]),
    //     ]),
    //     ListOrInt.list([
    //       ListOrInt.list([]),
    //     ]),
    //   ),
    //   Tuple2(
    //     ListOrInt.list([
    //       ListOrInt.integer(1),
    //       ListOrInt.list([
    //         ListOrInt.integer(2),
    //         ListOrInt.list([
    //           ListOrInt.integer(3),
    //           ListOrInt.list([
    //             ListOrInt.integer(4),
    //             ListOrInt.list([
    //               ListOrInt.integer(5),
    //               ListOrInt.integer(6),
    //               ListOrInt.integer(7),
    //             ]),
    //           ]),
    //         ]),
    //       ]),
    //       ListOrInt.integer(8),
    //       ListOrInt.integer(9),
    //     ]),
    //     ListOrInt.list([
    //       ListOrInt.integer(1),
    //       ListOrInt.list([
    //         ListOrInt.integer(2),
    //         ListOrInt.list([
    //           ListOrInt.integer(3),
    //           ListOrInt.list([
    //             ListOrInt.integer(4),
    //             ListOrInt.list([
    //               ListOrInt.integer(5),
    //               ListOrInt.integer(6),
    //               ListOrInt.integer(0),
    //             ]),
    //           ]),
    //         ]),
    //       ]),
    //       ListOrInt.integer(8),
    //       ListOrInt.integer(9),
    //     ]),
    //   ),
    // ];
    final duosParsed = parseInput();
    int rightOrderIndicesSum = 0;
    for (final duos in duosParsed) {
      final left = duos.item1;
      final right = duos.item2;
      final result = comparison(left, right);
      if (result > 0) {
        rightOrderIndicesSum += duosParsed.indexOf(duos) + 1;
      }
    }
    return rightOrderIndicesSum;
  }

  List<ListOrInt> parseInputP2() {
    final inputUtil = InputUtil(13);
    final lines = inputUtil.getPerLine();
    lines.removeWhere((element) => element.isEmpty);
    final List<ListOrInt> parsed = [];
    for (final line in lines) {
      final decodedJson = jsonDecode(line);
      parsed.add(helper(decodedJson));
    }
    return parsed;
  }

  int comparisonP2(ListOrInt left, ListOrInt right) {
    if (left.type == ListOrIntEnum.integer &&
        right.type == ListOrIntEnum.integer) {
      return left.value! < right.value!
          ? 1
          : left.value! > right.value!
              ? -1
              : 0;
    } else if (left.type == ListOrIntEnum.list &&
        right.type == ListOrIntEnum.list) {
      for (int i = 0; i < left.list!.length; i++) {
        if (i >= right.list!.length) return -1;
        final result = comparison(left.list![i], right.list![i]);
        if (result != 0) return result;
      }
      if (left.list!.length < right.list!.length) return 1;
      return 0;
    } else if (left.type == ListOrIntEnum.integer &&
        right.type == ListOrIntEnum.list) {
      return comparison(
          ListOrInt.list([ListOrInt.integer(left.value!)]), right);
    } else if (left.type == ListOrIntEnum.list &&
        right.type == ListOrIntEnum.integer) {
      return comparison(
          left, ListOrInt.list([ListOrInt.integer(right.value!)]));
    } else {
      throw Exception('Invalid input');
    }
  }

  @override
  int solvePart2() {
    // final parsed = [
    //   ListOrInt.list([
    //     ListOrInt.integer(1),
    //     ListOrInt.integer(1),
    //     ListOrInt.integer(3),
    //     ListOrInt.integer(1),
    //     ListOrInt.integer(1),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.integer(1),
    //     ListOrInt.integer(1),
    //     ListOrInt.integer(5),
    //     ListOrInt.integer(1),
    //     ListOrInt.integer(1),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([
    //       ListOrInt.integer(1),
    //     ]),
    //     ListOrInt.list([
    //       ListOrInt.integer(2),
    //       ListOrInt.integer(3),
    //       ListOrInt.integer(4),
    //     ]),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([
    //       ListOrInt.integer(1),
    //     ]),
    //     ListOrInt.integer(4),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.integer(9),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([
    //       ListOrInt.integer(8),
    //       ListOrInt.integer(7),
    //       ListOrInt.integer(6),
    //     ]),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([
    //       ListOrInt.integer(4),
    //       ListOrInt.integer(4),
    //     ]),
    //     ListOrInt.integer(4),
    //     ListOrInt.integer(4),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([
    //       ListOrInt.integer(4),
    //       ListOrInt.integer(4),
    //     ]),
    //     ListOrInt.integer(4),
    //     ListOrInt.integer(4),
    //     ListOrInt.integer(4),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.integer(7),
    //     ListOrInt.integer(7),
    //     ListOrInt.integer(7),
    //     ListOrInt.integer(7),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.integer(7),
    //     ListOrInt.integer(7),
    //     ListOrInt.integer(7),
    //   ]),
    //   ListOrInt.list([]),
    //   ListOrInt.list([
    //     ListOrInt.integer(3),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([
    //       ListOrInt.list([]),
    //     ]),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.list([]),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.integer(1),
    //     ListOrInt.list([
    //       ListOrInt.integer(2),
    //       ListOrInt.list([
    //         ListOrInt.integer(3),
    //         ListOrInt.list([
    //           ListOrInt.integer(4),
    //           ListOrInt.list([
    //             ListOrInt.integer(5),
    //             ListOrInt.integer(6),
    //             ListOrInt.integer(7),
    //           ]),
    //         ]),
    //       ]),
    //     ]),
    //     ListOrInt.integer(8),
    //     ListOrInt.integer(9),
    //   ]),
    //   ListOrInt.list([
    //     ListOrInt.integer(1),
    //     ListOrInt.list([
    //       ListOrInt.integer(2),
    //       ListOrInt.list([
    //         ListOrInt.integer(3),
    //         ListOrInt.list([
    //           ListOrInt.integer(4),
    //           ListOrInt.list([
    //             ListOrInt.integer(5),
    //             ListOrInt.integer(6),
    //             ListOrInt.integer(0),
    //           ]),
    //         ]),
    //       ]),
    //     ]),
    //     ListOrInt.integer(8),
    //     ListOrInt.integer(9),
    //   ]),
    // ];
    final parsed = parseInputP2();
    final decoderKeyStart = ListOrInt.list([
      ListOrInt.list([
        ListOrInt.integer(2),
      ])
    ]);
    final decoderKeyEnd = ListOrInt.list([
      ListOrInt.list([
        ListOrInt.integer(6),
      ])
    ]);
    parsed.add(decoderKeyStart);
    parsed.add(decoderKeyEnd);
    parsed.sort((a, b) => comparisonP2(b, a));
    print(parsed.indexOf(decoderKeyStart));
    print(parsed.indexOf(decoderKeyEnd));
    print(parsed);
    return (parsed.indexOf(decoderKeyStart) + 1) * (parsed.indexOf(decoderKeyEnd) + 1);
  }
}
