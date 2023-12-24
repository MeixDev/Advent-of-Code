import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:z3/z3.dart' as z3;

import '../utils/index.dart';

class Hail extends Equatable {
  final Point3D position;
  final Point3D velocity;

  Hail(this.position, this.velocity);

  @override
  List<Object?> get props => [position, velocity];

  bool operator ==(Object other) {
    if (other is Hail) {
      return position == other.position && velocity == other.velocity;
    }
    throw Exception('Invalid type');
  }
}

class Day24 extends GenericDay {
  Day24() : super(24);

  void parseLines(List<String> lines) {}

  @override
  List<Hail> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final hail = <Hail>[];
    for (final line in lines) {
      final split = line.split('@');
      final position = split[0].split(',').map((e) => int.parse(e)).toList();
      final velocity = split[1].split(',').map((e) => int.parse(e)).toList();
      hail.add(Hail(
        Point3D(position[0], position[1], position[2]),
        Point3D(velocity[0], velocity[1], velocity[2]),
      ));
    }
    return hail;
  }

  bool isClose(double a, double b) {
    final rel = 0.000000001;

    return (a - b).abs() <= max(rel * max(a.abs(), b.abs()), 0);
  }

  ({
    bool identical,
    bool parallel,
    ({bool inFuture, double cx, double cy})? result
  }) intersect(Hail h1, Hail h2) {
    final a1 = h1.velocity.y / h1.velocity.x;
    final b1 = h1.position.y - a1 * h1.position.x;
    final a2 = h2.velocity.y / h2.velocity.x;
    final b2 = h2.position.y - a2 * h2.position.x;
    if (isClose(a1, a2)) {
      if (isClose(b1, b2)) {
        return (identical: true, parallel: false, result: null);
      }
      return (identical: false, parallel: true, result: null);
    }
    final cx = (b2 - b1) / (a1 - a2);
    final cy = a1 * cx + b1;
    final inFuture = (cx > h1.position.x) == (h1.velocity.x > 0) &&
        (cx > h2.position.x) == (h2.velocity.x > 0);
    return (
      identical: false,
      parallel: false,
      result: (inFuture: inFuture, cx: cx, cy: cy)
    );
  }

  @override
  int solvePart1() {
    final hail = parseInput();
    // final minZone = 7;
    final minZone = 200000000000000;
    // final maxZone = 27;
    final maxZone = 400000000000000;
    int countIntersections = 0;
    for (int i = 0; i < hail.length - 1; i++) {
      final h = hail[i];
      for (int j = i; j < hail.length; j++) {
        final o = hail[j];
        // Try to see if the two hails will intersect in the x7-x27, y7-y27 zone.
        // Not taking z into account here
        final res = intersect(h, o);
        if (res.identical || res.parallel) {
          continue;
        } else {
          final result = res.result!;
          final inFuture = result.inFuture;
          final cx = result.cx;
          final cy = result.cy;
          if (inFuture) {
            if (minZone <= cx &&
                cx <= maxZone &&
                minZone <= cy &&
                cy <= maxZone) {
              countIntersections++;
            }
          }
        }
      }
    }
    return countIntersections;
  }

  // final z3Lib = Z3Lib(DynamicLibrary.open(
  //     r'C:\ProgramData\chocolatey\lib\z3\tools\bin\bin\libz3.dll'));

  // late final config = z3Lib.mk_config();
  // late final context = z3Lib.mk_context_rc(config);
  // late final intSort = z3Lib.mk_int_sort(context);

  // void killConfigZ3() {
  //   z3Lib.del_context(context);
  //   z3Lib.del_config(config);
  // }

  // ({int x, int y, int z}) vectorDifference(Point3D a, Point3D b) {
  //   return (x: (a.x - b.x), y: (a.y - b.y), z: (a.z - b.z));
  // }

  // ({List<List<int>> A, List<int> B}) getEquations(Hail h1, Hail h2) {
  //   final p1 = h1.position;
  //   final p2 = h2.position;
  //   final v1 = h1.velocity;
  //   final v2 = h2.velocity;

  //   final deltas = vectorDifference(p1, p2);
  //   final vDeltas = vectorDifference(v1, v2);

  //   final A = [
  //     [0, vDeltas.z, vDeltas.y, 0, -deltas.z, deltas.y],
  //     [vDeltas.z, 0, -vDeltas.x, deltas.z, 0, -deltas.x],
  //     [-vDeltas.y, vDeltas.x, 0, -deltas.y, deltas.x, 0],
  //   ];

  //   final B = [
  //     p2.y * v2.z - p2.z * v2.y - (p1.y * v1.z - p1.z * v1.y),
  //     p2.z * v2.x - p2.x * v2.z - (p1.z * v1.x - p1.x * v1.z),
  //     p2.x * v2.y - p2.y * v2.x - (p1.x * v1.y - p1.y * v1.x),
  //   ];

  //   return (A: A, B: B);
  // }

  // List<List<int>> matrixTranspose(List<List<int>> m) {
  //   int rowCount = m.length;
  //   int colCount = m[0].length;
  //   List<List<int>> transposed = List.generate(
  //       colCount, (_) => List<int>.filled(rowCount, 0),
  //       growable: false);

  //   for (int i = 0; i < rowCount; i++) {
  //     for (int j = 0; j < colCount; j++) {
  //       transposed[j][i] = m[i][j];
  //     }
  //   }
  //   return transposed;
  // }

  // List<List<int>> matrixMinor(List<List<int>> m, int i, int j) {
  //   List<List<int>> minor = [];
  //   for (int row = 0; row < m.length; row++) {
  //     if (row == i) continue;
  //     minor.add([...m[row].sublist(0, j), ...m[row].sublist(j + 1)]);
  //   }
  //   return minor;
  // }

  // int matrixDet(List<List<int>> m) {
  //   if (m.length == 2) {
  //     return m[0][0] * m[1][1] - m[0][1] * m[1][0];
  //   }
  //   int determinant = 0;
  //   for (int i = 0; i < m.length; i++) {
  //     final p = pow(-1, i).toInt();
  //     print("p: $p");
  //     print("m[0][$i]: ${m[0][i]}");
  //     determinant += (p * m[0][i] * matrixDet(m.sublist(1, m.length)));
  //   }
  //   return determinant;
  // }

  // List<List<int>> matrixInverse(List<List<int>> m) {
  //   final determinant = matrixDet(m);
  //   final coFactors = <List<int>>[];

  //   for (int r = 0; r < m.length; r++) {
  //     final row = <int>[];

  //     for (int c = 0; c < m.length; c++) {
  //       final minor = matrixMinor(m, r, c);
  //       final det = matrixDet(minor);
  //       row.add(pow(-1, r + c).toInt() * det);
  //     }
  //     coFactors.add(row);
  //   }
  //   final newCoFactors = matrixTranspose(coFactors);
  //   for (int r = 0; r < newCoFactors.length; r++) {
  //     for (int c = 0; c < newCoFactors.length; c++) {
  //       newCoFactors[r][c] = newCoFactors[r][c] ~/ determinant;
  //     }
  //   }
  //   return newCoFactors;
  // }

  // List<int> matrixMul(List<List<int>> A, List<int> B) {
  //   final result = <int>[];
  //   for (var i = 0; i < A.length; i++) {
  //     var sum = 0;
  //     final currentAAndBTuple = <({int sA, int b})>[];
  //     for (var j = 0; j < A.length; j++) {
  //       currentAAndBTuple.add((sA: A[i][j], b: B[j]));
  //     }
  //     for (final t in currentAAndBTuple) {
  //       sum += t.sA * t.b;
  //     }
  //     result.add(sum);
  //   }
  //   return result;
  // }

  // int solvePlz(List<Hail> hail) {
  //   final smallHail = hail.sublist(0, 3);

  //   final e1 = getEquations(smallHail[0], smallHail[1]);
  //   final A1 = e1.A;
  //   final B1 = e1.B;
  //   final e2 = getEquations(smallHail[0], smallHail[2]);
  //   final A2 = e2.A;
  //   final B2 = e2.B;
  //   final A = A1 + A2;
  //   final B = B1 + B2;

  //   final x = matrixMul(matrixInverse(A), B);
  //   return x[0] + x[1] + x[2];
  // }

  @override
  int solvePart2() {
    final hail = parseInput();
    // NOTE: I HATE IT IT DOESN'T WORK
    // return solvePlz(hail);

    final solver = z3.solver();
    final x = z3.constVar('x', z3.intSort);
    final y = z3.constVar('y', z3.intSort);
    final z = z3.constVar('z', z3.intSort);
    final vx = z3.constVar('vx', z3.intSort);
    final vy = z3.constVar('vy', z3.intSort);
    final vz = z3.constVar('vz', z3.intSort);
    for (var i = 0; i < 3; i++) {
      final h = hail[i];
      final p = h.position;
      final v = h.velocity;
      final t = z3.constVar('t-$i', z3.intSort);
      solver.add(z3.gt(t, z3.$(0)));
      solver.add(z3.eq(z3.add(z3.$(p.x), z3.mul(z3.$(v.x), z3.$(t))),
          z3.add(x, z3.mul(vx, t))));
      solver.add(z3.eq(z3.add(z3.$(p.y), z3.mul(z3.$(v.y), z3.$(t))),
          z3.add(y, z3.mul(vy, t))));
      solver.add(z3.eq(z3.add(z3.$(p.z), z3.mul(z3.$(v.z), z3.$(t))),
          z3.add(z, z3.mul(vz, t))));
    }

    var sum = 0;
    if (solver.check() != null) {
      final model = solver.getModel();
      sum += int.parse(model.eval(x).toString());
      sum += int.parse(model.eval(y).toString());
      sum += int.parse(model.eval(z).toString());
    }
    return sum;
  }
}
