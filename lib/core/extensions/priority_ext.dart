import 'package:estesis_tech/domain/model/enum/priority.dart';

extension PriorityExt on Priority {
  int priorityToIndex() {
    switch (this) {
      case Priority.low:
        return 1;
      case Priority.medium:
        return 2;
      case Priority.high:
        return 2;
    }
  }
}
