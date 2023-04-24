import 'package:lyell/lyell.dart';

import 'implementation.dart';

@TypeToken<String>()
class BAC {}

class NonCascadingObject<T> {

}

const TestAnnotation test = TestAnnotation("Hello World!",
    sym: #MySymbol,
    li: [1, 2, 3],
    map: {"yes": true, "no": false},
    n1: N1Obj("Moin!", [N2Obj(true), N2Obj(true), N2Obj(false)]));