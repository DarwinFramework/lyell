import 'dart:async';

import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:lyell/lyell.dart';
import 'package:mutex/mutex.dart';
import 'package:source_gen/source_gen.dart';

bool _isInitialized = false;
late LibraryReader coreLibraryReader;
late LibraryReader asyncLibraryReader;
late LibraryReader lyellLibraryReader;

late InterfaceElement2 iterableInterface;
late InterfaceElement2 listInterface;
late InterfaceElement2 setInterface;
late InterfaceElement2 streamInterface;
late InterfaceElement2 futureInterface;
late InterfaceElement2 futureOrInterface;
late InterfaceElement2 cascadeTypeInterface;

TypeChecker retainedAnnotationChecker =
    TypeChecker.typeNamed(RetainedAnnotation);
TypeChecker mapChecker = TypeChecker.typeNamed(Map, inSdk: true);
TypeChecker iterableChecker = TypeChecker.typeNamed(Iterable, inSdk: true);
TypeChecker listChecker = TypeChecker.typeNamed(List, inSdk: true);
TypeChecker setChecker = TypeChecker.typeNamed(Set, inSdk: true);
TypeChecker streamChecker = TypeChecker.typeNamed(Stream, inSdk: true);
TypeChecker futureChecker = TypeChecker.typeNamed(Future, inSdk: true);
TypeChecker cascadeTypeChecker = TypeChecker.typeNamed(CascadeItemType);
late TypeChecker futureOrChecker;

var _initLock = Mutex();

/// Initializes deeper introspection capabilities.
Future tryInitialize(BuildStep step) async {
  await _initLock.acquire();
  try {
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
        coreLibraryReader.findType("Iterable") as InterfaceElement2;
    listInterface = coreLibraryReader.findType("List") as InterfaceElement2;
    setInterface = coreLibraryReader.findType("Set") as InterfaceElement2;
    streamInterface =
        asyncLibraryReader.findType("Stream") as InterfaceElement2;
    futureInterface =
        asyncLibraryReader.findType("Future") as InterfaceElement2;
    futureOrInterface =
        asyncLibraryReader.findType("FutureOr") as InterfaceElement2;
    cascadeTypeInterface =
        lyellLibraryReader.findType("CascadeItemType") as InterfaceElement2;
    futureOrChecker = TypeChecker.fromStatic(futureOrInterface.thisType);
  } finally {
    _initLock.release();
  }
}

///
Future<DartType> getItemType(DartType type, BuildStep step) async {
  await tryInitialize(step);

  // Check special cases
  if (type is DynamicType || type.isDartCoreObject || type is VoidType) {
    return type;
  }

  // Handle Primitives
  if (type.isDartCoreString ||
      type.isDartCoreInt ||
      type.isDartCoreDouble ||
      type.isDartCoreBool) {
    return type;
  }

  // Check common collections
  if (iterableChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(iterableInterface)!.typeArguments.first;
  } else if (listChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(listInterface)!.typeArguments.first;
  } else if (setChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(setInterface)!.typeArguments.first;
  } else if (streamChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(streamInterface)!.typeArguments.first;
  } else if (futureChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(futureInterface)!.typeArguments.first;
  } else if (futureOrChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(futureOrInterface)!.typeArguments.first;
  }

  // Check cascading item type interface
  if (cascadeTypeChecker.isAssignableFromType(type)) {
    return type.asInstanceOf2(cascadeTypeInterface)!.typeArguments.first;
  }

  return type;
}

extension MetadataExtension on List<ElementAnnotation> {
  List<ElementAnnotation> whereTypeChecker(TypeChecker checker) =>
      where((element) {
        var elementType = element.computeConstantValue()!.type!;
        return checker.isAssignableFrom(elementType.element3!);
      }).toList();
}
