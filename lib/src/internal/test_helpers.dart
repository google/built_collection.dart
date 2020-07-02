// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import '../set_multimap.dart';

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltSetMultimap<int, String> overridenHashcodeBuiltSetMultimap(
          Object map, int hashCode) =>
      OverriddenHashcodeBuiltSetMultimap<int, String>(map, hashCode);

  static BuiltSetMultimap<String, String>
      overridenHashcodeBuiltSetMultimapWithStringKeys(
              Object map, int hashCode) =>
          OverriddenHashcodeBuiltSetMultimap<String, String>(map, hashCode);
}
