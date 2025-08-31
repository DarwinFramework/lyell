import 'dart:math';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:lyell_gen/lyell_gen.dart';

String getRetainedAnnotationSourceArray(Element2 element,
    [CachedAliasCounter? counter]) {

  if (element is! Annotatable) {
    throw ArgumentError("Element of type ${element.runtimeType} is not Annotatable");
  }
  var annotatable = element as Annotatable;
  var annotations = <String>[];
  for (var value
      in annotatable.metadata2.annotations.whereTypeChecker(retainedAnnotationChecker)) {
    if (counter == null) {
      annotations.add(value.toSource().substring(1));
    } else {
      var innerElement = value.element2;
      if (innerElement is ConstructorElement2) {
        annotations.add(counter.toSource(value.computeConstantValue()!));
      } else if (innerElement is PropertyAccessorElement2) {
        if (innerElement.isPrivate) {
          annotations.add(counter.toSource(value.computeConstantValue()!));
        } else {
          var alias = counter.getImportAlias(innerElement.library2.firstFragment.source.uri.toString());
          annotations.add("${alias.prefix}.${innerElement.displayName}");
        }
      } else {
        print("Unexpected inner element of type ${innerElement.runtimeType}");
      }
    }
  }
  if (annotations.isEmpty) return "[]";
  return "[${annotations.join(", ")}]";
}

GeneratedRetainedAnnotations getRetainedAnnotations(Element2 element,
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
