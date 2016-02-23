// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.copy_on_write_set;

class CopyOnWriteSet<E> implements Set<E> {
  bool _copyBeforeWrite;
  Set<E> _set;

  CopyOnWriteSet(this._set) : _copyBeforeWrite = true;

  // Read-only methods: just forward.

  int get length => _set.length;

  @override
  E lookup(Object object) => _set.lookup(object);

  @override
  Set<E> intersection(Set<Object> other) => _set.intersection(other);

  @override
  Set<E> union(Set<E> other) => _set.union(other);

  @override
  Set<E> difference(Set<E> other) => _set.difference(other);

  @override
  bool containsAll(Iterable<Object> other) => _set.containsAll(other);

  @override
  bool any(bool test(E element)) => _set.any(test);

  @override
  bool contains(Object element) => _set.contains(element);

  @override
  E elementAt(int index) => _set.elementAt(index);

  @override
  bool every(bool test(E element)) => _set.every(test);

  @override
  Iterable expand(Iterable f(E element)) => _set.expand(f);

  @override
  E get first => _set.first;

  @override
  E firstWhere(bool test(E element), {E orElse()}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  fold(initialValue, combine(previousValue, E element)) =>
      _set.fold(initialValue, combine);

  @override
  void forEach(void f(E element)) => _set.forEach(f);

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool get isNotEmpty => _set.isNotEmpty;

  @override
  Iterator<E> get iterator => _set.iterator;

  @override
  String join([String separator = ""]) => _set.join(separator);

  @override
  E get last => _set.last;

  @override
  E lastWhere(bool test(E element), {E orElse()}) =>
      _set.lastWhere(test, orElse: orElse);

  @override
  Iterable map(f(E element)) => _set.map(f);

  @override
  E reduce(E combine(E value, E element)) => _set.reduce(combine);

  @override
  E get single => _set.single;

  @override
  E singleWhere(bool test(E element)) => _set.singleWhere(test);

  @override
  Iterable<E> skip(int count) => _set.skip(count);

  @override
  Iterable<E> skipWhile(bool test(E value)) => _set.skipWhile(test);

  @override
  Iterable<E> take(int count) => _set.take(count);

  @override
  Iterable<E> takeWhile(bool test(E value)) => _set.takeWhile(test);

  @override
  List<E> toList({bool growable: true}) => _set.toList(growable: growable);

  @override
  Set<E> toSet() => _set.toSet();

  @override
  Iterable<E> where(bool test(E element)) => _set.where(test);

  // Mutating methods: copy first if needed.

  @override
  bool add(E value) {
    _maybeCopyBeforeWrite();
    return _set.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _set.addAll(iterable);
  }

  @override
  void clear() {
    _maybeCopyBeforeWrite();
    _set.clear();
  }

  @override
  bool remove(Object value) {
    _maybeCopyBeforeWrite();
    return _set.remove(value);
  }

  @override
  void removeWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _set.removeWhere(test);
  }

  @override
  void retainWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _set.retainWhere(test);
  }

  @override
  void removeAll(Iterable<Object> elements) {
    _maybeCopyBeforeWrite();
    _set.removeAll(elements);
  }

  @override
  void retainAll(Iterable<Object> elements) {
    _maybeCopyBeforeWrite();
    _set.retainAll(elements);
  }

  @override
  String toString() => _set.toString();

  // Internal.

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _set = new Set<E>.from(_set);
  }
}
