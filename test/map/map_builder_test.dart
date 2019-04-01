// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.map.map_builder_test;

import 'dart:collection' show SplayTreeMap;
import 'package:built_collection/built_collection.dart';
import 'package:test/test.dart';

import '../performance.dart';

void main() {
  group('MapBuilder', () {
    test('throws on attempt to create MapBuilder<dynamic, dynamic>', () {
      expect(() => new MapBuilder(), throwsA(anything));
    });

    test('throws on attempt to create MapBuilder<String, dynamic>', () {
      expect(() => new MapBuilder<String, dynamic>(), throwsA(anything));
    });

    test('throws on attempt to create MapBuilder<dynamic, String>', () {
      expect(() => new MapBuilder<dynamic, String>(), throwsA(anything));
    });

    test('allows MapBuilder<Object, Object>', () {
      new MapBuilder<Object, Object>();
    });

    test('throws on null key put', () {
      expect(
          () => new MapBuilder<int, String>()[null] = '0', throwsA(anything));
    });

    test('throws on null value put', () {
      expect(() => new MapBuilder<int, String>()[0] = null, throwsA(anything));
    });

    test('throws on null key putIfAbsent', () {
      expect(() => new MapBuilder<int, String>().putIfAbsent(null, () => '0'),
          throwsA(anything));
    });

    test('throws on null value putIfAbsent', () {
      expect(() => new MapBuilder<int, String>().putIfAbsent(0, () => null),
          throwsA(anything));
    });

    test('throws on null key addAll', () {
      expect(() => new MapBuilder<int, String>().addAll({null: '0'}),
          throwsA(anything));
    });

    test('throws on null value addAll', () {
      expect(() => new MapBuilder<int, String>().addAll({0: null}),
          throwsA(anything));
    });

    test('throws on null withBase', () {
      var builder = new MapBuilder<int, String>({2: '2', 0: '0', 1: '1'});
      expect(() => builder.withBase(null), throwsA(anything));
      expect(builder.build().keys, orderedEquals([2, 0, 1]));
    });

    test('has replace method that replaces all data', () {
      expect(
          (new MapBuilder<int, String>()..replace({1: '1', 2: '2'}))
              .build()
              .toMap(),
          {1: '1', 2: '2'});
    });

    test('has replace method that casts the supplied map', () {
      expect(
          (new MapBuilder<int, String>()
                ..replace(<num, Object>{1: '1', 2: '2'}))
              .build()
              .toMap(),
          {1: '1', 2: '2'});
    });

    test('has addIterable method like Map.fromIterable', () {
      expect(
          (new MapBuilder<int, int>()..addIterable([1, 2, 3])).build().toMap(),
          {1: 1, 2: 2, 3: 3});
      expect(
          (new MapBuilder<int, int>()
                ..addIterable([1, 2, 3], key: (element) => element + 1))
              .build()
              .toMap(),
          {2: 1, 3: 2, 4: 3});
      expect(
          (new MapBuilder<int, int>()
                ..addIterable([1, 2, 3], value: (element) => element + 1))
              .build()
              .toMap(),
          {1: 2, 2: 3, 3: 4});
    });

    test('has addEntries method like Map.addEntries', () {
      expect(
          (new MapBuilder<int, int>()
                ..addEntries([
                  new MapEntry(1, 1),
                  new MapEntry(2, 2),
                  new MapEntry(3, 3),
                ]))
              .build()
              .toMap(),
          {1: 1, 2: 2, 3: 3});
    });

    test('reuses BuiltMap passed to replace if it has the same base', () {
      var treeMapBase = () => new SplayTreeMap<int, String>();
      var map = new BuiltMap<int, String>.build((b) => b
        ..withBase(treeMapBase)
        ..addAll({1: '1', 2: '2'}));
      var builder = new MapBuilder<int, String>()
        ..withBase(treeMapBase)
        ..replace(map);
      expect(builder.build(), same(map));
    });

    test("doesn't reuse BuiltMap passed to replace if it has a different base",
        () {
      var map = new BuiltMap<int, String>.build((b) => b
        ..withBase(() => new SplayTreeMap<int, String>())
        ..addAll({1: '1', 2: '2'}));
      var builder = new MapBuilder<int, String>()..replace(map);
      expect(builder.build(), isNot(same(map)));
    });

    test('has withBase method that changes the underlying map type', () {
      var builder = new MapBuilder<int, String>({2: '2', 0: '0', 1: '1'});
      builder.withBase(() => new SplayTreeMap<int, String>());
      expect(builder.build().keys, orderedEquals([0, 1, 2]));
    });

    test('has withDefaultBase method that resets the underlying map type', () {
      var builder = new MapBuilder<int, String>()
        ..withBase(() => new SplayTreeMap<int, String>())
        ..withDefaultBase()
        ..addAll({2: '2', 0: '0', 1: '1'});
      expect(builder.build().keys, orderedEquals([2, 0, 1]));
    });

    // Lazy copies.

    test('does not mutate BuiltMap following reuse of underlying Map', () {
      var map = new BuiltMap<int, String>({1: '1', 2: '2'});
      var mapBuilder = map.toBuilder();
      mapBuilder[3] = '3';
      expect(map.toMap(), {1: '1', 2: '2'});
    });

    test('converts to BuiltMap without copying', () {
      var makeLongMapBuilder = () => new MapBuilder<int, int>(
          new Map<int, int>.fromIterable(
              new List<int>.generate(100000, (x) => x)));
      var longMapBuilder = makeLongMapBuilder();
      var buildLongMapBuilder = () => longMapBuilder.build();

      expectMuchFaster(buildLongMapBuilder, makeLongMapBuilder);
    });

    test('does not mutate BuiltMap following mutates after build', () {
      var mapBuilder = new MapBuilder<int, String>({1: '1', 2: '2'});

      var map1 = mapBuilder.build();
      expect(map1.toMap(), {1: '1', 2: '2'});

      mapBuilder[3] = '3';
      expect(map1.toMap(), {1: '1', 2: '2'});
    });

    // Map.

    test('has a method like Map[]', () {
      var mapBuilder = new MapBuilder<int, String>({1: '1', 2: '2'});
      mapBuilder[1] += '*';
      mapBuilder[2] += '**';
      expect(mapBuilder.build().asMap(), {1: '1*', 2: '2**'});
    });

    test('has a method like Map[]=', () {
      expect((new MapBuilder<int, String>({1: '1'})..[2] = '2').build().toMap(),
          {1: '1', 2: '2'});
      expect(
          (new BuiltMap<int, String>({1: '1'}).toBuilder()..[2] = '2')
              .build()
              .toMap(),
          {1: '1', 2: '2'});
    });

    test('has a method like Map.length', () {
      expect(new MapBuilder<int, String>({1: '1', 2: '2'}).length, 2);
      expect(new BuiltMap<int, String>({1: '1', 2: '2'}).toBuilder().length, 2);

      expect(new MapBuilder<int, String>({}).length, 0);
      expect(new BuiltMap<int, String>({}).toBuilder().length, 0);
    });

    test('has a method like Map.isEmpty', () {
      expect(new MapBuilder<int, String>({1: '1', 2: '2'}).isEmpty, false);
      expect(new BuiltMap<int, String>({1: '1', 2: '2'}).toBuilder().isEmpty,
          false);

      expect(new MapBuilder<int, String>().isEmpty, true);
      expect(new BuiltMap<int, String>().toBuilder().isEmpty, true);
    });

    test('has a method like Map.isNotEmpty', () {
      expect(new MapBuilder<int, String>({1: '1', 2: '2'}).isNotEmpty, true);
      expect(new BuiltMap<int, String>({1: '1', 2: '2'}).toBuilder().isNotEmpty,
          true);

      expect(new MapBuilder<int, String>().isNotEmpty, false);
      expect(new BuiltMap<int, String>().toBuilder().isNotEmpty, false);
    });

    test('has a method like Map.putIfAbsent', () {
      expect(
          new MapBuilder<int, String>({1: '1'}).putIfAbsent(2, () => '2'), '2');
      expect(
          (new MapBuilder<int, String>({1: '1'})
                ..putIfAbsent(2, () => '2')
                ..putIfAbsent(1, () => '3'))
              .build()
              .toMap(),
          {1: '1', 2: '2'});
      expect(
          (new BuiltMap<int, String>({1: '1'}).toBuilder()
                ..putIfAbsent(2, () => '2')
                ..putIfAbsent(1, () => '3'))
              .build()
              .toMap(),
          {1: '1', 2: '2'});
    });

    test('has a method like Map.addAll', () {
      expect(
          (new MapBuilder<int, String>()..addAll({1: '1', 2: '2'}))
              .build()
              .toMap(),
          {1: '1', 2: '2'});
      expect(
          (new BuiltMap<int, String>().toBuilder()..addAll({1: '1', 2: '2'}))
              .build()
              .toMap(),
          {1: '1', 2: '2'});
    });

    test('has a method like Map.remove', () {
      expect(new MapBuilder<int, String>({1: '1', 2: '2'}).remove(2), '2');
      expect(new MapBuilder<int, String>({1: '1', 2: '2'}).remove(3), null);
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})..remove(2))
              .build()
              .toMap(),
          {1: '1'});
      expect(
          (new BuiltMap<int, String>({1: '1', 2: '2'}).toBuilder()..remove(2))
              .build()
              .toMap(),
          {1: '1'});
    });

    test('has a method like Map.removeWhere', () {
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})
                ..removeWhere((k, v) => k == 2))
              .build()
              .toMap(),
          {1: '1'});
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})
                ..removeWhere((k, v) => v == '2'))
              .build()
              .toMap(),
          {1: '1'});
    });

    test('has a method like Map.clear', () {
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})..clear())
              .build()
              .toMap(),
          {});
      expect(
          (new BuiltMap<int, String>({1: '1', 2: '2'}).toBuilder()..clear())
              .build()
              .toMap(),
          {});
    });

    test('has a method like Map.update called updateValue', () {
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})
                ..updateValue(1, (v) => v + '1', ifAbsent: () => '7'))
              .build()
              .toMap(),
          {1: '11', 2: '2'});
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})
                ..updateValue(7, (v) => v + '1', ifAbsent: () => '7'))
              .build()
              .toMap(),
          {1: '1', 2: '2', 7: '7'});
    });

    test('has a method like Map.updateAll called updateAllValues', () {
      expect(
          (new MapBuilder<int, String>({1: '1', 2: '2'})
                ..updateAllValues((k, v) => v + k.toString()))
              .build()
              .toMap(),
          {1: '11', 2: '22'});
    });
  });
}
