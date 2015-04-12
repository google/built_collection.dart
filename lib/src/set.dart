// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.set;

import 'package:quiver/core.dart' show hashObjects, hash2;
import 'internal/copy_on_write_set.dart';
import 'internal/unused_class.dart';

part 'set/built_set.dart';
part 'set/set_builder.dart';

class OverriddenHashcodeBuiltSet<T> extends BuiltSet<T> {
  final int _hashCode;

  OverriddenHashcodeBuiltSet(Iterable iterable, this._hashCode)
      : super._copyAndCheck(iterable);

  int get hashCode => _hashCode;
}
