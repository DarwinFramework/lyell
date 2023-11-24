import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:lyell_gen/lyell_gen.dart';
import 'package:source_gen/source_gen.dart';

import 'libraries.dart';

const String genAlias = "gen";
final AliasedPrefix genPrefix = AliasedPrefix(genAlias);

/// Representation of an possibly aliased/"prefixed" import statement.
class AliasImport {
  final String import;
  final String? alias;

  const AliasImport(this.import, this.alias);

  factory AliasImport.root(String import) => AliasImport(import, null);

  factory AliasImport.gen(String import) => AliasImport(import, genAlias);

  factory AliasImport.type(DartType type, [String? alias]) {
    return AliasImport(type.import!, alias);
  }

  factory AliasImport.library(LibraryElement element, [String? alias]) {
    return AliasImport(element.source.uri.toString(), alias);
  }

  String get code => "import '$import'${alias == null ? "" : " as $alias"};";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AliasImport &&
          runtimeType == other.runtimeType &&
          import == other.import &&
          alias == other.alias;

  @override
  int get hashCode => import.hashCode ^ alias.hashCode;
}

/// Returns the most "wide" import for [type].
///
/// An import is considered wide when it is the most unspecific import for a given
/// type. When [type] is exported by its library, the library will be referenced,
/// otherwise the direct source file of the [type] will be referenced as the type
/// would be unreachable via just importing the library.
@Deprecated("Use getImport() instead.")
String getWidestImport(DartType type) {
  return getImport(type)!;
}


/// Utility for creating a non partial augmentation class for the give asset [id]
/// with the [library]. The [additional] imports are also added to the the import
/// string.
String getImportString(LibraryElement? library, AssetId? id,
    [List<AliasImport> additional = const []]) {
  Set<AliasImport> importValues = <AliasImport>{};
  importValues.addAll(additional);
  if (id != null) importValues.add(AliasImport.root(id.uri.toString()));
  if (library != null) {
    for (var element in library.libraryImports) {
      importValues.add(AliasImport(element.importedLibrary!.identifier,
          element.prefix?.element.displayName));
    }
  }
  return importValues.map((e) => e.code).join("\n");
}

/// Utility for creating a import sections of dart files.
String createImports(
    {LibraryElement? library,
    AssetId? id,
    List<AliasImport>? imports,
    bool includeDartCore = true}) {
  Set<AliasImport> importValues = <AliasImport>{};
  if (includeDartCore) importValues.add(AliasImport.root("dart:core"));
  if (imports != null) importValues.addAll(imports);
  if (id != null) importValues.add(AliasImport.root(id.uri.toString()));
  if (library != null) {
    for (var element in library.libraryImports) {
      importValues.add(AliasImport(element.importedLibrary!.identifier,
          element.prefix?.element.displayName));
    }
  }
  return importValues.map((e) => e.code).join("\n");
}

/// Utility for incrementally generating aliases for imports to avoid conflicts.
class AliasCounter extends TypeStringifier {
  List<AliasImport> imports = [];
  int _value = 0;

  AliasCounter();

  AliasCounter.withImports(this.imports);

  int getAndIncrement() {
    return _value++;
  }

  /// Increments and gets the next [AliasedPrefix].
  AliasedPrefix getNextPrefix([String prefix = genAlias]) {
    return AliasedPrefix("$prefix${getAndIncrement()}");
  }

  /// Generates an ephemeral import alias for [type] and saves the import to
  /// [importBuffer]. The generation prefix can be overridden by using [prefixOverride].
  String ephemeral(DartType type,
      [List<AliasImport>? importBuffer, String prefixOverride = genAlias]) {
    var prefix = getNextPrefix(prefixOverride);
    if (importBuffer != null) {
      importBuffer.add(AliasImport.type(type, prefix.prefix));
    }
    imports.add(AliasImport.type(type, prefix.prefix));
    var element = type.element!;
    if (type is ParameterizedType && type.typeArguments.isNotEmpty) {
      return prefix.str(
          "${element.name}<${type.typeArguments.map((e) => ephemeral(e, importBuffer, prefixOverride)).join(",")}>");
    } else {
      return prefix.str(element.name!);
    }
  }

  @override
  String get(DartType type, [AliasedPrefix? prefix]) {
    return ephemeral(type, null, (prefix ?? genPrefix).prefix);
  }

