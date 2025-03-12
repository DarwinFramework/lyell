# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-03-12

### Changes

---

Packages with breaking changes:

 - [`lyell_gen` - `v3.0.0`](#lyell_gen---v300)

Packages with other changes:

 - There are no other changes in this release.

---

#### `lyell_gen` - `v3.0.0`

 - **BREAKING** **REFACTOR**: actually update to the newest analyzer version, I should have done that a long time ago.


## 2025-03-12

### Changes

---

Packages with breaking changes:

 - [`lyell_gen` - `v2.0.0`](#lyell_gen---v200)

Packages with other changes:

 - [`lyell` - `v1.2.0`](#lyell---v120)

---

#### `lyell_gen` - `v2.0.0`

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

#### `lyell` - `v1.2.0`

 - **FEAT**: add and use qualified trees.
 - **FEAT**: add TypeTrees.
 - **FEAT**: add collection casts.
 - **FEAT**: improve alias capabilities.


## 2024-02-21

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.3.1`](#lyell_gen---v131)

---

#### `lyell_gen` - `v1.3.1`

 - **FIX**: header colliding with code because of missing newlines.


## 2024-02-01

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.3.0`](#lyell_gen---v130)

---

#### `lyell_gen` - `v1.3.0`

 - **FEAT**: add header for generated files.


## 2024-01-23

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.2.4+1`](#lyell_gen---v1241)

---

#### `lyell_gen` - `v1.2.4+1`


## 2024-01-14

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.2.4`](#lyell_gen---v124)

---

#### `lyell_gen` - `v1.2.4`

 - **FIX**: fix support for enums, by using InterfaceElement instead of ClassElement.


## 2024-01-14

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.2.3`](#lyell_gen---v123)

---

#### `lyell_gen` - `v1.2.3`

 - **FIX**: support named constructors.


## 2023-12-14

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.2.2`](#lyell_gen---v122)

---

#### `lyell_gen` - `v1.2.2`

 - **REFACTOR**: remove unused imports and fix alias naming.
 - **FIX**: edge-cases where top level functions aren't resolved correctly.


## 2023-12-11

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.2.1`](#lyell_gen---v121)

---

#### `lyell_gen` - `v1.2.1`

 - **FIX**: handle strings with content that requires escapes.


## 2023-11-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell_gen` - `v1.2.0`](#lyell_gen---v120)

---

#### `lyell_gen` - `v1.2.0`

 - **FIX**: remove UnsupportedError for now implemented feature.
 - **FEAT**: handle functions in toSource.
 - **FEAT**: handle variable references in toSource.
 - **FEAT**: add getLibraryAlias.

