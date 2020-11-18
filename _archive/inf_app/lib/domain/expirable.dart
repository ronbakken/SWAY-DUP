import 'package:meta/meta.dart';

@immutable
class Expirable<T> {
  const Expirable(this.expiry, this.value);

  factory Expirable.fromNow(Duration ttl, T value) {
    return Expirable(DateTime.now().add(ttl), value);
  }

  final DateTime expiry;
  final T value;

  bool get expired => DateTime.now().compareTo(expiry) >= 0;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is Expirable &&
        runtimeType == other.runtimeType &&
        value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Expirable { value: $value, expiry: $expiry }';
  }
}
