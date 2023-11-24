import 'package:lyell/lyell.dart';

class FunctionAnnotation implements RetainedAnnotation {
  final Function functionRef;

  const FunctionAnnotation(this.functionRef);
}


void topLevelFunc() {}

class SomeClass {
  static void staticFunc() {}
}

/// @@Marker
@FunctionAnnotation(topLevelFunc)
@FunctionAnnotation(SomeClass.staticFunc)
class Test {

}