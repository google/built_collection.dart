// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.map;

/// The Built Collection builder for [BuiltMap].
///
/// It implements the mutating part of the [Map] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class MapBuilder<K, V> {
  Map<K, V> _map;
  BuiltMap<K, V> _mapOwner;

  /// Instantiates with elements from a [Map] or [BuiltMap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new MapBuilder({1: '1', 2: '2', 3: '3'})`.
  ///
  /// Right: `new MapBuilder<int, String>({1: '1', 2: '2', 3: '3'})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory MapBuilder([map = const {}]) {
    return new MapBuilder<K, V>._uninitialized()..replace(map);
  }

  /// Converts to a [BuiltMap].
  ///
  /// The `MapBuilder` can be modified again and used to create any number
  /// of `BuiltMap`s.
  BuiltMap<K, V> build() {
    if (_mapOwner == null) {
      _mapOwner = new BuiltMap<K, V>._withSafeMap(_map);
    }
    return _mapOwner;
  }

  /// Applies a function to `this`.
  void update(updates(MapBuilder<K, V> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from a [Map] or [BuiltMap].
  void replace(map) {
    if (map is BuiltMap<K, V>) {
      _setOwner(map);
    } else if (map is BuiltMap) {
      _setSafeMap(new Map<K, V>.from(map._map));
    } else if (map is Map) {
      _setSafeMap(new Map<K, V>.from(map));
    } else {
      throw new ArgumentError(
          'expected Map or BuiltMap, got ${map.runtimeType}');
    }
  }

  /// As [Map.fromIterable] but adds.
  ///
  /// [key] and [value] default to the identity function.
  void addIterable(Iterable iterable, {K key(element), V value(element)}) {
    if (key == null) key = (x) => x;
    if (value == null) value = (x) => x;
    for (final element in iterable) {
      this[key(element)] = value(element);
    }
  }

  // Based on Map.

  /// As [Map].
  operator []=(K key, V value) {
    _checkKey(key);
    _checkValue(value);
    _safeMap[key] = value;
  }

  /// As [Map.putIfAbsent] but returns nothing.
  void putIfAbsent(K key, V ifAbsent()) {
    _checkKey(key);
    _safeMap.putIfAbsent(key, () {
      final value = ifAbsent();
      _checkValue(value);
      return value;
    });
  }

  /// As [Map.addAll].
  void addAll(Map<K, V> other) {
    _checkKeys(other.keys);
    _checkValues(other.values);
    _safeMap.addAll(other);
  }

  /// As [Map.remove] but returns nothing.
  void remove(Object key) {
    _safeMap.remove(key);
  }

  /// As [Map.clear].
  void clear() {
    _safeMap.clear();
  }

  // Internal.

  MapBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  void _setOwner(BuiltMap<K, V> mapOwner) {
    _mapOwner = mapOwner;
    _map = mapOwner._map;
  }

  void _setSafeMap(Map<K, V> map) {
    _mapOwner = null;
    _map = map;
  }

  Map<K, V> get _safeMap {
    if (_mapOwner != null) {
      _map = new Map<K, V>.from(_map);
      _mapOwner = null;
    }
    return _map;
  }

  void _checkGenericTypeParameter() {
    if (K == dynamic) {
      throw new UnsupportedError(
          'explicit key type required, for example "new MapBuilder<int, int>"');
    }
    if (V == dynamic) {
      throw new UnsupportedError('explicit value type required,'
          ' for example "new MapBuilder<int, int>"');
    }
  }

  void _checkKey(Object key) {
    if (key is! K) {
      throw new ArgumentError('invalid key: ${key}');
    }
  }

  void _checkKeys(Iterable keys) {
    for (final key in keys) {
      _checkKey(key);
    }
  }

  void _checkValue(Object value) {
    if (value is! V) {
      throw new ArgumentError('invalid value: ${value}');
    }
  }

  void _checkValues(Iterable values) {
    for (final value in values) {
      _checkValue(value);
    }
  }
}
