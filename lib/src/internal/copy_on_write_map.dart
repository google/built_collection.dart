// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.copy_on_write_map;

class CopyOnWriteMap<K, V> implements Map<K, V> {
  bool _copyBeforeWrite;
  Map<K, V> _map;

  CopyOnWriteMap(this._map) : _copyBeforeWrite = true;

  // Read-only methods: just forward.

  @override
  V operator [](Object key) => _map[key];

  @override
  bool containsKey(Object key) => _map.containsKey(key);

  @override
  bool containsValue(Object value) => _map.containsValue(value);

  @override
  void forEach(void f(K key, V value)) => _map.forEach(f);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  Iterable<V> get values => _map.values;

  // Mutating methods: copy first if needed.

  @override
  void operator []=(K key, V value) {
    _maybeCopyBeforeWrite();
    _map[key] = value;
  }

  @override
  void addAll(Map other) {
    _maybeCopyBeforeWrite();
    _map.addAll(other);
  }

  @override
  void clear() {
    _maybeCopyBeforeWrite();
    _map.clear();
  }

  @override
  V putIfAbsent(K key, V ifAbsent()) {
    _maybeCopyBeforeWrite();
    return _map.putIfAbsent(key, ifAbsent);
  }

  @override
  V remove(Object key) {
    _maybeCopyBeforeWrite();
    return _map.remove(key);
  }

  @override
  String toString() => _map.toString();

  // Internal.

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _map = new Map<K, V>.from(_map);
  }
}
