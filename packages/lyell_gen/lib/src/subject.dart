import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:lyell_gen/lyell_gen.dart';
import 'package:source_gen/source_gen.dart';

abstract class SubjectAdapter<TAnnotation, TElement extends Element> {
  final String descriptorExtension;
  final String archetype;
  final Type annotation;

  bool importSourceFile = true;
  bool copySourceImports = false;

  late Builder descriptorBuilder;
  late Builder subjectBuilder;

  SubjectAdapter({
    required this.descriptorExtension,
    required this.archetype,
    required this.annotation,
  }) {
    descriptorBuilder =
        _ServiceAdapterDescriptorBuilder<TAnnotation, TElement>(this);
    subjectBuilder = _ServiceAdapterServiceBuilder<TAnnotation, TElement>(this);
  }

  Future<SubjectGenContext<TElement>?> _createContext(BuildStep step) async {
    var library = await step.inputLibrary;
    var reader = LibraryReader(library);
    var foundElements =
        reader.annotatedWith(TypeChecker.fromRuntime(TAnnotation));
    if (foundElements.isEmpty) return null;
    var matchingElements =
        foundElements.map((e) => e.element).whereType<TElement>().toList();
    if (matchingElements.isEmpty) return null;
    return SubjectGenContext<TElement>(this, reader, matchingElements, step);
  }

  FutureOr<bool> doesOutput(SubjectGenContext<TElement> genContext) => true;

  FutureOr<void> generateSubject(
      SubjectGenContext<TElement> genContext, SubjectCodeContext codeContext);

  FutureOr<SubjectDescriptor> generateDescriptor(SubjectGenContext<TElement> context);
}

class SubjectGenContext<TElement extends Element> {
  final SubjectAdapter adapter;
  final LibraryReader library;
  final List<TElement> matches;
  final BuildStep step;
  
  TElement get first => matches.first;
  TElement? get firstOrNull => matches.firstOrNull;

  SubjectGenContext(this.adapter, this.library, this.matches, this.step);

  SubjectDescriptor defaultDescriptor() => SubjectDescriptor(
      uri: step.inputId
          .changeExtension(".${adapter.archetype}.g.dart")
          .uri
          .toString());
}

class SubjectCodeContext {
  final List<AliasImport> additionalImports;
  final StringBuffer codeBuffer;
  bool noGenerate = false;

  late AliasCounter incrementalCounter;
  late CachedAliasCounter cachedCounter;

  SubjectCodeContext(this.additionalImports, this.codeBuffer) {
    incrementalCounter = AliasCounter.withImports(additionalImports);
    cachedCounter = CachedAliasCounter.withImports(incrementalCounter, additionalImports);
  }
}

class _ServiceAdapterDescriptorBuilder<TAnnotation, TElement extends Element>
    extends Builder {
  final SubjectAdapter<TAnnotation, TElement> adapter;

  _ServiceAdapterDescriptorBuilder(this.adapter);

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await tryInitialize(buildStep);
    var context = await adapter._createContext(buildStep);
    if (context == null) return;
    if (!await adapter.doesOutput(context)) return;
    var binding = await adapter.generateDescriptor(context);
    await buildStep.writeAsString(
        buildStep.inputId.changeExtension(
            ".${adapter.archetype}.${adapter.descriptorExtension}"),
        jsonEncode(binding.toMap()));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".dart": [".${adapter.archetype}.${adapter.descriptorExtension}"]
      };
}

class _ServiceAdapterServiceBuilder<TAnnotation, TElement extends Element>
    extends Builder {
  final SubjectAdapter<TAnnotation, TElement> adapter;

  _ServiceAdapterServiceBuilder(this.adapter);

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await tryInitialize(buildStep);
    var genContext = await adapter._createContext(buildStep);
    if (genContext == null) return;
    if (!await adapter.doesOutput(genContext)) return;
    var passedCodeBuffer = StringBuffer();
    var additionalImports = List<AliasImport>.empty(growable: true);
    var codeContext = SubjectCodeContext(additionalImports, passedCodeBuffer);
    await adapter.generateSubject(genContext, codeContext);
    var codeBuffer = StringBuffer();
    var importString = createImports(
      library: (adapter.copySourceImports ? genContext.library.element : null),
      id: (adapter.importSourceFile ? genContext.step.inputId : null),
      imports: additionalImports
    );
    codeBuffer.writeln(importString);
    codeBuffer.writeln(passedCodeBuffer.toString());
    if (codeContext.noGenerate) return;
    await buildStep.writeAsString(
        buildStep.inputId.changeExtension(".${adapter.archetype}.g.dart"),
        DartFormatter(pageWidth: 200).format(codeBuffer.toString()));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".dart": [".${adapter.archetype}.g.dart"]
      };
}

class SubjectDescriptor {
  final String uri;
  Map<String, dynamic> meta = {};

  SubjectDescriptor({required this.uri, Map<String, dynamic>? meta}) {
    if (meta != null) {
      this.meta = meta;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uri': uri,
      'meta': meta,
    };
  }

  factory SubjectDescriptor.fromMap(Map<String, dynamic> map) {
    return SubjectDescriptor(
      uri: map['uri'] as String,
      meta: map['meta'] as Map<String, dynamic>,
    );
  }
}

abstract class SubjectReactorBuilder extends Builder {
  final String descriptorExtension;
  final String reactorFileName;

  SubjectReactorBuilder(this.descriptorExtension, this.reactorFileName);

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await tryInitialize(buildStep);
    var descriptorIds =
        await buildStep.findAssets(Glob("**.$descriptorExtension")).toList();
    List<AliasImport> imports = [];
    List<SubjectDescriptor> descriptors = [];
    StringBuffer codeBuffer = StringBuffer();
    var context = SubjectCodeContext(imports, codeBuffer);

    for (var value in descriptorIds) {
      var bindingString = await buildStep.readAsString(value);
      var binding = SubjectDescriptor.fromMap(jsonDecode(bindingString));
      descriptors.add(binding);
      var componentImport = AliasImport(binding.uri, null);
      if (!imports.contains(componentImport)) imports.add(componentImport);
    }

    await buildReactor(descriptors, context);
    var content = getImportString(null, null, imports) + codeBuffer.toString();
    buildStep.writeAsString(
        AssetId(buildStep.inputId.package, "lib/$reactorFileName"),
        DartFormatter().format(content));
  }

  FutureOr<void> buildReactor(
      List<SubjectDescriptor> descriptors, SubjectCodeContext code);

  @override
  Map<String, List<String>> get buildExtensions => {
        r"$lib$": [reactorFileName]
      };
}
