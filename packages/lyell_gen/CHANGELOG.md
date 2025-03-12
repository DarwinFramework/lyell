## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: actually update to the newest analyzer version, I should have done that a long time ago.

## 2.0.0

> Note: This release has breaking changes.

 - **REFACTOR**: remove unused imports and fix alias naming.
 - **REFACTOR**: update CachedAliasCounter and fixed get(void).
 - **REFACTOR**: add clarifying brackets.
 - **REFACTOR**: reformat code.
 - **FIX**: header colliding with code because of missing newlines.
 - **FIX**: fix support for enums, by using InterfaceElement instead of ClassElement.
 - **FIX**: support named constructors.
 - **FIX**: edge-cases where top level functions aren't resolved correctly.
 - **FIX**: handle strings with content that requires escapes.
 - **FIX**: remove UnsupportedError for now implemented feature.
 - **FIX**: use the right element library.
 - **FIX**: improve const getter based annotation handling in toSource().
 - **FIX**: descriptor uri now points towards the generated file, not the source file.
 - **FIX**: add missing return clauses.
 - **FEAT**: add header for generated files.
 - **FEAT**: handle functions in toSource.
 - **FEAT**: handle variable references in toSource.
 - **FEAT**: add getLibraryAlias.
 - **FEAT**: add and use qualified trees.
 - **FEAT**: add TypeTrees.
 - **FEAT**: improve alias capabilities.
 - **BREAKING** **REFACTOR**: fix naming, add qol features.
 - **BREAKING** **FEAT**: add library proxies for extensible imports, add locks to tryInitialize, add serialize.

## 1.3.1

 - **FIX**: header colliding with code because of missing newlines.

## 1.3.0

 - **FEAT**: add header for generated files.

## 1.2.4+1

## 1.2.4

 - **FIX**: fix support for enums, by using InterfaceElement instead of ClassElement.

## 1.2.3

 - **FIX**: support named constructors.

## 1.2.2

 - **REFACTOR**: remove unused imports and fix alias naming.
 - **FIX**: edge-cases where top level functions aren't resolved correctly.

## 1.2.1

 - **FIX**: handle strings with content that requires escapes.

## 1.2.0

 - **FIX**: remove UnsupportedError for now implemented feature.
 - **FEAT**: handle functions in toSource.
 - **FEAT**: handle variable references in toSource.
 - **FEAT**: add getLibraryAlias.

## 1.1.0

 - **FEAT**: add and use qualified trees.

## 1.0.0

 - **FEAT**: add TypeTrees.

## 0.2.0+3

 - **FIX**: use the right element library.

## 0.2.0+2

 - **FIX**: improve const getter based annotation handling in toSource().

## 0.2.0+1

 - Update a dependency to the latest release.

## 0.2.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: add library proxies for extensible imports, add locks to tryInitialize, add serialize.

## 0.1.0

> Note: This release has breaking changes.

 - **REFACTOR**: update CachedAliasCounter and fixed get(void).
 - **REFACTOR**: add clarifying brackets.
 - **BREAKING** **REFACTOR**: fix naming, add qol features.

## 0.0.2

 - **REFACTOR**: reformat code.
 - **FEAT**: improve alias capabilities.

## 0.0.1+2

 - **FIX**: descriptor uri now points towards the generated file, not the source file.

## 0.0.1+1

 - **FIX**: add missing return clauses.

## 0.0.1

- Initial version.
