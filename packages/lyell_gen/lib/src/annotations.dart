import 'package:analyzer/dart/element/element.dart';
import 'package:lyell_gen/lyell_gen.dart';

String getRetainedAnnotationSourceArray(Element element,
    [CachedAliasCounter? counter]) {
  var annotations = <String>[];
  for (var value
      in element.metadata.annotations.whereTypeChecker(retainedAnnotationChecker)) {
    if (counter == null) {
      annotations.add(value.toSource().substring(1));
    } else {
      var innerElement = value.element;
      if (innerElement is ConstructorElement) {
        annotations.add(counter.toSource(value.computeConstantValue()!));
      } else if (innerElement is PropertyAccessorElement) {
        if (innerElement.isPrivate) {
          annotations.add(counter.toSource(value.computeConstantValue()!));
        } else {
          var alias = counter.getImportAlias(innerElement.library.firstFragment.source.uri.toString());
          annotations.add("${alias.prefix}.${innerElement.name}");
        }
      } else {
        print("Unexpected inner element of type ${innerElement.runtimeType}");
      }
    }
  }
  if (annotations.isEmpty) return "[]";
  return "[${annotations.join(", ")}]";
}

GeneratedRetainedAnnotations getRetainedAnnotations(Element element,
    [CachedAliasCounter? counter]) {
  return GeneratedRetainedAnnotations(
      getRetainedAnnotationSourceArray(element, counter));
}

class GeneratedRetainedAnnotations {
  String sourceArray;

  GeneratedRetainedAnnotations(this.sourceArray);

  String get container => "RetainedAnnotationContainer($sourceArray)";

  String get prefixedContainer => genPrefix.str(container);
}
