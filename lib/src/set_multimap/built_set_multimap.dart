// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.set_multimap;

/// The Built Collection [SetMultimap].
///
/// It implements the non-mutating part of the [SetMultimap] interface. It
/// preserves key order. Modifications are made via [SetMultimapBuilder].
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class BuiltSetMultimap<K, V> {
  final Map<K, BuiltSet<V>> _map;

  // Precomputed.
  final BuiltSet<V> _emptySet = new BuiltSet<V>();

  // Cached.
  int _hashCode = null;
  Iterable<K> _keys;
  Iterable<V> _values;

  /// Instantiates with elements from a [Map], [SetMultimap] or
  /// [BuiltSetMultimap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new BuiltSetMultimap({1: ['1'], 2: ['2'], 3: ['3']})`.
  ///
  /// Right: `new BuiltSetMultimap<int, String>({1: ['1'], 2: ['2'], 3: ['3']})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory BuiltSetMultimap([multimap = const {}]) {
    if (multimap is BuiltSetMultimap<K, V>) {
      return multimap;
    } else if (multimap is Map ||
        multimap is SetMultimap ||
        multimap is BuiltSetMultimap) {
      return new BuiltSetMultimap<K, V>._copyAndCheck(
          multimap.keys, (k) => multimap[k]);
    } else {
      throw new ArgumentError(
          'expected Map, SetMultimap or BuiltSetMultimap, got ${multimap.runtimeType}');
    }
  }

  /// Creates a [SetMultimapBuilder], applies updates to it, and builds.
  factory BuiltSetMultimap.build(updates(SetMultimapBuilder<K, V> builder)) =>
      (new SetMultimapBuilder<K, V>()..update(updates)).build();

  /// Converts to a [SetMultimapBuilder] for modification.
  ///
  /// The `BuiltSetMultimap` remains immutable and can continue to be used.
  SetMultimapBuilder<K, V> toBuilder() => new SetMultimapBuilder<K, V>(this);

  /// Converts to a [SetMultimapBuilder], applies updates to it, and builds.
  BuiltSetMultimap<K, V> rebuild(updates(SetMultimapBuilder<K, V> builder)) =>
      (toBuilder()..update(updates)).build();

  /// Converts to a [Map].
  ///
  /// Note that the implementation is efficient: it returns a copy-on-write
  /// wrapper around the data from this `BuiltSetMultimap`. So, if no mutations are
  /// made to the result, no copy is made.
  ///
  /// This allows efficient use of APIs that ask for a mutable collection
  /// but don't actually mutate it.
  Map<K, BuiltSet<V>> toMap() => new CopyOnWriteMap<K, BuiltSet<V>>(_map);

  /// Deep hashCode.
  ///
  /// A `BuiltSetMultimap` is only equal to another `BuiltSetMultimap` with
  /// equal key/values pairs in any order. Then, the `hashCode` is guaranteed
  /// to be the same.
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = hashObjects(_map.keys
          .map((key) => hash2(key.hashCode, _map[key].hashCode))
          .toList(growable: false)..sort());
    }
    return _hashCode;
  }

  /// Deep equality.
  ///
  /// A `BuiltSetMultimap` is only equal to another `BuiltSetMultimap` with
  /// equal key/values pairs in any order.
  @override
  bool operator ==(other) {
    if (other is! BuiltSetMultimap) return false;
    if (other.length != length) return false;
    if (other.hashCode != hashCode) return false;
    for (final key in keys) {
      if (other[key] != this[key]) return false;
    }
    return true;
  }

  String toString() => _map.toString();

  // SetMultimap.

  /// As [SetMultimap], but results are [BuiltSet]s and not mutable.
  BuiltSet<V> operator [](Object key) {
    final result = _map[key];
    return identical(result, null) ? _emptySet : result;
  }

  /// As [SetMultimap.containsKey].
  bool containsKey(Object key) => _map.containsKey(key);

  /// As [SetMultimap.containsValue].
  bool containsValue(Object value) => values.contains(value);

  /// As [SetMultimap.forEach].
  void forEach(void f(K key, V value)) {
    _map.forEach((key, values) {
      values.forEach((value) {
        f(key, value);
      });
    });
  }

  /// As [SetMultimap.forEachKey].
  void forEachKey(void f(K key, Iterable<V> value)) {
    _map.forEach((key, values) {
      f(key, values);
    });
  }

  /// As [SetMultimap.isEmpty].
  bool get isEmpty => _map.isEmpty;

  /// As [SetMultimap.isNotEmpty].
  bool get isNotEmpty => _map.isNotEmpty;

  /// As [SetMultimap.keys], but result is stable; it always returns the same
  /// instance.
  Iterable<K> get keys {
    if (_keys == null) {
      _keys = _map.keys;
    }
    return _keys;
  }

  /// As [SetMultimap.length].
  int get length => _map.length;

  /// As [SetMultimap.values], but result is stable; it always returns the
  /// same instance.
  Iterable<V> get values {
    if (_values == null) {
      _values = _map.values.expand((x) => x);
    }
    return _values;
  }

  // Internal.

  BuiltSetMultimap._copyAndCheck(Iterable keys, Function lookup)
      : _map = new Map<K, BuiltSet<V>>() {
    _checkGenericTypeParameter();

    for (final key in keys) {
      if (key is! K) {
        throw new ArgumentError('map contained invalid key: ${key}');
      }

      _map[key] = new BuiltSet<V>(lookup(key));
    }
  }

  BuiltSetMultimap._withSafeMap(this._map) {
    _checkGenericTypeParameter();
  }

  void _checkGenericTypeParameter() {
    if (K == dynamic) {
      throw new UnsupportedError(
          'explicit key type required, for example "new BuiltSetMultimap<int, int>"');
    }
    if (V == dynamic) {
      throw new UnsupportedError('explicit value type required,'
          ' for example "new BuiltSetMultimap<int, int>"');
    }
  }
}
