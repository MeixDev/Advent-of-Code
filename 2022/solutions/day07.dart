import '../utils/index.dart';

enum DirOrFileEnum {
  dir,
  file,
}

class DirOrFile<T> {
  DirOrFile(this.dirOrFile, this.type);

  T dirOrFile;
  DirOrFileEnum type;
}

abstract class DirOrFileInterface {
  String get name;
  int get size;
}

class Directory implements DirOrFileInterface {
  Directory(this.name, [this.isRoot = false]);

  String name;
  bool isRoot = false;
  List<DirOrFile<DirOrFileInterface>> children = [];
  int size = 0;

  void addFile(DirOrFileInterface file) {
    children.add(DirOrFile(file, DirOrFileEnum.file));
    size += file.size;
  }

  void addDir(Directory dir) {
    if (children.firstWhereOrNull(
            (element) => element.dirOrFile.name == dir.name) !=
        null) {
      // replacing
      children.removeWhere((element) => element.dirOrFile.name == dir.name);
    }
    if (dir.name == "/") return;
    children.add(DirOrFile(dir, DirOrFileEnum.dir));
    size += dir.size;
  }

  void addDeepDir(Directory dir, List<String> path) {
    if (path.isEmpty) {
      addDir(dir);
    } else {
      final child = children.firstWhereOrNull(
        (d) => d.dirOrFile.name == path.first,
      );
      if (child == null) {
        final newDir = Directory(path.first);
        newDir.addDeepDir(dir, path.sublist(1));
        addDir(newDir);
      } else {
        (child.dirOrFile as Directory).addDeepDir(dir, path.sublist(1));
      }
    }
  }

  void updateSizes() {
    size = 0;
    for (final child in children) {
      if (child.type == DirOrFileEnum.dir) {
        (child.dirOrFile as Directory).updateSizes();
      }
      size += child.dirOrFile.size;
    }
  }

  List<Directory> _smallestAboveSize(int size) {
    List<Directory> dirs = [];
    for (final child in children) {
      if (child.type == DirOrFileEnum.dir) {
        if (child.dirOrFile.size > size) {
          dirs.add(child.dirOrFile as Directory);
          dirs.addAll((child.dirOrFile as Directory)._smallestAboveSize(size));
        }
      }
    }
    return dirs;
  }

  int smallestAboveSize(int size) {
    List<Directory> dirs = [];
    for (final child in children) {
      if (child.type == DirOrFileEnum.dir) {
        if (child.dirOrFile.size > size) {
          dirs.add(child.dirOrFile as Directory);
          dirs.addAll((child.dirOrFile as Directory)._smallestAboveSize(size));
        }
      }
    }
    dirs.sort((a, b) => a.size.compareTo(b.size));
    return dirs.first.size;
  }
}

class File implements DirOrFileInterface {
  File(this.name, this.size);

  String name;
  int size;
}

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  Directory parseInput() {
    final inputUtil = InputUtil(7);
    final lines = inputUtil.getPerLine();
    Directory fileSystem = Directory("/", true);
    final List<String> currentLocation = [];
    for (final line in lines) {
      final parts = line.split(" ");
      bool isInstruction = parts[0].contains("\$");
      if (isInstruction) {
        final instruction = parts[1];
        if (instruction == "cd") {
          if (parts[2] == "..") {
            currentLocation.removeLast();
          } else if (parts[2] == "/") {
            currentLocation.clear();
            currentLocation.add("/");
          } else {
            currentLocation.add(parts[2]);
          }
        }
      } else {
        final sizeOrDir = parts[0];
        final size = int.tryParse(sizeOrDir);
        final DirOrFile<DirOrFileInterface> dirOrFile;
        if (size == null) {
          // is dir
          dirOrFile =
              DirOrFile<Directory>(Directory(parts[1]), DirOrFileEnum.dir);
        } else {
          // is file
          dirOrFile = DirOrFile<File>(File(parts[1], size), DirOrFileEnum.file);
        }
        Directory currentDir = fileSystem;
        if (currentLocation.length > 1) {
          for (final dir in currentLocation) {
            if (dir == "/") {
              continue;
            }
            currentDir = currentDir.children
                .firstWhere(
                  (d) => d.dirOrFile.name == dir,
                )
                .dirOrFile as Directory;
          }
          currentDir.children.add(dirOrFile);
          fileSystem.addDeepDir(currentDir, currentLocation);
        } else {
          if (dirOrFile.type == DirOrFileEnum.dir)
            fileSystem.addDir(dirOrFile.dirOrFile as Directory);
          else
            fileSystem.addFile(dirOrFile.dirOrFile as File);
        }
      }
    }
    fileSystem.updateSizes();
    return fileSystem;
  }

  int deepChildScore(Directory dir) {
    int score = 0;
    for (final child in dir.children) {
      if (child.type == DirOrFileEnum.dir) {
        score += deepChildScore(child.dirOrFile as Directory);
        if (child.dirOrFile.size <= 100000) {
          score += child.dirOrFile.size;
        }
      }
    }
    return score;
  }

  @override
  int solvePart1() {
    final fileSystem = parseInput();
    int score = 0;
    for (final child in fileSystem.children) {
      if (child.type == DirOrFileEnum.dir) {
        score += deepChildScore(child.dirOrFile as Directory);
        if (child.dirOrFile.size <= 100000) {
          score += child.dirOrFile.size;
        }
      }
    }
    return score;
  }

  @override
  int solvePart2() {
    final fileSystem = parseInput();
    int fsSize = 70000000;
    int sizeNeeded = 30000000;
    int sizeAvailable = fsSize - fileSystem.size;
    int minSizeNeeded = sizeNeeded - sizeAvailable;
    return fileSystem.smallestAboveSize(minSizeNeeded);
  }
}
