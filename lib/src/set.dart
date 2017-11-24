// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.set;

import 'package:built_collection/src/iterable.dart' show BuiltIterable;
import 'package:built_collection/src/list.dart' show BuiltList;
import 'package:collection/collection.dart' show UnmodifiableSetView;
import 'package:quiver/core.dart' show hashObjects;

import 'internal/copy_on_write_set.dart';

part 'set/built_set.dart';
part 'set/set_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltSet<T> extends _BuiltSet<T> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltSet(Iterable iterable, this._overridenHashCode)
      : super.copyAndCheck(iterable);

  @override
  // ignore: hash_and_equals
  int get hashCode => _overridenHashCode;
}
