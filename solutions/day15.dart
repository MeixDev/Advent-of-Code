import '../utils/index.dart';

typedef SensorBeacon = Tuple2<Position, Position>;

extension SensorBeaconExtension on SensorBeacon {
  Position get sensor => item1;
  Position get beacon => item2;
}

class Day15 extends GenericDay {
  Day15() : super(15);
  @override
  List<SensorBeacon> parseInput() {
    final inputUtil = InputUtil(15);
    final lines = inputUtil.getPerLine();
    final List<SensorBeacon> sensorsInfo = [];
    for (final line in lines) {
      final split = line.split(' ');
      String tmp = split[2].split('=').last;
      tmp = tmp.substring(0, tmp.length - 1);
      final sensorX = int.parse(tmp);
      tmp = split[3].split('=').last;
      tmp = tmp.substring(0, tmp.length - 1);
      final sensorY = int.parse(tmp);
      tmp = split[8].split('=').last;
      tmp = tmp.substring(0, tmp.length - 1);
      final beaconX = int.parse(tmp);
      tmp = split[9].split('=').last;
      final beaconY = int.parse(tmp);
      sensorsInfo.add(
          SensorBeacon(Position(sensorX, sensorY), Position(beaconX, beaconY)));
    }
    return sensorsInfo;
  }

  @override
  int solvePart1() {
    final stopwatch = Stopwatch()..start();
    final sensorsInfo = parseInput();
    final yToCheck = 2000000;
    // Set of x coordinates that can't contain on beacon on y = 2000000
    final Set<int> xCoordinates = {};
    for (final info in sensorsInfo) {
      final sensor = info.sensor;
      final beacon = info.beacon;
      final x = sensor.x;
      final y = sensor.y;
      final x2 = beacon.x;
      final y2 = beacon.y;
      final distance = (x - x2).abs() + (y - y2).abs();
      if (y < yToCheck && y + distance >= yToCheck) {
        final yToGoal = yToCheck - y;
        for (int xOnY = x - (distance - yToGoal);
            xOnY <= x + (distance - yToGoal);
            xOnY++) {
          xCoordinates.add(xOnY);
        }
      }
      if (y > yToCheck && y - distance <= yToCheck) {
        final yToGoal = y - yToCheck;
        for (int xOnY = x - (distance - yToGoal);
            xOnY <= x + (distance - yToGoal);
            xOnY++) {
          xCoordinates.add(xOnY);
        }
      }
    }
    print('Found in ${stopwatch.elapsedMilliseconds} ms');
    return xCoordinates.length - 1;
  }

  bool check(int x, int y, List<SensorBeacon> sensorsInfo) {
    for (final info in sensorsInfo) {
      final sensor = info.sensor;
      final beacon = info.beacon;
      final sx = sensor.x;
      final sy = sensor.y;
      final bx = beacon.x;
      final by = beacon.y;
      final distance = (sx - bx).abs() + (sy - by).abs();
      final distance2 = (sx - x).abs() + (sy - y).abs();
      if (distance2 < distance) return false;
    }
    return true;
  }

  @override
  int solvePart2() {
    final stopwatch = Stopwatch()..start();
    final sensorsInfo = parseInput();
    for (final info in sensorsInfo) {
      final sensor = info.sensor;
      final beacon = info.beacon;
      final sx = sensor.x;
      final sy = sensor.y;
      final bx = beacon.x;
      final by = beacon.y;
      final distance = (sx - bx).abs() + (sy - by).abs();
      for (final xx in [-1, 1]) {
        for (final yy in [-1, 1]) {
          for (int dx = 0; dx <= distance; dx++) {
            final dy = distance + 1 - dx;
            final x = sx + dx * xx;
            final y = sy + dy * yy;
            if (x < 0 || y < 0 || x > 4000000 || y > 4000000) continue;
            if (check(x, y, sensorsInfo)) {
              print('Found in ${stopwatch.elapsedMilliseconds} ms');
              return x * 4000000 + y;
            }
          }
        }
      }
    }
    return 0;
  }
}
