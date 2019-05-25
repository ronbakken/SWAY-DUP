import 'package:inf/domain/domain.dart';
import 'package:quiver/collection.dart' show LruMap;
import 'package:quiver/core.dart';

class LruCache<T> {
  LruCache(
    this.maximumSize, {
    this.ttl = const Duration(minutes: 10),
  }) : _cacheMap = LruMap(maximumSize: maximumSize);

  final int maximumSize;
  final Duration ttl;

  final LruMap<String, Expirable<Optional<T>>> _cacheMap;

  Optional<T> operator [](String key) {
    final item = _cacheMap[key];
    if (item?.expired ?? false) {
      _cacheMap.remove(key);
      return null;
    }
    return item?.value;
  }

  void operator []=(String key, Optional<T> value) {
    _cacheMap[key] = Expirable.fromNow(ttl, value);
  }

  void clear() {
    _cacheMap.clear();
  }
}
