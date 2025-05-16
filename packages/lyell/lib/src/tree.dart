import 'package:collection/collection.dart';
import 'package:lyell/src/container.dart';
import 'package:lyell/src/qualified_tree.dart';

import 'lyell_base.dart';


class TokenTypeTrees {

  static TypeTree arg0(TypeCapture capture) => capture.consumeType(TypeTree.terminal);
  static TypeTree arg1(TypeCapture base, TypeCapture arg0) => TypeContainers
      .arg2(base,arg0).consume(TypeTree.arg1);
  static TypeTree arg2(TypeCapture base, TypeCapture arg0, TypeCapture arg1) => TypeContainers
      .arg3(base,arg0,arg1).consume(TypeTree.arg2);
  static TypeTree arg3(TypeCapture base, TypeCapture arg0, TypeCapture arg1, TypeCapture arg2) => TypeContainers
      .arg4(base,arg0,arg1,arg2).consume(TypeTree.arg3);
}


abstract class TypeTree<BASE> {

  static const TypeTree object = TypeTree0<Object>();
  static const TypeTree $string = TypeTree0<String>();
  static const TypeTree $int = TypeTree0<int>();
  static const TypeTree $double = TypeTree0<double>();
  static const TypeTree $bool = TypeTree0<bool>();

  TypeCapture<BASE> get base;
  List<TypeTree> get arguments;

  const TypeTree();

  @override
  int get hashCode => $hashCode(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is TypeTree) {
      if (other.isSynthetic) return false;
      return other.base.typeArgument == base.typeArgument &&
        const ListEquality().equals(arguments, other.arguments);
    } else  if (other is TypeCapture) {
      return other.typeArgument == base.typeArgument && arguments.isEmpty;
    }
    return false;
  }

  @override
  String toString() {
    return "~${$toString(this)}";
  }

  static TypeTree terminal<T>() => QualifiedTerminal<T>();
  static TypeTree arg0<T>() => QualifiedTerminal<T>();
  static TypeTree arg1<BASE,A>() => TypeTree1<BASE,A>();
  static TypeTree arg2<BASE,A,B>() => TypeTree2<BASE,A,B>();
  static TypeTree arg3<BASE,A,B,C>() => TypeTree3<BASE,A,B,C>();
  static TypeTree argN<BASE>(List<TypeTree> arguments) => TypeTreeN<BASE>(arguments);

  static TypeTree future<T>() => QualifiedTypeTree.future<T>();
  static TypeTree futureOr<T>() => QualifiedTypeTree.futureOr<T>();
  static TypeTree stream<T>() => QualifiedTypeTree.stream<T>();
  static TypeTree list<T>() => QualifiedTypeTree.list<T>();
  static TypeTree set<T>() => QualifiedTypeTree.set<T>();
  static TypeTree iterable<T>() => QualifiedTypeTree.iterable<T>();
  static TypeTree map<K,V>() => QualifiedTypeTree.map<K,V>();

  static String $toString(TypeTree tree) {
    if (tree.arguments.isEmpty) {
      return "${tree.base.typeArgument}";
    } else {
      var diamondlessBaseName = tree.base.typeArgument.toString().split("<").first;
      return "$diamondlessBaseName<${tree.arguments.map((e) => e.toString()).join(", ")}>";
    }
  }

  static int $hashCode(TypeTree tree) {
    if (tree.arguments.isEmpty) return tree.base.typeArgument.hashCode;
    return tree.base.typeArgument.hashCode ^ tree.arguments.map((e) => e.hashCode).reduce((a, b) => a ^ b);
  }
}

extension TypeTreeExtension<T> on TypeTree<T> {

  bool get isTerminal => arguments.isEmpty;

  bool isBase<A>() {
    return base.typeArgument == A;
  }

  bool isAssignableToBase(dynamic obj) {
    return base.isAssignable(obj);
  }
}

class TypeTree0<T> extends TypeTree<T> with TypeCaptureMixin<T> {

  const TypeTree0();

  @override
  List<TypeTree> get arguments => const [];

  @override
  TypeCapture<T> get base => this;
}

class TypeTree1<BASE,ITEM> extends TypeTree<BASE> {

  const TypeTree1();

  @override
  List<TypeTree> get arguments => [TypeTree0<ITEM>()];

  @override
  TypeCapture<BASE> get base => TypeToken<BASE>();

}

class TypeTree2<BASE,ITEM0,ITEM1> extends TypeTree<BASE> {

  const TypeTree2();

  @override
  List<TypeTree> get arguments => [TypeTree0<ITEM0>(), TypeTree0<ITEM1>()];

  @override
  TypeCapture<BASE> get base => TypeToken<BASE>();

}

class TypeTree3<BASE,ITEM0,ITEM1,ITEM2> extends TypeTree<BASE> {

  const TypeTree3();

  @override
  List<TypeTree> get arguments => [TypeTree0<ITEM0>(), TypeTree0<ITEM1>(), TypeTree0<ITEM2>()];

  @override
  TypeCapture<BASE> get base => TypeToken<BASE>();

}

class TypeTreeN<BASE> extends TypeTree<BASE> {

  @override
  final List<TypeTree> arguments;

  const TypeTreeN(this.arguments);

  @override
  TypeCapture<BASE> get base => TypeToken<BASE>();
}