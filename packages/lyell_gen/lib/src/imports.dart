import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';

const String genAlias = "gen";
final AliasedPrefix genPrefix = AliasedPrefix(genAlias);

class AliasImport {
  final String import;
  final String? alias;

  const AliasImport(this.import, this.alias);

  factory AliasImport.root(String import) => AliasImport(import, null);
  factory AliasImport.gen(String import) => AliasImport(import, genAlias);
  factory AliasImport.type(DartType type, [String? alias]) {
    return AliasImport(type.element!.library!.identifier, alias);
  }
  factory AliasImport.library(LibraryElement element, [String? alias]) {
    return AliasImport(element.identifier, alias);
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

/// Utility for incrementally generating aliases for imports to avoid conflicts.
class AliasReferenceCounter {
  int _value = 0;

  int getAndIncrement() {
    return _value++;
  }

  AliasedPrefix getNextPrefix([String prefix = genAlias]) {
    return AliasedPrefix("$prefix${getAndIncrement()}");
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
