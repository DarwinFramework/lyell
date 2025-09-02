import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:lyell_gen/lyell_gen.dart';

extension GenExtension<T extends Element2> on SubjectGenContext<T> {
  // Unused
}

extension CodeExtension on SubjectCodeContext {
  String typeName(DartType? type) => cachedCounter.get(type!);

  String className(ClassElement2 element) =>
      cachedCounter.get(element.thisType);

  String constantSource(DartObject? object) => cachedCounter.toSource(object!);

  String annotationSource(ElementAnnotation element) =>
      constantSource(element.computeConstantValue());
}

extension DartTypeExtensions on DartType {
  /// Returns the display name of the type without a trailing '?' for nullability.
  String get displayName {
    var str = getDisplayString();
    if (str.endsWith("?")) {
      return str.substring(0, str.length - 1);
    }
    return str;
  }
}
