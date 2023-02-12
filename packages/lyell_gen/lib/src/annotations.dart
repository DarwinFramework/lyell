import 'package:analyzer/dart/element/element.dart';
import 'package:lyell_gen/lyell_gen.dart';

String getRetainedAnnotationSourceArray(Element element) {
  var annotations = <String>[];
  for (var value
      in element.metadata.whereTypeChecker(retainedAnnotationChecker)) {
    annotations.add(value.toSource().substring(1));
  }
  if (annotations.isEmpty) return "[]";
  return "[${annotations.join(", ")}]";
}

GeneratedRetainedAnnotations getRetainedAnnotations(Element element) {
  return GeneratedRetainedAnnotations(
      getRetainedAnnotationSourceArray(element));
}

class GeneratedRetainedAnnotations {
  String sourceArray;

  GeneratedRetainedAnnotations(this.sourceArray);

  String get container => "RetainedAnnotationContainer($sourceArray)";
  String get prefixedContainer => genPrefix.str(container);
}
