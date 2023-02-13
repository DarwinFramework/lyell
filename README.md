# Lyell
Generator utilities used by darwin and dogs.

## Contents
- **AliasedImport**  
Utilities for working with aliased imports and file augmentations which don't use partial files.
- **AliasCounter**  
Incremental import alias generator to avoid conflicting type names. 
- **CachedAliasCounter**  
Cached version of the alias counter also capable of generating an alias source representation of
constantly evaluable dart objects like annotations. 
- **TypeTokens**  
Utility for deriving other common types from origin types, like getting the list type.
- **ItemType Introspection**  
Generator utility for retrieving the item type of any given DartType.
- **Retained Annotations**  
Utility for retaining and exposing annotations to runtime code via annotation containers. 
- **Subject Adapters & Reactor**  
Adapters for creating reactor based builders.