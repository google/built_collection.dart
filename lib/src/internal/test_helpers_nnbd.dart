// Copyright (c) 2020, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import '../list.dart';
import '../map.dart';
import '../set.dart';

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltList<int> overridenHashcodeBuiltList(
          Iterable iterable, int hashCode) =>
      OverriddenHashcodeBuiltList<int>(iterable, hashCode);

  static BuiltMap<int, String> overridenHashcodeBuiltMap(
          Object map, int hashCode) =>
      OverriddenHashcodeBuiltMap<int, String>(map, hashCode);

  static BuiltMap<String, String> overridenHashcodeBuiltMapWithStringKeys(
          Object map, int hashCode) =>
      OverriddenHashcodeBuiltMap<String, String>(map, hashCode);

  static BuiltSet<int> overridenHashcodeBuiltSet(
          Iterable iterable, int hashCode) =>
      OverriddenHashcodeBuiltSet<int>(iterable, hashCode);
}
