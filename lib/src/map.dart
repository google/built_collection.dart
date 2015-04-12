// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.map;

import 'package:quiver/core.dart' show hashObjects, hash2;

import 'internal/copy_on_write_map.dart';
import 'internal/unused_class.dart';

part 'map/built_map.dart';
part 'map/map_builder.dart';

class OverriddenHashcodeBuiltMap<K, V> extends BuiltMap<K, V> {
  final int _hashCode;

  OverriddenHashcodeBuiltMap(map, this._hashCode)
      : super._copyAndCheck(map.keys, (k) => map[k]);

  int get hashCode => _hashCode;
}
