// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.set.built_set_test;

import 'dart:collection' show SplayTreeSet;
import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/internal/test_helpers.dart';
import 'package:test/test.dart';

import '../performance.dart';

void main() {
  group('BuiltSet', () {
    test('instantiates empty by default', () {
      var set = new BuiltSet<int>();
      expect(set.isEmpty, isTrue);
      expect(set.isNotEmpty, isFalse);
    });

    test('throws on attempt to create BuiltSet<dynamic>', () {
      expect(() => new BuiltSet(), throwsA(anything));
    });

    test('of constructor throws on attempt to create BuiltSet<dynamic>', () {
      expect(() => new BuiltSet.of(<dynamic>[]), throwsA(anything));
    });

    test('allows BuiltSet<Object>', () {
      new BuiltSet<Object>();
    });

    test('can be instantiated from Set', () {
      new BuiltSet<int>([]);
    });

    test('of constructor takes inferred type', () {
      expect(new BuiltSet.of([1, 2, 3]), const TypeMatcher<BuiltSet<int>>());
    });

    test('reports non-emptiness', () {
      var set = new BuiltSet<int>([1]);
      expect(set.isEmpty, isFalse);
      expect(set.isNotEmpty, isTrue);
    });

    test('can be instantiated from Set then converted back to equal Set', () {
      var mutableSet = [1];
      var set = new BuiltSet<int>(mutableSet);
      expect(set.toSet(), mutableSet);
    });

    test('throws on wrong type element', () {
      expect(() => new BuiltSet<int>(['1']), throwsA(anything));
    });

    test('does not keep a mutable Set', () {
      var mutableSet = [1];
      var set = new BuiltSet<int>(mutableSet);
      mutableSet.clear();
      expect(set.toSet(), [1]);
    });

    test('copies from BuiltSet instances of different type', () {
      var set1 = new BuiltSet<Object>();
      var set2 = new BuiltSet<int>(set1);
      expect(set1, isNot(same(set2)));
    });

    test('can be converted to Set<E>', () {
      expect(new BuiltSet<int>().toSet() is Set<int>, isTrue);
      expect(new BuiltSet<int>().toSet() is Set<String>, isFalse);
    });

    test('uses same base when converted with toSet', () {
      var built = new BuiltSet<int>.build((b) => b
        ..withBase(() => new SplayTreeSet<int>())
        ..addAll([1, 3]));
      var set = built.toSet()..addAll([2, 4]);
      expect(set, [1, 2, 3, 4]);
    });

    test('can be converted to an UnmodifiableSetView', () {
      var immutableSet = new BuiltSet<int>().asSet();
      expect(immutableSet is Set<int>, isTrue);
      expect(() => immutableSet.add(1), throwsUnsupportedError);
      expect(immutableSet, isEmpty);
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

    test('passes along its base when converted to SetBuilder', () {
      var set = new BuiltSet<int>.build((b) => b
        ..withBase(() => new SplayTreeSet<int>())
        ..addAll([10, 15, 5]));
      var builder = set.toBuilder()..addAll([2, 12]);
      expect(builder.build(), orderedEquals([2, 5, 10, 12, 15]));
    });

    test('throws on null', () {
      expect(() => new BuiltSet<int>([null]), throwsA(anything));
    });

    test('hashes to same value for same contents', () {
      var set1 = new BuiltSet<int>([1, 2, 3]);
      var set2 = new BuiltSet<int>([1, 2, 3]);

      expect(set1.hashCode, set2.hashCode);
    });

    test('hashes to same value for same contents in different order', () {
      var set1 = new BuiltSet<int>([1, 2, 3]);
      var set2 = new BuiltSet<int>([3, 2, 1]);

      expect(set1.hashCode, set2.hashCode);
    });

    test('hashes to different value for different contents', () {
      var set1 = new BuiltSet<int>([1, 2, 3]);
      var set2 = new BuiltSet<int>([1, 2, 4]);

      expect(set1.hashCode, isNot(set2.hashCode));
    });

    test('caches hash', () {
      var set = new BuiltSet<Object>([new _HashcodeOnlyTwice()]);

      set.hashCode;
      set.hashCode;
    });

    test('compares equal to same instance', () {
      var set1 = new BuiltSet<int>([1, 2, 3]);
      expect(set1 == set1, isTrue);
    });

    test('compares equal to same contents', () {
      var set1 = new BuiltSet<int>([1, 2, 3]);
      var set2 = new BuiltSet<int>([1, 2, 3]);
      expect(set1 == set2, isTrue);
    });

    test('compares not equal to different type', () {
      // ignore: unrelated_type_equality_checks
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
                  [1, 2, 3], 1),
          isFalse);
    });

    test('compares not equal to different content BuiltSet', () {
      expect(
          BuiltCollectionTestHelpers.overridenHashcodeBuiltSet([1, 2, 3], 0) ==
              BuiltCollectionTestHelpers.overridenHashcodeBuiltSet(
                  [1, 2, 4], 0),
          isFalse);
    });

    test('provides toString() for debugging', () {
      expect(new BuiltSet<int>([1, 2, 3]).toString(), '{1, 2, 3}');
    });

    test('preserves order', () {
      expect(new BuiltSet<int>([1, 2, 3]), [1, 2, 3]);
      expect(new BuiltSet<int>([3, 2, 1]), [3, 2, 1]);
    });

    test('has build constructor', () {
      expect(new BuiltSet<int>.build((b) => b.addAll([0, 1, 2])), [0, 1, 2]);
    });

    test('has rebuild method', () {
      expect(new BuiltSet<int>([0, 1, 2]).rebuild((b) => b.addAll([3, 4, 5])),
          [0, 1, 2, 3, 4, 5]);
    });

    test('converts to BuiltList with toBuiltList', () {
      expect(new BuiltSet<int>([0, 1, 2]).toBuiltList(), [0, 1, 2]);
    });

    test('returns identical with toBuiltSet', () {
      var set = new BuiltSet<int>([0, 1, 2]);
      expect(set.toBuiltSet(), same(set));
    });

    // Lazy copies.

    test('reuses BuiltSet instances of the same type', () {
      var set1 = new BuiltSet<int>();
      var set2 = new BuiltSet<int>(set1);
      expect(set1, same(set2));
    });

    test('does not reuse BuiltSet instances with subtype element type', () {
      var set1 = new BuiltSet<_ExtendsA>();
      var set2 = new BuiltSet<_A>(set1);
      expect(set1, isNot(same(set2)));
    });

    test('can be reused via SetBuilder if there are no changes', () {
      var set1 = new BuiltSet<Object>();
      var set2 = set1.toBuilder().build();
      expect(set1, same(set2));
    });

    test('converts to SetBuilder from correct type without copying', () {
      var makeLongSet = () => new BuiltSet<int>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      var longSet = makeLongSet();
      var longSetToSetBuilder = longSet.toBuilder;

      expectMuchFaster(longSetToSetBuilder, makeLongSet);
    });

    test('converts to SetBuilder from wrong type by copying', () {
      var makeLongSet = () => new BuiltSet<Object>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      var longSet = makeLongSet();
      var longSetToSetBuilder = () => new SetBuilder<int>(longSet);

      expectNotMuchFaster(longSetToSetBuilder, makeLongSet);
    });

    test('has fast toSet', () {
      var makeLongSet = () => new BuiltSet<Object>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      var longSet = makeLongSet();
      var longSetToSet = () => longSet.toSet();

      expectMuchFaster(longSetToSet, makeLongSet);
    });

    test('checks for reference identity', () {
      var makeLongSet = () => new BuiltSet<Object>(
          new Set<int>.from(new List<int>.generate(100000, (x) => x)));
      var longSet = makeLongSet();
      var otherLongSet = makeLongSet();

      expectMuchFaster(() => longSet == longSet, () => longSet == otherLongSet);
    });

    test('is not mutated when Set from toSet is mutated', () {
      var set = new BuiltSet<int>();
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
      expect(new BuiltSet<int>([1, 2, 3]).difference(new BuiltSet<int>([1])),
          [2, 3]);
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
      expect(new BuiltSet<int>([1, 2, 3]).union(new BuiltSet<int>([4])),
          [1, 2, 3, 4]);
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
      expect(
          new BuiltSet<int>([1, 2])
              .fold('', (x, y) => x.toString() + y.toString()),
          '12');
    });

    test('implements Iterable.followedBy', () {
      expect(new BuiltSet<int>([1, 2]).followedBy(new BuiltSet<int>([3, 4])),
          [1, 2, 3, 4]);
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
      expect(() => new BuiltSet<int>([1, 2]).single, throwsA(anything));
      expect(new BuiltSet<int>([1]).single, 1);
    });

    test('implements Iterable.firstWhere', () {
      expect(new BuiltSet<int>([1, 2]).firstWhere((x) => x == 2), 2);
      expect(() => new BuiltSet<int>([1, 2]).firstWhere((x) => x == 3),
          throwsA(anything));
      expect(
          new BuiltSet<int>([1, 2]).firstWhere((x) => x == 3, orElse: () => 4),
          4);
    });

    test('implements Iterable.lastWhere', () {
      expect(new BuiltSet<int>([1, 2]).lastWhere((x) => x == 2), 2);
      expect(() => new BuiltSet<int>([1, 2]).lastWhere((x) => x == 3),
          throwsA(anything));
      expect(
          new BuiltSet<int>([1, 2]).lastWhere((x) => x == 3, orElse: () => 4),
          4);
    });

    test('implements Iterable.singleWhere', () {
      expect(new BuiltSet<int>([1, 2]).singleWhere((x) => x == 2), 2);
      expect(() => new BuiltSet<int>([1, 2]).singleWhere((x) => x == 3),
          throwsA(anything));
      expect(() => new BuiltSet<int>([1, 2]).singleWhere((x) => true),
          throwsA(anything));
      expect(
          new BuiltSet<int>([1, 2]).singleWhere((x) => false, orElse: () => 7),
          7);
    });

    test('implements Iterable.elementAt', () {
      expect(new BuiltSet<int>([1, 2]).elementAt(0), 1);
    });

    test('implements Iterable.cast', () {
      expect(new BuiltSet<int>([1, 2]).cast<Object>(),
          const TypeMatcher<Iterable<Object>>());
      expect(new BuiltSet<int>([1, 2]).cast<Object>(), [1, 2]);
    });

    test('implements Iterable.whereType', () {
      expect(new BuiltSet<Object>([1, 'two', 3]).whereType<String>(), ['two']);
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
