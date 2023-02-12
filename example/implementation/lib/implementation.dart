import 'package:lyell/lyell.dart';

int calculate() {
  return 6 * 7;
}

/// @@Marker
@TestAnnotation("Hello World!")
class TestClass {

  String a;
  List<String> b;
  bool c;
  CascadingObject<int> d;
  NonCascadingObject<bool> e;

  TestClass(this.a, this.b, this.c, this.d, this.e);
}

class TestAnnotation extends RetainedAnnotation {

  final String name;
  const TestAnnotation(this.name);

}

class CascadingObject<T> extends CascadeItemType<T> {

}

class NonCascadingObject<T> {

}

@TypeToken<String>()
class AAC {}