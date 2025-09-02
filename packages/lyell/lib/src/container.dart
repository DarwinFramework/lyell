import 'package:lyell/lyell.dart';

class TypeContainers {
  static TypeContainer2 arg2(TypeCapture a, TypeCapture b) {
    TypeContainer0 c0 = TypeContainer0();
    TypeContainer1 c1 = a.consumeType(c0.next);
    TypeContainer2 c2 = b.consumeType(c1.next);
    return c2;
  }

  static TypeContainer3 arg3(TypeCapture a, TypeCapture b, TypeCapture c) {
    TypeContainer0 c0 = TypeContainer0();
    TypeContainer1 c1 = a.consumeType(c0.next);
    TypeContainer2 c2 = b.consumeType(c1.next);
    TypeContainer3 c3 = c.consumeType(c2.next);
    return c3;
  }

  static TypeContainer4 arg4(
      TypeCapture a, TypeCapture b, TypeCapture c, TypeCapture d) {
    TypeContainer0 c0 = TypeContainer0();
    TypeContainer1 c1 = a.consumeType(c0.next);
    TypeContainer2 c2 = b.consumeType(c1.next);
    TypeContainer3 c3 = c.consumeType(c2.next);
    TypeContainer4 c4 = d.consumeType(c3.next);
    return c4;
  }

  static TypeContainer5 arg5(TypeCapture a, TypeCapture b, TypeCapture c,
      TypeCapture d, TypeCapture e) {
    TypeContainer0 c0 = TypeContainer0();
    TypeContainer1 c1 = a.consumeType(c0.next);
    TypeContainer2 c2 = b.consumeType(c1.next);
    TypeContainer3 c3 = c.consumeType(c2.next);
    TypeContainer4 c4 = d.consumeType(c3.next);
    TypeContainer5 c5 = e.consumeType(c4.next);
    return c5;
  }

  static TypeContainer6 arg6(TypeCapture a, TypeCapture b, TypeCapture c,
      TypeCapture d, TypeCapture e, TypeCapture f) {
    TypeContainer0 c0 = TypeContainer0();
    TypeContainer1 c1 = a.consumeType(c0.next);
    TypeContainer2 c2 = b.consumeType(c1.next);
    TypeContainer3 c3 = c.consumeType(c2.next);
    TypeContainer4 c4 = d.consumeType(c3.next);
    TypeContainer5 c5 = e.consumeType(c4.next);
    TypeContainer6 c6 = f.consumeType(c5.next);
    return c6;
  }

  static TypeContainer7 arg7(TypeCapture a, TypeCapture b, TypeCapture c,
      TypeCapture d, TypeCapture e, TypeCapture f, TypeCapture g) {
    TypeContainer0 c0 = TypeContainer0();
    TypeContainer1 c1 = a.consumeType(c0.next);
    TypeContainer2 c2 = b.consumeType(c1.next);
    TypeContainer3 c3 = c.consumeType(c2.next);
    TypeContainer4 c4 = d.consumeType(c3.next);
    TypeContainer5 c5 = e.consumeType(c4.next);
    TypeContainer6 c6 = f.consumeType(c5.next);
    TypeContainer7 c7 = g.consumeType(c6.next);
    return c7;
  }
}

class TypeContainer0 {
  TypeContainer1 next<T>() => TypeContainer1<T>();
}

class TypeContainer1<A> {
  TypeContainer2<A, T> next<T>() => TypeContainer2<A, T>();
  RETURN consume<RETURN>(RETURN Function<_>() func) => func<A>();
}

class TypeContainer2<A, B> {
  TypeContainer3<A, B, T> next<T>() => TypeContainer3<A, B, T>();
  RETURN consume<RETURN>(RETURN Function<_0, _1>() func) => func<A, B>();
}

class TypeContainer3<A, B, C> {
  TypeContainer4<A, B, C, T> next<T>() => TypeContainer4<A, B, C, T>();
  RETURN consume<RETURN>(RETURN Function<_0, _1, _2>() func) => func<A, B, C>();
}

class TypeContainer4<A, B, C, D> {
  TypeContainer5<A, B, C, D, T> next<T>() => TypeContainer5<A, B, C, D, T>();
  RETURN consume<RETURN>(RETURN Function<_0, _1, _2, _3>() func) =>
      func<A, B, C, D>();
}

class TypeContainer5<A, B, C, D, E> {
  TypeContainer6<A, B, C, D, E, T> next<T>() =>
      TypeContainer6<A, B, C, D, E, T>();
  RETURN consume<RETURN>(RETURN Function<_0, _1, _2, _3, _4>() func) =>
      func<A, B, C, D, E>();
}

class TypeContainer6<A, B, C, D, E, F> {
  TypeContainer7<A, B, C, D, E, F, T> next<T>() =>
      TypeContainer7<A, B, C, D, E, F, T>();
  RETURN consume<RETURN>(RETURN Function<_0, _1, _2, _3, _4, _5>() func) =>
      func<A, B, C, D, E, F>();
}

class TypeContainer7<A, B, C, D, E, F, G> {
  RETURN consumeType<RETURN>(
          RETURN Function<_0, _1, _2, _3, _4, _5, _6>() func) =>
      func<A, B, C, D, E, F, G>();
}
