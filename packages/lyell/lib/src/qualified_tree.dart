import 'dart:async';

import 'package:lyell/lyell.dart';

abstract base class QualifiedTypeTree<T,B> with TypeCaptureMixin<T> implements TypeTree<B> {
  const QualifiedTypeTree();

  TypeCapture<T> get qualified => this;

  static QualifiedTypeTree terminal<T>() => QualifiedTerminal<T>();
  static QualifiedTypeTree arg0<T>() => QualifiedTerminal<T>();
  static QualifiedTypeTree arg1<QUALIFIED,BASE,A>() => QualifiedTypeTreeN<QUALIFIED,BASE>([terminal<A>()]);
  static QualifiedTypeTree arg2<QUALIFIED,BASE,A,B>() => QualifiedTypeTreeN<QUALIFIED,BASE>([terminal<A>(), terminal<B>()]);
  static QualifiedTypeTree arg3<QUALIFIED,BASE,A,B,C>() => QualifiedTypeTreeN<QUALIFIED,BASE>([terminal<A>(), terminal<B>(), terminal<C>()]);
  static QualifiedTypeTree argN<QUALIFIED,BASE>(List<TypeTree> arguments) => QualifiedTypeTreeN<QUALIFIED, BASE>(arguments);

  static QualifiedTypeTree future<T>() => QualifiedTypeTreeN<Future<T>, Future>([terminal<T>()]);
  static QualifiedTypeTree futureOr<T>() => QualifiedTypeTreeN<FutureOr<T>, FutureOr>([terminal<T>()]);
  static QualifiedTypeTree stream<T>() => QualifiedTypeTreeN<Stream<T>, Stream>([terminal<T>()]);
  static QualifiedTypeTree list<T>() => QualifiedTypeTreeN<List<T>, List>([terminal<T>()]);
  static QualifiedTypeTree set<T>() => QualifiedTypeTreeN<Set<T>, Set>([terminal<T>()]);
  static QualifiedTypeTree iterable<T>() => QualifiedTypeTreeN<Iterable<T>, Iterable>([terminal<T>()]);
  static QualifiedTypeTree map<K,V>() => QualifiedTypeTreeN<Map<K,V>, Map>([terminal<K>(), terminal<V>()]);

}

final class DelegateQualifiedTypeTree<T,B> extends QualifiedTypeTree<T,B> {

  final TypeTree<B> delegate;
  const DelegateQualifiedTypeTree(this.delegate);

  @override
  List<TypeTree> get arguments => delegate.arguments;

  @override
  TypeCapture<B> get base => delegate.base;
}

final class QualifiedTypeTreeN<T,B> extends QualifiedTypeTree<T,B> {

  @override
  final List<TypeTree> arguments;

  const QualifiedTypeTreeN(this.arguments);

  @override
  TypeCapture<B> get base => TypeToken<B>();

}

final class QualifiedTerminal<T> extends QualifiedTypeTree<T,T> {

  const QualifiedTerminal();

  @override
  TypeCapture<T> get base => TypeToken<T>();

  @override
  List<TypeTree> get arguments => [];

}

extension QualifiedExtension on TypeTree {

  bool get isQualified => this is QualifiedTypeTree;
  TypeCapture get qualified => (this as QualifiedTypeTree).qualified;

}