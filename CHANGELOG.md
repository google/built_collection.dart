# Changelog

## 2.0.0

- Split collection classes into abstract interfaces and concrete, private,
  implementations. This allows new implementations of the interfaces. Note that
  this change is invisible _unless_ you rely on the exact `runtimeType` of the
  collections.

## 1.6.2

- Fix a bug whereby `ListBuilder` and `MapBuilder` allowed nulls to be
  introduced via `map` and `expand`.

## 1.6.1

- Allow quiver 0.26.

## 1.6.0

- The addIterable method is now generic. This allows the types of the functions
  passed in to be inferred.

## 1.5.0

- Add BuiltIterable interface for when you want to accept a BuiltList or BuiltSet.

## 1.4.1

- Use real generic syntax, drop comment-based syntax.

## 1.4.0

- Add operator[] to ListBuilder and MapBuilder for easier inline updates.

## 1.3.1

- Allow quiver 0.25.

## 1.3.0

- Widen parameter of BuiltSet.difference and BuiltSet.intersection to
  `BuiltSet<Object>` to match Set.

## 1.2.0

- Update for Set.difference change in SDK 1.21.0.
- Add `asList`, `asMap`, and `asSet` to the built collection classes.

## 1.1.0

- Remove runtime checks that are unnecessary if the project using
  built_collection is "strong mode clean", that is, if it has no errors with
  strong mode. See note in `README.md` about strong mode.

## 1.0.6

- Allow quiver 0.23.

## 1.0.5

- Strong mode clean.

## 1.0.4

- Add reference identity check to equals operators.

## 1.0.3

- Fix factories when iterable generic type is subtype of requested type.

## 1.0.2

- Add generic type information to map, fold and expand methods.

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
