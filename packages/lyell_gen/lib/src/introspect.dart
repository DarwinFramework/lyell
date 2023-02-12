import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:lyell/lyell.dart';
import 'package:source_gen/source_gen.dart';

bool _isInitialized = false;
late LibraryReader coreLibraryReader;
late LibraryReader asyncLibraryReader;
late LibraryReader lyellLibraryReader;

late InterfaceElement iterableInterface;
late InterfaceElement listInterface;
late InterfaceElement setInterface;
late InterfaceElement streamInterface;
late InterfaceElement futureInterface;
late InterfaceElement futureOrInterface;
late InterfaceElement cascadeTypeInterface;

TypeChecker retainedAnnotationChecker =
    TypeChecker.fromRuntime(RetainedAnnotation);
TypeChecker iterableChecker = TypeChecker.fromRuntime(Iterable);
TypeChecker listChecker = TypeChecker.fromRuntime(List);
TypeChecker setChecker = TypeChecker.fromRuntime(Set);
TypeChecker streamChecker = TypeChecker.fromRuntime(Stream);
TypeChecker futureChecker = TypeChecker.fromRuntime(Future);
TypeChecker cascadeTypeChecker = TypeChecker.fromRuntime(CascadeItemType);
late TypeChecker futureOrChecker;

/// Initializes deeper introspection capabilities
Future tryInitialize(BuildStep step) async {
  if (_isInitialized) return;
  _isInitialized = true;
  var coreLibrary = await step.resolver.findLibraryByName("dart.core");
  var asyncLibrary = await step.resolver.findLibraryByName("dart.async");
  var lyellLibrary = await step.resolver
      .libraryFor(AssetId.resolve(Uri.parse("package:lyell/lyell.dart")));
  coreLibraryReader = LibraryReader(coreLibrary!);
  asyncLibraryReader = LibraryReader(asyncLibrary!);
  lyellLibraryReader = LibraryReader(lyellLibrary);

  iterableInterface =
      coreLibraryReader.findType("Iterable") as InterfaceElement;
  listInterface = coreLibraryReader.findType("List") as InterfaceElement;
  setInterface = coreLibraryReader.findType("Set") as InterfaceElement;
  streamInterface = asyncLibraryReader.findType("Stream") as InterfaceElement;
  futureInterface = asyncLibraryReader.findType("Future") as InterfaceElement;
  futureOrInterface =
      asyncLibraryReader.findType("FutureOr") as InterfaceElement;
  cascadeTypeInterface =
      lyellLibraryReader.findType("CascadeItemType") as InterfaceElement;
  futureOrChecker = TypeChecker.fromStatic(futureOrInterface.thisType);
}

///
Future<DartType> getItemType(DartType type, BuildStep step) async {
  await tryInitialize(step);

  // Check special cases
  if (type.isDynamic || type.isDartCoreObject || type.isVoid) return type;

  // Handle Primitives
  if (type.isDartCoreString ||
      type.isDartCoreInt ||
      type.isDartCoreDouble ||
      type.isDartCoreBool) return type;

  // Check common collections
  if (iterableChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(iterableInterface)!.typeArguments.first;
  } else if (listChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(listInterface)!.typeArguments.first;
  } else if (setChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(setInterface)!.typeArguments.first;
  } else if (streamChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(streamInterface)!.typeArguments.first;
  } else if (futureChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(futureInterface)!.typeArguments.first;
  } else if (futureOrChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(futureOrInterface)!.typeArguments.first;
  }

  // Check cascading item type interface
  if (cascadeTypeChecker.isAssignableFromType(type)) {
    return type.asInstanceOf(cascadeTypeInterface)!.typeArguments.first;
  }

  return type;
}

extension MetadataExtension on List<ElementAnnotation> {
  List<ElementAnnotation> whereTypeChecker(TypeChecker checker) =>
      where((element) {
        var elementType = element.computeConstantValue()!.type!;
        print(elementType);
        print(elementType.element);
        return checker.isAssignableFrom(elementType.element!);
      }).toList();
}
