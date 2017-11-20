// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.list_multimap;

/// The Built Collection [ListMultimap].
///
/// It implements the non-mutating part of the [ListMultimap] interface.
/// Iteration over keys is in the same order in which they were inserted.
/// Modifications are made via [ListMultimapBuilder].
///
/// See the
/// [Built Collection library documentation]
/// (#built_collection/built_collection)
/// for the general properties of Built Collections.
abstract class BuiltListMultimap<K, V> {
  final Map<K, BuiltList<V>> _map;

  // Precomputed.
  final BuiltList<V> _emptyList = new BuiltList<V>();

  // Cached.
  int _hashCode;
  Iterable<K> _keys;
  Iterable<V> _values;

  /// Instantiates with elements from a [Map], [ListMultimap] or
  /// [BuiltListMultimap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong:
  ///   `new BuiltListMultimap({1: ['1'], 2: ['2'], 3: ['3']})`.
  ///
  /// Right:
  ///   `new BuiltListMultimap<int, String>({1: ['1'], 2: ['2'], 3: ['3']})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory BuiltListMultimap([multimap = const {}]) {
    if (multimap is _BuiltListMultimap &&
        multimap.hasExactKeyAndValueTypes(K, V)) {
      return multimap as BuiltListMultimap<K, V>;
    } else if (multimap is Map ||
        multimap is ListMultimap ||
        multimap is BuiltListMultimap) {
      return new _BuiltListMultimap<K, V>.copyAndCheck(
          multimap.keys, (k) => multimap[k]);
    } else {
      throw new ArgumentError(
          'expected Map, ListMultimap or BuiltListMultimap, '
          'got ${multimap.runtimeType}');
    }
  }

  /// Creates a [ListMultimapBuilder], applies updates to it, and builds.
  factory BuiltListMultimap.build(updates(ListMultimapBuilder<K, V> builder)) =>
      (new ListMultimapBuilder<K, V>()..update(updates)).build();

  /// Converts to a [ListMultimapBuilder] for modification.
  ///
  /// The `BuiltListMultimap` remains immutable and can continue to be used.
  ListMultimapBuilder<K, V> toBuilder() => new ListMultimapBuilder<K, V>(this);

  /// Converts to a [ListMultimapBuilder], applies updates to it, and builds.
  BuiltListMultimap<K, V> rebuild(updates(ListMultimapBuilder<K, V> builder)) =>
      (toBuilder()..update(updates)).build();

  /// Converts to a [Map].
  ///
  /// Note that the implementation is efficient: it returns a copy-on-write
  /// wrapper around the data from this `BuiltListMultimap`. So, if no
  /// mutations are made to the result, no copy is made.
  ///
  /// This allows efficient use of APIs that ask for a mutable collection
  /// but don't actually mutate it.
  Map<K, BuiltList<V>> toMap() => new CopyOnWriteMap<K, BuiltList<V>>(_map);

  /// Deep hashCode.
  ///
  /// A `BuiltListMultimap` is only equal to another `BuiltListMultimap` with
  /// equal key/values pairs in any order. Then, the `hashCode` is guaranteed
  /// to be the same.
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = hashObjects(_map.keys
          .map((key) => hash2(key.hashCode, _map[key].hashCode))
          .toList(growable: false)
            ..sort());
    }
    return _hashCode;
  }

  /// Deep equality.
  ///
  /// A `BuiltListMultimap` is only equal to another `BuiltListMultimap` with
  /// equal key/values pairs in any order.
  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! BuiltListMultimap) return false;
    if (other.length != length) return false;
    if (other.hashCode != hashCode) return false;
    for (final key in keys) {
      if (other[key] != this[key]) return false;
    }
    return true;
  }

  @override
  String toString() => _map.toString();

  /// Returns as an immutable map.
  ///
  /// Useful when producing or using APIs that need the [Map] interface. This
  /// differs from [toMap] where mutations are explicitly disallowed.
  Map<K, Iterable<V>> asMap() => new Map<K, Iterable<V>>.unmodifiable(_map);

  // ListMultimap.

  /// As [ListMultimap], but results are [BuiltList]s and not mutable.
  BuiltList<V> operator [](Object key) {
    final result = _map[key];
    return identical(result, null) ? _emptyList : result;
  }

  /// As [ListMultimap.containsKey].
  bool containsKey(Object key) => _map.containsKey(key);

  /// As [ListMultimap.containsValue].
  bool containsValue(Object value) => values.contains(value);

  /// As [ListMultimap.forEach].
  void forEach(void f(K key, V value)) {
    _map.forEach((key, values) {
      values.forEach((value) {
        f(key, value);
      });
    });
  }

  /// As [ListMultimap.forEachKey].
  void forEachKey(void f(K key, Iterable<V> value)) {
    _map.forEach((key, values) {
      f(key, values);
    });
  }

  /// As [ListMultimap.isEmpty].
  bool get isEmpty => _map.isEmpty;

  /// As [ListMultimap.isNotEmpty].
  bool get isNotEmpty => _map.isNotEmpty;

  /// As [ListMultimap.keys], but result is stable; it always returns the same
  /// instance.
  Iterable<K> get keys {
    if (_keys == null) {
      _keys = _map.keys;
    }
    return _keys;
  }

  /// As [ListMultimap.length].
  int get length => _map.length;

  /// As [ListMultimap.values], but result is stable; it always returns the
  /// same instance.
  Iterable<V> get values {
    if (_values == null) {
      _values = _map.values.expand((x) => x);
    }
    return _values;
  }

  // Internal.

  BuiltListMultimap._(this._map) {
    if (K == dynamic) {
      throw new UnsupportedError('explicit key type required, '
          'for example "new BuiltListMultimap<int, int>"');
    }
    if (V == dynamic) {
      throw new UnsupportedError('explicit value type required,'
          ' for example "new BuiltListMultimap<int, int>"');
    }
  }
}

/// Default implementation of the public [BuiltListMultimap] interface.
class _BuiltListMultimap<K, V> extends BuiltListMultimap<K, V> {
  _BuiltListMultimap.withSafeMap(Map<K, BuiltList<V>> map) : super._(map);

  _BuiltListMultimap.copyAndCheck(Iterable keys, Function lookup)
      : super._(new Map<K, BuiltList<V>>()) {
    for (final key in keys) {
      if (key is K) {
        _map[key] = new BuiltList<V>(lookup(key));
      } else {
        throw new ArgumentError('map contained invalid key: $key');
      }
    }
  }

  bool hasExactKeyAndValueTypes(Type key, Type value) => K == key && V == value;
}
