// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test_helpers;

import '../list.dart';
import '../map.dart';
import '../set.dart';

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltMap<int, String> overridenHashcodeBuiltMap(map, int hashCode) =>
      new OverriddenHashcodeBuiltMap<int, String>(map, hashCode);

  static BuiltList<int> overridenHashcodeBuiltList(
          Iterable iterable, int hashCode) =>
      new OverriddenHashcodeBuiltList<int>(iterable, hashCode);

  static BuiltSet<int> overridenHashcodeBuiltSet(
          Iterable iterable, int hashCode) =>
      new OverriddenHashcodeBuiltSet<int>(iterable, hashCode);
}
