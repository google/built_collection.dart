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
  bool _copyBeforeWrite;
  BuiltMap<K, V> _builtMap;
  Map<K, V> _map;

  /// Instantiates with elements from a [Map] or [BuiltMap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new BuiltMap({1: '1', 2: '2', 3: '3'})`.
  ///
  /// Right: `new BuiltMap<int, String>({1: '1', 2: '2', 3: '3'})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory MapBuilder([map = const {}]) {
    if (map is BuiltMap<K, V>) {
      return new MapBuilder<K, V>._fromBuiltMap(map);
    } else if (map is BuiltMap) {
      return new MapBuilder<K, V>._withSafeMap(new Map<K, V>.from(map._map));
    } else {
      return new MapBuilder<K, V>._withSafeMap(new Map<K, V>.from(map));
    }
  }

  /// Converts to a [BuiltMap].
  ///
  /// The `MapBuilder` can be modified again and used to create any number
  /// of `BuiltMap`s.
  BuiltMap<K, V> build() {
    if (_builtMap != null) return _builtMap;
    _copyBeforeWrite = true;
    return new BuiltMap<K, V>._withSafeMap(_map);
  }

  // Based on Map.

  /// As [Map].
  operator []=(K key, V value) {
    _checkKey(key);
    _checkValue(value);
    _maybeCopyBeforeWrite();
    _map[key] = value;
  }

  /// As [Map.putIfAbsent] but returns nothing.
  void putIfAbsent(K key, V ifAbsent()) {
    _checkKey(key);
    _maybeCopyBeforeWrite();
    _map.putIfAbsent(key, () {
      final value = ifAbsent();
      _checkValue(value);
      return value;
    });
  }

  /// As [Map.addAll].
  void addAll(Map<K, V> other) {
    _checkKeys(other.keys);
    _checkValues(other.values);
    _maybeCopyBeforeWrite();
    _map.addAll(other);
  }

  /// As [Map.remove] but returns nothing.
  void remove(Object key) {
    _maybeCopyBeforeWrite();
    _map.remove(key);
  }

  /// As [Map.clear].
  void clear() {
    _maybeCopyBeforeWrite();
    _map.clear();
  }

  // Internal.

  MapBuilder._fromBuiltMap(BuiltMap<K, V> builtMap)
      : _copyBeforeWrite = true,
        _builtMap = builtMap,
        _map = builtMap._map {
    _checkGenericTypeParameter();
  }

  MapBuilder._withSafeMap(this._map) : _copyBeforeWrite = false {
    _checkGenericTypeParameter();
  }

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _builtMap = null;
    _map = new Map<K, V>.from(_map);
  }

  void _checkGenericTypeParameter() {
    if (UnusedClass is K && K != Object) {
      throw new UnsupportedError(
          'explicit key type required, for example "new MapBuilder<int, int>"');
    }
    if (UnusedClass is V && V != Object) {
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