  @override
  String getLibraryAlias(LibraryElement element) {
    var importString = element.source.uri.toString();
    var alias = getNextPrefix().prefix;
    imports.add(AliasImport.library(element, alias));
    return alias;
  }
}

/// Utility for generating cached incrementally generated aliases using [AliasCounter].
class CachedAliasCounter extends TypeStringifier {
  List<AliasImport> imports = [];
  Map<String, AliasedPrefix> importPrefixes = {};
  AliasCounter counter;

  CachedAliasCounter(this.counter);

  CachedAliasCounter.withImports(this.counter, this.imports);

  /// Retrieves the import alias for [import].
  AliasedPrefix getImportAlias(String import) {
    if (importPrefixes.containsKey(import)) {
      return importPrefixes[import]!;
    } else {
      var prefix = counter.getNextPrefix();
      importPrefixes[import] = prefix;
      imports.add(AliasImport(import, prefix.prefix));
      return prefix;
    }
  }

  /// Retrieves the import alias for [type].
  @override
  String get(DartType type, [AliasedPrefix? prefix]) {
    var import = type.import;
    if (import == null) {
      return type.getDisplayString(withNullability: false);
    }
    var prefix = getImportAlias(import);
    var element = type.element!;
    if (type is ParameterizedType && type.typeArguments.isNotEmpty) {
      return prefix.str(
          "${element.name}<${type.typeArguments.map((e) => get(e)).join(",")}>");
    } else {
      return prefix.str(element.name!);
    }
  }

  String mapParameter(ParameterElement element, DartObject? object) {
    if (object == null || object.isNull) return "null";
    return object.toString();
  }

  @override
  String getLibraryAlias(LibraryElement element) {
    var importString = element.source.uri.toString();
    return getImportAlias(importString).prefix;
  }
}

abstract class TypeStringifier {
  String get(DartType type, [AliasedPrefix? prefix]);

  String getLibraryAlias(LibraryElement element);


  /// Converts a compile-time evaluated [DartObject] to an aliased source
  /// representation where all types are incrementally aliased using this
  /// [CachedAliasCounter].
  ///
  /// Note: Function and accessor references are currently not supported!
  String toSource(DartObject object) {
    var reader = ConstantReader(object);
    // Handle primitive dart objects
    if (reader.isNull) return "null";
    if (reader.isInt) return reader.intValue.toString();
    if (reader.isDouble) return reader.doubleValue.toString();
    if (reader.isBool) return reader.boolValue.toString();
    if (reader.isString) return "'${reader.stringValue.toString()}'";
    if (reader.isSymbol) return reader.symbolValue.toString();
    if (reader.isType) return get(reader.typeValue);

    // Handle generic collections
    if (reader.isList) {
      return "[${reader.listValue.map((e) => toSource(e)).join(",")}]";
    }
    if (reader.isSet) {
      return "{${reader.setValue.map((e) => toSource(e)).join(",")}}";
    }
    if (reader.isMap) {
      return "{${reader.mapValue.map((key, value) => MapEntry(toSource(key!), toSource(value!))).entries.map((e) => "${e.key}:${e.value}").join(",")}}";
    }

    // Handle objects
    if (object.type!.isDartCoreFunction) {
      throw UnsupportedError("Functions are not supported");
    }
    var revived = reader.revive();
    var type = get(object.type!);

    // Construct arguments
    StringBuffer args = StringBuffer();
    for (var element in revived.positionalArguments) {
      args.write(toSource(element));
      args.write(",");
    }
    for (var element in revived.namedArguments.entries) {
      args.write(element.key);
      args.write(":");
      args.write(toSource(element.value));
      args.write(",");
    }
    var builtArgs = args.toString();
    // Remove trailing ','
    if (builtArgs.endsWith(",")) {
      builtArgs = builtArgs.substring(0, builtArgs.length - 1);
    }
    return "$type($builtArgs)";
  }
}

class AliasedPrefix {
  String prefix;

  AliasedPrefix(this.prefix);

  @override
  String toString() {
    return prefix;
  }

  String type(DartType type) {
    return "$prefix.${type.getDisplayString(withNullability: false)}";
  }

  String str(String str) {
    return "$prefix.$str";
  }
}
