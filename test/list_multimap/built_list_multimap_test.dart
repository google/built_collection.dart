// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.list_multimap.built_list_multimap_test;

import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:quiver/collection.dart';
import 'package:test/test.dart';

import '../performance.dart';

void main() {
  group('BuiltListMultimap', () {
    test('instantiates empty by default', () {
      var multimap = new BuiltListMultimap<int, String>();
      expect(multimap.isEmpty, isTrue);
      expect(multimap.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltListMultimap<dynamic, dynamic>', () {
      expect(() => new BuiltListMultimap(), throwsA(anything));
    });

    test('throws on attempt to create BuiltListMultimap<String, dynamic>', () {
      expect(() => new BuiltListMultimap<String, dynamic>(), throwsA(anything));
    });

    test('throws on attempt to create BuiltListMultimap<dynamic, String>', () {
      expect(() => new BuiltListMultimap<dynamic, String>(), throwsA(anything));
    });

    test('allows BuiltListMultimap<Object, Object>', () {
      new BuiltListMultimap<Object, Object>();
    });

    test('can be instantiated from ListMultimap', () {
      new BuiltListMultimap<int, String>({});
    });

    test('reports non-emptiness', () {
      var map = new BuiltListMultimap<int, String>({
        1: ['1']
      });
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
    });

    test(
        'can be instantiated from ListMultimap '
        'then converted back to equal ListMultimap', () {
      var mutableMultimap = new ListMultimap<int, String>();
      mutableMultimap.add(1, '1');
      var multimap = new BuiltListMultimap<int, String>(mutableMultimap);
      expect(multimap.toMap(), mutableMultimap.asMap());
    });

    test('throws on wrong type key', () {
      expect(
          () => new BuiltListMultimap<int, String>({
                '1': ['1']
              }),
          throwsA(anything));
    });

    test('throws on wrong type value iterable', () {
      expect(
          () => new BuiltListMultimap<int, String>({1: 1}), throwsA(anything));
    });

    test('throws on wrong type value', () {
      expect(
          () => new BuiltListMultimap<int, String>({
                1: [1]
              }),
          throwsA(anything));
    });

    test('does not keep a mutable ListMultimap', () {
      var mutableMultimap = new ListMultimap<int, String>();
      mutableMultimap.add(1, '1');
      var multimap = new BuiltListMultimap<int, String>(mutableMultimap);
      mutableMultimap.clear();
      expect(multimap.toMap(), {
        1: ['1']
      });
    });

    test('copies from BuiltListMultimap instances of different type', () {
      var multimap1 = new BuiltListMultimap<Object, Object>();
      var multimap2 = new BuiltListMultimap<int, String>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test('can be converted to Map<K, BuiltList<V>>', () {
      expect(
          new BuiltListMultimap<int, String>().toMap()
              is Map<int, BuiltList<String>>,
          isTrue);
      expect(
          new BuiltListMultimap<int, String>().toMap()
              is Map<int, BuiltList<int>>,
          isFalse);
      expect(
          new BuiltListMultimap<int, String>().toMap()
              is Map<String, BuiltList<String>>,
          isFalse);
    });

    test('can be converted to an UnmodifiableMapView', () {
      var immutableMap = new BuiltListMultimap<int, String>().asMap();
      expect(immutableMap is Map<int, Iterable<String>>, isTrue);
      expect(() => immutableMap[1] = ['Hello'], throwsUnsupportedError);
      expect(immutableMap, isEmpty);
    });

    test('can be converted to ListMultimapBuilder<K, V>', () {
      expect(
          new BuiltListMultimap<int, String>().toBuilder()
              is ListMultimapBuilder<int, String>,
          isTrue);
      expect(
          new BuiltListMultimap<int, String>().toBuilder()
              is ListMultimapBuilder<int, int>,
          isFalse);
      expect(
          new BuiltListMultimap<int, String>().toBuilder()
              is ListMultimapBuilder<String, String>,
          isFalse);
    });

    test(
        'can be converted to ListMultimapBuilder<K, V> and back to ListMultimap<K, V>',
        () {
      expect(
          new BuiltListMultimap<int, String>().toBuilder().build()
              is BuiltListMultimap<int, String>,
          isTrue);
      expect(
          new BuiltListMultimap<int, String>().toBuilder().build()
              is BuiltListMultimap<int, int>,
          isFalse);
      expect(
          new BuiltListMultimap<int, String>().toBuilder().build()
              is BuiltListMultimap<String, String>,
          isFalse);
    });

    test('throws on null keys', () {
      expect(
          () => new BuiltListMultimap<int, String>({
                null: ['1']
              }),
          throwsA(anything));
    });

    test('throws on null value iterables', () {
      expect(() => new BuiltListMultimap<int, String>({1: null}),
          throwsA(anything));
    });

    test('throws on null values', () {
      expect(
          () => new BuiltListMultimap<int, String>({
                1: [null]
              }),
          throwsA(anything));
    });

    test('hashes to same value for same contents', () {
      var multimap1 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap1.hashCode, multimap2.hashCode);
    });

    test('hashes to different value for different keys', () {
      var multimap1 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        4: ['3']
      });

      expect(multimap1.hashCode, isNot(multimap2.hashCode));
    });

    test('hashes to different value for different values', () {
      var multimap1 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '3'],
        3: ['3']
      });

      expect(multimap1.hashCode, isNot(multimap2.hashCode));
    });

    test('caches hash', () {
      var multimap = new BuiltListMultimap<Object, Object>({
        1: [new _HashcodeOnlyOnce()]
      });

      multimap.hashCode;
      multimap.hashCode;
    });

    test('compares equal to same instance', () {
      var multimap = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap == multimap, isTrue);
    });

    test('compares equal to same contents', () {
      var multimap1 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      var multimap2 = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap1 == multimap2, isTrue);
    });

    test('compares not equal to different type', () {
      expect(
          // ignore: unrelated_type_equality_checks
          new BuiltListMultimap<int, String>({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }) ==
              '',
          isFalse);
    });

    test('compares not equal to different length BuiltListMultimap', () {
      expect(
          new BuiltListMultimap<int, String>({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }) ==
              new BuiltListMultimap<int, String>({
                1: ['1'],
                2: ['2']
              }),
          isFalse);
    });

    test('compares not equal to different hashcode BuiltListMultimap', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltListMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }, 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltListMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }, 1),
          isFalse);
    });

    test('compares not equal to different content BuiltListMultimap', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltListMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }, 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltListMultimap({
                1: ['1'],
                2: ['2'],
                3: ['3', '4']
              }, 0),
          isFalse);
    });

    test('compares without throwing for same hashcode different key type', () {
      expect(
          // ignore: unrelated_type_equality_checks
          BuiltCollectionTestHelpers.overridenHashcodeBuiltListMultimap({
                1: ['1']
              }, 0) ==
              BuiltCollectionTestHelpers
                  .overridenHashcodeBuiltListMultimapWithStringKeys({
                '1': ['1']
              }, 0),
          false);
    });

    test('provides toString() for debugging', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).toString(),
          '{1: [1], 2: [2], 3: [3]}');
    });

    test('preserves key order', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).keys,
          [1, 2, 3]);
      expect(
          new BuiltListMultimap<int, String>({
            3: ['3'],
            2: ['2'],
            1: ['1']
          }).keys,
          [3, 2, 1]);
    });

    // Lazy copies.

    test('reuses BuiltListMultimap instances of the same type', () {
      var multimap1 = new BuiltListMultimap<int, String>();
      var multimap2 = new BuiltListMultimap<int, String>(multimap1);
      expect(multimap1, same(multimap2));
    });

    test('does not reuse BuiltListMultimap instances with subtype key type',
        () {
      var multimap1 = new BuiltListMultimap<_ExtendsA, String>();
      var multimap2 = new BuiltListMultimap<_A, String>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test(
        'does not reuse BuiltListMultimultimap instances with subtype value type',
        () {
      var multimap1 = new BuiltListMultimap<String, _ExtendsA>();
      var multimap2 = new BuiltListMultimap<String, _A>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test('can be reused via ListMultimapBuilder if there are no changes', () {
      var multimap1 = new BuiltListMultimap<Object, Object>();
      var multimap2 = multimap1.toBuilder().build();
      expect(multimap1, same(multimap2));
    });

    test('converts to ListMultimapBuilder from correct type without copying',
        () {
      var makeLongListMultimap = () {
        var result = new ListMultimapBuilder<int, int>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longListMultimap = makeLongListMultimap();
      var longListMultimapToListMultimapBuilder = longListMultimap.toBuilder;

      expectMuchFaster(
          longListMultimapToListMultimapBuilder, makeLongListMultimap);
    });

    test('converts to ListMultimapBuilder from wrong type by copying', () {
      var makeLongListMultimap = () {
        var result = new ListMultimapBuilder<Object, Object>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longListMultimap = makeLongListMultimap();
      var longListMultimapToListMultimapBuilder =
          () => new ListMultimapBuilder<int, int>(longListMultimap);

      expectNotMuchFaster(
          longListMultimapToListMultimapBuilder, makeLongListMultimap);
    });

    test('has fast toMap', () {
      var makeLongListMultimap = () {
        var result = new ListMultimapBuilder<int, int>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longListMultimap = makeLongListMultimap();
      var longListMultimapToListMultimap = () => longListMultimap.toMap();

      expectMuchFaster(longListMultimapToListMultimap, makeLongListMultimap);
    });

    test('checks for reference identity', () {
      var makeLongListMultimap = () {
        var result = new ListMultimapBuilder<int, int>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      var longListMultimap = makeLongListMultimap();
      var otherLongListMultimap = makeLongListMultimap();

      expectMuchFaster(() => longListMultimap == longListMultimap,
          () => longListMultimap == otherLongListMultimap);
    });

    test('is not mutated when Map from toMap is mutated', () {
      var multimap = new BuiltListMultimap<int, String>();
      multimap.toMap()[1] = new BuiltList<String>(['1']);
      expect(multimap.isEmpty, isTrue);
    });

    test('has build constructor', () {
      expect(
          new BuiltListMultimap<int, String>.build((b) => b.add(0, '0'))
              .toMap(),
          {
            0: ['0']
          });
    });

    test('has rebuild method', () {
      expect(
          new BuiltListMultimap<int, String>({
            0: ['0']
          }).rebuild((b) => b.add(1, '1')).toMap(),
          {
            0: ['0'],
            1: ['1']
          });
    });

    // ListMultimap.

    test('does not implement ListMultimap', () {
      expect(new BuiltListMultimap<int, String>() is ListMultimap, isFalse);
    });

    test('has a method like ListMultimap[]', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          })[2],
          ['2']);
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          })[4],
          []);
    });

    test('returns stable empty BuiltLists', () {
      var multimap = new BuiltListMultimap<int, String>();
      expect(multimap[1], same(multimap[1]));
      expect(multimap[1], same(multimap[2]));
    });

    test('has a method like ListMultimap.length', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).length,
          3);
    });

    test('has a method like ListMultimap.containsKey', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsKey(3),
          isTrue);
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsKey(4),
          isFalse);
    });

    test('has a method like ListMultimap.containsValue', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsValue('3'),
          isTrue);
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsValue('4'),
          isFalse);
    });

    test('has a method like ListMultimap.forEach', () {
      var totalKeys = 0;
      var concatenatedValues = '';
      new BuiltListMultimap<int, String>({
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

    test('has a method like ListMultimap.forEachKey', () {
      var totalKeys = 0;
      var concatenatedValues = '';
      new BuiltListMultimap<int, String>({
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

    test('has a method like ListMultimap.keys', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).keys,
          [1, 2, 3]);
    });

    test('has a method like ListMultimap.values', () {
      expect(
          new BuiltListMultimap<int, String>({
            1: ['1'],
            2: ['2', '2'],
            3: ['3']
          }).values,
          ['1', '2', '2', '3']);
    });

    test('has stable keys', () {
      var multimap = new BuiltListMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3']
      });
      expect(multimap.keys, same(multimap.keys));
    });

    test('has stable values', () {
      var multimap = new BuiltListMultimap<int, String>({
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

class _HashcodeOnlyOnce {
  bool hashCodeAllowed = true;

  @override
  // ignore: hash_and_equals
  int get hashCode {
    expect(hashCodeAllowed, isTrue);
    hashCodeAllowed = false;
    return 0;
  }
}
