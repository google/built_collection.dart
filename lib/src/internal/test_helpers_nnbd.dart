// Copyright (c) 2020, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import '../list.dart';

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltList<int> overridenHashcodeBuiltList(
          Iterable iterable, int hashCode) =>
      OverriddenHashcodeBuiltList<int>(iterable, hashCode);
}
