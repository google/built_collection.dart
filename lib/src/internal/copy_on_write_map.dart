// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

typedef Map<K, V> _MapFactory<K, V>();

class CopyOnWriteMap<K, V> implements Map<K, V> {
  final _MapFactory<K, V> _mapFactory;
  bool _copyBeforeWrite;
  Map<K, V> _map;

  CopyOnWriteMap(this._map, [this._mapFactory]) : _copyBeforeWrite = true;

  // Read-only methods: just forward.

  @override
  V operator [](Object key) => _map[key];

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Map<K2, V2> cast<K2, V2>() {
    throw new UnimplementedError('cast');
  }

  @override
  bool containsKey(Object key) => _map.containsKey(key);

  @override
  bool containsValue(Object value) => _map.containsValue(value);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_getter
  Iterable<Null> get entries {
    // Change Iterable<Null> to Iterable<MapEntry<K, V>> when
    // the MapEntry class has been added.
    throw new UnimplementedError('entries');
  }

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
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Map<K2, V2> map<K2, V2>(Object transform(K key, V value)) {
    // Change Object to MapEntry<K2, V2> when
    // the MapEntry class has been added.
    throw new UnimplementedError('map');
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Map<K2, V2> retype<K2, V2>() {
    throw new UnimplementedError('retype');
  }

  @override
  Iterable<V> get values => _map.values;

  // Mutating methods: copy first if needed.

  @override
  void operator []=(K key, V value) {
    _maybeCopyBeforeWrite();
    _map[key] = value;
  }

  @override
  void addAll(Map<K, V> other) {
    _maybeCopyBeforeWrite();
    _map.addAll(other);
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  void addEntries(Iterable<Object> entries) {
    // Change Iterable<Object> to Iterable<MapEntry<K, V>> when
    // the MapEntry class has been added.
    throw new UnimplementedError('addEntries');
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
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  void removeWhere(bool test(K key, V value)) {
    throw new UnimplementedError('removeWhere');
  }

  @override
  String toString() => _map.toString();

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  V update(K key, V update(V value), {V ifAbsent()}) {
    throw new UnimplementedError('update');
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  void updateAll(V update(K key, V value)) {
    throw new UnimplementedError('updateAll');
  }

  // Internal.

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _map = _mapFactory != null
        ? (_mapFactory()..addAll(_map))
        : new Map<K, V>.from(_map);
  }
}
