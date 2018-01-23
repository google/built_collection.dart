// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.set;

/// The Built Collection builder for [BuiltSet].
///
/// It implements the mutating part of the [Set] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class SetBuilder<E> {
  /// Used by [_createSet] to instantiate [_set]. The default value is `null`.
  _SetFactory<E> _setFactory;
  Set<E> _set;
  _BuiltSet<E> _setOwner;

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new SetBuilder([1, 2, 3])`.
  ///
  /// Right: `new SetBuilder<int>([1, 2, 3])`,
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory SetBuilder([Iterable iterable = const []]) {
    return new SetBuilder<E>._uninitialized()..replace(iterable);
  }

  /// Converts to a [BuiltSet].
  ///
  /// The `SetBuilder` can be modified again and used to create any number
  /// of `BuiltSet`s.
  BuiltSet<E> build() {
    if (_setOwner == null) {
      _setOwner = new _BuiltSet<E>.withSafeSet(_setFactory, _set);
    }
    return _setOwner;
  }

  /// Applies a function to `this`.
  void update(updates(SetBuilder<E> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from an [Iterable].
  void replace(Iterable iterable) {
    if (iterable is _BuiltSet<E> && iterable._setFactory == _setFactory) {
      _withOwner(iterable);
    } else {
      // Can't use addAll because it requires an Iterable<E>.
      final Set<E> set = _createSet();
      for (final element in iterable) {
        if (element is E) {
          set.add(element);
        } else {
          throw new ArgumentError(
              'iterable contained invalid element: $element');
        }
      }
      _setSafeSet(set);
    }
  }

  /// Uses `base` as the collection type for all sets created by this builder.
  ///
  ///     // Iterates over elements in ascending order.
  ///     new SetBuilder<int>()..withBase(() => new SplayTreeSet<int>());
  ///
  ///     // Uses custom equality.
  ///     new SetBuilder<int>()..withBase(() => new LinkedHashSet<int>(
  ///         equals: (int a, int b) => a % 255 == b % 255,
  ///         hashCode: (int n) => (n % 255).hashCode));
  ///
  /// The set returned by `base` must be empty, mutable, and each call must
  /// instantiate and return a new object. The methods `difference`,
  /// `intersection` and `union` of the returned set must create sets of the
  /// same type.
  ///
  /// Use [withDefaultBase] to reset `base` to the default value.
  void withBase(_SetFactory<E> base) {
    if (base == null) {
      throw new ArgumentError.notNull('base');
    }
    _setFactory = base;
    _setSafeSet(_createSet()..addAll(_set));
  }

  /// As [withBase], but sets `base` back to the default value, which
  /// instantiates `Set<E>`.
  void withDefaultBase() {
    _setFactory = null;
    _setSafeSet(_createSet()..addAll(_set));
  }

  // Based on Set.

  /// As [Set.add].
  void add(E value) {
    _checkElement(value);
    _safeSet.add(value);
  }

  /// As [Set.addAll].
  void addAll(Iterable<E> iterable) {
    _checkElements(iterable);
    _safeSet.addAll(iterable);
  }

  /// As [Set.clear].
  void clear() {
    _safeSet.clear();
  }

  /// As [Set.remove] but returns nothing.
  void remove(Object value) {
    _safeSet.remove(value);
  }

  /// As [Set.removeAll].
  void removeAll(Iterable<Object> elements) {
    _safeSet.removeAll(elements);
  }

  /// As [Set.removeWhere].
  void removeWhere(bool test(E element)) {
    _safeSet.removeWhere(test);
  }

  /// As [Set.retainAll].
  void retainAll(Iterable<Object> elements) {
    _safeSet.retainAll(elements);
  }

  /// As [Set.retainWhere].
  ///
  /// This method is an alias of [where].
  void retainWhere(bool test(E element)) {
    _safeSet.retainWhere(test);
  }

  // Based on Iterable.

  /// As [Iterable.map], but updates the builder in place. Returns nothing.
  void map(E f(E element)) {
    final result = _createSet()..addAll(_set.map(f));
    _checkElements(result);
    _setSafeSet(result);
  }

  /// As [Iterable.where], but updates the builder in place. Returns nothing.
  ///
  /// This method is an alias of [retainWhere].
  void where(bool test(E element)) => retainWhere(test);

  /// As [Iterable.expand], but updates the builder in place. Returns nothing.
  void expand(Iterable<E> f(E element)) {
    final result = _createSet()..addAll(_set.expand(f));
    _checkElements(result);
    _setSafeSet(result);
  }

  /// As [Iterable.take], but updates the builder in place. Returns nothing.
  void take(int n) {
    _setSafeSet(_createSet()..addAll(_set.take(n)));
  }

  /// As [Iterable.takeWhile], but updates the builder in place. Returns
  /// nothing.
  void takeWhile(bool test(E value)) {
    _setSafeSet(_createSet()..addAll(_set.takeWhile(test)));
  }

  /// As [Iterable.skip], but updates the builder in place. Returns nothing.
  void skip(int n) {
    _setSafeSet(_createSet()..addAll(_set.skip(n)));
  }

  /// As [Iterable.skipWhile], but updates the builder in place. Returns
  /// nothing.
  void skipWhile(bool test(E value)) {
    _setSafeSet(_createSet()..addAll(_set.skipWhile(test)));
  }

  // Internal.

  SetBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  SetBuilder._fromBuiltSet(_BuiltSet<E> set)
      : _setFactory = set._setFactory,
        _set = set._set,
        _setOwner = set;

  void _withOwner(_BuiltSet<E> setOwner) {
    assert(setOwner._setFactory == _setFactory,
        "Can't reuse a built set that uses a different base");
    _set = setOwner._set;
    _setOwner = setOwner;
  }

  void _setSafeSet(Set<E> set) {
    _setOwner = null;
    _set = set;
  }

  Set<E> get _safeSet {
    if (_setOwner != null) {
      _set = _createSet()..addAll(_set);
      _setOwner = null;
    }
    return _set;
  }

  Set<E> _createSet() => _setFactory != null ? _setFactory() : new Set<E>();

  void _checkGenericTypeParameter() {
    if (E == dynamic) {
      throw new UnsupportedError('explicit element type required, '
          'for example "new SetBuilder<int>"');
    }
  }

  void _checkElement(E element) {
    if (identical(element, null)) {
      throw new ArgumentError('null element');
    }
  }

  void _checkElements(Iterable elements) {
    for (final element in elements) {
      if (element is! E) {
        throw new ArgumentError('invalid element: $element');
      }
    }
  }
}
