import 'package:implementation/thirdFile.dart';
import 'package:lyell/lyell.dart';

class ComplexConst implements RetainedAnnotation {
  final Object val;

  const ComplexConst(this.val);
}

abstract class ComplexInner {
  static const ComplexInner constInst = _PrivateInner();
  const ComplexInner();
}

class _PrivateInner extends ComplexInner {
  const _PrivateInner();
}

class PublicInner extends ComplexInner {
  const PublicInner();
}

class ForceSecondary {
  final int val;
  final int hidden;
  const ForceSecondary._(this.val, this.hidden);

  const ForceSecondary.named(int v) : val = v, hidden = v + 1;
}

enum TestEnum {
  a,b
}

const globalInner = _PrivateInner();

// This is still technically publicly accessible
const _privateGlobalInner = PublicInner();

/// @@Marker
@ComplexConst(ComplexInner.constInst)
@ComplexConst(globalInner)
@ComplexConst(_privateGlobalInner)
@ComplexConst(#test)
@ComplexConst("\\\\\\This \\\\is\"\"'' a \\string\$\n🇩🇪")
@ComplexConst(generator)
@ComplexConst(foreignGenerator)
@ComplexConst(InsideGenerator.generator)
@ComplexConst(identical)
@ComplexConst(ForceSecondary.named(10))
@ComplexConst(TestEnum.a)
class TestCase {

}

String generator() {
  return "Hello World!";
}