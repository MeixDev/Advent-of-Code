import '../utils/index.dart';

typedef DistanceNode = Tuple2<String, int>;
typedef CacheIdentifier = Tuple3<int, String, int>;
typedef CacheIdentifierP2 = Tuple4<int, String, String, int>;

class TunnelPath {
  final int flow;
  final List<String> paths;

  TunnelPath(this.flow, this.paths);
}

class TunnelInfo {
  final Map<String, TunnelPath> paths;
  final int specialNodes;

  TunnelInfo(this.paths, this.specialNodes);
}

class Day16 extends GenericDay {
  Day16() : super(16);
  @override
  TunnelInfo parseInput() {
    final Map<String, TunnelPath> paths = {};
    int specialNodes = 0;
    final inputUtil = InputUtil(16);
    final lines = inputUtil.getPerLine();
    for (final line in lines) {
      final split = line.split(' ');
      final name = split[1];
      final flow = int.parse(split[4].substring(5, split[4].length - 1));
      if (flow > 0) {
        specialNodes += 1;
      }
      final pathsString = split.sublist(9);
      final destinations = <String>[];
      for (final path in pathsString) {
        destinations.add(path.replaceAll(",", ""));
      }
      paths[name] = TunnelPath(flow, destinations);
    }

    return TunnelInfo(paths, specialNodes);
  }

  int? deepSearch(
    int minute,
    String currentLocation,
    int flowRate,
    int currentScore,
    Set<String> openValves,
    Map<String, TunnelPath> paths,
    Map<CacheIdentifier, int> cache,
  ) {
    if (minute > 30) {
      return currentScore;
    }

    final cacheIdentifier = CacheIdentifier(minute, currentLocation, flowRate);
    if (cache.containsKey(cacheIdentifier)) {
      if (cache[cacheIdentifier]! >= currentScore) {
        return null;
      }
    }
    cache[cacheIdentifier] = currentScore;

    final currentNode = paths[currentLocation]!;

    final int? bestResultOpenCurrent;
    if (currentNode.flow > 0 && !openValves.contains(currentLocation)) {
      final newOpenValves = Set<String>.from(openValves);
      newOpenValves.add(currentLocation);
      final newScore = currentScore + flowRate;
      final newFlowRate = flowRate + currentNode.flow;
      bestResultOpenCurrent = deepSearch(
        minute + 1,
        currentLocation,
        newFlowRate,
        newScore,
        newOpenValves,
        paths,
        cache,
      );
    } else {
      bestResultOpenCurrent = null;
    }

    final int? bestResultDownTunnels;
    int bestScore = 0;
    for (final tunnel in currentNode.paths) {
      int? _score = deepSearch(
        minute + 1,
        tunnel,
        flowRate,
        currentScore + flowRate,
        openValves,
        paths,
        cache,
      );
      if (_score != null) {
        if (_score > bestScore) {
          bestScore = _score;
        }
      }
    }
    bestResultDownTunnels = bestScore;
    if (bestResultOpenCurrent != null) {
      if (bestResultDownTunnels > bestResultOpenCurrent) {
        return bestResultDownTunnels;
      } else
        return bestResultOpenCurrent;
    }
    return bestResultDownTunnels;
  }

  @override
  int solvePart1() {
    final stopwatch = Stopwatch()..start();
    final tunnelInfo = parseInput();
    final score = deepSearch(1, "AA", 0, 0, {}, tunnelInfo.paths, {});
    print("Time: ${stopwatch.elapsedMilliseconds}ms");
    stopwatch.stop();
    return score ?? 0;
  }

  int? deepSearch2(
    int minute,
    String heroLocation,
    String elephantLocation,
    int flowRate,
    int currentScore,
    Set<String> openValves,
    Map<String, TunnelPath> paths,
    Map<CacheIdentifierP2, int> cache,
  ) {
    if (minute > 26) {
      return currentScore;
    }

    final cacheIdentifier = CacheIdentifierP2(
      minute,
      heroLocation,
      elephantLocation,
      flowRate,
    );
    if (cache.containsKey(cacheIdentifier)) {
      if (cache[cacheIdentifier]! >= currentScore) {
        return null;
      }
    }
    cache[cacheIdentifier] = currentScore;

    final heroNode = paths[heroLocation]!;
    final elephantNode = paths[elephantLocation]!;

    final heroFlowRate = heroNode.flow;
    final elephantFlowRate = elephantNode.flow;

    final heroTunnels = heroNode.paths;
    final elephantTunnels = elephantNode.paths;

    final canHeroOpenValve =
        heroFlowRate > 0 && !openValves.contains(heroLocation);
    final canElephantOpenValve =
        elephantFlowRate > 0 && !openValves.contains(elephantLocation);

    final List<int?> potentialResults = [];

    if (canHeroOpenValve) {
      final newOpenValves = Set<String>.from(openValves);
      newOpenValves.add(heroLocation);
      for (final elephantTunnel in elephantTunnels) {
        potentialResults.add(
          deepSearch2(
            minute + 1,
            heroLocation,
            elephantTunnel,
            flowRate + heroFlowRate,
            currentScore + flowRate,
            newOpenValves,
            paths,
            cache,
          ),
        );
      }
    }

    if (canElephantOpenValve) {
      final newOpenValves = Set<String>.from(openValves);
      newOpenValves.add(elephantLocation);
      for (final heroTunnel in heroTunnels) {
        potentialResults.add(
          deepSearch2(
            minute + 1,
            heroTunnel,
            elephantLocation,
            flowRate + elephantFlowRate,
            currentScore + flowRate,
            newOpenValves,
            paths,
            cache,
          ),
        );
      }
    }

    if (canHeroOpenValve &&
        canElephantOpenValve &&
        heroLocation != elephantLocation) {
      final newOpenValves = Set<String>.from(openValves);
      newOpenValves.add(heroLocation);
      newOpenValves.add(elephantLocation);
      potentialResults.add(
        deepSearch2(
          minute + 1,
          heroLocation,
          elephantLocation,
          flowRate + heroFlowRate + elephantFlowRate,
          currentScore + flowRate,
          newOpenValves,
          paths,
          cache,
        ),
      );
    }

    for (final heroTunnel in heroTunnels) {
      for (final elephantTunnel in elephantTunnels) {
        potentialResults.add(
          deepSearch2(
            minute + 1,
            heroTunnel,
            elephantTunnel,
            flowRate,
            currentScore + flowRate,
            openValves,
            paths,
            cache,
          ),
        );
      }
    }

    int? bestResult = null;
    for (final result in potentialResults) {
      if (result != null) {
        if (result > (bestResult ?? 0)) {
          bestResult = result;
        }
      }
    }
    return bestResult;
  }

  @override
  int solvePart2() {
    final stopwatch = Stopwatch()..start();
    final tunnelInfo = parseInput();
    final score = deepSearch2(1, "AA", "AA", 0, 0, {}, tunnelInfo.paths, {});
    print("Time: ${stopwatch.elapsedMilliseconds}ms");
    stopwatch.stop();
    return score ?? 0;
  }
}
