import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:lyell_gen/lyell_gen.dart';

class GeneratedAssociatedItemTypeToken {
  final DartType origin;
  final DartType item;

  GeneratedAssociatedItemTypeToken(this.origin, this.item);

  String get code =>
      "ItemAssociatedTypeToken<${origin.getDisplayString(withNullability: false)},${item.getDisplayString(withNullability: false)}>()";

  String get prefixedCode => genPrefix.str(code);

  String prefixedCodeWithAliasedTypes(CachedAliasCounter counter) {
    return genPrefix.str(
        "ItemAssociatedTypeToken<${counter.get(origin)},${counter.get(item)}>()");
  }
}

class GeneratedTypeToken {
  final DartType type;

  GeneratedTypeToken(this.type);

  String get code =>
      "TypeToken<${type.getDisplayString(withNullability: false)}>()";

  String get prefixedCode => genPrefix.str(code);

  String prefixedCodeWithAliasedTypes(CachedAliasCounter counter) {
    return genPrefix.str("TypeToken<${counter.get(type)}>()");
  }
}

class GeneratedTypeTree {

  DartType qualified;
  DartType base;
  List<GeneratedTypeTree> parameters;

  GeneratedTypeTree(this.qualified, this.base, this.parameters);

  String code(CachedAliasCounter counter) {
    if (parameters.isEmpty) {
      return "gen.QualifiedTerminal<${counter.get(qualified)}>()";
    }
    return "gen.QualifiedTypeTreeN<${counter.get(qualified)},${counter.get(base)}>([${parameters.map((e) => e.code(counter)).join(",")}])";
  }


}

GeneratedTypeToken getTypeToken(DartType type) => GeneratedTypeToken(type);

Future<GeneratedAssociatedItemTypeToken> getAssociatedTypeToken(
    DartType type, BuildStep step) async {
  var itemType = await getItemType(type, step);
  return GeneratedAssociatedItemTypeToken(type, itemType);
}

GeneratedTypeTree getTypeTree(DartType type) {
  if (type is InterfaceType && type.typeArguments.isNotEmpty) {
    var neutralTypeArgs = <DartType>[];
    for (var element in type.element3.typeParameters2) {
      if (element.bound == null) {
        neutralTypeArgs.add(coreLibraryReader.element.typeProvider.dynamicType);
      } else {
        neutralTypeArgs.add(element.bound!);
      }
    }
    return GeneratedTypeTree(type,type.element3.instantiate(typeArguments: neutralTypeArgs, nullabilitySuffix: NullabilitySuffix.none), type.typeArguments.map((e) => getTypeTree(e)).toList());
  } else {
    return GeneratedTypeTree(type, type, []);
  }
}