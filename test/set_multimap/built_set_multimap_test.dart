// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.set_multimap.built_set_multimap_test;

import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:quiver/collection.dart';
import 'package:unittest/unittest.dart';

void main() {
  group('BuiltSetMultimap', () {
    test('instantiates empty by default', () {
      final multimap = new BuiltSetMultimap<int, String>();
      expect(multimap.isEmpty, isTrue);
      expect(multimap.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltSetMultimap<dynamic, dynamic>', () {
      expect(() => new BuiltSetMultimap(), throws);
    });

    test('throws on attempt to create BuiltSetMultimap<String, dynamic>', () {
      expect(() => new BuiltSetMultimap<String, dynamic>(), throws);
    });

    test('throws on attempt to create BuiltSetMultimap<dynamic, String>', () {
      expect(() => new BuiltSetMultimap<dynamic, String>(), throws);
    });

    test('allows BuiltSetMultimap<Object, Object>', () {
      new BuiltSetMultimap<Object, Object>();
    });

    test('can be instantiated from SetMultimap', () {
      new BuiltSetMultimap<int, String>({});
    });

    test('reports non-emptiness', () {
      final map = new BuiltSetMultimap<int, String>({
        1: ['1']
      });
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
    });

    test(
        'can be instantiated from SetMultimap then converted back to equal SetMultimap',
        () {
      final mutableMultimap = new SetMultimap<int, String>();
      mutableMultimap.add(1, '1');
      final multimap = new BuiltSetMultimap<int, String>(mutableMultimap);
      expect(multimap.toMap(), mutableMultimap.toMap());
    });

    test('throws on wrong type key', () {
      expect(
          () => new BuiltSetMultimap<int, String>({
                '1': ['1']
              }),
          throws);
    });

    test('throws on wrong type value iterable', () {
      expect(() => new BuiltSetMultimap<int, String>({1: 1}), throws);
    });

    test('throws on wrong type value', () {
      expect(
          () => new BuiltSetMultimap<int, String>({
                1: [1]
              }),
          throws);
    });

    test('does not keep a mutable SetMultimap', () {
      final mutableMultimap = new SetMultimap<int, String>();
      mutableMultimap.add(1, '1');
      final multimap = new BuiltSetMultimap<int, String>(mutableMultimap);
      mutableMultimap.clear();
      expect(multimap.toMap(), {
        1: ['1']
      });
    });

    test('copies from BuiltSetMultimap instances of different type', () {
      final multimap1 = new BuiltSetMultimap<Object, Object>();
      final multimap2 = new BuiltSetMultimap<int, String>(multimap1);
      expect(multimap1, isNot(same(multimap2)));
    });

    test('can be converted to Map<K, BuiltSet<V>>', () {
      expect(
          new BuiltSetMultimap<int, String>().toMap()
          is Map<int, BuiltSet<String>>,
          isTrue);
      expect(
          new BuiltSetMultimap<int, String>().toMap()
          is Map<int, BuiltSet<int>>,
          isFalse);
      expect(
          new BuiltSetMultimap<int, String>().toMap()
          is Map<String, BuiltSet<String>>,
          isFalse);
    });

    test('can be converted to SetMultimapBuilder<K, V>', () {
      expect(
          new BuiltSetMultimap<int, String>().toBuilder()
          is SetMultimapBuilder<int, String>,
          isTrue);
      expect(
          new BuiltSetMultimap<int, String>().toBuilder()
          is SetMultimapBuilder<int, int>,
          isFalse);
      expect(
          new BuiltSetMultimap<int, String>().toBuilder()
          is SetMultimapBuilder<String, String>,
          isFalse);
    });

    test(
        'can be converted to SetMultimapBuilder<K, V> and back to SetMultimap<K, V>',
        () {
      expect(
          new BuiltSetMultimap<int, String>().toBuilder().build()
          is BuiltSetMultimap<int, String>,
          isTrue);
      expect(
          new BuiltSetMultimap<int, String>().toBuilder().build()
          is BuiltSetMultimap<int, int>,
          isFalse);
      expect(
          new BuiltSetMultimap<int, String>().toBuilder().build()
          is BuiltSetMultimap<String, String>,
          isFalse);
    });

    test('throws on null keys', () {
      expect(
          () => new BuiltSetMultimap<int, String>({
                null: ['1']
              }),
          throws);
    });

    test('throws on null value iterables', () {
      expect(() => new BuiltSetMultimap<int, String>({1: null}), throws);
    });

    test('throws on null values', () {
      expect(
          () => new BuiltSetMultimap<int, String>({
                1: [null]
              }),
          throws);
    });

    test('hashes to same value for same contents', () {
      final multimap1 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      final multimap2 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap1.hashCode, multimap2.hashCode);
    });

    test('hashes to different value for different keys', () {
      final multimap1 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      final multimap2 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        4: ['3']
      });

      expect(multimap1.hashCode, isNot(multimap2.hashCode));
    });

    test('hashes to different value for different values', () {
      final multimap1 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      final multimap2 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '3'],
        3: ['3']
      });

      expect(multimap1.hashCode, isNot(multimap2.hashCode));
    });

    test('caches hash', () {
      final multimap = new BuiltSetMultimap<Object, Object>({
        1: [new _HashcodeOnlyTwice()]
      });

      multimap.hashCode;
      multimap.hashCode;
    });

    test('compares equal to same contents', () {
      final multimap1 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });
      final multimap2 = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2', '2'],
        3: ['3']
      });

      expect(multimap1 == multimap2, isTrue);
    });

    test('compares not equal to different type', () {
      expect(
          new BuiltSetMultimap<int, String>({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }) ==
              '',
          isFalse);
    });

    test('compares not equal to different length BuiltSetMultimap', () {
      expect(
          new BuiltSetMultimap<int, String>({
                1: ['1'],
                2: ['2'],
                3: ['3']
              }) ==
              new BuiltSetMultimap<int, String>({
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
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).toString(),
          '{1: {1}, 2: {2}, 3: {3}}');
    });

    test('preserves key order', () {
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).keys,
          [1, 2, 3]);
      expect(
          new BuiltSetMultimap<int, String>({
            3: ['3'],
            2: ['2'],
            1: ['1']
          }).keys,
          [3, 2, 1]);
    });

    // Lazy copies.

    test('reuses BuiltSetMultimap instances of the same type', () {
      final multimap1 = new BuiltSetMultimap<int, String>();
      final multimap2 = new BuiltSetMultimap<int, String>(multimap1);
      expect(multimap1, same(multimap2));
    });

    test('can be reused via SetMultimapBuilder if there are no changes', () {
      final multimap1 = new BuiltSetMultimap<Object, Object>();
      final multimap2 = multimap1.toBuilder().build();
      expect(multimap1, same(multimap2));
    });

    test('converts to SetMultimapBuilder from correct type without copying',
        () {
      final makeLongSetMultimap = () {
        final result = new SetMultimapBuilder<int, int>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      final longSetMultimap = makeLongSetMultimap();
      final longSetMultimapToSetMultimapBuilder = longSetMultimap.toBuilder;

      expectMuchFaster(
          longSetMultimapToSetMultimapBuilder, makeLongSetMultimap);
    });

    test('converts to SetMultimapBuilder from wrong type by copying', () {
      final makeLongSetMultimap = () {
        final result = new SetMultimapBuilder<Object, Object>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      final longSetMultimap = makeLongSetMultimap();
      final longSetMultimapToSetMultimapBuilder = () =>
          new SetMultimapBuilder<int, int>(longSetMultimap);

      expectNotMuchFaster(
          longSetMultimapToSetMultimapBuilder, makeLongSetMultimap);
    });

    test('has fast toMap', () {
      final makeLongSetMultimap = () {
        final result = new SetMultimapBuilder<int, int>();
        for (int i = 0; i != 100000; ++i) {
          result.add(i, i);
        }
        return result.build();
      };
      final longSetMultimap = makeLongSetMultimap();
      final longSetMultimapToSetMultimap = () => longSetMultimap.toMap();

      expectMuchFaster(longSetMultimapToSetMultimap, makeLongSetMultimap);
    });

    test('is not mutated when Map from toMap is mutated', () {
      final multimap = new BuiltSetMultimap<int, String>();
      multimap.toMap()[1] = new BuiltSet<String>(['1']);
      expect(multimap.isEmpty, isTrue);
    });

    test('has build constructor', () {
      expect(
          new BuiltSetMultimap<int, String>.build((b) => b.add(0, '0')).toMap(),
          {
        0: ['0']
      });
    });

    test('has rebuild method', () {
      expect(
          new BuiltSetMultimap<int, String>({
            0: ['0']
          }).rebuild((b) => b.add(1, '1')).toMap(),
          {
        0: ['0'],
        1: ['1']
      });
    });

    // SetMultimap.

    test('does not implement SetMultimap', () {
      expect(new BuiltSetMultimap<int, String>() is SetMultimap, isFalse);
    });

    test('has a method like SetMultimap[]', () {
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          })[2],
          ['2']);
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          })[4],
          []);
    });

    test('returns stable empty BuiltSets', () {
      final multimap = new BuiltSetMultimap<int, String>();
      expect(multimap[1], same(multimap[1]));
      expect(multimap[1], same(multimap[2]));
    });

    test('has a method like SetMultimap.length', () {
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).length,
          3);
    });

    test('has a method like SetMultimap.containsKey', () {
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsKey(3),
          isTrue);
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsKey(4),
          isFalse);
    });

    test('has a method like SetMultimap.containsValue', () {
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsValue('3'),
          isTrue);
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).containsValue('4'),
          isFalse);
    });

    test('has a method like SetMultimap.forEach', () {
      var totalKeys = 0;
      var concatenatedValues = '';
      new BuiltSetMultimap<int, String>({
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
      new BuiltSetMultimap<int, String>({
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
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2'],
            3: ['3']
          }).keys,
          [1, 2, 3]);
    });

    test('has a method like SetMultimap.values', () {
      expect(
          new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2', '2'],
            3: ['3']
          }).values,
          ['1', '2', '3']);
    });

    test('has stable keys', () {
      final multimap = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3']
      });
      expect(multimap.keys, same(multimap.keys));
    });

    test('has stable values', () {
      final multimap = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2'],
        3: ['3']
      });
      expect(multimap.values, same(multimap.values));
    });
  });
}

