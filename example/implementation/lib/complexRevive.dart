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
class TestCase {

}

String generator() {
  return "Hello World!";
}