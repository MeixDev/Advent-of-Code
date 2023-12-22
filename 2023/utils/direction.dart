import 'index.dart';

enum Orientation {
  HORIZONTAL,
  VERTICAL,
}

enum Compass {
  NORTH,
  EAST,
  SOUTH,
  WEST;

  Direction get direction {
    switch (this) {
      case Compass.NORTH:
        return Direction.UP;
      case Compass.EAST:
        return Direction.RIGHT;
      case Compass.SOUTH:
        return Direction.DOWN;
      case Compass.WEST:
        return Direction.LEFT;
    }
  }
}

enum Direction {
  UP(
    orientation: Orientation.VERTICAL,
  ),
  RIGHT(
    orientation: Orientation.HORIZONTAL,
  ),
  DOWN(
    orientation: Orientation.VERTICAL,
  ),
  LEFT(
    orientation: Orientation.HORIZONTAL,
  );

  final Orientation orientation;
  Direction get left {
    switch (this) {
      case Direction.UP:
        return Direction.LEFT;
      case Direction.RIGHT:
        return Direction.UP;
      case Direction.DOWN:
        return Direction.RIGHT;
      case Direction.LEFT:
        return Direction.DOWN;
    }
  }

  Direction get right {
    switch (this) {
      case Direction.UP:
        return Direction.RIGHT;
      case Direction.RIGHT:
        return Direction.DOWN;
      case Direction.DOWN:
        return Direction.LEFT;
      case Direction.LEFT:
        return Direction.UP;
    }
  }

  Direction get opposite {
    switch (this) {
      case Direction.UP:
        return Direction.DOWN;
      case Direction.RIGHT:
        return Direction.LEFT;
      case Direction.DOWN:
        return Direction.UP;
      case Direction.LEFT:
        return Direction.RIGHT;
    }
  }

  Point get pointPositiveDown => DirectionPointMapping.downPositive().get(this);

  Point get pointPositiveUp => DirectionPointMapping.upPositive().get(this);

  const Direction({required this.orientation});
}

class DirectionPointMapping {
  final Direction positiveY;
  final Direction positiveX;

  DirectionPointMapping({
    required this.positiveY,
    required this.positiveX,
  }) {
    _up = positiveY == Direction.UP ? Point(0, 1) : Point(0, -1);
    _down = Point(0, -_up.y);
    _left = positiveX == Direction.LEFT ? Point(1, 0) : Point(-1, 0);
    _right = Point(-_left.x, 0);
  }

  late final Point _up;
  late final Point _right;
  late final Point _down;
  late final Point _left;

  Point get(Direction direction) {
    switch (direction) {
      case Direction.UP:
        return _up;
      case Direction.RIGHT:
        return _right;
      case Direction.DOWN:
        return _down;
      case Direction.LEFT:
        return _left;
    }
  }

  factory DirectionPointMapping.downPositive() {
    return DirectionPointMapping(
      positiveY: Direction.DOWN,
      positiveX: Direction.RIGHT,
    );
  }

  factory DirectionPointMapping.upPositive() {
    return DirectionPointMapping(
      positiveY: Direction.UP,
      positiveX: Direction.LEFT,
    );
  }
}

enum Direction3D {
  UP,
  RIGHT,
  DOWN,
  LEFT,
  FRONT,
  BACK;

  Point3D get pointMap {
    switch (this) {
      case Direction3D.UP:
        return Direction3DPointMapping.positiveY;
      case Direction3D.RIGHT:
        return Direction3DPointMapping.positiveX;
      case Direction3D.DOWN:
        return Direction3DPointMapping.negativeY;
      case Direction3D.LEFT:
        return Direction3DPointMapping.negativeX;
      case Direction3D.FRONT:
        return Direction3DPointMapping.positiveZ;
      case Direction3D.BACK:
        return Direction3DPointMapping.negativeZ;
    }
  }
}

class Direction3DPointMapping {
  static Point3D get positiveX => Point3D(1, 0, 0);
  static Point3D get positiveY => Point3D(0, 1, 0);
  static Point3D get positiveZ => Point3D(0, 0, 1);

  static Point3D get negativeX => Point3D(-1, 0, 0);
  static Point3D get negativeY => Point3D(0, -1, 0);
  static Point3D get negativeZ => Point3D(0, 0, -1);
}
