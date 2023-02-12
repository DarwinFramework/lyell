import 'dart:async';

import 'package:collection/collection.dart';

/// Abstract base class for using a generic type capture.
abstract class TypeCapture<T> {
  const TypeCapture();

  Type get typeArgument => T;
  Type get deriveList => List<T>;
  Type get deriveSet => Set<T>;
  Type get deriveIterable => Iterable<T>;
  Type get deriveFuture => Future<T>;
  Type get deriveFutureOr => FutureOr<T>;
  Type get deriveStream => Stream<T>;
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

/// Marker annotation to make an annotation accessible at runtime via annotation
/// holder implementation holders.
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
