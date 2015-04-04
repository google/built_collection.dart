// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection;

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltMap<int, String> overridenHashcodeBuiltMap(map, int hashCode) =>
      new _OverriddenHashcodeBuiltMap<int, String>(map, hashCode);

  static BuiltList<int> overridenHashcodeBuiltList(
          Iterable iterable, int hashCode) =>
      new _OverriddenHashcodeBuiltList<int>(iterable, hashCode);

  static BuiltSet<int> overridenHashcodeBuiltSet(
          Iterable iterable, int hashCode) =>
      new _OverriddenHashcodeBuiltSet<int>(iterable, hashCode);
}

class _OverriddenHashcodeBuiltMap<K, V> extends BuiltMap<K, V> {
  final int _hashCode;

  _OverriddenHashcodeBuiltMap(map, this._hashCode)
      : super._copyAndCheck(map.keys, (k) => map[k]);

  int get hashCode => _hashCode;
}

class _OverriddenHashcodeBuiltList<T> extends BuiltList<T> {
  final int _hashCode;

  _OverriddenHashcodeBuiltList(Iterable iterable, this._hashCode)
      : super._copyAndCheck(iterable);

  int get hashCode => _hashCode;
}

class _OverriddenHashcodeBuiltSet<T> extends BuiltSet<T> {
  final int _hashCode;

  _OverriddenHashcodeBuiltSet(Iterable iterable, this._hashCode)
      : super._copyAndCheck(iterable);

  int get hashCode => _hashCode;
}
