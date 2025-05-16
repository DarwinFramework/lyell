# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-05-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.4.3`](#lyell---v143)
 - [`lyell_gen` - `v3.0.7`](#lyell_gen---v307)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.7`

---

#### `lyell` - `v1.4.3`

 - **FIX**: naming for unsafe runtime types now works properly, and base getters return clones without arguments for both unsafe runtime captures and synthetic types.


## 2025-05-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.4.2`](#lyell---v142)
 - [`lyell_gen` - `v3.0.6`](#lyell_gen---v306)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.6`

---

#### `lyell` - `v1.4.2`

 - **FIX**: hashing for unsafe runtime type capture and proper equality checks.


## 2025-05-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.4.1`](#lyell---v141)
 - [`lyell_gen` - `v3.0.5`](#lyell_gen---v305)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.5`

---

#### `lyell` - `v1.4.1`

 - **FIX**: Synthetic Type Capture didn't return itself as base.


## 2025-05-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.4.0`](#lyell---v140)
 - [`lyell_gen` - `v3.0.4`](#lyell_gen---v304)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.4`

---

#### `lyell` - `v1.4.0`

 - **REFACTOR**: enhance QualifiedTypeTree implementation and improve equality checks.
 - **FEAT**: improve type capture methods and add SyntheticTypeCapture class.


## 2025-03-18

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.3.2`](#lyell---v132)
 - [`lyell_gen` - `v3.0.3`](#lyell_gen---v303)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.3`

---

#### `lyell` - `v1.3.2`

 - **FIX**: I forgot to add the arguments as a constructor parameter.


## 2025-03-18

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.3.1`](#lyell---v131)
 - [`lyell_gen` - `v3.0.2`](#lyell_gen---v302)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.2`

---

#### `lyell` - `v1.3.1`

 - **FIX**: implement type tree for unsafe runtime type capture for easy usage.


## 2025-03-18

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`lyell` - `v1.3.0`](#lyell---v130)
 - [`lyell_gen` - `v3.0.1`](#lyell_gen---v301)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `lyell_gen` - `v3.0.1`

---

#### `lyell` - `v1.3.0`

 - **FEAT**: add UnsafeRuntimeTypeCapture for limited runtime type support.
 - **FEAT**: add additional extensions for handling not qualified type trees.
 - **FEAT**: terminal and primitive type tree factory methods return qualified type tress now.


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

