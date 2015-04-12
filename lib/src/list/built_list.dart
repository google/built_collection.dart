// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.list;

/// The Built Collection [List].
///
/// It implements [Iterable] and the non-mutating part of the [List] interface.
/// Modifications are made via [ListBuilder].
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class BuiltList<E> implements Iterable<E> {
  final List<E> _list;
  int _hashCode = null;

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new BuiltList([1, 2, 3])`.
  ///
  /// Right: `new BuiltList<int>([1, 2, 3])`,
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory BuiltList([Iterable iterable = const []]) {
    if (iterable is BuiltList<E>) {
      return iterable;
    } else {
      return new BuiltList<E>._copyAndCheck(iterable);
    }
  }

  /// Converts to a [ListBuilder] for modification.
  ///
  /// The `BuiltList` remains immutable and can continue to be used.
  ListBuilder toBuilder() => new ListBuilder<E>(this);

  /// Deep hashCode.
  ///
  /// A `BuiltList` is only equal to another `BuiltList` with equal elements in
  /// the same order. Then, the `hashCode` is guaranteed to be the same.
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = hashObjects(_list);
    }
    return _hashCode;
  }

  /// Deep equality.
  ///
  /// A `BuiltList` is only equal to another `BuiltList` with equal elements in
  /// the same order.
  @override
  bool operator ==(other) {
    if (other is! BuiltList) return false;
    if (other.length != length) return false;
    if (other.hashCode != hashCode) return false;
    for (var i = 0; i != length; ++i) {
      if (other[i] != this[i]) return false;
    }
    return true;
  }

  @override
  String toString() => _list.toString();

  // List.

  /// As [List.elementAt].
  E operator [](int index) => _list[index];

  /// As [List.length].
  int get length => _list.length;

  /// As [List.reversed].
  Iterable<E> get reversed => _list.reversed;

  /// As [List.indexOf].
  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);

  /// As [List.lastIndexOf].
  int lastIndexOf(E element, [int start]) => _list.lastIndexOf(element, start);

  /// As [List.sublist] but returns a `BuiltList<E>`.
  BuiltList<E> sublist(int start, [int end]) =>
      new BuiltList<E>._withSafeList(_list.sublist(start, end));

  /// As [List.getRange].
  Iterable<E> getRange(int start, int end) => _list.getRange(start, end);

  /// As [List.asMap].
  Map<int, E> asMap() => _list.asMap();

  // Iterable.

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  Iterable map(f(E element)) => _list.map(f);

  @override
  Iterable<E> where(bool test(E element)) => _list.where(test);

  @override
  Iterable expand(Iterable f(E element)) => _list.expand(f);

  @override
  bool contains(E element) => _list.contains(element);

  @override
  void forEach(void f(E element)) => _list.forEach(f);

  @override
  E reduce(E combine(E value, E element)) => _list.reduce(combine);

  @override
  dynamic fold(
          var initialValue, dynamic combine(var previousValue, E element)) =>
      _list.fold(initialValue, combine);

  @override
  bool every(bool test(E element)) => _list.every(test);

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  bool any(bool test(E element)) => _list.any(test);

  /// As [Iterable.toList].
  ///
  /// Note that the implementation is efficient: it returns a copy-on-write
  /// wrapper around the data from this `BuiltList`. So, if no mutations are
  /// made to the result, no copy is made.
  ///
  /// This allows efficient use of APIs that ask for a mutable collection
  /// but don't actually mutate it.
  @override
  List<E> toList({bool growable: true}) =>
      new CopyOnWriteList<E>(_list, growable);

  @override
  Set<E> toSet() => _list.toSet();

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterable<E> take(int n) => _list.take(n);

  @override
  Iterable<E> takeWhile(bool test(E value)) => _list.takeWhile(test);

  @override
  Iterable<E> skip(int n) => _list.skip(n);

  @override
  Iterable<E> skipWhile(bool test(E value)) => _list.skipWhile(test);

  @override
  E get first => _list.first;

  @override
  E get last => _list.last;

  @override
  E get single => _list.single;

  @override
  E firstWhere(bool test(E element), {E orElse()}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  E lastWhere(bool test(E element), {E orElse()}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  E singleWhere(bool test(E element)) => _list.singleWhere(test);

  @override
  E elementAt(int index) => _list.elementAt(index);

  // Internal.

  BuiltList._copyAndCheck([Iterable iterable = const []])
      : _list = new List<E>.from(iterable, growable: false) {
    _checkGenericTypeParameter();

    for (final element in _list) {
      if (element is! E) {
        throw new ArgumentError(
            'iterable contained invalid element: ${element}');
      }
    }
  }

  BuiltList._withSafeList(this._list) {
    _checkGenericTypeParameter();
  }

  void _checkGenericTypeParameter() {
    if (UnusedClass is E && E != Object) {
      throw new UnsupportedError(
          'explicit element type required, for example "new BuiltList<int>"');
    }
  }
}
