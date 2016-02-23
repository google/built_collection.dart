// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.all_tests;

import 'internal/copy_on_write_list_test.dart' as copy_on_write_list_test;
import 'internal/copy_on_write_map_test.dart' as copy_on_write_map_test;
import 'internal/copy_on_write_set_test.dart' as copy_on_write_set_test;
import 'list/built_list_test.dart' as built_list_test;
import 'list/list_builder_test.dart' as list_builder_test;
import 'list_multimap/built_list_multimap_test.dart'
    as built_list_multimap_test;
import 'list_multimap/list_multimap_builder_test.dart'
    as list_multimap_builder_test;
import 'map/built_map_test.dart' as built_map_test;
import 'map/map_builder_test.dart' as map_builder_test;
import 'set/built_set_test.dart' as built_set_test;
import 'set/set_builder_test.dart' as set_builder_test;
import 'set_multimap/built_set_multimap_test.dart' as built_set_multimap_test;
import 'set_multimap/set_multimap_builder_test.dart'
    as set_multimap_builder_test;

void main() {
  copy_on_write_list_test.main();
  copy_on_write_map_test.main();
  copy_on_write_set_test.main();

  built_list_test.main();
  list_builder_test.main();

  built_list_multimap_test.main();
  list_multimap_builder_test.main();

  built_map_test.main();
  map_builder_test.main();

  built_set_test.main();
  set_builder_test.main();

  built_set_multimap_test.main();
  set_multimap_builder_test.main();
}
