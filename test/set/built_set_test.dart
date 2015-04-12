// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.set.built_set_test;

import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:unittest/unittest.dart';

void main() {
  group('BuiltSet', () {
    test('instantiates empty by default', () {
      final set = new BuiltSet<int>();
      expect(set.isEmpty, isTrue);
      expect(set.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltSet<dynamic>', () {
      expect(() => new BuiltSet(), throws);
    });

    test('allows BuiltSet<Object>', () {
      new BuiltSet<Object>();
    });

    test('can be instantiated from Set', () {
      new BuiltSet<int>([]);
    });

    test('reports non-emptiness', () {
      final set = new BuiltSet<int>([1]);
      expect(set.isEmpty, isFalse);
      expect(set.isNotEmpty, isTrue);
    });

    test('can be instantiated from Set then converted back to equal Set', () {
      final mutableSet = [1];
      final set = new BuiltSet<int>(mutableSet);
      expect(set.toSet(), mutableSet);
    });

    test('throws on wrong type element', () {
      expect(() => new BuiltSet<int>(['1']), throws);
    });

    test('does not keep a mutable Set', () {
      final mutableSet = [1];
      final set = new BuiltSet<int>(mutableSet);
      mutableSet.clear();
      expect(set.toSet(), [1]);
    });

    test('copies from BuiltSet instances of different type', () {
      final set1 = new BuiltSet<Object>();
      final set2 = new BuiltSet<int>(set1);
      expect(set1, isNot(same(set2)));
    });

    test('can be converted to Set<E>', () {
      expect(new BuiltSet<int>().toSet() is Set<int>, isTrue);
      expect(new BuiltSet<int>().toSet() is Set<String>, isFalse);
    });

    test('can be converted to SetBuilder<E>', () {
      expect(new BuiltSet<int>().toBuilder() is SetBuilder<int>, isTrue);
      expect(new BuiltSet<int>().toBuilder() is SetBuilder<String>, isFalse);
    });

    test('can be converted to SetBuilder<E> and back to Set<E>', () {
      expect(new BuiltSet<int>().toBuilder().build() is BuiltSet<int>, isTrue);
      expect(
          new BuiltSet<int>().toBuilder().build() is BuiltSet<String>, isFalse);
    });

    test('throws on null', () {
      expect(() => new BuiltSet<int>([null]), throws);
    });

    test('hashes to same value for same contents', () {
      final set1 = new BuiltSet<int>([1, 2, 3]);
      final set2 = new BuiltSet<int>([1, 2, 3]);

      expect(set1.hashCode, set2.hashCode);
    });

    test('hashes to same value for same contents in different order', () {
      final set1 = new BuiltSet<int>([1, 2, 3]);
      final set2 = new BuiltSet<int>([3, 2, 1]);

      expect(set1.hashCode, set2.hashCode);
    });

    test('hashes to different value for different contents', () {
      final set1 = new BuiltSet<int>([1, 2, 3]);
      final set2 = new BuiltSet<int>([1, 2, 4]);

      expect(set1.hashCode, isNot(set2.hashCode));
    });

    test('caches hash', () {
      final set = new BuiltSet<Object>([new _HashcodeOnlyTwice()]);

      set.hashCode;
      set.hashCode;
    });

    test('compares equal to same contents', () {
      final set1 = new BuiltSet<int>([1, 2, 3]);
      final set2 = new BuiltSet<int>([1, 2, 3]);
      expect(set1 == set2, isTrue);
    });

    test('compares not equal to different type', () {
      expect(new BuiltSet<int>([1, 2, 3]) == '', isFalse);
    });

    test('compares not equal to different length BuiltSet', () {
      expect(new BuiltSet<int>([1, 2, 3]) == new BuiltSet<int>([1, 2, 3, 4]),
          isFalse);
    });

    test('compares not equal to different hashcode BuiltSet', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltSet([1, 2, 3], 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltSet(
                  [1, 2, 3], 1), isFalse);
    });

    test('compares not equal to different content BuiltSet', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltSet([1, 2, 3], 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltSet(
                  [1, 2, 4], 0), isFalse);
    });

    test('provides toString() for debugging', () {
      expect(new BuiltSet<int>([1, 2, 3]).toString(), '{1, 2, 3}');
    });

    test('preserves order', () {
      expect(new BuiltSet<int>([1, 2, 3]), [1, 2, 3]);
      expect(new BuiltSet<int>([3, 2, 1]), [3, 2, 1]);
    });

    // Lazy copies.

    test('reuses BuiltSet instances of the same type', () {
      final set1 = new BuiltSet<int>();
      final set2 = new BuiltSet<int>(set1);
      expect(set1, same(set2));
    });

    test('can be reused via SetBuilder if there are no changes', () {
      final set1 = new BuiltSet<Object>();
      final set2 = set1.toBuilder().build();
      expect(set1, same(set2));
    });

    test('converts to SetBuilder from correct type without copying', () {
      final makeLongSet = () => new BuiltSet<int>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      final longSet = makeLongSet();
      final longSetToSetBuilder = longSet.toBuilder;

      expectMuchFaster(longSetToSetBuilder, makeLongSet);
    });

    test('converts to SetBuilder from wrong type by copying', () {
      final makeLongSet = () => new BuiltSet<Object>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      final longSet = makeLongSet();
      final longSetToSetBuilder = () => new SetBuilder<int>(longSet);

      expectNotMuchFaster(longSetToSetBuilder, makeLongSet);
    });

    test('has fast toSet', () {
      final makeLongSet = () => new BuiltSet<Object>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      final longSet = makeLongSet();
      final longSetToSet = () => longSet.toSet();

      expectMuchFaster(longSetToSet, makeLongSet);
    });

    test('is not mutated when Set from toSet is mutated', () {
      final set = new BuiltSet<int>();
      set.toSet().add(1);
      expect(set, []);
    });

    // Set.

    test('does not implement Set', () {
      expect(new BuiltSet<int>() is Set, isFalse);
    });

    test('has a method like Set.length', () {
      expect(new BuiltSet<int>([1, 2, 3]).length, 3);
    });

    test('has a method like Set.containsAll', () {
      expect(new BuiltSet<int>([1, 2, 3]).containsAll([1, 2]), isTrue);
      expect(new BuiltSet<int>([1, 2, 3]).containsAll([1, 2, 3, 4]), isFalse);
    });

    test('has a method like Set.difference', () {
      expect(new BuiltSet<int>([1, 2, 3]).difference(new BuiltSet<int>([1])), [
        2,
        3
      ]);
    });

    test('has a method like Set.intersection', () {
      expect(new BuiltSet<int>([1, 2, 3]).intersection(new BuiltSet<int>([1])),
          [1]);
    });

    test('has a method like Set.lookup', () {
      expect(new BuiltSet<int>([1, 2, 3]).lookup(1), 1);
      expect(new BuiltSet<int>([1, 2, 3]).lookup(4), isNull);
    });

    test('has a method like Set.union', () {
      expect(new BuiltSet<int>([1, 2, 3]).union(new BuiltSet<int>([4])), [
        1,
        2,
        3,
        4
      ]);
    });

    // Iterable.

    test('implements Iterable', () {
      expect(new BuiltSet<int>() is Iterable, isTrue);
    });

    test('implements Iterable<E>', () {
      expect(new BuiltSet<int>() is Iterable<int>, isTrue);
      expect(new BuiltSet<int>() is Iterable<String>, isFalse);
    });

    test('implements Iterable.map', () {
      expect(new BuiltSet<int>([1]).map((x) => x + 1), [2]);
    });

    test('implements Iterable.where', () {
      expect(new BuiltSet<int>([1, 2]).where((x) => x > 1), [2]);
    });

    test('implements Iterable.expand', () {
      expect(new BuiltSet<int>([1, 2]).expand((x) => [x, x + 1]), [1, 2, 2, 3]);
    });

    test('implements Iterable.contains', () {
      expect(new BuiltSet<int>([1]).contains(1), isTrue);
      expect(new BuiltSet<int>([1]).contains(2), isFalse);
    });

    test('implements Iterable.forEach', () {
      var value = 1;
      new BuiltSet<int>([2]).forEach((x) => value = x);
      expect(value, 2);
    });

    test('implements Iterable.reduce', () {
      expect(new BuiltSet<int>([1, 2]).reduce((x, y) => x + y), 3);
    });

    test('implements Iterable.fold', () {
      expect(new BuiltSet<int>([1, 2]).fold(
          '', (x, y) => x.toString() + y.toString()), '12');
    });

    test('implements Iterable.every', () {
      expect(new BuiltSet<int>([1, 2]).every((x) => x == 1), isFalse);
      expect(new BuiltSet<int>([1, 2]).every((x) => x == 1 || x == 2), isTrue);
    });

    test('implements Iterable.join', () {
      expect(new BuiltSet<int>([1, 2]).join(','), '1,2');
    });

    test('implements Iterable.any', () {
      expect(new BuiltSet<int>([1, 2]).any((x) => x == 0), isFalse);
      expect(new BuiltSet<int>([1, 2]).any((x) => x == 1), isTrue);
    });

    test('implements Iterable.toSet', () {
      expect(new BuiltSet<int>([1, 2]).toSet() is Set, isTrue);
      expect(new BuiltSet<int>([1, 2]).toSet(), [1, 2]);
    });

    test('implements Iterable.toList', () {
      expect(new BuiltSet<int>([1, 2]).toList() is List, isTrue);
      expect(new BuiltSet<int>([1, 2]).toList(), [1, 2]);
    });

    test('implements Iterable.take', () {
      expect(new BuiltSet<int>([1, 2]).take(1), [1]);
    });

    test('implements Iterable.takeWhile', () {
      expect(new BuiltSet<int>([1, 2]).takeWhile((x) => x == 1), [1]);
    });

    test('implements Iterable.skip', () {
      expect(new BuiltSet<int>([1, 2]).skip(1), [2]);
    });

    test('implements Iterable.skipWhile', () {
      expect(new BuiltSet<int>([1, 2]).skipWhile((x) => x == 1), [2]);
    });

    test('implements Iterable.first', () {
      expect(new BuiltSet<int>([1, 2]).first, 1);
    });

    test('implements Iterable.last', () {
      expect(new BuiltSet<int>([1, 2]).last, 2);
    });

    test('implements Iterable.last', () {
      expect(() => new BuiltSet<int>([1, 2]).single, throws);
      expect(new BuiltSet<int>([1]).single, 1);
    });

    test('implements Iterable.firstWhere', () {
      expect(new BuiltSet<int>([1, 2]).firstWhere((x) => x == 2), 2);
      expect(() => new BuiltSet<int>([1, 2]).firstWhere((x) => x == 3), throws);
      expect(
          new BuiltSet<int>([1, 2]).firstWhere((x) => x == 3, orElse: () => 4),
          4);
    });

    test('implements Iterable.lastWhere', () {
      expect(new BuiltSet<int>([1, 2]).lastWhere((x) => x == 2), 2);
      expect(() => new BuiltSet<int>([1, 2]).lastWhere((x) => x == 3), throws);
      expect(
          new BuiltSet<int>([1, 2]).lastWhere((x) => x == 3, orElse: () => 4),
          4);
    });

    test('implements Iterable.singleWhere', () {
      expect(new BuiltSet<int>([1, 2]).singleWhere((x) => x == 2), 2);
      expect(
          () => new BuiltSet<int>([1, 2]).singleWhere((x) => x == 3), throws);
      expect(() => new BuiltSet<int>([1, 2]).singleWhere((x) => true), throws);
    });

    test('implements Iterable.elementAt', () {
      expect(new BuiltSet<int>([1, 2]).elementAt(0), 1);
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
