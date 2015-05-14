// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.multimap;

/// The Built Collection builder for [BuiltListMultimap].
///
/// It implements the mutating part of the [ListMultimap] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class ListMultimapBuilder<K, V> {
  bool _copyBeforeWrite;
  BuiltListMultimap<K, V> _builtListMultimap;
  Map<K, BuiltList<V>> _builtMap;
  Map<K, ListBuilder<V>> _builderMap = new Map<K, ListBuilder<V>>();

  /// Instantiates with elements from a [Map], [ListMultimap] or
  /// [BuiltListMultimap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new ListMultimapBuilder({1: ['1'], 2: ['2'], 3: ['3']})`.
  ///
  /// Right: `new ListMultimapBuilder<int, String>({1: ['1'], 2: ['2'], 3: ['3']})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory ListMultimapBuilder([multimap = const {}]) {
    return new ListMultimapBuilder<K, V>._uninitialized()..replace(multimap);
  }

  /// Converts to a [BuiltListMultimap].
  ///
  /// The `ListMultimapBuilder` can be modified again and used to create any number
  /// of `BuiltListMultimap`s.
  BuiltListMultimap<K, V> build() {
    if (_builtListMultimap == null) {
      _copyBeforeWrite = true;

      for (final key in _builderMap.keys) {
        final builtList = _builderMap[key].build();
        if (builtList.isEmpty) {
          _builtMap.remove(key);
        } else {
          _builtMap[key] = builtList;
        }
      }

      _builtListMultimap = new BuiltListMultimap<K, V>._withSafeMap(_builtMap);
    }
    return _builtListMultimap;
  }

  /// Applies a function to `this`.
  void update(updates(ListMultimapBuilder<K, V> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from a [Map], [ListMultimap] or
  /// [BuiltListMultimap].
  void replace(multimap) {
    if (multimap is BuiltListMultimap<K, V>) {
      _replaceFromBuiltListMultimap(multimap);
    } else if (multimap is Map ||
        multimap is ListMultimap ||
        multimap is BuiltListMultimap) {
      _replaceWithCopyAndCheck(multimap.keys, (k) => multimap[k]);
    } else {
      throw new ArgumentError(
          'expected Map, ListMultimap or BuiltListMultimap, got ${multimap.runtimeType}');
    }
  }

  // Based on ListMultimap.

  /// As [ListMultimap.add].
  void add(K key, V value) {
    _maybeCopyBeforeWrite();
    _checkKey(key);
    _checkValue(value);

    final values = _builderMap[key];
    if (values == null) {
      var newValues = _builtMap[key];
      if (newValues == null) {
        newValues = new ListBuilder<V>();
      } else {
        newValues = newValues.toBuilder();
      }
      _builderMap[key] = newValues;
      newValues.add(value);
    } else {
      values.add(value);
    }
  }

  /// As [ListMultimap.addValues].
  void addValues(K key, Iterable<V> values) {
    values.forEach((value) {
      add(key, value);
    });
  }

  /// As [ListMultimap.addAll].
  void addAll(ListMultimap<K, V> other) {
    other.forEach((key, value) {
      add(key, value);
    });
  }

  /// As [ListMultimap.remove] but returns nothing.
  void remove(Object key, V value) {
    _maybeCopyBeforeWrite();
    final values = _builderMap[key];
    if (values == null) {
      var newValues = _builtMap[key];
      if (newValues == null) {
        return;
      } else {
        newValues = newValues.toBuilder();
      }
      _builderMap[key] = newValues;
      newValues.remove(value);
    } else {
      values.remove(value);
    }
  }

  /// As [ListMultimap.removeAll] but returns nothing.
  void removeAll(Object key) {
    _maybeCopyBeforeWrite();
    _builderMap[key] = new ListBuilder<V>();
  }

  /// As [ListMultimap.clear].
  void clear() {
    _maybeCopyBeforeWrite();
    _builtMap.clear();
    _builderMap.clear();
  }

  // Internal.

  ListMultimapBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  void _replaceFromBuiltListMultimap(
      BuiltListMultimap<K, V> builtListMultimap) {
    _copyBeforeWrite = true;
    _builtListMultimap = builtListMultimap;
    _builtMap = builtListMultimap._map;
  }

  void _replaceWithCopyAndCheck(Iterable keys, Function lookup) {
    _copyBeforeWrite = false;
    _builtListMultimap = null;
    _builtMap = new Map<K, BuiltList<V>>();

    for (final key in keys) {
      if (key is! K) {
        throw new ArgumentError('map contained invalid key: ${key}');
      }

      for (final value in lookup(key)) {
        add(key, value);
      }
    }
  }

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _builtListMultimap = null;
    _builtMap = new Map<K, BuiltList<V>>.from(_builtMap);
  }

  void _checkGenericTypeParameter() {
    if (null is K && K != Object) {
      throw new UnsupportedError(
          'explicit key type required, for example "new ListMultimapBuilder<int, int>"');
    }
    if (null is V && V != Object) {
      throw new UnsupportedError('explicit value type required,'
          ' for example "new ListMultimapBuilder<int, int>"');
    }
  }

  void _checkKey(Object key) {
    if (key is! K) {
      throw new ArgumentError('invalid key: ${key}');
    }
  }

  void _checkValue(Object value) {
    if (value is! V) {
      throw new ArgumentError('invalid value: ${value}');
    }
  }
}
