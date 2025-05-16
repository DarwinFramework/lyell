import 'dart:math';

import 'package:lyell/lyell.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class $A {}
class $B {}

void main() {
  test("TypeToken Equality", () {
    expect(TypeToken<$A>(), TypeToken<$A>());
    expect(TypeToken<$A>(), bidiEquals(UnsafeRuntimeTypeCapture($A)));
    expect(TypeToken<$A>(), bidiNotEquals(UnsafeRuntimeTypeCapture($B)));
    expect(TypeToken<List<$A>>(), TypeToken<List<$A>>());
  });

  test("TypeTreeEquality", () {
    expect(QualifiedTypeTree.map<String,$A>(), QualifiedTypeTree.map<String,$A>());
    expect(QualifiedTypeTree.map<$A,$B>(), TypeTree.map<$A,$B>());
    expect(TypeTree.$string, TypeTree.$string);
    expect(TypeTree.terminal<String>(), bidiEquals(TypeTree.$string));
    expect(QualifiedTypeTree.terminal<String>(), bidiEquals(TypeTree.$string));
    expect(QualifiedTypeTree.terminal<String>(), QualifiedTypeTree.terminal<String>());
    expect(TypeTree.$string, bidiEquals(QualifiedTerminal<String>()));
    expect(TypeTree.terminal<String>(), bidiEquals(QualifiedTerminal<String>()));
    expect(TypeToken<String>(), bidiEquals(QualifiedTerminal<String>()));
    expect(TypeToken<String>(), bidiEquals(TypeTree0<String>()));
    expect(TypeTree0<$A>(), bidiEquals(UnsafeRuntimeTypeCapture($A)));
    expect(QualifiedTerminal<$A>(), bidiEquals(UnsafeRuntimeTypeCapture($A)));
    expect(TypeTree0<$A>(), bidiNotEquals(UnsafeRuntimeTypeCapture($B)));
    expect(QualifiedTerminal<$A>(), bidiNotEquals(UnsafeRuntimeTypeCapture($B)));

    expect(QualifiedTypeTree.map<String,double>().base, bidiEquals(TypeToken<Map>()));
    expect(QualifiedTypeTree.map<String,double>().base, bidiEquals(UnsafeRuntimeTypeCapture(Map)));
    expect(UnsafeRuntimeTypeCapture(Map, arguments: [
      UnsafeRuntimeTypeCapture(String),
      UnsafeRuntimeTypeCapture(double)
    ]).base, bidiEquals(UnsafeRuntimeTypeCapture(Map)));
  });

  test("TypeTreeInequality", () {
    expect(TypeTree.terminal<String>(), isNot(TypeTree.$double));
    expect(TypeTree.list<String>(), isNot(TypeTree.list<double>()));
  });

  test("Synthetic", () {
    expect(SyntheticTypeCapture("A"), SyntheticTypeCapture("A"));
    expect(SyntheticTypeCapture("A"), bidiNotEquals(SyntheticTypeCapture("B")));
    expect(SyntheticTypeCapture("A"), bidiNotEquals(TypeToken<dynamic>()));
    expect(SyntheticTypeCapture("A"), bidiNotEquals(TypeToken<String>()));
    expect(TypeTreeN<List>([SyntheticTypeCapture("A")]), bidiEquals(TypeTreeN<List>([SyntheticTypeCapture("A")])));
    expect(TypeTreeN<List>([SyntheticTypeCapture("A")]), bidiNotEquals(TypeTreeN<List>([SyntheticTypeCapture("B")])));

    expect(SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]), SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]));
    expect(SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]), bidiNotEquals(SyntheticTypeCapture("Cont", arguments: [TypeTree.$double])));
    expect(SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]), bidiNotEquals(SyntheticTypeCapture("Cont")));
    expect(SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]), bidiEquals(SyntheticTypeCapture("Cont", arguments: [QualifiedTerminal<String>()])));
    expect(SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]), bidiEquals(SyntheticTypeCapture("Cont", arguments: [UnsafeRuntimeTypeCapture(String)])));

    expect(SyntheticTypeCapture("A").base, isA<SyntheticTypeCapture>());
    expect(UnsafeRuntimeTypeCapture($A).base, isA<UnsafeRuntimeTypeCapture>());
  });

  test("Map Access", () {
    final map = <TypeCapture, int>{
      TypeToken<$A>(): 1,
      TypeToken<$B>(): 2,
    };

    expect(map[TypeToken<$A>()], 1);
    expect(map[TypeToken<$B>()], 2);
    expect(map[TypeTree0<$A>()], 1);
    expect(map[QualifiedTerminal<$A>()], 1);
    expect(map[UnsafeRuntimeTypeCapture($A)], 1);
    expect(map[UnsafeRuntimeTypeCapture($A).base], 1);
    expect(map[UnsafeRuntimeTypeCapture($B)], 2);
  });


  // print(SyntheticTypeCapture("Cont", arguments: [TypeTree.$string]));
  // print(QualifiedTypeTree.list<String>());
  // print(TypeTree.argN<Map>([TypeTree.$string, SyntheticTypeCapture("MyCustomType")]));
}

class BidirectionalEquals<T> extends Matcher {
  
  T value;
  final bool inverted;
  BidirectionalEquals(this.value, {this.inverted = false});
  
  @override
  Description describe(Description description) {
    return description.add("BidirectionalEquals(${inverted ? "!=" : "=="}$value)");
  }

  @override
  bool matches(Object? item, Map matchState) {
    return (item == value && value == item) == !inverted;
  }

  @override
  Description describeMismatch(Object? item, Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription.add("BidirectionalEquals($value) ${inverted ? "==" : "!="} $item | actual == expected: ${item == value}, expected == actual: ${value == item}");
  }
}

Matcher bidiEquals<T>(T value) => BidirectionalEquals<T>(value);
Matcher bidiNotEquals<T>(T value) => BidirectionalEquals<T>(value, inverted: true);