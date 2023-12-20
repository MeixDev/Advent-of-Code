import '../utils/index.dart';

class Part {
  final int x;
  final int m;
  final int a;
  final int s;

  Part({required this.x, required this.m, required this.a, required this.s});

  int get sum => x + m + a + s;
}

class QuantumPart {
  final List<int> x;
  final List<int> m;
  final List<int> a;
  final List<int> s;

  QuantumPart(
      {required this.x, required this.m, required this.a, required this.s});

  QuantumPart copyWithFromEnum(PartValues part, List<int> values) {
    return copyWith(
      x: part == PartValues.x ? values : x,
      m: part == PartValues.m ? values : m,
      a: part == PartValues.a ? values : a,
      s: part == PartValues.s ? values : s,
    );
  }

  QuantumPart copyWith({
    List<int>? x,
    List<int>? m,
    List<int>? a,
    List<int>? s,
  }) {
    return QuantumPart(
      x: x ?? this.x,
      m: m ?? this.m,
      a: a ?? this.a,
      s: s ?? this.s,
    );
  }

  (QuantumPart, QuantumPart) applyCondition(WorkflowCondition condition) {
    final conditionPart = condition.part;
    final conditionValue = condition.value;
    final conditionOperator = condition.op;
    final localValue = conditionPart == PartValues.x
        ? x
        : conditionPart == PartValues.m
            ? m
            : conditionPart == PartValues.a
                ? a
                : s;
    List<int> trueList = [];
    List<int> falseList = [];
    if (conditionOperator == WorkflowConditionOperator.greaterThan) {
      for (int x = conditionValue + 1; x < localValue.last + 1; x++) {
        trueList.add(x);
      }
      for (int x = localValue.first; x < conditionValue + 1; x++) {
        falseList.add(x);
      }
    } else if (conditionOperator == WorkflowConditionOperator.lessThan) {
      for (int x = localValue.first; x < conditionValue; x++) {
        trueList.add(x);
      }
      for (int x = conditionValue; x < localValue.last + 1; x++) {
        falseList.add(x);
      }
    }
    QuantumPart quantumTrue = copyWithFromEnum(conditionPart, trueList);
    QuantumPart quantumFalse = copyWithFromEnum(conditionPart, falseList);
    return (quantumTrue, quantumFalse);
  }

  int get specialSum => x.length * m.length * a.length * s.length;
}

enum PartValues { x, m, a, s }

enum WorkflowConditionOperator { greaterThan, lessThan, defaultCase }

class WorkflowCondition {
  final WorkflowConditionOperator op;
  final PartValues part;
  final int value;
  final String redirection;

  WorkflowCondition({
    required this.op,
    required this.part,
    required this.value,
    required this.redirection,
  });
}

class Workflow {
  final String name;

  final List<WorkflowCondition> conditions;

  Workflow({required this.name, required this.conditions});
}

class WorkflowEngine {
  final List<Workflow> workflows;
  final List<Part> parts;

  WorkflowEngine({required this.workflows, required this.parts});
}

class Day19 extends GenericDay {
  Day19() : super(19);

  void parseLines(List<String> lines) {}

