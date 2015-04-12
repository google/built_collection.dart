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
  bool _copyBeforeWrite;
  BuiltSet<E> _builtSet;
  Set<E> _set;

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
    if (iterable is BuiltSet<E>) {
      return new SetBuilder<E>._fromBuiltSet(iterable);
    } else {
      final Set<E> set = new Set<E>();
      for (final element in iterable) {
        set.add(element);
      }
      return new SetBuilder<E>._withSafeSet(set);
    }
  }

  /// Converts to a [BuiltSet].
  ///
  /// The `SetBuilder` can be modified again and used to create any number
  /// of `BuiltSet`s.
  BuiltSet<E> build() {
    if (_builtSet != null) return _builtSet;
    _copyBeforeWrite = true;
    return new BuiltSet<E>._withSafeSet(_set);
  }

  // Based on Set.

  /// As [Set.add].
  void add(E value) {
    _checkElement(value);
    _maybeCopyBeforeWrite();
    _set.add(value);
  }

  /// As [Set.addAll].
  void addAll(Iterable<E> iterable) {
    _checkElements(iterable);
    _maybeCopyBeforeWrite();
    _set.addAll(iterable);
  }

  /// As [Set.clear].
  void clear() {
    _maybeCopyBeforeWrite();
    _set.clear();
  }

  /// As [Set.remove] but returns nothing.
  void remove(Object value) {
    _maybeCopyBeforeWrite();
    _set.remove(value);
  }

  /// As [Set.removeWhere].
  void removeWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _set.removeWhere(test);
  }

  /// As [Set.retainWhere].
  void retainWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _set.retainWhere(test);
  }

  // Based on Iterable.

  /// As [Iterable.map], but updates the builder in place. Returns nothing.
  void map(E f(E element)) {
    _set = _set.map(f).toSet();
    _checkElements(_set);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.where], but updates the builder in place. Returns nothing.
  void where(bool test(E element)) {
    _set = _set.where(test).toSet();
    _copyBeforeWrite = false;
  }

  /// As [Iterable.expand], but updates the builder in place. Returns nothing.
  void expand(Iterable<E> f(E element)) {
    _set = _set.expand(f).toSet();
    _checkElements(_set);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.take], but updates the builder in place. Returns nothing.
  void take(int n) {
    _set = _set.take(n).toSet();
    _copyBeforeWrite = false;
  }

  /// As [Iterable.takeWhile], but updates the builder in place. Returns nothing.
  void takeWhile(bool test(E value)) {
    _set = _set.takeWhile(test).toSet();
    _copyBeforeWrite = false;
  }

  /// As [Iterable.skip], but updates the builder in place. Returns nothing.
  void skip(int n) {
    _set = _set.skip(n).toSet();
    _copyBeforeWrite = false;
  }

  /// As [Iterable.skipWhile], but updates the builder in place. Returns nothing.
  void skipWhile(bool test(E value)) {
    _set = _set.skipWhile(test).toSet();
    _copyBeforeWrite = false;
  }

  // Internal.

  SetBuilder._fromBuiltSet(BuiltSet<E> builtSet)
      : _copyBeforeWrite = true,
        _builtSet = builtSet,
        _set = builtSet._set {
    _checkGenericTypeParameter();
  }

  SetBuilder._withSafeSet(this._set) : _copyBeforeWrite = false {
    _checkGenericTypeParameter();
  }

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _builtSet = null;
    _set = new Set<E>.from(_set);
  }

  void _checkGenericTypeParameter() {
    if (UnusedClass is E && E != Object) {
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
