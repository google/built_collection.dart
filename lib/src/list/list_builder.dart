// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.list;

/// The Built Collection builder for [BuiltList].
///
/// It implements the mutating part of the [List] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class ListBuilder<E> {
  List<E> _list;
  _BuiltList<E> _listOwner;

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new ListBuilder([1, 2, 3])`.
  ///
  /// Right: `new ListBuilder<int>([1, 2, 3])`,
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory ListBuilder([Iterable iterable = const []]) {
    return new ListBuilder<E>._uninitialized()..replace(iterable);
  }

  /// Converts to a [BuiltList].
  ///
  /// The `ListBuilder` can be modified again and used to create any number
  /// of `BuiltList`s.
  BuiltList<E> build() {
    if (_listOwner == null) {
      _setOwner(new _BuiltList<E>.withSafeList(_list));
    }
    return _listOwner;
  }

  /// Applies a function to `this`.
  void update(updates(ListBuilder<E> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from an [Iterable].
  void replace(Iterable iterable) {
    if (iterable is _BuiltList<E>) {
      _setOwner(iterable);
    } else {
      _setSafeList(new List<E>.from(iterable));
    }
  }

  // Based on List.

  /// As [List.elementAt].
  E operator [](int index) => _list[index];

  /// As [List].
  void operator []=(int index, E element) {
    _checkElement(element);
    _safeList[index] = element;
  }

  /// As [List.add].
  void add(E value) {
    _checkElement(value);
    _safeList.add(value);
  }

  /// As [List.addAll].
  void addAll(Iterable<E> iterable) {
    _checkElements(iterable);
    _safeList.addAll(iterable);
  }

  /// As [List.reversed], but updates the builder in place. Returns nothing.
  void reverse() {
    _list = _list.reversed.toList(growable: true);
    _listOwner = null;
  }

  /// As [List.sort].
  void sort([int compare(E a, E b)]) {
    _safeList.sort(compare);
  }

  /// As [List.shuffle].
  void shuffle([Random random]) {
    _safeList.shuffle(random);
  }

  /// As [List.clear].
  void clear() {
    _safeList.clear();
  }

  /// As [List.insert].
  void insert(int index, E element) {
    _checkElement(element);
    _safeList.insert(index, element);
  }

  /// As [List.insertAll].
  void insertAll(int index, Iterable<E> iterable) {
    _checkElements(iterable);
    _safeList.insertAll(index, iterable);
  }

  /// As [List.setAll].
  void setAll(int index, Iterable<E> iterable) {
    _checkElements(iterable);
    _safeList.setAll(index, iterable);
  }

  /// As [List.remove], but returns nothing.
  void remove(Object value) {
    _safeList.remove(value);
  }

  /// As [List.removeAt], but returns nothing.
  void removeAt(int index) {
    _safeList.removeAt(index);
  }

  /// As [List.removeLast], but returns nothing.
  void removeLast() {
    _safeList.removeLast();
  }

  /// As [List.removeWhere].
  void removeWhere(bool test(E element)) {
    _safeList.removeWhere(test);
  }

  /// As [List.retainWhere].
  ///
  /// This method is an alias of [where].
  void retainWhere(bool test(E element)) {
    _safeList.retainWhere(test);
  }

  /// As [List.sublist], but updates the builder in place. Returns nothing.
  void sublist(int start, [int end]) {
    _setSafeList(_list.sublist(start, end));
  }

  /// As [List.setRange].
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _checkElements(iterable);
    _safeList.setRange(start, end, iterable, skipCount);
  }

  /// As [List.removeRange].
  void removeRange(int start, int end) {
    _safeList.removeRange(start, end);
  }

  /// As [List.fillRange], but requires a value.
  void fillRange(int start, int end, E fillValue) {
    _checkElement(fillValue);
    _safeList.fillRange(start, end, fillValue);
  }

  /// As [List.replaceRange].
  void replaceRange(int start, int end, Iterable<E> iterable) {
    _checkElements(iterable);
    _safeList.replaceRange(start, end, iterable);
  }

  // Based on Iterable.

  /// As [Iterable.map], but updates the builder in place. Returns nothing.
  void map(E f(E element)) {
    final result = _list.map(f).toList(growable: true);
    _checkElements(result);
    _setSafeList(result);
  }

  /// As [Iterable.where], but updates the builder in place. Returns nothing.
  ///
  /// This method is an alias of [retainWhere].
  void where(bool test(E element)) => retainWhere(test);

  /// As [Iterable.expand], but updates the builder in place. Returns nothing.
  void expand(Iterable<E> f(E element)) {
    final result = _list.expand(f).toList(growable: true);
    _checkElements(result);
    _setSafeList(result);
  }

  /// As [Iterable.take], but updates the builder in place. Returns nothing.
  void take(int n) {
    _setSafeList(_list = _list.take(n).toList(growable: true));
  }

  /// As [Iterable.takeWhile], but updates the builder in place. Returns
  /// nothing.
  void takeWhile(bool test(E value)) {
    _setSafeList(_list = _list.takeWhile(test).toList(growable: true));
  }

  /// As [Iterable.skip], but updates the builder in place. Returns nothing.
  void skip(int n) {
    _setSafeList(_list.skip(n).toList(growable: true));
  }

  /// As [Iterable.skipWhile], but updates the builder in place. Returns
  /// nothing.
  void skipWhile(bool test(E value)) {
    _setSafeList(_list.skipWhile(test).toList(growable: true));
  }

  // Internal.

  ListBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  void _setOwner(_BuiltList<E> listOwner) {
    _list = listOwner._list;
    _listOwner = listOwner;
  }

  void _setSafeList(List<E> list) {
    _list = list;
    _listOwner = null;
  }

  List<E> get _safeList {
    if (_listOwner != null) {
      _setSafeList(new List<E>.from(_list, growable: true));
    }
    return _list;
  }

  void _checkGenericTypeParameter() {
    if (E == dynamic) {
      throw new UnsupportedError('explicit element type required, '
          'for example "new ListBuilder<int>"');
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
