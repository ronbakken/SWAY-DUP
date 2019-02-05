import 'package:flutter/foundation.dart' show ChangeNotifier;

class SelectionSet<T> extends ChangeNotifier {

  final Set<T> values;

  SelectionSet() : values = Set<T>();

  SelectionSet.fromIterable(Iterable<T> iterable) : values = Set.from(iterable);

  List<T> toList() => values.toList();

  bool contains(T value) => values.contains(value);

  void add(T value) {
    values.add(value);
    notifyListeners();
  }

  void remove(T value) {
    values.remove(value);
    notifyListeners();
  }

  void addAll(Iterable<T> toAdd) {
    values.addAll(toAdd);
    notifyListeners();
  }

  void toggle(T value) {
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }
    notifyListeners();
  }
}
