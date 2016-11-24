// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' show Random;

import 'package:built_collection/src/set.dart' show BuiltSet;
import 'package:quiver/core.dart' show hashObjects;

import 'internal/copy_on_write_list.dart';

part 'list/built_list.dart';
part 'list/list_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltList<T> extends BuiltList<T> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltList(Iterable iterable, this._overridenHashCode)
      : super._copyAndCheck(iterable);

  int get hashCode => _overridenHashCode;
}
