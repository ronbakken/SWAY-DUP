import 'dart:collection';

class CacheMapEntry<K, V> extends LinkedListEntry<CacheMapEntry<K, V>> {
  final K key;
  final V value;
  int accessed;
  CacheMapEntry(this.key, this.value);
}

class CacheMap<K, V> {
  Map<K, CacheMapEntry<K, V>> _map = new Map<K, CacheMapEntry<K, V>>();
  LinkedList<CacheMapEntry<K, V>> _list = new LinkedList<CacheMapEntry<K, V>>();

  int lifeTime = 15 * 60 * 1000; // 15 minute lifetime
  int entryLimit = 16 * 1024; // 16k entries

  void _expire(int now) {
    int limit = now - lifeTime;
    while (_list.isNotEmpty && _list.first.accessed < limit) {
      CacheMapEntry<K, V> entry = _list.first;
      _list.remove(entry);
      _map.remove(entry.key);
    }
  }

  void remove(K key) {
    CacheMapEntry<K, V> entry = _map[key];
    if (entry != null) {
      _list.remove(entry);
      _map.remove(entry.key);
    }
  }

  V operator [](K key) {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    _expire(now);
    CacheMapEntry<K, V> entry = _map[key];
    if (entry == null) {
      return null;
    }
    _list.remove(entry);
    entry.accessed = now;
    _list.add(entry);
    return entry.value;
  }

  void operator []=(K key, V value) {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    CacheMapEntry<K, V> entry = new CacheMapEntry<K, V>(key, value);
    entry.accessed = now;
    _map[key] = entry;
    _list.add(entry);
  }
}
