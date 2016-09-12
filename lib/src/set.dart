// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.set;

import 'package:built_collection/src/list.dart' show BuiltList;
import 'package:quiver/core.dart' show hashObjects;

import 'internal/copy_on_write_set.dart';

part 'set/built_set.dart';
part 'set/set_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltSet<T> extends BuiltSet<T> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltSet(Iterable iterable, this._overridenHashCode)
      : super._copyAndCheck(iterable);

  int get hashCode => _overridenHashCode;
}