void expectMuchFaster(Function fastFunction, Function slowFunction) {
  final fastStopWatch = new Stopwatch()..start();
  fastFunction();
  fastStopWatch.stop();

  final slowStopWatch = new Stopwatch()..start();
  slowFunction();
  slowStopWatch.stop();

  if (fastStopWatch.elapsedMicroseconds * 10 >
      slowStopWatch.elapsedMicroseconds) {
    throw 'Expected first function to be at least 10x faster than second!'
        ' Measured: first=${fastStopWatch.elapsedMicroseconds}'
        ' second=${slowStopWatch.elapsedMicroseconds}';
  }
}

void expectNotMuchFaster(Function notFastFunction, Function slowFunction) {
  final fastStopWatch = new Stopwatch()..start();
  notFastFunction();
  fastStopWatch.stop();

  final slowStopWatch = new Stopwatch()..start();
  slowFunction();
  slowStopWatch.stop();

  if (fastStopWatch.elapsedMicroseconds * 10 <
      slowStopWatch.elapsedMicroseconds) {
    throw 'Expected first function to be less than 10x faster than second!'
        ' Measured: first=${fastStopWatch.elapsedMicroseconds}'
        ' second=${slowStopWatch.elapsedMicroseconds}';
  }
}

class _HashcodeOnlyTwice {
  int hashCodeAllowed = 2;

  int get hashCode {
    expect(hashCodeAllowed, isNot(0));
    hashCodeAllowed--;
    return 0;
  }
}
