// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.list;

import 'dart:math' show Random;

import 'package:built_collection/src/iterable.dart' show BuiltIterable;
import 'package:built_collection/src/set.dart' show BuiltSet;
import 'package:quiver/core.dart' show hashObjects;

import 'internal/copy_on_write_list.dart';

part 'list/built_list.dart';
part 'list/list_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltList<T> extends _BuiltList<T> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltList(Iterable iterable, this._overridenHashCode)
      : super.copyAndCheck(iterable);

  @override
  // ignore: hash_and_equals
  int get hashCode => _overridenHashCode;
}
