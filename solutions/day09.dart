import '../utils/index.dart';

enum Direction {
  up,
  left,
  right,
  down,
}

class Instruction {
  final Direction direction;
  final int steps;

  Instruction(this.direction, this.steps);
  factory Instruction.fromLine(String line) {
    final parts = line.split(" ");
    switch (parts[0]) {
      case "R":
        return Instruction(Direction.right, int.parse(parts[1]));
      case "U":
        return Instruction(Direction.up, int.parse(parts[1]));
      case "L":
        return Instruction(Direction.left, int.parse(parts[1]));
      case "D":
        return Instruction(Direction.down, int.parse(parts[1]));
      default:
        throw Exception("Unknown direction");
    }
  }
}

class Day09 extends GenericDay {
  Day09() : super(9);
  @override
  List<Instruction> parseInput() {
    final inputUtil = InputUtil(9);
    final lines = inputUtil.getPerLine();
    final instructions =
        lines.map((line) => Instruction.fromLine(line)).toList();
    return instructions;
  }

  bool isAround(Position head, Position tail) {
    return (head.x - tail.x).abs() <= 1 && (head.y - tail.y).abs() <= 1;
  }

  @override
  int solvePart1() {
    final List<List<bool>> grid =
        List.generate(1500, (index) => List.filled(1500, false));
    final gridField = Field<bool>(grid);
    Position head = Position(750, 750);
    Position oldHead = head;
    Position tail = Position(750, 750);
    gridField.setValueAt(tail.x, tail.y, true);
    int score = 1;
    final instructions = parseInput();
    for (final instruction in instructions) {
      for (int i = 0; i < instruction.steps; i += 1) {
        switch (instruction.direction) {
          case Direction.up:
            oldHead = head;
            head = Position(head.x, head.y - 1);
            break;
          case Direction.down:
            oldHead = head;
            head = Position(head.x, head.y + 1);
            break;
          case Direction.left:
            oldHead = head;
            head = Position(head.x - 1, head.y);
            break;
          case Direction.right:
            oldHead = head;
            head = Position(head.x + 1, head.y);
            break;
        }
        if (!isAround(head, tail)) {
          if (head.x == tail.x) {
            if (head.y > tail.y) {
              tail = Position(tail.x, tail.y + 1);
            } else {
              tail = Position(tail.x, tail.y - 1);
            }
          } else if (head.y == tail.y) {
            if (head.x > tail.x) {
              tail = Position(tail.x + 1, tail.y);
            } else {
              tail = Position(tail.x - 1, tail.y);
            }
          } else {
            tail = oldHead;
          }
          if (gridField.getValueAt(tail.x, tail.y) == false) {
            score += 1;
            gridField.setValueAt(tail.x, tail.y, true);
          }
        }
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final List<List<bool>> grid =
        List.generate(1500, (index) => List.filled(1500, false));
    final gridField = Field<bool>(grid);
    List<Position> snake = List.filled(10, Position(750, 750));
    gridField.setValueAt(snake.last.x, snake.last.y, true);
    int score = 1;
    final instructions = parseInput();
    for (final instruction in instructions) {
      for (int i = 0; i < instruction.steps; i += 1) {
        switch (instruction.direction) {
          case Direction.up:
            snake[0] = Position(snake[0].x, snake[0].y - 1);
            break;
          case Direction.down:
            snake[0] = Position(snake[0].x, snake[0].y + 1);
            break;
          case Direction.left:
            snake[0] = Position(snake[0].x - 1, snake[0].y);
            break;
          case Direction.right:
            snake[0] = Position(snake[0].x + 1, snake[0].y);
            break;
        }
        for (int i = 1; i < snake.length; i += 1) {
          if (!isAround(snake[i - 1], snake[i])) {
            if (snake[i - 1].x == snake[i].x) {
              if (snake[i - 1].y > snake[i].y) {
                snake[i] = Position(snake[i].x, snake[i].y + 1);
              } else {
                snake[i] = Position(snake[i].x, snake[i].y - 1);
              }
            } else if (snake[i - 1].y == snake[i].y) {
              if (snake[i - 1].x > snake[i].x) {
                snake[i] = Position(snake[i].x + 1, snake[i].y);
              } else {
                snake[i] = Position(snake[i].x - 1, snake[i].y);
              }
            } else {
              if ((snake[i - 1].x - snake[i].x).abs() != 1) {
                if (snake[i - 1].y > snake[i].y) {
                  if (snake[i - 1].x > snake[i].x) {
                    snake[i] = Position(snake[i].x + 1, snake[i].y + 1);
                  } else {
                    snake[i] = Position(snake[i].x - 1, snake[i].y + 1);
                  }
                } else {
                  if (snake[i - 1].x > snake[i].x) {
                    snake[i] = Position(snake[i].x + 1, snake[i].y - 1);
                  } else {
                    snake[i] = Position(snake[i].x - 1, snake[i].y - 1);
                  }
                }
              } else {
                if (snake[i - 1].x > snake[i].x) {
                  if (snake[i - 1].y > snake[i].y) {
                    snake[i] = Position(snake[i].x + 1, snake[i].y + 1);
                  } else {
                    snake[i] = Position(snake[i].x + 1, snake[i].y - 1);
                  }
                } else {
                  if (snake[i - 1].y > snake[i].y) {
                    snake[i] = Position(snake[i].x - 1, snake[i].y + 1);
                  } else {
                    snake[i] = Position(snake[i].x - 1, snake[i].y - 1);
                  }
                }
              }
            }
          }
        }
        if (gridField.getValueAt(snake.last.x, snake.last.y) == false) {
          score += 1;
          gridField.setValueAt(snake.last.x, snake.last.y, true);
        }
      }
    }
    return score;
  }
}
