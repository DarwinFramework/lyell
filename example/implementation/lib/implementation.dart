import 'package:lyell/lyell.dart';
import 'secondFile.dart';

part 'partFile.dart';

int calculate() {
  return 6 * 7;
}

/// @@Marker
@test
@SecondAnnotation()
@TestAnnotation("Hello World!",
    sym: #MySymbol,
    li: [1, 2, 3],
    map: {"yes": true, "no": false},
    n1: N1Obj("Moin!", [N2Obj(true), N2Obj(true), N2Obj(false)]))
class TestClass {
  String a;
  List<String> b;
  bool c;
  CascadingObject<int> d;
  NonCascadingObject<bool> e;
  List<bool> f;
  List<CascadingObject<int>> g;
  List<dynamic> h;
  Future<Stream<Symbol>> i;
  late RestrictedClassGeneric j;

  TestClass(this.a, this.b, this.c, this.d, this.e, this.f, this.g, this.h, this.i);


  void test() {
    print("Hello World!");
  }
}

class SecondAnnotation extends RetainedAnnotation {
  const SecondAnnotation();
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

class RestrictedClassGeneric<T extends num> {}