  @override
  WorkflowEngine parseInput() {
    // ignore: unused_local_variable
    final lines = input.getPerLine();
    final workflows = <Workflow>[];
    final parts = <Part>[];
    bool partMode = false;
    for (final line in lines) {
      if (line.length <= 1) {
        partMode = true;
        continue;
      }
      if (!partMode) {
        final workflowName = line.substring(0, line.indexOf('{'));
        final conditionsWhole =
            line.substring(line.indexOf('{') + 1, line.indexOf('}'));
        final conditionsStr = conditionsWhole.split(',');
        final conditions = <WorkflowCondition>[];
        for (final c in conditionsStr) {
          if (c.contains('<')) {
            final parts = c.split('<');
            final part = parts[0];
            final value =
                int.parse(parts[1].substring(0, parts[1].indexOf(':')));
            final condition = WorkflowCondition(
              op: WorkflowConditionOperator.lessThan,
              part: part == 'x'
                  ? PartValues.x
                  : part == 'm'
                      ? PartValues.m
                      : part == 'a'
                          ? PartValues.a
                          : PartValues.s,
              value: value,
              redirection: parts[1].substring(parts[1].indexOf(':') + 1),
            );
            conditions.add(condition);
          } else if (c.contains('>')) {
            final parts = c.split('>');
            final part = parts[0];
            final value =
                int.parse(parts[1].substring(0, parts[1].indexOf(':')));
            final condition = WorkflowCondition(
              op: WorkflowConditionOperator.greaterThan,
              part: part == 'x'
                  ? PartValues.x
                  : part == 'm'
                      ? PartValues.m
                      : part == 'a'
                          ? PartValues.a
                          : PartValues.s,
              value: value,
              redirection: parts[1].substring(parts[1].indexOf(':') + 1),
            );
            conditions.add(condition);
          } else {
            final condition = WorkflowCondition(
              op: WorkflowConditionOperator.defaultCase,
              part: PartValues.x,
              value: 0,
              redirection: c,
            );
            conditions.add(condition);
          }
        }
        final workflow = Workflow(name: workflowName, conditions: conditions);
        workflows.add(workflow);
      } else {
        final rLine = line.substring(1, line.indexOf('}'));
        final values = rLine.split(',');
        final p = Part(
          x: int.parse(values[0].substring(values[0].indexOf('=') + 1)),
          m: int.parse(values[1].substring(values[1].indexOf('=') + 1)),
          a: int.parse(values[2].substring(values[2].indexOf('=') + 1)),
          s: int.parse(values[3].substring(values[3].indexOf('=') + 1)),
        );
        parts.add(p);
      }
    }
    return WorkflowEngine(workflows: workflows, parts: parts);
  }

  @override
  int solvePart1() {
    final engine = parseInput();
    int score = 0;
    final parts = engine.parts;
    final workflows = engine.workflows;
    // int x = 0;
    for (final part in parts) {
      // x++;
      // print("Part $x");
      String currentWorkflow = 'in';
      while (currentWorkflow != 'A' && currentWorkflow != 'R') {
        final workflow =
            workflows.firstWhere((element) => element.name == currentWorkflow);
        final conditions = workflow.conditions;
        for (final condition in conditions) {
          final partValue = condition.part == PartValues.x
              ? part.x
              : condition.part == PartValues.m
                  ? part.m
                  : condition.part == PartValues.a
                      ? part.a
                      : part.s;
          bool conditionMet = false;
          switch (condition.op) {
            case WorkflowConditionOperator.greaterThan:
              if (partValue > condition.value) {
                // print("Part $x redirected to ${condition.redirection}");
                currentWorkflow = condition.redirection;
                conditionMet = true;
              }
              break;
            case WorkflowConditionOperator.lessThan:
              if (partValue < condition.value) {
                // print("Part $x redirected to ${condition.redirection}");
                currentWorkflow = condition.redirection;
                conditionMet = true;
              }
              break;
            case WorkflowConditionOperator.defaultCase:
              // print("Part $x redirected to ${condition.redirection}");
              currentWorkflow = condition.redirection;
              conditionMet = true;
              break;
          }
          if (conditionMet) {
            break;
          }
        }
      }
      if (currentWorkflow == 'A') {
        score += part.sum;
      }
    }
    return score;
  }

  int quantumSolve(
      QuantumPart part, List<Workflow> workflows, String currentWorkflow) {
    if (currentWorkflow == 'A') {
      return part.specialSum;
    } else if (currentWorkflow == 'R') {
      return 0;
    }
    final workflow =
        workflows.firstWhere((element) => element.name == currentWorkflow);
    int total = 0;
    QuantumPart truePart = part;
    QuantumPart falsePart = part;
    for (final condition
        in workflow.conditions.sublist(0, workflow.conditions.length - 1)) {
      (truePart, falsePart) = falsePart.applyCondition(condition);
      total += quantumSolve(truePart, workflows, condition.redirection);
    }
    return total +
        quantumSolve(
            falsePart, workflows, workflow.conditions.last.redirection);
  }

  @override
  int solvePart2() {
    final engine = parseInput();
    final workflows = engine.workflows;
    // int x = 0;
    QuantumPart quantumPart = QuantumPart(
      x: List.generate(4000, (index) => index + 1),
      m: List.generate(4000, (index) => index + 1),
      a: List.generate(4000, (index) => index + 1),
      s: List.generate(4000, (index) => index + 1),
    );
    final score = quantumSolve(quantumPart, workflows, 'in');
    return score;
  }
}
