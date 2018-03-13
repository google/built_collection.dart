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
/// [Built Collection library documentation]
/// (#built_collection/built_collection)
/// for the general properties of Built Collections.
abstract class BuiltList<E> implements Iterable<E>, BuiltIterable<E> {
  final List<E> _list;
  int _hashCode;

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
    if (iterable is _BuiltList && iterable.hasExactElementType(E)) {
      return iterable as BuiltList<E>;
    } else {
      return new _BuiltList<E>.copyAndCheck(iterable);
    }
  }

  /// Creates a [ListBuilder], applies updates to it, and builds.
  factory BuiltList.build(updates(ListBuilder<E> builder)) =>
      (new ListBuilder<E>()..update(updates)).build();

  /// Converts to a [ListBuilder] for modification.
  ///
  /// The `BuiltList` remains immutable and can continue to be used.
  ListBuilder<E> toBuilder() => new ListBuilder<E>(this);

  /// Converts to a [ListBuilder], applies updates to it, and builds.
  BuiltList<E> rebuild(updates(ListBuilder<E> builder)) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltList<E> toBuiltList() => this;

  @override
  BuiltSet<E> toBuiltSet() => new BuiltSet<E>(this);

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
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
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

  /// Returns as an immutable list.
  ///
  /// Useful when producing or using APIs that need the [List] interface. This
  /// differs from [toList] where mutations are explicitly disallowed.
  List<E> asList() => new List<E>.unmodifiable(_list);

  // List.

  /// As [List.elementAt].
  E operator [](int index) => _list[index];

  /// As [List.length].
  @override
  int get length => _list.length;

  /// As [List.reversed].
  Iterable<E> get reversed => _list.reversed;

  /// As [List.indexOf].
  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);

  /// As [List.lastIndexOf].
  int lastIndexOf(E element, [int start]) => _list.lastIndexOf(element, start);

  /// As [List.sublist] but returns a `BuiltList<E>`.
  BuiltList<E> sublist(int start, [int end]) =>
      new _BuiltList<E>.withSafeList(_list.sublist(start, end));

  /// As [List.getRange].
  Iterable<E> getRange(int start, int end) => _list.getRange(start, end);

  /// As [List.asMap].
  Map<int, E> asMap() => _list.asMap();

  // Iterable.

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  Iterable<T> map<T>(T f(E e)) => _list.map(f);

  @override
  Iterable<E> where(bool test(E element)) => _list.where(test);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<T> whereType<T>() {
    throw new UnimplementedError('whereType');
  }

  @override
  Iterable<T> expand<T>(Iterable<T> f(E e)) => _list.expand(f);

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  void forEach(void f(E element)) => _list.forEach(f);

  @override
  E reduce(E combine(E value, E element)) => _list.reduce(combine);

  @override
  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _list.followedBy(other);

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
  E singleWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) throw new UnimplementedError('singleWhere:orElse');
    return _list.singleWhere(test);
  }

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  BuiltList<T> cast<T>() {
    throw new UnimplementedError('cast');
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  BuiltList<T> retype<T>() {
    throw new UnimplementedError('retype');
  }

  // Internal.

  BuiltList._(this._list) {
    if (E == dynamic) {
      throw new UnsupportedError(
          'explicit element type required, for example "new BuiltList<int>"');
    }
  }
}

/// Default implementation of the public [BuiltList] interface.
class _BuiltList<E> extends BuiltList<E> {
  _BuiltList.withSafeList(List<E> list) : super._(list);

  _BuiltList.copyAndCheck([Iterable iterable = const []])
      : super._(new List<E>.from(iterable, growable: false)) {
    for (final element in _list) {
      if (element is! E) {
        throw new ArgumentError('iterable contained invalid element: $element');
      }
    }
  }

  bool hasExactElementType(Type type) => E == type;
}
