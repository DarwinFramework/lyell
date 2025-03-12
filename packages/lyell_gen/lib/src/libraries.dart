import 'dart:async';
import 'dart:ffi';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:lyell_gen/lyell_gen.dart';

/// Interface for defining proxies used by [getImport] and [getLibrary].
abstract class LibraryProxy {
  bool acceptsType(DartType type);
  bool acceptsImport(String import);

  String? getImport(DartType type);
  FutureOr<LibraryElement> getLibrary(String import, BuildStep step);
}

/// Library proxy for dart:* imports.
class DartCoreLibrariesProxy extends LibraryProxy {
  @override
  bool acceptsImport(String import) {
    return import.startsWith("dart:");
  }

  @override
  bool acceptsType(DartType type) {
    String? uri = type.element?.source?.uri.toString();
    if (uri == null) return false;
    return uri.startsWith("dart:");
  }

  @override
  String? getImport(DartType type) {
    return type.element?.source?.uri.toString().split("/").first;
  }

  @override
  Future<LibraryElement> getLibrary(String import, BuildStep step) async {
    var lib = import.split("/").first.replaceFirst("dart:", "");

    // Try to rewrite private libraries
    if (lib.startsWith("_")) {
      switch(lib) {
        case "_http":
          lib = "io";
          break;
        default:
          throw Exception("Unresolvable private core library $lib");
      }
    }

    var element = await step.resolver.findLibraryByName("dart.$lib");
    if (element == null) throw Exception("Can't resolve core library $lib");
    return element;
  }
}

List<LibraryProxy> libraryProxies = [
  DartCoreLibrariesProxy()
];

/// Returns the library associated with the [import] string.
Future<LibraryElement> getLibrary(String import, BuildStep step) async {
  await tryInitialize(step);
  for (var element in libraryProxies) {
    if (element.acceptsImport(import)) {
      return await element.getLibrary(import, step);
    }
  }

  var resolver = step.resolver;
  return await resolver.libraryFor(AssetId.resolve(Uri.parse(import)));
}

/// Returns a possible import string to refer to [type].
/// Will be null if the type is of type [void], [dynamic] or is otherwise
/// unresolvable. To handle unexpected edge-cases, provide a [LibraryProxy]
/// using [libraryProxies].
String? getImport(DartType type) {
  // Handle special primitives that can't be directly resolved.
  if (type is VoidType || type is DynamicType) return null;

  // Check if library is being proxied.
  for (var element in libraryProxies) {
    if (element.acceptsType(type)) {
      return element.getImport(type);
    }
  }

  var library = type.element?.library;
  if (library == null) throw Exception("Can't get library of $type");
  var elementName = type.element?.name;
  if (elementName == null) throw Exception("Can't get element name of $type");

  // Prefer importing the type via the importing the defining library.
  if (library.getClass(elementName) != null) {
    return library.source.uri.toString();
  }

  // Import the type using its source address.
  var sourceUri = type.element?.source?.uri.toString();
  if (sourceUri == null) throw Exception("Can't get element source uri of $type");
  return sourceUri;
}

extension LibTypeExt on DartType {

  /// Resolves the library of this through [import], defaulting to dart:core.
  Future<LibraryElement> resolveLibrary(BuildStep step) async {
    var import = getImport(this);
    if (import == null) return coreLibraryReader.element;
    return await getLibrary(import, step);
  }

  /// Returns a possible import string to refer to this [DartType].
  /// Will be null if the type is of type [void], [dynamic] or is otherwise
  /// unresolvable. To handle unexpected edge-cases, provide a [LibraryProxy]
  /// using [libraryProxies].
  String? get import {
    return getImport(this);
  }
}


Future<DartType> getDartType(BuildStep step, String import, String type, [List<DartType> typeArguments = const []]) async {
  var library = await getLibrary(import, step);
  var clazz = library.getClass(type);
  if (clazz == null) throw ArgumentError.value(type, "type", "Type not found inside imported library '$library'");
  if (typeArguments.isEmpty) {
    return clazz.thisType;
  } else {
    return clazz.instantiate(typeArguments: typeArguments, nullabilitySuffix: NullabilitySuffix.none);
  }
}