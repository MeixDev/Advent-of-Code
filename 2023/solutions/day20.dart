import '../utils/index.dart';

enum ModuleType {
  broadcaster,
  flipFlop,
  conjunction,
  normal,
}

enum Pulse {
  low,
  high,
}

class Module {
  final String name;
  final ModuleType type;
  final List<String> connections;

  Module({
    required this.name,
    required this.type,
    required this.connections,
  });
}

class Day20 extends GenericDay {
  Day20() : super(20);

  void parseLines(List<String> lines) {}

  @override
  List<Module> parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final modules = <Module>[];
    for (final line in lines) {
      final parts = line.substring(0, line.length - 1).split(' ');
      String nameModule = parts[0];
      ModuleType moduleType = ModuleType.normal;
      if (nameModule.startsWith("broadcaster")) {
        moduleType = ModuleType.broadcaster;
      }
      if (nameModule.startsWith("%")) {
        moduleType = ModuleType.flipFlop;
        nameModule = nameModule.substring(1);
      }
      if (nameModule.startsWith("&")) {
        moduleType = ModuleType.conjunction;
        nameModule = nameModule.substring(1);
      }
      final connectionsStr = parts.sublist(2).join('');
      final connections = connectionsStr.split(',');
      if (connections.last.length == 0) connections.removeLast();
      modules.add(Module(
        name: nameModule,
        type: moduleType,
        connections: connections,
      ));
    }
    return modules;
  }

  @override
  int solvePart1() {
    final modules = parseInput();
    final List<Map<(String, int), Pulse>> states = [];
    final Map<String, Map<String, Pulse>> conjunctionRememberedPulses = {};
    final Map<String, bool> flipFlops = {};
    for (final module in modules) {
      if (module.type == ModuleType.conjunction) {
        conjunctionRememberedPulses[module.name] = {};
      }
      if (module.type == ModuleType.flipFlop) {
        flipFlops[module.name] = false;
      }
    }
    for (final entry in conjunctionRememberedPulses.entries) {
      final moduleKey = entry.key;
      final rememberedPulses = entry.value;
      for (final module in modules) {
        if (module.connections.contains(moduleKey)) {
          rememberedPulses[module.name] = Pulse.low;
        }
      }
      conjunctionRememberedPulses[moduleKey] = rememberedPulses;
    }
    for (int x = 0; x < 1000; x++) {
      final state = <(String, int), Pulse>{};
      final queue = <(Module, Pulse)>[];
      queue.add((modules.first, Pulse.low));
      int i = -1;
      while (queue.isNotEmpty) {
        i++;
        final (Module module, Pulse pulse) = queue.removeAt(0);
        if (module.type == ModuleType.broadcaster) {
          state[(module.name, i)] = pulse;
          queue.addAll(modules
              .where((m) => module.connections.contains(m.name))
              .map((e) => (e, pulse)));
        }
        if (module.type == ModuleType.flipFlop) {
          if (pulse == Pulse.high) continue;
          flipFlops[module.name] = !flipFlops[module.name]!;
          state[(module.name, i)] =
              flipFlops[module.name]! ? Pulse.high : Pulse.low;
          queue.addAll(modules
              .where((m) => module.connections.contains(m.name))
              .map((e) =>
                  (e, flipFlops[module.name]! ? Pulse.high : Pulse.low)));
        }
        if (module.type == ModuleType.conjunction) {
          final rememberedPulses = conjunctionRememberedPulses[module.name]!;
          final rememberedPulsesKeys = rememberedPulses.keys;
          for (final key in rememberedPulsesKeys) {
            final stateKeys = state.keys;
            final last = stateKeys.lastWhereOrNull((e) => e.$1 == key);
            if (last != null) {
              rememberedPulses[key] = state[last]!;
            }
          }
          final allPulses = rememberedPulses.values;
          conjunctionRememberedPulses[module.name] = rememberedPulses;
          Pulse sentPulse = Pulse.high;
          if (allPulses.every((p) => p == Pulse.high)) {
            state[(module.name, i)] = Pulse.low;
            sentPulse = Pulse.low;
          } else {
            state[(module.name, i)] = Pulse.high;
            sentPulse = Pulse.high;
          }
          queue.addAll(modules
              .where((m) => module.connections.contains(m.name))
              .map((e) => (e, sentPulse)));
        }
      }
      states.add(state);
    }
    int score = 0;
    int lowPulses = 0;
    int highPulses = 0;
    for (final state in states) {
      // Button sending low
      lowPulses++;
      for (final entry in state.entries) {
        if (entry.value == Pulse.low) {
          lowPulses += modules
              .firstWhere((element) => element.name == entry.key.$1)
              .connections
              .length;
        } else {
          highPulses += modules
              .firstWhere((element) => element.name == entry.key.$1)
              .connections
              .length;
          ;
        }
      }
    }
    score = lowPulses * highPulses;
    return score;
  }

  @override
  int solvePart2() {
    final modules = parseInput();
    final List<Map<(String, int), Pulse>> states = [];
    final Map<String, Map<String, Pulse>> conjunctionRememberedPulses = {};
    final Map<String, bool> flipFlops = {};
    for (final module in modules) {
      if (module.type == ModuleType.conjunction) {
        conjunctionRememberedPulses[module.name] = {};
      }
      if (module.type == ModuleType.flipFlop) {
        flipFlops[module.name] = false;
      }
    }
    for (final entry in conjunctionRememberedPulses.entries) {
      final moduleKey = entry.key;
      final rememberedPulses = entry.value;
      for (final module in modules) {
        if (module.connections.contains(moduleKey)) {
          rememberedPulses[module.name] = Pulse.low;
        }
      }
      conjunctionRememberedPulses[moduleKey] = rememberedPulses;
    }
    final rxConnection =
        modules.firstWhere((element) => element.connections.contains('rx'));
    final rxConnectionConnections = modules
        .where((element) => element.connections.contains(rxConnection.name))
        .toList();
    final rxConnectionConnectionsNames =
        rxConnectionConnections.map((e) => e.name).toList();
    final rxConnectionConnectionCycles = <String, int?>{};
    for (final connection in rxConnectionConnections) {
      rxConnectionConnectionCycles[connection.name] = null;
    }
    final subcyclesLength = <int>[];
    for (int x = 0; x < 1000000; x++) {
      if (rxConnectionConnectionsNames.isEmpty) {
        break;
      }
      final state = <(String, int), Pulse>{};
      final queue = <(Module, Pulse)>[];
      queue.add((modules.first, Pulse.low));
      int i = -1;
      while (queue.isNotEmpty) {
        i++;
        final (Module module, Pulse pulse) = queue.removeAt(0);
        if (module.type == ModuleType.broadcaster) {
          state[(module.name, i)] = pulse;
          queue.addAll(modules
              .where((m) => module.connections.contains(m.name))
              .map((e) => (e, pulse)));
        }
        if (module.type == ModuleType.flipFlop) {
          if (pulse == Pulse.high) continue;
          flipFlops[module.name] = !flipFlops[module.name]!;
          state[(module.name, i)] =
              flipFlops[module.name]! ? Pulse.high : Pulse.low;
          queue.addAll(modules
              .where((m) => module.connections.contains(m.name))
              .map((e) =>
                  (e, flipFlops[module.name]! ? Pulse.high : Pulse.low)));
        }
        if (module.type == ModuleType.conjunction) {
          final rememberedPulses = conjunctionRememberedPulses[module.name]!;
          final rememberedPulsesKeys = rememberedPulses.keys;
          for (final key in rememberedPulsesKeys) {
            final stateKeys = state.keys;
            final last = stateKeys.lastWhereOrNull((e) => e.$1 == key);
            if (last != null) {
              rememberedPulses[key] = state[last]!;
            }
          }
          final allPulses = rememberedPulses.values;
          conjunctionRememberedPulses[module.name] = rememberedPulses;
          Pulse sentPulse = Pulse.high;
          if (allPulses.every((p) => p == Pulse.high)) {
            state[(module.name, i)] = Pulse.low;
            sentPulse = Pulse.low;
          } else {
            state[(module.name, i)] = Pulse.high;
            sentPulse = Pulse.high;
            if (rxConnectionConnectionsNames.contains(module.name)) {
              if (rxConnectionConnectionCycles[module.name] != null) {
                subcyclesLength
                    .add(x - rxConnectionConnectionCycles[module.name]!);
                rxConnectionConnectionsNames.remove(module.name);
              }
              rxConnectionConnectionCycles[module.name] = x;
            }
          }
          queue.addAll(modules
              .where((m) => module.connections.contains(m.name))
              .map((e) => (e, sentPulse)));
        }
      }
      states.add(state);
    }
    return listLcm(subcyclesLength);
  }

  int lcm(int a, int b) {
    return (a * b) ~/ a.gcd(b);
  }

  int listLcm(List<int> list) {
    int result = list[0];
    for (int i = 1; i < list.length; i++) {
      result = lcm(result, list[i]);
    }
    return result;
  }
}
