// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.set_multimap.built_set_multimap_test;

import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:quiver/collection.dart';
import 'package:test/test.dart';

import '../performance.dart';

void main() {
  group('BuiltSetMultimap', () {
    test('instantiates empty by default', () {
      var multimap = BuiltSetMultimap<int, String>();
      expect(multimap.isEmpty, isTrue);
      expect(multimap.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltSetMultimap<dynamic, dynamic>', () {
      expect(() => BuiltSetMultimap(), throwsA(anything));
    });

    test('throws on attempt to create BuiltSetMultimap<String, dynamic>', () {
      expect(() => BuiltSetMultimap<String, dynamic>(), throwsA(anything));
    });

    test('throws on attempt to create BuiltSetMultimap<dynamic, String>', () {
      expect(() => BuiltSetMultimap<dynamic, String>(), throwsA(anything));
    });

    test('allows BuiltSetMultimap<Object, Object>', () {
      BuiltSetMultimap<Object, Object>();
    });

    test('can be instantiated from SetMultimap', () {
      BuiltSetMultimap<int, String>({});
    });

    test('reports non-emptiness', () {
      var map = BuiltSetMultimap<int, String>({
        1: ['1']
      });
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
    });

    test(
        'can be instantiated from SetMultimap '
        'then converted back to equal SetMultimap', () {
      var mutableMultimap = SetMultimap<int, String>();
      mutableMultimap.add(1, '1');
      var multimap = BuiltSetMultimap<int, String>(mutableMultimap);
      expect(multimap.toMap(), mutableMultimap.asMap());
    });

    test('throws on wrong type key', () {
      expect(
          () => BuiltSetMultimap<int, String>({
                '1': ['1']
              }),
          throwsA(anything));
    });

    test('throws on wrong type value iterable', () {
      expect(() => BuiltSetMultimap<int, String>({1: 1}), throwsA(anything));
    });

    test('throws on wrong type value', () {
      expect(
          () => BuiltSetMultimap<int, String>({
                1: [1]
              }),
          throwsA(anything));
    });

    test('does not keep a mutable SetMultimap', () {
      var mutableMultimap = SetMultimap<int, String>();
      mutableMultimap.add(1, '1');
      var multimap = BuiltSetMultimap<int, String>(mutableMultimap);
      mutableMultimap.clear();
      expect(multimap.toMap(), {
        1: ['1']
      });
    });

    test('copies from BuiltSetMultimap instances of different type', () {
      var multimap1 = BuiltSetMultimap<Object, Object>();
      var multimap2 = BuiltSetMultimap<int, String>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test('can be converted to Map<K, BuiltSet<V>>', () {
      expect(
          BuiltSetMultimap<int, String>().toMap() is Map<int, BuiltSet<String>>,
          isTrue);
      expect(BuiltSetMultimap<int, String>().toMap() is Map<int, BuiltSet<int>>,
          isFalse);
      expect(
          BuiltSetMultimap<int, String>().toMap()
              is Map<String, BuiltSet<String>>,
          isFalse);
    });

    test('can be converted to an UnmodifiableMapView', () {
      var immutableMap = BuiltSetMultimap<int, String>().asMap();
      expect(immutableMap is Map<int, Iterable<String>>, isTrue);
      expect(() => immutableMap[1] = ['Hello'], throwsUnsupportedError);
      expect(immutableMap, isEmpty);
    });

    test('can be converted to SetMultimapBuilder<K, V>', () {
      expect(
          BuiltSetMultimap<int, String>().toBuilder()
              is SetMultimapBuilder<int, String>,
          isTrue);
      expect(
          BuiltSetMultimap<int, String>().toBuilder()
              is SetMultimapBuilder<int, int>,
          isFalse);
      expect(
          BuiltSetMultimap<int, String>().toBuilder()
              is SetMultimapBuilder<String, String>,
          isFalse);
    });

    test(
        'can be converted to SetMultimapBuilder<K, V> and back to SetMultimap<K, V>',
        () {
      expect(
          BuiltSetMultimap<int, String>().toBuilder().build()
              is BuiltSetMultimap<int, String>,
          isTrue);
      expect(
          BuiltSetMultimap<int, String>().toBuilder().build()
              is BuiltSetMultimap<int, int>,
          isFalse);
      expect(
          BuiltSetMultimap<int, String>().toBuilder().build()
              is BuiltSetMultimap<String, String>,
          isFalse);
    });

    test('throws on null keys', () {
      expect(
          () => BuiltSetMultimap<int, String>({
                null: ['1']
              }),
          throwsA(anything));
    });

    test('throws on null value iterables', () {
      expect(() => BuiltSetMultimap<int, String>({1: null}), throwsA(anything));
    });

    test('throws on null values', () {
      expect(
          () => BuiltSetMultimap<int, String>({
                1: [null]
              }),
          throwsA(anything));
    });

    test('hashes to same value for same contents', () {
      var multimap1 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap1.hashCode, multimap2.hashCode);
    });

    test('hashes to different value for different keys', () {
      var multimap1 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        4: ['3']
      });

      expect(multimap1.hashCode, isNot(multimap2.hashCode));
    });

    test('hashes to different value for different values', () {
      var multimap1 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '3'],
        3: ['3']
      });

      expect(multimap1.hashCode, isNot(multimap2.hashCode));
    });

    test('caches hash', () {
      var multimap = BuiltSetMultimap<Object, Object>({
        1: [_HashcodeOnlyTwice()]
      });

      multimap.hashCode;
      multimap.hashCode;
    });

    test('compares equal to same instance', () {
      var multimap = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap == multimap, isTrue);
    });

    test('compares equal to same contents', () {
      var multimap1 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap1 == multimap2, isTrue);
    });

    test('compares not equal to different type', () {
      expect(
          // ignore: unrelated_type_equality_checks
          BuiltSetMultimap<int, String>({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }) ==
              '',
          isFalse);
    });

    test('compares not equal to different length BuiltSetMultimap', () {
      expect(
          BuiltSetMultimap<int, String>({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }) ==
              BuiltSetMultimap<int, String>({
                1: ['1'],
                2: ['2']
              }),
          isFalse);
    });

    test('compares not equal to different hashcode BuiltSetMultimap', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltSetMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }, 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltSetMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }, 1),
          isFalse);
    });

    test('compares not equal to different content BuiltSetMultimap', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltSetMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }, 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltSetMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3', '4']
              }, 0),
          isFalse);
    });

    test('compares without throwing for same hashcode different key type', () {
      expect(
          // ignore: unrelated_type_equality_checks
          BuiltCollectionTestHelpers.overridenHashcodeBuiltSetMultimap({
                1: ['1']
              }, 0) ==
              BuiltCollectionTestHelpers
                  .overridenHashcodeBuiltSetMultimapWithStringKeys({
                '1': ['1']
              }, 0),
          false);
    });

    test('provides toString() for debugging', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).toString(),
          '{1: {1}, 2: {2}, 3: {3}}');
    });

    test('preserves key order', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).keys,
          [1, 2, 3]);
      expect(
          BuiltSetMultimap<int, String>({
            3: ['3'],
            2: ['2'],
            1: ['1']
          }).keys,
          [3, 2, 1]);
    });

    // Lazy copies.

    test('reuses BuiltSetMultimap instances of the same type', () {
      var multimap1 = BuiltSetMultimap<int, String>();
      var multimap2 = BuiltSetMultimap<int, String>(multimap1);
      expect(multimap1, same(multimap2));
    });

    test('does not reuse BuiltSetMultimap instances with subtype key type', () {
      var multimap1 = BuiltSetMultimap<_ExtendsA, String>();
      var multimap2 = BuiltSetMultimap<_A, String>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test(
        'does not reuse BuiltSetMultimultimap instances with subtype value type',
        () {
      var multimap1 = BuiltSetMultimap<String, _ExtendsA>();
      var multimap2 = BuiltSetMultimap<String, _A>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test('can be reused via SetMultimapBuilder if there are no changes', () {
      var multimap1 = BuiltSetMultimap<Object, Object>();
      var multimap2 = multimap1.toBuilder().build();
      expect(multimap1, same(multimap2));
    });

    test('converts to SetMultimapBuilder from correct type without copying',
        () {
      var makeLongSetMultimap = () {
        var result = SetMultimapBuilder<int, int>();
        for (var i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longSetMultimap = makeLongSetMultimap();
      var longSetMultimapToSetMultimapBuilder = longSetMultimap.toBuilder;

      expectMuchFaster(
          longSetMultimapToSetMultimapBuilder, makeLongSetMultimap);
    });

    test('converts to SetMultimapBuilder from wrong type by copying', () {
      var makeLongSetMultimap = () {
        var result = SetMultimapBuilder<Object, Object>();
        for (var i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longSetMultimap = makeLongSetMultimap();
      var longSetMultimapToSetMultimapBuilder =
          () => SetMultimapBuilder<int, int>(longSetMultimap);

      expectNotMuchFaster(
          longSetMultimapToSetMultimapBuilder, makeLongSetMultimap);
    });

    test('has fast toMap', () {
      var makeLongSetMultimap = () {
        var result = SetMultimapBuilder<int, int>();
        for (var i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longSetMultimap = makeLongSetMultimap();
      var longSetMultimapToSetMultimap = () => longSetMultimap.toMap();

      expectMuchFaster(longSetMultimapToSetMultimap, makeLongSetMultimap);
    });

    test('checks for reference identity', () {
      var makeLongSetMultimap = () {
        var result = SetMultimapBuilder<int, int>();
        for (var i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longSetMultimap = makeLongSetMultimap();
      var otherLongSetMultimap = makeLongSetMultimap();

      expectMuchFaster(() => longSetMultimap == longSetMultimap,
          () => longSetMultimap == otherLongSetMultimap);
    });

    test('is not mutated when Map from toMap is mutated', () {
      var multimap = BuiltSetMultimap<int, String>();
      multimap.toMap()[1] = BuiltSet<String>(['1']);
      expect(multimap.isEmpty, isTrue);
    });

    test('has build constructor', () {
      expect(
          BuiltSetMultimap<int, String>.build((b) => b.add(0, '0')).toMap(), {
        0: ['0']
      });
    });

    test('has rebuild method', () {
      expect(
          BuiltSetMultimap<int, String>({
            0: ['0']
          }).rebuild((b) => b.add(1, '1')).toMap(),
          {
            0: ['0'],
            1: ['1']
          });
    });

    // SetMultimap.

    test('does not implement SetMultimap', () {
      expect(BuiltSetMultimap<int, String>() is SetMultimap, isFalse);
    });

    test('has a method like SetMultimap[]', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          })[2],
          ['2']);
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          })[4],
          []);
    });

    test('returns stable empty BuiltSets', () {
      var multimap = BuiltSetMultimap<int, String>();
      expect(multimap[1], same(multimap[1]));
      expect(multimap[1], same(multimap[2]));
    });

    test('has a method like SetMultimap.length', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).length,
          3);
    });

    test('has a method like SetMultimap.containsKey', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsKey(3),
          isTrue);
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsKey(4),
          isFalse);
    });

    test('has a method like SetMultimap.containsValue', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsValue('3'),
          isTrue);
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsValue('4'),
          isFalse);
    });

    test('has a method like SetMultimap.forEach', () {
      var totalKeys = 0;
      var concatenatedValues = '';
      BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3', '4']
      }).forEach((key, value) {
        totalKeys += key;
        concatenatedValues += value;
      });

      expect(totalKeys, 9);
      expect(concatenatedValues, '1234');
    });

    test('has a method like SetMultimap.forEachKey', () {
      var totalKeys = 0;
      var concatenatedValues = '';
      BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3', '4']
      }).forEachKey((key, values) {
        totalKeys += key;
        concatenatedValues += values.reduce((x, y) => x + y);
      });

      expect(totalKeys, 6);
      expect(concatenatedValues, '1234');
    });

    test('has a method like SetMultimap.keys', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).keys,
          [1, 2, 3]);
    });

    test('has a method like SetMultimap.values', () {
      expect(
          BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2', '2'],
            3: ['3']
          }).values,
          ['1', '2', '3']);
    });

    test('has stable keys', () {
      var multimap = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3']
      });
      expect(multimap.keys, same(multimap.keys));
    });

    test('has stable values', () {
      var multimap = BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3']
      });
      expect(multimap.values, same(multimap.values));
    });
  });
}

class _A {}

class _ExtendsA extends _A {}

class _HashcodeOnlyTwice {
  int hashCodeAllowed = 2;

  @override
  // ignore: hash_and_equals
  int get hashCode {
    expect(hashCodeAllowed, isNot(0));
    hashCodeAllowed--;
    return 0;
  }
}
