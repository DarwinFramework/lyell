import 'dart:async';

import 'package:collection/collection.dart';

/// Abstract base class for using a generic type capture.
abstract class TypeCapture<T> {
  const TypeCapture();

  TypeCapture get nullable => TypeToken<T?>();
  bool get isNullable => null is T;
  Type get typeArgument => T;
  Type get deriveList => List<T>;
  Type get deriveSet => Set<T>;
  Type get deriveIterable => Iterable<T>;
  Type get deriveFuture => Future<T>;
  Type get deriveFutureOr => FutureOr<T>;
  Type get deriveStream => Stream<T>;

  List<T> castList(List<dynamic> list) => list.cast<T>();
  Set<T> castSet(Set<dynamic> set) => set.cast<T>();
  Iterable<T> castIterable(Iterable<T> iterable) => iterable.cast<T>();
  bool isAssignable(dynamic object) => object is T;
  RETURN consumeType<RETURN>(RETURN Function<_>() func) => func<T>();
  RETURN consumeTypeArg<RETURN,ARG>(RETURN Function<_>(ARG) func, ARG arg) => func<T>(arg);
}

/// Unsafe type capture that only provides the passed in type and otherwise
/// behaves like a dynamic type capture.
class UnsafeRuntimeTypeCapture extends TypeCapture<dynamic> {

  final Type type;
  const UnsafeRuntimeTypeCapture(this.type);

  @override
  TypeCapture get nullable => TypeToken<dynamic>();

  @override
  bool get isNullable => false;

  @override
  Type get typeArgument => type;

  @override
  bool isAssignable(dynamic object) => object.runtimeType == type;

   @override
  Iterable castIterable(Iterable iterable) => iterable;

  @override
  List castList(List list) => list;

  @override
  Set castSet(Set set) => set;
}

/// Mixin for adding the [TypeCapture] interface to classes.
mixin TypeCaptureMixin<T> implements TypeCapture<T> {

  @override
  TypeCapture get nullable => TypeToken<T?>();
  @override
  bool get isNullable => null is T;
  @override
  Type get typeArgument => T;
  @override
  Type get deriveList => List<T>;
  @override
  Type get deriveSet => Set<T>;
  @override
  Type get deriveIterable => Iterable<T>;
  @override
  Type get deriveFuture => Future<T>;
  @override
  Type get deriveFutureOr => FutureOr<T>;
  @override
  Type get deriveStream => Stream<T>;

  @override
  List<T> castList(List<dynamic> list) => list.cast<T>();
  @override
  Set<T> castSet(Set<dynamic> set) => set.cast<T>();
  @override
  Iterable<T> castIterable(Iterable<T> iterable) => iterable.cast<T>();
  @override
  bool isAssignable(dynamic object) => object is T;
  @override
  RETURN consumeType<RETURN>(RETURN Function<_>() func) => func<T>();
  @override
  RETURN consumeTypeArg<RETURN,ARG>(RETURN Function<_>(ARG) func, ARG arg) => func<T>(arg);
}

/// Defines the item type of the implementing class.
/// The getItemType method in lyell_gen will consider [T] as the actual
/// item type and treat it as if it is the type argument of a [List],
/// [Future] or a similar generic core types.
abstract class CascadeItemType<T> extends TypeToken<T> {
  const CascadeItemType();
}

/// Default implementation for a [TypeCapture] of type [T].
class TypeToken<T> extends TypeCapture<T> {
  const TypeToken();
}

/// Double type capture token for associated item types.
/// Mainly useful for serialization or type mapping.
class ItemAssociatedTypeToken<SOURCE, ITEM> {
  const ItemAssociatedTypeToken();
  TypeToken<SOURCE> get sourceType => TypeToken<SOURCE>();
  TypeToken<ITEM> get itemType => TypeToken<ITEM>();
}

/// Marker annotation to make an annotation accessible at runtime using
/// [RetainedAnnotationHolder] implementations.
abstract class RetainedAnnotation {
  const RetainedAnnotation();
}

/// Abstract container of [RetainedAnnotation]s.
abstract class RetainedAnnotationHolder {
  const RetainedAnnotationHolder();

  List<RetainedAnnotation> get annotations;

  /// Gets the first annotation of type [T] or returns null otherwise.
  T? firstAnnotationOf<T>() => annotations.whereType<T>().firstOrNull;

  /// Returns all annotations assignable to type [T].
  Iterable<T> annotationsOf<T>() => annotations.whereType<T>();

  /// Returns all annotations with the exact type of [T].
  Iterable<T> annotationsOfExact<T>() => annotations
      .where((element) => element.runtimeType == T)
      .map((e) => e as T);
}

/// Standard implementation of const [RetainedAnnotationHolder].
class RetainedAnnotationContainer extends RetainedAnnotationHolder {
  @override
  final List<RetainedAnnotation> annotations;

  const RetainedAnnotationContainer(this.annotations);
}
