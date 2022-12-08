import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  Field<int> parseInput() {
    final inputUtil = InputUtil(8);
    final lines = inputUtil.getPerLine();
    final input = lines.map((line) => line.split('')).toList();
    final inputAsInt = input
        .map((line) => line.map((char) => int.parse(char)).toList())
        .toList();
    final field = Field<int>(inputAsInt);
    return field;
  }

  bool isTreeVisible(Field<int> field, int ogX, int ogY) {
    if (ogX == 46 && ogY == 1) {
      print('here');
    }
    int treeHeight = field.getValueAt(ogX, ogY);
    int highest = treeHeight;
    bool visible = true;
    for (int x = ogX - 1; x >= 0; x -= 1) {
      final height = field.getValueAt(x, ogY);
      if (height >= highest) {
        visible = false;
        break;
      }
    }
    if (visible) {
      return true;
    }
    visible = true;
    for (int x = ogX + 1; x < field.width; x += 1) {
      final height = field.getValueAt(x, ogY);
      if (height >= highest) {
        visible = false;
        break;
      }
    }
    if (visible) {
      return true;
    }
    visible = true;
    for (int y = ogY - 1; y >= 0; y -= 1) {
      final height = field.getValueAt(ogX, y);
      if (height >= highest) {
        visible = false;
        break;
      }
    }
    if (visible) {
      return true;
    }
    visible = true;
    for (int y = ogY + 1; y < field.height; y += 1) {
      final height = field.getValueAt(ogX, y);
      if (height >= highest) {
        visible = false;
        break;
      }
    }
    if (visible) {
      return true;
    }
    return false;
  }

  @override
  int solvePart1() {
    final field = parseInput();
    int score = field.height * 2 + field.width * 2 - 4;
    for (int y = 1; y < field.height - 1; y++) {
      for (int x = 1; x < field.width - 1; x++) {
        if (isTreeVisible(field, x, y)) {
          score += 1;
        }
      }
    }
    return score;
  }

  int calcScenicScore(Field<int> field, int ogX, int ogY) {
    int treeHeight = field.getValueAt(ogX, ogY);
    int highest = treeHeight;
    int minusXScore = 0;
    for (int x = ogX - 1; x >= 0; x -= 1) {
      minusXScore += 1;
      final height = field.getValueAt(x, ogY);
      if (height >= highest) {
        break;
      }
    }
    int plusXScore = 0;
    for (int x = ogX + 1; x < field.width; x += 1) {
      plusXScore += 1;
      final height = field.getValueAt(x, ogY);
      if (height >= highest) {
        break;
      }
    }
    int minusYScore = 0;
    for (int y = ogY - 1; y >= 0; y -= 1) {
      minusYScore += 1;
      final height = field.getValueAt(ogX, y);
      if (height >= highest) {
        break;
      }
    }
    int plusYScore = 0;
    for (int y = ogY + 1; y < field.height; y += 1) {
      plusYScore += 1;
      final height = field.getValueAt(ogX, y);
      if (height >= highest) {
        break;
      }
    }
    return minusXScore * plusXScore * minusYScore * plusYScore;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    int maxScenicScore = 0;
    for (int y = 0; y < field.height; y++) {
      for (int x = 0; x < field.width; x++) {
        int scenicScore = calcScenicScore(field, x, y);
        if (scenicScore > maxScenicScore) {
          maxScenicScore = scenicScore;
        }
      }
    }
    return maxScenicScore;
  }
}
