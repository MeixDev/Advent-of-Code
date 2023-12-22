import 'package:equatable/equatable.dart';

import 'direction.dart';

class Point extends Equatable {
  final int x;
  final int y;

  Point(this.x, this.y);

  int abs() {
    return x.abs() + y.abs();
  }

  Point move(Direction dir, int length, [bool pointPositiveDown = true]) {
    if (pointPositiveDown) {
      return this + dir.pointPositiveDown * length;
    } else {
      return this + dir.pointPositiveUp * length;
    }
  }

  Point operator +(Point other) {
    return Point(x + other.x, y + other.y);
  }

  Point operator -(Point other) {
    return Point(x - other.x, y - other.y);
  }

  Point operator *(int other) {
    return Point(x * other, y * other);
  }

  Point operator /(int other) {
    return Point(x ~/ other, y ~/ other);
  }

  bool operator ==(Object other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  List<Object?> get props => [x, y];

  List<Point> get neighbors {
    return [
      Point(x + 1, y),
      Point(x - 1, y),
      Point(x, y + 1),
      Point(x, y - 1),
    ];
  }

  List<Point> get diagonalNeighbors {
    return [
      Point(x + 1, y + 1),
      Point(x - 1, y + 1),
      Point(x + 1, y - 1),
      Point(x - 1, y - 1),
    ];
  }

  factory Point.ZERO() {
    return Point(0, 0);
  }
}

class Point3D extends Equatable {
  final int x;
  final int y;
  final int z;

  Point3D(this.x, this.y, this.z);

  Point3D move(Direction3D dir, int length) {
    return this + dir.pointMap * length;
  }

  Point3D operator +(Point3D other) {
    return Point3D(x + other.x, y + other.y, z + other.z);
  }

  Point3D operator -(Point3D other) {
    return Point3D(x - other.x, y - other.y, z - other.z);
  }

  Point3D operator *(int other) {
    return Point3D(x * other, y * other, z * other);
  }

  Point3D operator /(int other) {
    return Point3D(x ~/ other, y ~/ other, z ~/ other);
  }

  bool operator ==(Object other) {
    if (other is Point3D) {
      return x == other.x && y == other.y && z == other.z;
    }
    return false;
  }

  @override
  List<Object?> get props => [x, y, z];

  List<Point3D> get neighbors {
    return [
      for (final dir in Direction3D.values) this + dir.pointMap,
    ];
  }

  factory Point3D.ZERO() {
    return Point3D(0, 0, 0);
  }
}
