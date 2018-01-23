// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.set;

typedef Set<E> _SetFactory<E>();

/// The Built Collection [Set].
///
/// It implements [Iterable] and the non-mutating part of the [Set] interface.
/// Iteration is in the same order in which the elements were inserted.
/// Modifications are made via [SetBuilder].
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
abstract class BuiltSet<E> implements Iterable<E>, BuiltIterable<E> {
  final _SetFactory<E> _setFactory;
  final Set<E> _set;
  int _hashCode;

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new BuiltSet([1, 2, 3])`.
  ///
  /// Right: `new BuiltSet<int>([1, 2, 3])`,
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory BuiltSet([Iterable iterable = const []]) {
    if (iterable is _BuiltSet && iterable.hasExactElementType(E)) {
      return iterable as BuiltSet<E>;
    } else {
      return new _BuiltSet<E>.copyAndCheck(iterable);
    }
  }

  /// Creates a [SetBuilder], applies updates to it, and builds.
  factory BuiltSet.build(updates(SetBuilder<E> builder)) =>
      (new SetBuilder<E>()..update(updates)).build();

  /// Converts to a [SetBuilder] for modification.
  ///
  /// The `BuiltSet` remains immutable and can continue to be used.
  SetBuilder<E> toBuilder() => new SetBuilder<E>._fromBuiltSet(this);

  /// Converts to a [SetBuilder], applies updates to it, and builds.
  BuiltSet<E> rebuild(updates(SetBuilder<E> builder)) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltList<E> toBuiltList() => new BuiltList<E>(this);

  @override
  BuiltSet<E> toBuiltSet() => this;

  /// Deep hashCode.
  ///
  /// A `BuiltSet` is only equal to another `BuiltSet` with equal elements in
  /// any order. Then, the `hashCode` is guaranteed to be the same.
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = hashObjects(
          _set.map((e) => e.hashCode).toList(growable: false)..sort());
    }
    return _hashCode;
  }

  /// Deep equality.
  ///
  /// A `BuiltSet` is only equal to another `BuiltSet` with equal elements in
  /// any order.
  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! BuiltSet) return false;
    if (other.length != length) return false;
    if (other.hashCode != hashCode) return false;
    return containsAll(other);
  }

  @override
  String toString() => _set.toString();

  /// Returns as an immutable set.
  ///
  /// Useful when producing or using APIs that need the [Set] interface. This
  /// differs from [toSet] where mutations are explicitly disallowed.
  Set<E> asSet() => new UnmodifiableSetView<E>(_set);

  // Set.

  /// As [Set.length].
  @override
  int get length => _set.length;

  /// As [Set.containsAll].
  bool containsAll(Iterable<Object> other) => _set.containsAll(other);

  /// As [Set.difference] but takes and returns a `BuiltSet<E>`.
  BuiltSet<E> difference(BuiltSet<Object> other) =>
      new _BuiltSet<E>.withSafeSet(_setFactory, _set.difference(other._set));

  /// As [Set.intersection] but takes and returns a `BuiltSet<E>`.
  BuiltSet<E> intersection(BuiltSet<Object> other) =>
      new _BuiltSet<E>.withSafeSet(_setFactory, _set.intersection(other._set));

  /// As [Set.lookup].
  E lookup(Object object) => _set.lookup(object);

  /// As [Set.union] but takes and returns a `BuiltSet<E>`.
  BuiltSet<E> union(BuiltSet<E> other) =>
      new _BuiltSet<E>.withSafeSet(_setFactory, _set.union(other._set));

  // Iterable.

  @override
  Iterator<E> get iterator => _set.iterator;

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  BuiltSet<T> cast<T>() {
    throw new UnimplementedError('cast');
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  BuiltSet<T> retype<T>() {
    throw new UnimplementedError('retype');
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<E> followedBy(Iterable<E> other) {
    throw new UnimplementedError('followedBy');
  }

  @override
  // TODO: Dart 2.0 requires this method to be implemented.
  // ignore: override_on_non_overriding_method
  Iterable<T> whereType<T>() {
    throw new UnimplementedError('whereType');
  }

  @override
  Iterable<T> map<T>(T f(E e)) => _set.map(f);

  @override
  Iterable<E> where(bool test(E element)) => _set.where(test);

  @override
  Iterable<T> expand<T>(Iterable<T> f(E e)) => _set.expand(f);

  @override
  bool contains(Object element) => _set.contains(element);

  @override
  void forEach(void f(E element)) => _set.forEach(f);

  @override
  E reduce(E combine(E value, E element)) => _set.reduce(combine);

  @override
  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      _set.fold(initialValue, combine);

  @override
  bool every(bool test(E element)) => _set.every(test);

  @override
  String join([String separator = '']) => _set.join(separator);

  @override
  bool any(bool test(E element)) => _set.any(test);

  /// As [Iterable.toSet].
  ///
  /// Note that the implementation is efficient: it returns a copy-on-write
  /// wrapper around the data from this `BuiltSet`. So, if no mutations are
  /// made to the result, no copy is made.
  ///
  /// This allows efficient use of APIs that ask for a mutable collection
  /// but don't actually mutate it.
  @override
  Set<E> toSet() => new CopyOnWriteSet<E>(_set, _setFactory);

  @override
  List<E> toList({bool growable: true}) => _set.toList(growable: growable);

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool get isNotEmpty => _set.isNotEmpty;

  @override
  Iterable<E> take(int n) => _set.take(n);

  @override
  Iterable<E> takeWhile(bool test(E value)) => _set.takeWhile(test);

  @override
  Iterable<E> skip(int n) => _set.skip(n);

  @override
  Iterable<E> skipWhile(bool test(E value)) => _set.skipWhile(test);

  @override
  E get first => _set.first;

  @override
  E get last => _set.last;

  @override
  E get single => _set.single;

  @override
  E firstWhere(bool test(E element), {E orElse()}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  E lastWhere(bool test(E element), {E orElse()}) =>
      _set.lastWhere(test, orElse: orElse);

  @override
  E singleWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) throw new UnimplementedError('singleWhere:orElse');
    return _set.singleWhere(test);
  }

  @override
  E elementAt(int index) => _set.elementAt(index);

  // Internal.

  BuiltSet._(this._setFactory, this._set) {
    if (E == dynamic) {
      throw new UnsupportedError(
          'explicit element type required, for example "new BuiltSet<int>"');
    }
  }
}

/// Default implementation of the public [BuiltSet] interface.
class _BuiltSet<E> extends BuiltSet<E> {
  _BuiltSet.withSafeSet(_SetFactory<E> setFactory, Set<E> set)
      : super._(setFactory, set);

  _BuiltSet.copyAndCheck(Iterable iterable) : super._(null, new Set<E>()) {
    for (final element in iterable) {
      if (element is E) {
        _set.add(element);
      } else {
        throw new ArgumentError('iterable contained invalid element: $element');
      }
    }
  }

  bool hasExactElementType(Type type) => E == type;
}
