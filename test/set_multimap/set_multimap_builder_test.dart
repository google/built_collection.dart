// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.test.set_multimap.set_multimap_builder_test;

import 'package:built_collection/built_collection.dart';
import 'package:quiver/collection.dart';
import 'package:test/test.dart';

import '../performance.dart';

void main() {
  group('SetMultimapBuilder', () {
    test('throws on attempt to create SetMultimapBuilder<dynamic, dynamic>',
        () {
      expect(() => new SetMultimapBuilder(), throwsA(anything));
    });

    test('throws on attempt to create SetMultimapBuilder<String, dynamic>', () {
      expect(
          () => new SetMultimapBuilder<String, dynamic>(), throwsA(anything));
    });

    test('throws on attempt to create SetMultimapBuilder<dynamic, String>', () {
      expect(
          () => new SetMultimapBuilder<dynamic, String>(), throwsA(anything));
    });

    test('allows SetMultimapBuilder<Object, Object>', () {
      new SetMultimapBuilder<Object, Object>();
    });

    test('throws on null key add', () {
      expect(() => new SetMultimapBuilder<int, String>().add(null, '0'),
          throwsA(anything));
    });

    test('throws on null value add', () {
      expect(() => new SetMultimapBuilder<int, String>().add(0, null),
          throwsA(anything));
    });

    test('throws on null key addAll', () {
      var mutableMultimap = new SetMultimap<int, String>();
      mutableMultimap.add(0, null);

      expect(
          () => new SetMultimapBuilder<int, String>().addAll(mutableMultimap),
          throwsA(anything));
    });

    test('throws on null value addAll', () {
      var mutableMultimap = new SetMultimap<int, String>();
      mutableMultimap.add(0, null);

      expect(
          () => new SetMultimapBuilder<int, String>().addAll(mutableMultimap),
          throwsA(anything));
    });

    test('throws on wrong type value addValues', () {
      expect(
          () => new SetMultimapBuilder<int, String>()
              .addValues(0, new List.from([0])),
          throwsA(anything));
    });

    test('has replace method that replaces all data', () {
      expect(
          (new SetMultimapBuilder<int, String>()
                ..replace({
                  1: ['1'],
                  2: ['2']
                }))
              .build()
              .toMap(),
          {
            1: ['1'],
            2: ['2']
          });
    });

    test('has addIterable method like Map.fromIterable', () {
      expect(
          (new SetMultimapBuilder<int, int>()..addIterable([1, 2, 3]))
              .build()
              .toMap(),
          {
            1: [1],
            2: [2],
            3: [3]
          });
      expect(
          (new SetMultimapBuilder<int, int>()
                ..addIterable([1, 2, 3], key: (element) => element + 1))
              .build()
              .toMap(),
          {
            2: [1],
            3: [2],
            4: [3]
          });
      expect(
          (new SetMultimapBuilder<int, int>()
                ..addIterable([1, 2, 3], value: (element) => element + 1))
              .build()
              .toMap(),
          {
            1: [2],
            2: [3],
            3: [4]
          });
      expect(
          (new SetMultimapBuilder<int, int>()
                ..addIterable([1, 2, 3],
                    values: (element) => <int>[element, element + 1]))
              .build()
              .toMap(),
          {
            1: [1, 2],
            2: [2, 3],
            3: [3, 4]
          });
    });

    // Lazy copies.

    test('does not mutate BuiltSetMultimap following reuse of underlying Map',
        () {
      var multimap = new BuiltSetMultimap<int, String>({
        1: ['1'],
        2: ['2']
      });
      var multimapBuilder = multimap.toBuilder();
      multimapBuilder.add(3, '3');
      expect(
          multimap.toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));
    });

    test('converts to BuiltSetMultimap without copying', () {
      var makeLongSetMultimapBuilder = () {
        var result = new SetMultimapBuilder<int, int>();
        for (int i = 0; i != 100000; ++i) {
          result.add(0, i);
        }
        return result;
      };
      var longSetMultimapBuilder = makeLongSetMultimapBuilder();
      var buildLongSetMultimapBuilder = () => longSetMultimapBuilder.build();

      expectMuchFaster(buildLongSetMultimapBuilder, makeLongSetMultimapBuilder);
    });

    test('does not mutate BuiltSetMultimap following mutates after build', () {
      var multimapBuilder = new SetMultimapBuilder<int, String>({
        1: ['1'],
        2: ['2']
      });

      var map1 = multimapBuilder.build();
      expect(
          map1.toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));

      multimapBuilder.add(3, '3');
      expect(
          map1.toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));

      multimapBuilder.build();
      expect(
          map1.toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));

      multimapBuilder.add(4, '4');
      expect(
          map1.toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));

      multimapBuilder.build();
      expect(
          map1.toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));
    });

    test('returns identical BuiltSetMultimap on repeated build', () {
      var multimapBuilder = new SetMultimapBuilder<int, String>({
        1: ['1', '2', '3']
      });
      expect(multimapBuilder.build(), same(multimapBuilder.build()));
    });

    // Modification of existing data.

    test('adds to copied sets', () {
      var multimap = new BuiltSetMultimap<int, String>({
        1: ['1']
      });
      var multimapBuilder = multimap.toBuilder();
      expect((multimapBuilder..add(1, '2')).build().toMap(), {
        1: ['1', '2']
      });
    });

    test('removes from copied sets', () {
      var multimap = new BuiltSetMultimap<int, String>({
        1: ['1', '2', '3']
      });
      var multimapBuilder = multimap.toBuilder();
      expect((multimapBuilder..remove(1, '2')).build().toMap(), {
        1: ['1', '3']
      });
    });

    test('removes from copied sets to empty', () {
      var multimap = new BuiltSetMultimap<int, String>({
        1: ['1']
      });
      var multimapBuilder = multimap.toBuilder();
      expect((multimapBuilder..remove(1, '1')).build().toMap(), {});
    });

    test('removes all from copied sets', () {
      var multimap = new BuiltSetMultimap<int, String>({
        1: ['1', '2', '3']
      });
      var multimapBuilder = multimap.toBuilder();
      expect((multimapBuilder..removeAll(1)).build().toMap(), {});
    });

    test('clears copied sets', () {
      var multimap = new BuiltSetMultimap<int, String>({
        1: ['1', '2', '3']
      });
      var multimapBuilder = multimap.toBuilder();
      expect((multimapBuilder..clear()).build().toMap(), {});
    });

    // Map.

    test('has a method like SetMultimap.add', () {
      expect(
          (new SetMultimapBuilder<int, String>({
            1: ['1']
          })
                ..add(2, '2'))
              .build()
              .toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));
      expect(
          (new BuiltSetMultimap<int, String>({
            1: ['1']
          }).toBuilder()
                ..add(2, '2'))
              .build()
              .toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));
    });

    test('has a method like SetMultimap.addValues', () {
      expect(
          (new SetMultimapBuilder<int, String>({
            1: ['1']
          })
                ..addValues(2, ['2', '3']))
              .build()
              .toMap(),
          ({
            1: ['1'],
            2: ['2', '3']
          }));
      expect(
          (new BuiltSetMultimap<int, String>({
            1: ['1']
          }).toBuilder()
                ..addValues(2, ['2', '3']))
              .build()
              .toMap(),
          ({
            1: ['1'],
            2: ['2', '3']
          }));
    });

    test('has a method like SetMultimap.addAll', () {
      var mutableMultimap = new SetMultimap<int, String>();
      mutableMultimap.add(1, '1');
      mutableMultimap.add(2, '2');
      expect(
          (new SetMultimapBuilder<int, String>()..addAll(mutableMultimap))
              .build()
              .toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));
      expect(
          (new BuiltSetMultimap<int, String>().toBuilder()
                ..addAll(mutableMultimap))
              .build()
              .toMap(),
          ({
            1: ['1'],
            2: ['2']
          }));
    });

    test('has a method like SetMultimap.remove that returns nothing', () {
      expect(
          (new SetMultimapBuilder<int, String>({
            1: ['1'],
            2: ['2', '3']
          })
                ..remove(2, '3'))
              .build()
              .toMap(),
          {
            1: ['1'],
            2: ['2']
          });
      expect(
          (new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2', '3']
          }).toBuilder()
                ..remove(2, '3'))
              .build()
              .toMap(),
          {
            1: ['1'],
            2: ['2']
          });
    });

    test('has a method like SetMultimap.removeAll that returns nothing', () {
      expect(
          (new SetMultimapBuilder<int, String>({
            1: ['1'],
            2: ['2', '3']
          })
                ..removeAll(2))
              .build()
              .toMap(),
          {
            1: ['1']
          });
      expect(
          (new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2', '3']
          }).toBuilder()
                ..removeAll(2))
              .build()
              .toMap(),
          {
            1: ['1']
          });
    });

    test('has a method like SetMultimap.clear', () {
      expect(
          (new SetMultimapBuilder<int, String>({
            1: ['1'],
            2: ['2']
          })
                ..clear())
              .build()
              .toMap(),
          {});
      expect(
          (new BuiltSetMultimap<int, String>({
            1: ['1'],
            2: ['2']
          }).toBuilder()
                ..clear())
              .build()
              .toMap(),
          {});
    });
  });
}
