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
  Set<E> _set;
  BuiltSet<E> _setOwner;

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
      _setOwner = new BuiltSet<E>._withSafeSet(_set);
    }
    return _setOwner;
  }

  /// Applies a function to `this`.
  void update(updates(SetBuilder<E> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from an [Iterable].
  void replace(Iterable iterable) {
    if (iterable is BuiltSet<E>) {
      _withOwner(iterable);
    } else {
      // Can't use addAll because it requires an Iterable<E>.
      final Set<E> set = new Set<E>();
      for (final element in iterable) {
        set.add(element);
      }
      _setSafeSet(set);
    }
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
  void retainWhere(bool test(E element)) {
    _safeSet.retainWhere(test);
  }

  // Based on Iterable.

  /// As [Iterable.map], but updates the builder in place. Returns nothing.
  void map(E f(E element)) {
    _setSafeSet(_set.map(f).toSet());
    _checkElements(_set);
  }

  /// As [Iterable.where], but updates the builder in place. Returns nothing.
  void where(bool test(E element)) {
    _setSafeSet(_set.where(test).toSet());
  }

  /// As [Iterable.expand], but updates the builder in place. Returns nothing.
  void expand(Iterable<E> f(E element)) {
    _setSafeSet(_set.expand(f).toSet());
    _checkElements(_set);
  }

  /// As [Iterable.take], but updates the builder in place. Returns nothing.
  void take(int n) {
    _setSafeSet(_set.take(n).toSet());
  }

  /// As [Iterable.takeWhile], but updates the builder in place. Returns nothing.
  void takeWhile(bool test(E value)) {
    _setSafeSet(_set.takeWhile(test).toSet());
  }

  /// As [Iterable.skip], but updates the builder in place. Returns nothing.
  void skip(int n) {
    _setSafeSet(_set.skip(n).toSet());
  }

  /// As [Iterable.skipWhile], but updates the builder in place. Returns nothing.
  void skipWhile(bool test(E value)) {
    _setSafeSet(_set.skipWhile(test).toSet());
  }

  // Internal.

  SetBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  void _withOwner(BuiltSet<E> setOwner) {
    _set = setOwner._set;
    _setOwner = setOwner;
  }

  void _setSafeSet(Set<E> set) {
    _setOwner = null;
    _set = set;
  }

  Set<E> get _safeSet {
    if (_setOwner != null) {
      _set = new Set<E>.from(_set);
      _setOwner = null;
    }
    return _set;
  }

  void _checkGenericTypeParameter() {
    if (E == dynamic) {
      throw new UnsupportedError('explicit element type required,'
          ' for example "new SetBuilder<int>"');
    }
  }

  void _checkElement(Object element) {
    if (element is! E) {
      throw new ArgumentError('invalid element: ${element}');
    }
  }

  void _checkElements(Iterable elements) {
    for (final element in elements) {
      _checkElement(element);
    }
  }
}
