class Point {
  int x;
  int y;

  Point(this.x, this.y);

  int abs() {
    return x.abs() + y.abs();
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