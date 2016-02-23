// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test_helpers;

import '../list.dart';
import '../list_multimap.dart';
import '../map.dart';
import '../set.dart';
import '../set_multimap.dart';

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltList<int> overridenHashcodeBuiltList(
          Iterable iterable, int hashCode) =>
      new OverriddenHashcodeBuiltList<int>(iterable, hashCode);

  static BuiltListMultimap<int, String> overridenHashcodeBuiltListMultimap(
          map, int hashCode) =>
      new OverriddenHashcodeBuiltListMultimap<int, String>(map, hashCode);

  static BuiltListMultimap<String,
      String> overridenHashcodeBuiltListMultimapWithStringKeys(
          map, int hashCode) =>
      new OverriddenHashcodeBuiltListMultimap<String, String>(map, hashCode);

  static BuiltMap<int, String> overridenHashcodeBuiltMap(map, int hashCode) =>
      new OverriddenHashcodeBuiltMap<int, String>(map, hashCode);

  static BuiltMap<String, String> overridenHashcodeBuiltMapWithStringKeys(
          map, int hashCode) =>
      new OverriddenHashcodeBuiltMap<String, String>(map, hashCode);

  static BuiltSet<int> overridenHashcodeBuiltSet(
          Iterable iterable, int hashCode) =>
      new OverriddenHashcodeBuiltSet<int>(iterable, hashCode);

  static BuiltSetMultimap<int, String> overridenHashcodeBuiltSetMultimap(
          map, int hashCode) =>
      new OverriddenHashcodeBuiltSetMultimap<int, String>(map, hashCode);

  static BuiltSetMultimap<String,
      String> overridenHashcodeBuiltSetMultimapWithStringKeys(
          map, int hashCode) =>
      new OverriddenHashcodeBuiltSetMultimap<String, String>(map, hashCode);
}
