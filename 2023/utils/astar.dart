import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

typedef NeighborFunction<T extends Equatable> = List<T> Function(T);
typedef CostFunction<T extends Equatable> = int Function(T, T);
typedef HeuristicFunction<T extends Equatable> = int Function(T);

typedef EndConditionFunction<T extends Equatable> = bool Function(T);

/**
 * Implements A* search to find the shortest path between two vertices
 */
GraphSearchResult<T> findShortestPath<T extends Equatable>({
  required T start,
  required T end,
  required NeighborFunction<T> neighbors,
  required CostFunction<T> cost,
  required HeuristicFunction<T> heuristic,
}) {
  return findShortestPathByPredicate(
    start: start,
    endCondition: (T vertex) => vertex == end,
    neighbors: neighbors,
    cost: cost,
    heuristic: heuristic,
  );
}

GraphSearchResult<T> findShortestPathByPredicate<T extends Equatable>({
  required T start,
  required EndConditionFunction<T> endCondition,
  required NeighborFunction<T> neighbors,
  required CostFunction<T> cost,
  required HeuristicFunction<T> heuristic,
}) {
  final toVisit = PriorityQueue<ScoredVertex<T>>();
  toVisit.add(ScoredVertex(start, 0, heuristic(start)));
  T? endVertex = null;
  final seenPoints = Map<T, SeenVertex<T>>();
  seenPoints[start] = SeenVertex(0, null);

  while (endVertex == null) {
    if (toVisit.isEmpty) {
      return GraphSearchResult(start, null, seenPoints);
    }
    final current = toVisit.removeFirst();
    if (endCondition(current.vertex)) {
      endVertex = current.vertex;
    } else {
      endVertex = null;
    }

    final _nextPoints = neighbors(current.vertex);
    _nextPoints.removeWhere((vertex) => seenPoints.containsKey(vertex));
    final nextPoints = _nextPoints.map((e) =>
        ScoredVertex(e, current.score + cost(current.vertex, e), heuristic(e)));

    toVisit.addAll(nextPoints);
    seenPoints.addAll({
      for (final point in nextPoints)
        point.vertex: SeenVertex(point.score, current.vertex)
    });
  }

  return GraphSearchResult(start, endVertex, seenPoints);
}

class GraphSearchResult<T extends Equatable> {
  final T start;
  final T? end;
  final Map<T, SeenVertex<T>> result;

  GraphSearchResult(this.start, this.end, this.result);

  int getScore(T vertex) {
    final score = result[vertex]?.cost;
    if (score == null) {
      throw Exception('Vertex $vertex not found in result');
    }
    return score;
  }

  int getEndScore() {
    if (end == null) {
      throw Exception('No end vertex');
    }
    try {
      return getScore(end!);
    } catch (e) {
      print('No path found');
      rethrow;
    }
  }

  List<T> getEndPath() {
    if (end == null) {
      throw Exception('No end vertex');
    }
    try {
      return getPath(end!, []);
    } catch (e) {
      print('No path found');
      rethrow;
    }
  }

  Set<T> seen() {
    return result.keys.toSet();
  }

  List<T> getPath(T endVertex, List<T> pathEnd) {
    final previous = result[endVertex]?.prev;
    return previous == null
        ? [endVertex, ...pathEnd]
        : getPath(previous, [endVertex, ...pathEnd]);
  }
}

class SeenVertex<T extends Equatable> {
  final int cost;
  final T? prev;

  SeenVertex(this.cost, this.prev);
}

class ScoredVertex<T extends Equatable> implements Comparable {
  final T vertex;
  final int score;
  final int heuristic;

  ScoredVertex(this.vertex, this.score, this.heuristic);

  @override
  int compareTo(other) {
    return (score + heuristic).compareTo(other.score + other.heuristic);
  }
}
