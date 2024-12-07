import '../utils/index.dart';

class CombinationRule {
  final int before;
  final int after;

  CombinationRule(this.before, this.after);
}

class Day05 extends GenericDay {
  Day05() : super(5);

  (List<CombinationRule>, List<List<int>>) parseLines(List<String> lines) {
    final rules = <CombinationRule>[];
    final updates = <List<int>>[];
    List<String> breakLines = [];
    int breakIndex = 0;
    for (final line in lines) {
      breakIndex += 1;
      if (line.length == 1) {
        breakLines = lines.sublist(breakIndex);
        break;
      }
      final parts = line.split('|');
      final before = int.parse(parts[0]);
      final after = int.parse(parts[1]);
      rules.add(CombinationRule(before, after));
    }
    for (final line in breakLines) {
      final parts = line.split(',');
      final update = <int>[];
      for (final part in parts) {
        update.add(int.parse(part));
      }
      updates.add(update);
    }
    return (rules, updates);
  }

  @override
  (List<CombinationRule>, List<List<int>>) parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    return parseLines(lines);
  }

  @override
  int solvePart1() {
    final (rules, updates) = parseInput();
    int sum = 0;
    for (final update in updates) {
      bool valid = true;
      for (int i = 0; i < update.length - 1; i++) {
        final entry = update[i];
        final beforeRules = rules.where((rule) => rule.before == entry);
        final afterRules = rules.where((rule) => rule.after == entry);
        final beforeInUpdateList = update.sublist(0, i);
        final afterInUpdateList = update.sublist(i + 1);
        if (beforeRules.isNotEmpty) {
          for (final rule in beforeRules) {
            if (beforeInUpdateList.contains(rule.after)) {
              valid = false;
              // print('Invalid: ${update.join(',')}');
              // print(
              //     'Invalid rule: >${rule.before}< | ${rule.after} on index $i ($entry)');
              break;
            }
          }
        }
        if (!valid) {
          break;
        }
        if (afterRules.isNotEmpty) {
          for (final rule in afterRules) {
            if (afterInUpdateList.contains(rule.before)) {
              valid = false;
              // print('Invalid: ${update.join(',')}');
              // print(
              //     'Invalid rule: ${rule.before} | >${rule.after}<  on index $i ($entry)');

              break;
            }
          }
        }
        if (!valid) {
          break;
        }
      }
      if (valid) {
        final middleValue = update[update.length ~/ 2];
        sum += middleValue;
      }
    }
    return sum;
  }

  @override
  int solvePart2() {
    final (rules, updates) = parseInput();
    int sum = 0;
    final invalidUpdates = <List<int>>[];
    for (final update in updates) {
      bool valid = true;
      for (int i = 0; i < update.length - 1; i++) {
        final entry = update[i];
        final beforeRules = rules.where((rule) => rule.before == entry);
        final afterRules = rules.where((rule) => rule.after == entry);
        final beforeInUpdateList = update.sublist(0, i);
        final afterInUpdateList = update.sublist(i + 1);
        if (beforeRules.isNotEmpty) {
          for (final rule in beforeRules) {
            if (beforeInUpdateList.contains(rule.after)) {
              valid = false;
              break;
            }
          }
        }
        if (!valid) {
          invalidUpdates.add(update);
          break;
        }
        if (afterRules.isNotEmpty) {
          for (final rule in afterRules) {
            if (afterInUpdateList.contains(rule.before)) {
              valid = false;
              break;
            }
          }
        }
        if (!valid) {
          invalidUpdates.add(update);
          break;
        }
      }
    }
    for (final invalidUpdate in invalidUpdates) {
      final fixedUpdate = invalidUpdate;
      for (int i = 0; i < fixedUpdate.length; i++) {
        final entry = fixedUpdate[i];
        final beforeRules = rules.where((rule) => rule.before == entry);
        final afterRules = rules.where((rule) => rule.after == entry);
        final beforeInUpdateList = fixedUpdate.sublist(0, i);
        final afterInUpdateList = fixedUpdate.sublist(i + 1);
        bool changed = false;
        if (beforeRules.isNotEmpty) {
          for (final rule in beforeRules) {
            if (beforeInUpdateList.contains(rule.after)) {
              final index = fixedUpdate.indexOf(rule.after);
              // print('Invalid: ${fixedUpdate.join(',')}');
              // print(
              //     'Invalid rule: ${rule.before} | >${rule.after}<  on index $i ($entry)');
              fixedUpdate.removeAt(index);
              fixedUpdate.insert(i, rule.after);
              changed = true;
              // print('Fixed: ${fixedUpdate.join(',')}');
              break;
            }
          }
        }
        if (afterRules.isNotEmpty) {
          for (final rule in afterRules) {
            if (afterInUpdateList.contains(rule.before)) {
              final index = fixedUpdate.indexOf(rule.before);
              // print('Invalid: ${fixedUpdate.join(',')}');
              // print(
              //     'Invalid rule: ${rule.before} | >${rule.after}<  on index $i ($entry)');
              fixedUpdate.removeAt(index);
              fixedUpdate.insert(i, rule.before);
              changed = true;
              // print('Fixed: ${fixedUpdate.join(',')}');
              break;
            }
          }
        }
        if (changed) {
          i = -1;
        }
      }
      // print('Final: ${fixedUpdate.join(',')}');
      final middleValue = fixedUpdate[fixedUpdate.length ~/ 2];
      sum += middleValue;
    }
    return sum;
  }
}
