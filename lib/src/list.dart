// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.list;

import 'dart:math' show Random;

import 'package:quiver/core.dart' show hashObjects, hash2;

import 'internal/copy_on_write_list.dart';
import 'internal/unused_class.dart';

part 'list/built_list.dart';
part 'list/list_builder.dart';

class OverriddenHashcodeBuiltList<T> extends BuiltList<T> {
  final int _hashCode;

  OverriddenHashcodeBuiltList(Iterable iterable, this._hashCode)
      : super._copyAndCheck(iterable);

  int get hashCode => _hashCode;
}
