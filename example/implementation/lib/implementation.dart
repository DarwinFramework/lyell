import 'package:lyell/lyell.dart';
import 'secondFile.dart';

int calculate() {
  return 6 * 7;
}

const TestAnnotation test = TestAnnotation("Hello World!",
    sym: #MySymbol,
    li: [1, 2, 3],
    map: {"yes": true, "no": false},
    n1: N1Obj("Moin!", [N2Obj(true), N2Obj(true), N2Obj(false)]));

/// @@Marker
@test
class TestClass {
  String a;
  List<String> b;
  bool c;
  CascadingObject<int> d;
  NonCascadingObject<bool> e;
  List<bool> f;
  List<CascadingObject<int>> g;

  TestClass(this.a, this.b, this.c, this.d, this.e, this.f, this.g);
}

class TestAnnotation extends RetainedAnnotation {
  final String name;
  final Symbol? sym;
  final List<int>? li;
  final Map<String, bool>? map;
  final N1Obj? n1;

  const TestAnnotation(
    this.name, {
    this.sym,
    this.li,
    this.map,
    this.n1,
  });
}

class CascadingObject<T> extends CascadeItemType<T> {}

// First level nested
class N1Obj {
  final String name;
  final List<N2Obj> n2;

  const N1Obj(this.name, this.n2);
}

// Second level nested
class N2Obj {
  final bool b;

  const N2Obj(this.b);
}

@TypeToken<String>()
class AAC {}
