/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:collection';

class CacheMapEntry<K, V> extends LinkedListEntry<CacheMapEntry<K, V>> {
  final K key;
  final V value;
  int accessed;
  CacheMapEntry(this.key, this.value);
}

class CacheMap<K, V> {
  final Map<K, CacheMapEntry<K, V>> _map = <K, CacheMapEntry<K, V>>{};
  final LinkedList<CacheMapEntry<K, V>> _list =
      LinkedList<CacheMapEntry<K, V>>();

  int lifeTime = 15 * 60 * 1000; // 15 minute lifetime
  int entryLimit = 16 * 1024; // 16k entries

  void _expire(int now) {
    final int limit = now - lifeTime;
    while (_list.isNotEmpty && _list.first.accessed < limit) {
      final CacheMapEntry<K, V> entry = _list.first;
      _list.remove(entry);
      _map.remove(entry.key);
    }
  }

  void remove(K key) {
    final CacheMapEntry<K, V> entry = _map[key];
    if (entry != null) {
      _list.remove(entry);
      _map.remove(entry.key);
    }
  }

  V operator [](K key) {
    final int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    _expire(now);
    final CacheMapEntry<K, V> entry = _map[key];
    if (entry == null) {
      return null;
    }
    _list.remove(entry);
    entry.accessed = now;
    _list.add(entry);
    return entry.value;
  }

  void operator []=(K key, V value) {
    final int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final CacheMapEntry<K, V> entry = CacheMapEntry<K, V>(key, value);
    entry.accessed = now;
    _map[key] = entry;
    _list.add(entry);
  }
}

/* end of file */
