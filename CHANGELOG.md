# Changelog

## 1.0.1

- Make map operator[] take Object instead of K, as SDK collections do.
- Fix toString for result of toList, toSet, toMap.

## 1.0.0

- Fix missing generics on some return types.
- Fix BuiltList and BuiltSet "contains" method, should take Object, not E.
- Add removeAll and retainAll methods to SetBuilder.
- Add BuiltList.toBuiltSet() and BuiltSet.toBuiltList().
- Add addIterable methods to Map and Multimap builders.

## 0.4.0

- Add BuiltSetMultimap.

## 0.3.1

- Fix "part of" statement.

## 0.3.0

- Bug fix: fix Iterable "update in place" methods of BuiltList and BuiltSet so they discard original list or set.
- Make keys and values stable for BuiltMap and BuiltMultimap.
- Make repeated builds return identical instances for BuiltList, BuiltMap, BuiltSet.
- Add 'replace' methods.

## 0.2.0

- Add BuiltListMultimap.

## 0.1.1

- Fix comments.

## 0.1.0

- Add build and rebuild methods to BuiltList, BuiltMap, BuiltSet.
- Add update methods to ListBuilder, MapBuilder, SetBuilder.

## 0.0.1

- Initial version.
