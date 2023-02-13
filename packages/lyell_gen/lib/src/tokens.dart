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
    return genPrefix.str("ItemAssociatedTypeToken<${counter.get(origin)},${counter.get(item)}>()");
  }

}

class GeneratedTypeToken {
  final DartType type;

  GeneratedTypeToken(this.type);

  String get code =>
      "TypeToken<${type.getDisplayString(withNullability: false)}>()";

  String get prefixedCode => genPrefix.str(code);

  String prefixedCodeWithAliasedTypes(CachedAliasCounter counter) {
    return genPrefix.str("TypeToken<${counter.get(type)}}>()");
  }
}

GeneratedTypeToken getTypeToken(DartType type) => GeneratedTypeToken(type);

Future<GeneratedAssociatedItemTypeToken> getAssociatedTypeToken(
    DartType type, BuildStep step) async {
  var itemType = await getItemType(type, step);
  return GeneratedAssociatedItemTypeToken(type, itemType);
}
