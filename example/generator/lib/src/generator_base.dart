import 'dart:async';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:lyell_gen/lyell_gen.dart';
import 'package:source_gen/source_gen.dart';

class TestBuilder extends Builder {

  @override
  Future<void> build(BuildStep buildStep) async {
    print("Starting build");
    var library = await buildStep.inputLibrary;
    var reader = LibraryReader(library);
    var asset = buildStep.inputId;
    var hasOutput = false;
    AliasCounter counter = AliasCounter();
    CachedAliasCounter cachedCounter = CachedAliasCounter(counter);
    List<AliasImport> additionalImports = [];
    StringBuffer codeBuffer = StringBuffer();
    additionalImports.add(AliasImport.gen("package:lyell/lyell.dart"));
    print("Checking $asset");
    for (var clazz in reader.classes.where((element) => element.documentationComment?.contains("@@Marker") ?? false)) {
      // Example for generating type tokens
      for (var element in clazz.fields) {
        var token = await getAssociatedTypeToken(element.type, buildStep);
        codeBuffer.writeln("const \$${clazz.name}_${element.name} = ${token.prefixedCodeWithAliasedTypes(cachedCounter)};");
        codeBuffer.writeln("final \$${clazz.name}_${element.name}_aliased = ${cachedCounter.get(element.type)};");
      }

      // Example for using retained annotations
      var retained = getRetainedAnnotations(clazz, cachedCounter);
      codeBuffer.writeln("const \$${clazz.name}_annotations_array = ${retained.sourceArray};");
      codeBuffer.writeln("const \$${clazz.name}_annotations = ${retained.prefixedContainer};");

      hasOutput = true;
    }

    if (!hasOutput) return;

    additionalImports.addAll(cachedCounter.imports);
    var imports = createImports(imports: additionalImports);
    var formatted = DartFormatter().format(imports + codeBuffer.toString());
    await buildStep.writeAsString(asset.changeExtension(".test.g.dart"), formatted);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    ".dart": [".test.g.dart"]
  };

}