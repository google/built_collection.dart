import 'package:built_collection/built_collection.dart';

class BuiltCollectionBenchmark {
  final Map<String, void Function(ListBuilder<int>, Iterable<int>)>
      listBuilderFunctions = {
    'addAll': (b, iterable) => b.addAll(iterable),
    'insertAll': (b, iterable) => b.insertAll(0, iterable),
    'setAll': (b, iterable) => b.setAll(0, iterable),
    'setRange': (b, iterable) => b.setRange(0, 1000, iterable),
    'replaceRange': (b, iterable) => b.replaceRange(0, 1000, iterable),
  };

  Future<void> run() async {
    await benchmarkListBuilder();
  }

  Future<void> benchmarkListBuilder() async {
    for (var entry in listBuilderFunctions.entries) {
      var name = entry.key;
      var function = entry.value;

      Iterable<int> list = List<int>.generate(1000, (x) => x);
      Iterable<int> lazyIterable = list.map(_shortDelay);
      var builderFactory = () => ListBuilder<int>()..addAll(list);

      _benchmark('ListBuilder.$name,list', function, builderFactory, list);
      _benchmark('ListBuilder.$name,slow lazy iterable', function,
          builderFactory, lazyIterable);
    }
  }
}

void _benchmark<B, D>(String name, void Function(B, D) function,
    B Function() builderFactory, D data) {
  var counts = <int>[];

  /// Run four times; first is to warm up, remaining three are reported.
  for (var runs = 0; runs != 4; ++runs) {
    /// Run for one second and count how many iterations are completed.
    var stopwatch = Stopwatch()..start();
    var count = 0;
    while (stopwatch.elapsedMilliseconds < 1000) {
      var builder = builderFactory();
      for (var j = 0; j != 100; ++j) {
        function(builder, data);
      }
      ++count;
    }
    counts.add(count);
  }

  print('$name,${counts[1]},${counts[2]},${counts[3]}');
}

T _shortDelay<T>(T element) {
  var total = 0;
  for (var i = 0; i != 100; ++i) {
    total += i;
  }
  if (total == 0) return null;
  return element;
}
