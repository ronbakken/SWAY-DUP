import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

class SelectionSet<T> extends DelegatingSet<T> with ChangeNotifier {
  SelectionSet() : super(Set<T>());

  SelectionSet.fromIterable(Iterable<T> iterable) : super(Set<T>.from(iterable));

  void toggle(T value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
  }

  @override
  bool add(T value) {
    final result = super.add(value);
    notifyListeners();
    return result;
  }

  @override
  void addAll(Iterable<T> elements) {
    super.addAll(elements);
    notifyListeners();
  }

  @override
  bool remove(Object value) {
    final result = super.remove(value);
    notifyListeners();
    return result;
  }

  @override
  void removeAll(Iterable<Object> elements) {
    super.removeAll(elements);
    notifyListeners();
  }
}
