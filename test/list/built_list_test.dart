// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.list.built_list_test;

import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:unittest/unittest.dart';

void main() {
  group('BuiltList', () {
    test('instantiates empty by default', () {
      final list = new BuiltList<int>();
      expect(list.isEmpty, isTrue);
      expect(list.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltList<dynamic>', () {
      expect(() => new BuiltList(), throws);
    });

    test('allows BuiltList<Object>', () {
      new BuiltList<Object>();
    });

    test('can be instantiated from List', () {
      new BuiltList<int>([]);
    });

    test('reports non-emptiness', () {
      final list = new BuiltList<int>([1]);
      expect(list.isEmpty, isFalse);
      expect(list.isNotEmpty, isTrue);
    });

    test('can be instantiated from List then converted back to equal List', () {
      final mutableList = [1];
      final list = new BuiltList<int>(mutableList);
      expect(list.toList(), mutableList);
    });

    test('throws on wrong type element', () {
      expect(() => new BuiltList<int>(['1']), throws);
    });

    test('does not keep a mutable List', () {
      final mutableList = [1];
      final list = new BuiltList<int>(mutableList);
      mutableList.clear();
      expect(list.toList(), [1]);
    });

    test('copies from BuiltList instances of different type', () {
      final list1 = new BuiltList<Object>();
      final list2 = new BuiltList<int>(list1);
      expect(list1, isNot(same(list2)));
    });

    test('can be converted to List<E>', () {
      expect(new BuiltList<int>().toList() is List<int>, isTrue);
      expect(new BuiltList<int>().toList() is List<String>, isFalse);
    });

    test('can be converted to ListBuilder<E>', () {
      expect(new BuiltList<int>().toBuilder() is ListBuilder<int>, isTrue);
      expect(new BuiltList<int>().toBuilder() is ListBuilder<String>, isFalse);
    });

    test('can be converted to ListBuilder<E> and back to List<E>', () {
      expect(
          new BuiltList<int>().toBuilder().build() is BuiltList<int>, isTrue);
      expect(new BuiltList<int>().toBuilder().build() is BuiltList<String>,
          isFalse);
    });

    test('throws on null', () {
      expect(() => new BuiltList<int>([null]), throws);
    });

    test('hashes to same value for same contents', () {
      final list1 = new BuiltList<int>([1, 2, 3]);
      final list2 = new BuiltList<int>([1, 2, 3]);

      expect(list1.hashCode, list2.hashCode);
    });

    test('hashes to different value for different contents', () {
      final list1 = new BuiltList<int>([1, 2, 3]);
      final list2 = new BuiltList<int>([1, 2, 4]);

      expect(list1.hashCode, isNot(list2.hashCode));
    });

    test('caches hash', () {
      final list = new BuiltList<Object>([new _HashcodeOnlyOnce()]);

      list.hashCode;
      list.hashCode;
    });

    test('compares equal to same contents', () {
      final list1 = new BuiltList<int>([1, 2, 3]);
      final list2 = new BuiltList<int>([1, 2, 3]);
      expect(list1 == list2, isTrue);
    });

    test('compares not equal to different type', () {
      expect(new BuiltList<int>([1, 2, 3]) == '', isFalse);
    });

    test('compares not equal to different length BuiltList', () {
      expect(new BuiltList<int>([1, 2, 3]) == new BuiltList<int>([1, 2, 3, 4]),
          isFalse);
    });

    test('compares not equal to different hashcode BuiltList', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltList([1, 2, 3], 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltList(
                  [1, 2, 3], 1), isFalse);
    });

    test('compares not equal to different content BuiltList', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltList([1, 2, 3], 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltList(
                  [1, 2, 4], 0), isFalse);
    });

    test('provides toString() for debugging', () {
      expect(new BuiltList<int>([1, 2, 3]).toString(), '[1, 2, 3]');
    });

    // Lazy copies.

    test('reuses BuiltList instances of the same type', () {
      final list1 = new BuiltList<int>();
      final list2 = new BuiltList<int>(list1);
      expect(list1, same(list2));
    });

    test('can be reused via ListBuilder if there are no changes', () {
      final list1 = new BuiltList<Object>();
      final list2 = list1.toBuilder().build();
      expect(list1, same(list2));
    });

    test('converts to ListBuilder from correct type without copying', () {
      final makeLongList =
          () => new BuiltList<int>(new List<int>.filled(1000000, 0));
      final longList = makeLongList();
      final longListToListBuilder = longList.toBuilder;

      expectMuchFaster(longListToListBuilder, makeLongList);
    });

    test('converts to ListBuilder from wrong type by copying', () {
      final makeLongList =
          () => new BuiltList<Object>(new List<int>.filled(1000000, 0));
      final longList = makeLongList();
      final longListToListBuilder = () => new ListBuilder<int>(longList);

      expectNotMuchFaster(longListToListBuilder, makeLongList);
    });

    test('has fast toList', () {
      final makeLongList =
          () => new BuiltList<Object>(new List<int>.filled(1000000, 0));
      final longList = makeLongList();
      final longListToList = () => longList.toList();

      expectMuchFaster(longListToList, makeLongList);
    });

    test('is not mutated when List from toList is mutated', () {
      final list = new BuiltList<int>();
      list.toList().add(1);
      expect(list, []);
    });

    // List.

    test('does not implement List', () {
      expect(new BuiltList<int>() is List, isFalse);
    });

    test('has a method like List[]', () {
      expect(new BuiltList<int>([1, 2, 3])[1], 2);
    });

    test('has a method like List.length', () {
      expect(new BuiltList<int>([1, 2, 3]).length, 3);
    });

    test('has a method like List.reversed', () {
      expect(new BuiltList<int>([1, 2, 3]).reversed, [3, 2, 1]);
    });

    test('has a method like List.indexOf', () {
      expect(new BuiltList<int>([1, 2, 3]).indexOf(2), 1);
      expect(new BuiltList<int>([1, 2, 3]).indexOf(2, 2), -1);
    });

    test('has a method like List.lastIndexOf', () {
      expect(new BuiltList<int>([1, 2, 3]).lastIndexOf(2), 1);
      expect(new BuiltList<int>([1, 2, 3]).lastIndexOf(2, 0), -1);
    });

    test('has a method like List.sublist', () {
      expect(new BuiltList<int>([1, 2, 3]).sublist(1), [2, 3]);
      expect(new BuiltList<int>([1, 2, 3]).sublist(1, 2), [2]);
    });

    test('has a method like List.getRange', () {
      expect(new BuiltList<int>([1, 2, 3]).getRange(1, 3), [2, 3]);
    });

    test('has a method like List.asMap', () {
      expect(new BuiltList<int>([1, 2, 3]).asMap(), {0: 1, 1: 2, 2: 3});
    });

    // Iterable.

    test('implements Iterable', () {
      expect(new BuiltList<int>() is Iterable, isTrue);
    });

    test('implements Iterable<E>', () {
      expect(new BuiltList<int>() is Iterable<int>, isTrue);
      expect(new BuiltList<int>() is Iterable<String>, isFalse);
    });

    test('implements Iterable.map', () {
      expect(new BuiltList<int>([1]).map((x) => x + 1), [2]);
    });

    test('implements Iterable.where', () {
      expect(new BuiltList<int>([1, 2]).where((x) => x > 1), [2]);
    });

    test('implements Iterable.expand', () {
      expect(
          new BuiltList<int>([1, 2]).expand((x) => [x, x + 1]), [1, 2, 2, 3]);
    });

    test('implements Iterable.contains', () {
      expect(new BuiltList<int>([1]).contains(1), isTrue);
      expect(new BuiltList<int>([1]).contains(2), isFalse);
    });

    test('implements Iterable.forEach', () {
      var value = 1;
      new BuiltList<int>([2]).forEach((x) => value = x);
      expect(value, 2);
    });

    test('implements Iterable.reduce', () {
      expect(new BuiltList<int>([1, 2]).reduce((x, y) => x + y), 3);
    });

    test('implements Iterable.fold', () {
      expect(new BuiltList<int>([1, 2]).fold(
          '', (x, y) => x.toString() + y.toString()), '12');
    });

    test('implements Iterable.every', () {
      expect(new BuiltList<int>([1, 2]).every((x) => x == 1), isFalse);
      expect(new BuiltList<int>([1, 2]).every((x) => x == 1 || x == 2), isTrue);
    });

    test('implements Iterable.join', () {
      expect(new BuiltList<int>([1, 2]).join(','), '1,2');
    });

    test('implements Iterable.any', () {
      expect(new BuiltList<int>([1, 2]).any((x) => x == 0), isFalse);
      expect(new BuiltList<int>([1, 2]).any((x) => x == 1), isTrue);
    });

    test('implements Iterable.toSet', () {
      expect(new BuiltList<int>([1, 2]).toSet() is Set, isTrue);
      expect(new BuiltList<int>([1, 2]).toSet(), [1, 2]);
    });

    test('implements Iterable.take', () {
      expect(new BuiltList<int>([1, 2]).take(1), [1]);
    });

    test('implements Iterable.takeWhile', () {
      expect(new BuiltList<int>([1, 2]).takeWhile((x) => x == 1), [1]);
    });

    test('implements Iterable.skip', () {
      expect(new BuiltList<int>([1, 2]).skip(1), [2]);
    });

    test('implements Iterable.skipWhile', () {
      expect(new BuiltList<int>([1, 2]).skipWhile((x) => x == 1), [2]);
    });

    test('implements Iterable.first', () {
      expect(new BuiltList<int>([1, 2]).first, 1);
    });

    test('implements Iterable.last', () {
      expect(new BuiltList<int>([1, 2]).last, 2);
    });

    test('implements Iterable.last', () {
      expect(() => new BuiltList<int>([1, 2]).single, throws);
      expect(new BuiltList<int>([1]).single, 1);
    });

    test('implements Iterable.firstWhere', () {
      expect(new BuiltList<int>([1, 2]).firstWhere((x) => x == 2), 2);
      expect(
          () => new BuiltList<int>([1, 2]).firstWhere((x) => x == 3), throws);
      expect(
          new BuiltList<int>([1, 2]).firstWhere((x) => x == 3, orElse: () => 4),
          4);
    });

    test('implements Iterable.lastWhere', () {
      expect(new BuiltList<int>([1, 2]).lastWhere((x) => x == 2), 2);
      expect(() => new BuiltList<int>([1, 2]).lastWhere((x) => x == 3), throws);
      expect(
          new BuiltList<int>([1, 2]).lastWhere((x) => x == 3, orElse: () => 4),
          4);
    });

    test('implements Iterable.singleWhere', () {
      expect(new BuiltList<int>([1, 2]).singleWhere((x) => x == 2), 2);
      expect(
          () => new BuiltList<int>([1, 2]).singleWhere((x) => x == 3), throws);
      expect(() => new BuiltList<int>([1, 2]).singleWhere((x) => true), throws);
    });

    test('implements Iterable.elementAt', () {
      expect(new BuiltList<int>([1, 2]).elementAt(0), 1);
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

class _HashcodeOnlyOnce {
  bool hashCodeAllowed = true;

  int get hashCode {
    expect(hashCodeAllowed, isTrue);
    hashCodeAllowed = false;
    return 0;
  }
}
