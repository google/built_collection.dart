// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

typedef Set<E> _SetFactory<E>();

class CopyOnWriteSet<E> implements Set<E> {
  final _SetFactory<E> _setFactory;
  bool _copyBeforeWrite;
  Set<E> _set;

  CopyOnWriteSet(this._set, [this._setFactory]) : _copyBeforeWrite = true;

  // Read-only methods: just forward.

  @override
  int get length => _set.length;

  @override
  E lookup(Object object) => _set.lookup(object);

  @override
  Set<E> intersection(Set<Object> other) => _set.intersection(other);

  @override
  Set<E> union(Set<E> other) => _set.union(other);

  @override
  Set<E> difference(Set<Object> other) => _set.difference(other);

  @override
  bool containsAll(Iterable<Object> other) => _set.containsAll(other);

  @override
  bool any(bool test(E element)) => _set.any(test);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Set<T> cast<T>() {
    throw new UnimplementedError('cast');
  }

  @override
  bool contains(Object element) => _set.contains(element);

  @override
  E elementAt(int index) => _set.elementAt(index);

  @override
  bool every(bool test(E element)) => _set.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> f(E e)) => _set.expand(f);

  @override
  E get first => _set.first;

  @override
  E firstWhere(bool test(E element), {E orElse()}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      _set.fold(initialValue, combine);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<E> followedBy(Iterable<E> other) {
    throw new UnimplementedError('followedBy');
  }

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
  Iterable<T> map<T>(T f(E e)) => _set.map(f);

  @override
  E reduce(E combine(E value, E element)) => _set.reduce(combine);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Set<T> retype<T>() {
    throw new UnimplementedError('retype');
  }

  @override
  E get single => _set.single;

  @override
  E singleWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) throw new UnimplementedError('singleWhere:orElse');
    return _set.singleWhere(test);
  }

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

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<T> whereType<T>() {
    throw new UnimplementedError('whereType');
  }

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
    _set = _setFactory != null
        ? (_setFactory()..addAll(_set))
        : new Set<E>.from(_set);
  }
}
