// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.map.map_builder_test;

import 'package:built_collection/built_collection.dart';
import 'package:unittest/unittest.dart';

void main() {
  group('MapBuilder', () {
    test('throws on attempt to create MapBuilder<dynamic, dynamic>', () {
      expect(() => new MapBuilder(), throws);
    });

    test('throws on attempt to create MapBuilder<String, dynamic>', () {
      expect(() => new MapBuilder<String, dynamic>(), throws);
    });

    test('throws on attempt to create MapBuilder<dynamic, String>', () {
      expect(() => new MapBuilder<dynamic, String>(), throws);
    });

    test('allows MapBuilder<Object, Object>', () {
      new MapBuilder<Object, Object>();
    });

    test('throws on null key put', () {
      expect(() => new MapBuilder<int, String>()[null] = '0', throws);
    });

    test('throws on null value put', () {
      expect(() => new MapBuilder<int, String>()[0] = null, throws);
    });

    test('throws on null key putIfAbsent', () {
      expect(() => new MapBuilder<int, String>().putIfAbsent(null, () => '0'),
          throws);
    });

    test('throws on null value putIfAbsent', () {
      expect(() => new MapBuilder<int, String>().putIfAbsent(0, () => null),
          throws);
    });

    test('throws on null key addAll', () {
      expect(() => new MapBuilder<int, String>().addAll({null: '0'}), throws);
    });

    test('throws on null value addAll', () {
      expect(() => new MapBuilder<int, String>().addAll({0: null}), throws);
    });

    test('throws on wrong type key put', () {
      expect(() => new MapBuilder<int, String>()['0'] = '0', throws);
    });

    test('throws on wrong type value put', () {
      expect(() => new MapBuilder<int, String>()[0] = 0, throws);
    });

    test('throws on wrong type key putIfAbsent', () {
      expect(() => new MapBuilder<int, String>().putIfAbsent('0', () => '0'),
          throws);
    });

    test('throws on wrong type value putIfAbsent', () {
      expect(
          () => new MapBuilder<int, String>().putIfAbsent(0, () => 0), throws);
    });

    test('throws on wrong type key addAll', () {
      expect(() => new MapBuilder<int, String>().addAll({'0': '0'}), throws);
    });

    test('throws on wrong type value addAll', () {
      expect(() => new MapBuilder<int, String>().addAll({0: 0}), throws);
    });

    // Lazy copies.

    test('does not mutate BuiltMap following reuse of underlying Map', () {
      final map = new BuiltMap<int, String>({1: '1', 2: '2'});
      final mapBuilder = map.toBuilder();
      mapBuilder[3] = '3';
      expect(map.toMap(), {1: '1', 2: '2'});
    });

    test('converts to BuiltMap without copying', () {
      final makeLongMapBuilder = () => new MapBuilder<int, int>(
          new Map<int, int>.fromIterable(
              new List<int>.generate(100000, (x) => x)));
      final longMapBuilder = makeLongMapBuilder();
      final buildLongMapBuilder = () => longMapBuilder.build();

      expectMuchFaster(buildLongMapBuilder, makeLongMapBuilder);
    });

    test('does not mutate BuiltMap following mutates after build', () {
      final mapBuilder = new MapBuilder<int, String>({1: '1', 2: '2'});

      final map1 = mapBuilder.build();
      expect(map1.toMap(), {1: '1', 2: '2'});

      mapBuilder[3] = '3';
      expect(map1.toMap(), {1: '1', 2: '2'});
    });

    // Map.

    test('has a method like Map[]=', () {
      expect((new MapBuilder<int, String>({1: '1'})..[2] = '2').build().toMap(),
          {1: '1', 2: '2'});
    });

    test('has a method like Map.putIfAbsent that returns nothing', () {
      expect((new MapBuilder<int, String>({1: '1'})
        ..putIfAbsent(2, () => '2')
        ..putIfAbsent(1, () => '3')).build().toMap(), {1: '1', 2: '2'});
    });

    test('has a method like Map.addAll', () {
      expect((new MapBuilder<int, String>()..addAll({1: '1', 2: '2'}))
          .build()
          .toMap(), {1: '1', 2: '2'});
    });

    test('has a method like Map.remove that returns nothing', () {
      expect((new MapBuilder<int, String>({1: '1', 2: '2'})..remove(2))
          .build()
          .toMap(), {1: '1'});
    });

    test('has a method like Map.clear', () {
      expect((new MapBuilder<int, String>({1: '1', 2: '2'})..clear())
          .build()
          .toMap(), {});
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
