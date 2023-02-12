import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:lyell/lyell.dart';
import 'package:lyell_gen/lyell_gen.dart';

abstract class TestSubjectAdapter extends SubjectAdapter<TypeToken<String>, ClassElement> {
  TestSubjectAdapter({required super.archetype, required super.annotation}) : super(descriptorExtension: 'tsd');
}

class TestSubjectImpl extends TestSubjectAdapter {
  TestSubjectImpl() : super(archetype: 'impl', annotation: RetainedAnnotation);

  @override
  FutureOr<SubjectDescriptor> generateBinding(SubjectGenContext<Element> context) {
    var descriptor = context.defaultBinding();
    descriptor.meta["names"] = context.matches.map((e) => e.name).toList();
    return descriptor;
  }

  @override
  FutureOr<void> generateSubject(SubjectGenContext<Element> genContext, SubjectCodeContext codeContext) {
    codeContext.codeBuffer.writeln("final names = [${genContext.matches.map((e) => "'${e.name}'").join(",")}];");
  }

}

class TestSubjectReactor extends SubjectReactorBuilder {
  TestSubjectReactor() : super('tsd', 'reactor.g.dart');

  @override
  FutureOr<void> buildReactor(List<SubjectDescriptor> descriptors, SubjectCodeContext code) {
    code.codeBuffer.writeln("final allNames = [${
        descriptors.expand((element) => (element.meta["names"] as List)
        .cast<String>().map((e) => "'$e'")).join(", ")
    }];");
    descriptors.forEach((element) {
      print(element.uri);
    });
  }
}