# Lyell
Generator utilities used by darwin and dogs.

## Contents
- **Library & Type Resolution**
Utilities for easily resolving types and library at runtime in builder environments.
- **DartType Serialization**
Serialization support for DartTypes for use in cached build files. 
- **AliasedImport**  
Utilities for working with aliased imports and file augmentations which don't use partial files.
- **AliasCounter**  
Incremental import alias generator to avoid conflicting type names. 
- **CachedAliasCounter**  
Cached version of the alias counter also capable of generating an alias source representation of
constantly evaluable dart objects like annotations. 
- **TypeCapture/TypeTokens**  
Utility for capturing types at runtime using generics. Also has default methods for deriving common
container types from the captured type.
- **TypeTrees**
A fully traversable representation of a type at runtime that uses captured generics.
- **ItemType Introspection**  
Generator utility for retrieving the item type of any given DartType.
- **Retained Annotations**  
Utility for retaining and exposing annotations to runtime code via annotation containers. 
- **Subject Adapters & Reactor**  
Adapters for creating reactor based builders.