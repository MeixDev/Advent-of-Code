import 'solutions/index.dart';
import 'utils/generic_day.dart';

/// Const to switch between showing the results for each day in [days], or only
/// the latest.
const ONLY_SHOW_LAST = true;

/// List holding all the solution classes.
final days = <GenericDay>[
  Day01(),
  Day02(),
  Day03(),
  Day04(),
];

void main() {
  ONLY_SHOW_LAST
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}
