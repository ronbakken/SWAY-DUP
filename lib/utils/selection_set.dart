import 'package:flutter/foundation.dart';

class SelectionSet<T> extends ChangeNotifier {

  SelectionSet();

  SelectionSet.fromIterable(Iterable<T> iterable)
  {
    for(var element in iterable)
    {
      values.add(element);
    }
  }

  List<T> toList()
  {
    return values.toList();
  }

  Set<T> values = Set<T>();

  bool contains(T value) => values.contains(value);

  void add(T value) {
    values.add(value);
    notifyListeners();
  }

  void remove(T value) {
    values.remove(value);
    notifyListeners();
  }

  void addAll(Iterable<T> toAdd)
  {
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
