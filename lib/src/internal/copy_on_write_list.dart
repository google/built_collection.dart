// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math';

class CopyOnWriteList<E> implements List<E> {
  bool _copyBeforeWrite;
  bool _growable;
  List<E> _list;

  CopyOnWriteList(this._list, this._growable) : _copyBeforeWrite = true;

  // Read-only methods: just forward.

  @override
  int get length => _list.length;

  @override
  E operator [](int index) => _list[index];

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  List<E> operator +(List<E> other) {
    throw new UnimplementedError('+');
  }

  @override
  bool any(bool test(E element)) => _list.any(test);

  @override
  Map<int, E> asMap() => _list.asMap();

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  List<T> cast<T>() {
    throw new UnimplementedError('cast');
  }

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool test(E element)) => _list.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> f(E e)) => _list.expand(f);

  @override
  E get first => _list.first;

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_setter
  set first(E element) {
    if (this.isEmpty) throw new RangeError.index(0, this);
    this[0] = element;
  }

  @override
  E firstWhere(bool test(E element), {E orElse()}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      _list.fold(initialValue, combine);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<E> followedBy(Iterable<E> other) {
    throw new UnimplementedError('followedBy');
  }

  @override
  void forEach(void f(E element)) => _list.forEach(f);

  @override
  Iterable<E> getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  int indexWhere(bool test(E element), [int start = 0]) {
    throw new UnimplementedError('indexWhere');
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  E get last => _list.last;

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_setter
  set last(E element) {
    if (this.isEmpty) throw new RangeError.index(0, this);
    this[this.length - 1] = element;
  }

  @override
  int lastIndexOf(E element, [int start]) => _list.lastIndexOf(element, start);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  int lastIndexWhere(bool test(E element), [int start]) {
    throw new UnimplementedError('lastIndexWhere');
  }

  @override
  E lastWhere(bool test(E element), {E orElse()}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T f(E e)) => _list.map(f);

  @override
  E reduce(E combine(E value, E element)) => _list.reduce(combine);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  List<T> retype<T>() {
    throw new UnimplementedError('retype');
  }

  @override
  Iterable<E> get reversed => _list.reversed;

  @override
  E get single => _list.single;

  @override
  E singleWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) throw new UnimplementedError('singleWhere:orElse');
    return _list.singleWhere(test);
  }

  @override
  Iterable<E> skip(int count) => _list.skip(count);

  @override
  Iterable<E> skipWhile(bool test(E value)) => _list.skipWhile(test);

  @override
  List<E> sublist(int start, [int end]) => _list.sublist(start, end);

  @override
  Iterable<E> take(int count) => _list.take(count);

  @override
  Iterable<E> takeWhile(bool test(E value)) => _list.takeWhile(test);

  @override
  List<E> toList({bool growable: true}) => _list.toList(growable: growable);

  @override
  Set<E> toSet() => _list.toSet();

  @override
  Iterable<E> where(bool test(E element)) => _list.where(test);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<T> whereType<T>() {
    throw new UnimplementedError('whereType');
  }

  // Mutating methods: copy first if needed.

  @override
  set length(int length) {
    _maybeCopyBeforeWrite();
    _list.length = length;
  }

  @override
  void operator []=(int index, E element) {
    _maybeCopyBeforeWrite();
    _list[index] = element;
  }

  @override
  void add(E value) {
    _maybeCopyBeforeWrite();
    _list.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.addAll(iterable);
  }

  @override
  void sort([int compare(E a, E b)]) {
    _maybeCopyBeforeWrite();
    _list.sort(compare);
  }

  @override
  void shuffle([Random random]) {
    _maybeCopyBeforeWrite();
    _list.shuffle(random);
  }

  @override
  void clear() {
    _maybeCopyBeforeWrite();
    _list.clear();
  }

  @override
  void insert(int index, E element) {
    _maybeCopyBeforeWrite();
    _list.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.setAll(index, iterable);
  }

  @override
  bool remove(Object value) {
    _maybeCopyBeforeWrite();
    return _list.remove(value);
  }

  @override
  E removeAt(int index) {
    _maybeCopyBeforeWrite();
    return _list.removeAt(index);
  }

  @override
  E removeLast() {
    _maybeCopyBeforeWrite();
    return _list.removeLast();
  }

  @override
  void removeWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _list.removeWhere(test);
  }

  @override
  void retainWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _list.retainWhere(test);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _maybeCopyBeforeWrite();
    _list.setRange(start, end, iterable, skipCount);
  }

  @override
  void removeRange(int start, int end) {
    _maybeCopyBeforeWrite();
    _list.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _maybeCopyBeforeWrite();
    _list.fillRange(start, end, fillValue);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.replaceRange(start, end, iterable);
  }

  @override
  String toString() => _list.toString();

  // Internal.

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _list = new List<E>.from(_list, growable: _growable);
  }
}
