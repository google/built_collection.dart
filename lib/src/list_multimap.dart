// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.list_multimap;

import 'package:quiver/collection.dart' show ListMultimap;
import 'package:quiver/core.dart' show hashObjects, hash2;

import 'internal/copy_on_write_map.dart';

import 'list.dart';

part 'list_multimap/built_list_multimap.dart';
part 'list_multimap/list_multimap_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltListMultimap<K, V>
    extends _BuiltListMultimap<K, V> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltListMultimap(map, this._overridenHashCode)
      : super.copyAndCheck(map.keys, (k) => map[k]);

  @override
  // ignore: hash_and_equals
  int get hashCode => _overridenHashCode;
}
