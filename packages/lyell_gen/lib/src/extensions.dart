import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:lyell_gen/lyell_gen.dart';
import 'package:source_gen/source_gen.dart';

extension GenExtension<T extends Element2> on SubjectGenContext<T> {
  // Unused
}

extension CodeExtension on SubjectCodeContext {
  String typeName(DartType? type) => cachedCounter.get(type!);
  String className(ClassElement2 element) => cachedCounter.get(element.thisType);
  String constantSource(DartObject? object) => cachedCounter.toSource(object!);
  String annotationSource(ElementAnnotation element) => constantSource(element.computeConstantValue());
}