// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.set_multimap;

import 'package:quiver/collection.dart' show SetMultimap;
import 'package:quiver/core.dart' show hashObjects, hash2;

import 'internal/copy_on_write_map.dart';

import 'set.dart';

part 'set_multimap/built_set_multimap.dart';
part 'set_multimap/set_multimap_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltSetMultimap<K, V> extends _BuiltSetMultimap<K, V> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltSetMultimap(map, this._overridenHashCode)
      : super.copyAndCheck(map.keys, (k) => map[k]);

  @override
  // ignore: hash_and_equals
  int get hashCode => _overridenHashCode;
}
