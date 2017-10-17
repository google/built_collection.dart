// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.list.list_builder_test;

import 'dart:math' show Random;

import 'package:built_collection/built_collection.dart';
import 'package:test/test.dart';

void main() {
  group('ListBuilder', () {
    test('throws on attempt to create ListBuilder<dynamic>', () {
      expect(() => new ListBuilder(), throwsA(anything));
    });

    test('allows ListBuilder<Object>', () {
      new ListBuilder<Object>();
    });

    test('throws on null assign', () {
      expect(() => new ListBuilder<int>([0])[0] = null, throwsA(anything));
    });

    test('throws on null add', () {
      expect(() => new ListBuilder<int>().add(null), throwsA(anything));
    });

    test('throws on null addAll', () {
      expect(
          () => new ListBuilder<int>().addAll([0, 1, null]), throwsA(anything));
    });

    test('throws on null insert', () {
      expect(() => new ListBuilder<int>().insert(0, null), throwsA(anything));
    });

    test('throws on null insertAll', () {
      expect(() => new ListBuilder<int>().insertAll(0, [0, 1, null]),
          throwsA(anything));
    });

    test('throws on null setAll', () {
      expect(() => new ListBuilder<int>([0, 1, 2]).setAll(0, [0, 1, null]),
          throwsA(anything));
    });

    test('throws on null setRange', () {
      expect(() => new ListBuilder<int>([0, 1, 2]).setRange(0, 2, [0, 1, null]),
          throwsA(anything));
    });

    test('throws on null fillRange', () {
      expect(() => new ListBuilder<int>([0, 1, 2]).fillRange(0, 2, null),
          throwsA(anything));
    });

    test('throws on null replaceRange', () {
      expect(
          () =>
              new ListBuilder<int>([0, 1, 2]).replaceRange(0, 2, [0, 1, null]),
          throwsA(anything));
    });

    test('throws on null map', () {
      expect(() => new ListBuilder<int>([0, 1, 2]).map((x) => null),
          throwsA(anything));
    });

    test('throws on null expand', () {
      expect(() => new ListBuilder<int>([0, 1, 2]).expand((x) => [x, null]),
          throwsA(anything));
    });

    test('throws on wrong type addAll', () {
      expect(
          () => new ListBuilder<int>().addAll(new List<int>.from([0, 1, '0'])),
          throwsA(anything));
    });

    test('throws on wrong type insertAll', () {
      expect(
          () => new ListBuilder<int>()
              .insertAll(0, new List<int>.from([0, 1, '0'])),
          throwsA(anything));
    });

    test('throws on wrong type setAll', () {
      expect(
          () => new ListBuilder<int>([0, 1, 2])
              .setAll(0, new List<int>.from([0, 1, '0'])),
          throwsA(anything));
    });

    test('throws on wrong type setRange', () {
      expect(
          () => new ListBuilder<int>([0, 1, 2])
              .setRange(0, 2, new List<int>.from([0, 1, '0'])),
          throwsA(anything));
    });

    test('throws on wrong type replaceRange', () {
      expect(
          () => new ListBuilder<int>([0, 1, 2])
              .replaceRange(0, 2, new List<int>.from([0, 1, '0'])),
          throwsA(anything));
    });

    test('has replace method that replaces all data', () {
      expect((new ListBuilder<int>()..replace([0, 1, 2])).build(), [0, 1, 2]);
    });

    // Lazy copies.

    test('does not mutate BuiltList following reuse of underlying List', () {
      final list = new BuiltList<int>([1, 2]);
      final listBuilder = list.toBuilder();
      listBuilder.add(3);
      expect(list, [1, 2]);
    });

    test('converts to BuiltList without copying', () {
      final makeLongListBuilder =
          () => new ListBuilder<int>(new List<int>.filled(1000000, 0));
      final longListBuilder = makeLongListBuilder();
      final buildLongListBuilder = () => longListBuilder.build();

      expectMuchFaster(buildLongListBuilder, makeLongListBuilder);
    });

    test('does not mutate BuiltList following mutates after build', () {
      final listBuilder = new ListBuilder<int>([1, 2]);

      final list1 = listBuilder.build();
      expect(list1, [1, 2]);

      listBuilder.add(3);
      expect(list1, [1, 2]);
    });

    // List.

    test('has a method like List[]', () {
      final listBuilder = new ListBuilder<int>([1, 2]);
      ++listBuilder[0];
      --listBuilder[1];
      expect(listBuilder.build(), [2, 1]);
    });

    test('has a method like List[]=', () {
      expect((new ListBuilder<int>([1])..[0] = 2).build(), [2]);
      expect((new BuiltList<int>([1]).toBuilder()..[0] = 2).build(), [2]);
    });

    test('has a method like List.add', () {
      expect((new ListBuilder<int>()..add(1)).build(), [1]);
      expect((new BuiltList<int>().toBuilder()..add(1)).build(), [1]);
    });

    test('has a method like List.addAll', () {
      expect((new ListBuilder<int>()..addAll([1, 2])).build(), [1, 2]);
      expect(
          (new BuiltList<int>().toBuilder()..addAll([1, 2])).build(), [1, 2]);
    });

    test('has a method like List.reversed that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..reverse()).build(), [2, 1]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..reverse()).build(), [2, 1]);
    });

    test('has a method like List.sort', () {
      expect((new ListBuilder<int>([2, 1])..sort()).build(), [1, 2]);
      expect(
          (new ListBuilder<int>([1, 2])..sort((int x, int y) => x < y ? 1 : -1))
              .build(),
          [2, 1]);

      expect((new BuiltList<int>([2, 1]).toBuilder()..sort()).build(), [1, 2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()
                ..sort((int x, int y) => x < y ? 1 : -1))
              .build(),
          [2, 1]);
    });

    test('has a method like List.shuffle', () {
      expect(
          (new ListBuilder<int>([1, 2])..shuffle(new _AlwaysZeroRandom()))
              .build(),
          [2, 1]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()
                ..shuffle(new _AlwaysZeroRandom()))
              .build(),
          [2, 1]);
    });

    test('has a method like List.clear', () {
      expect((new ListBuilder<int>([1, 2])..clear()).build(), []);
      expect((new BuiltList<int>([1, 2]).toBuilder()..clear()).build(), []);
    });

    test('has a method like List.insert', () {
      expect((new ListBuilder<int>([1, 2])..insert(1, 3)).build(), [1, 3, 2]);
      expect((new BuiltList<int>([1, 2]).toBuilder()..insert(1, 3)).build(),
          [1, 3, 2]);
    });

    test('has a method like List.insertAll', () {
      expect((new ListBuilder<int>([1, 2])..insertAll(1, [3, 4])).build(),
          [1, 3, 4, 2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..insertAll(1, [3, 4]))
              .build(),
          [1, 3, 4, 2]);
    });

    test('has a method like List.setAll', () {
      expect((new ListBuilder<int>([1, 2])..setAll(0, [3, 4])).build(), [3, 4]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..setAll(0, [3, 4])).build(),
          [3, 4]);
    });

    test('has a method like List.remove that returns nothing', () {
      expect((new ListBuilder<int>([1, 2])..remove(2)).build(), [1]);
      expect((new BuiltList<int>([1, 2]).toBuilder()..remove(2)).build(), [1]);
      expect(new ListBuilder<int>([1, 2]).remove(2), isNull);
    });

    test('has a method like List.removeAt that returns nothing', () {
      expect((new ListBuilder<int>([1, 2])..removeAt(1)).build(), [1]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..removeAt(1)).build(), [1]);
      expect(new ListBuilder<int>([1, 2]).removeAt(0), isNull);
    });

    test('has a method like List.removeLast that returns nothing', () {
      expect((new ListBuilder<int>([1, 2])..removeLast()).build(), [1]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..removeLast()).build(), [1]);
      expect(new ListBuilder<int>([1, 2]).removeLast(), isNull);
    });

    test('has a method like List.removeWhere', () {
      expect((new ListBuilder<int>([1, 2])..removeWhere((x) => x == 1)).build(),
          [2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..removeWhere((x) => x == 1))
              .build(),
          [2]);
    });

    test('has a method like List.retainWhere', () {
      expect((new ListBuilder<int>([1, 2])..retainWhere((x) => x == 1)).build(),
          [1]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..retainWhere((x) => x == 1))
              .build(),
          [1]);
    });

    test('has a method like List.sublist that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..sublist(1)).build(), [2]);
      expect((new ListBuilder<int>([1, 2])..sublist(1, 1)).build(), []);

      expect((new BuiltList<int>([1, 2]).toBuilder()..sublist(1)).build(), [2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..sublist(1, 1)).build(), []);
    });

    test('has a method like List.setRange', () {
      expect(
          (new ListBuilder<int>([1, 2])..setRange(0, 1, [3])).build(), [3, 2]);
      expect((new ListBuilder<int>([1, 2])..setRange(0, 1, [3, 4], 1)).build(),
          [4, 2]);

      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..setRange(0, 1, [3])).build(),
          [3, 2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..setRange(0, 1, [3, 4], 1))
              .build(),
          [4, 2]);
    });

    test('has a method like List.removeRange', () {
      expect((new ListBuilder<int>([1, 2])..removeRange(0, 1)).build(), [2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..removeRange(0, 1)).build(),
          [2]);
    });

    test('has a method like List.fillRange that requires a value', () {
      expect(
          (new ListBuilder<int>([1, 2])..fillRange(0, 2, 3)).build(), [3, 3]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..fillRange(0, 2, 3)).build(),
          [3, 3]);
    });

    test('has a method like List.replaceRange', () {
      expect((new ListBuilder<int>([1, 2])..replaceRange(0, 1, [2, 3])).build(),
          [2, 3, 2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..replaceRange(0, 1, [2, 3]))
              .build(),
          [2, 3, 2]);
    });

    // Iterable.

    test('has a method like Iterable.map that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..map((x) => x + 1)).build(), [2, 3]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..map((x) => x + 1)).build(),
          [2, 3]);
    });

    test('has a method like Iterable.where that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..where((x) => x == 2)).build(), [2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..where((x) => x == 2))
              .build(),
          [2]);
    });

    test('has a method like Iterable.expand that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..expand((x) => [x, x + 1])).build(),
          [1, 2, 2, 3]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..expand((x) => [x, x + 1]))
              .build(),
          [1, 2, 2, 3]);
    });

    test('has a method like Iterable.take that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..take(1)).build(), [1]);
      expect((new BuiltList<int>([1, 2]).toBuilder()..take(1)).build(), [1]);
    });

    test('has a method like Iterable.takeWhile that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..takeWhile((x) => x == 1)).build(),
          [1]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..takeWhile((x) => x == 1))
              .build(),
          [1]);
    });

    test('has a method like Iterable.skip that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..skip(1)).build(), [2]);
      expect((new BuiltList<int>([1, 2]).toBuilder()..skip(1)).build(), [2]);
    });

    test('has a method like Iterable.skipWhile that updates in place', () {
      expect((new ListBuilder<int>([1, 2])..skipWhile((x) => x == 1)).build(),
          [2]);
      expect(
          (new BuiltList<int>([1, 2]).toBuilder()..skipWhile((x) => x == 1))
              .build(),
          [2]);
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

class _AlwaysZeroRandom implements Random {
  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0.0;

  @override
  int nextInt(int max) => 0;
}
